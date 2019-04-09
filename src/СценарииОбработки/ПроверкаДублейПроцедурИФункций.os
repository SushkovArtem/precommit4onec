///////////////////////////////////////////////////////////////////////////////
// 
// Служебный модуль с реализацией сценариев обработки файлов <ИмяСценария>
//
///////////////////////////////////////////////////////////////////////////////
Перем Лог;

// ИмяСценария
//	Возвращает имя сценария обработки файлов
//
// Возвращаемое значение:
//   Строка   - Имя текущего сценария обработки файлов
//
Функция ИмяСценария() Экспорт
	
	Возврат "ПроверкаДублейПроцедурИФункций";
	
КонецФункции // ИмяСценария()

// ОбработатьФайл
//	Выполняет обработку файла
//
// Параметры:
//  АнализируемыйФайл		- Файл - Файл из журнала git для анализа
//  КаталогИсходныхФайлов  	- Строка - Каталог расположения исходных файлов относительно каталог репозитория
//  ДополнительныеПараметры - Структура - Набор дополнительных параметров, которые можно использовать 
//  	* Лог  					- Объект - Текущий лог
//  	* ИзмененныеКаталоги	- Массив - Каталоги, которые необходимо добавить в индекс
//		* КаталогРепозитория	- Строка - Адрес каталога репозитория
//		* ФайлыДляПостОбработки	- Массив - Файлы, изменившиеся / образовавшиеся в результате работы сценария
//											и которые необходимо дообработать
//
// Возвращаемое значение:
//   Булево   - Признак выполненной обработки файла
//
Функция ОбработатьФайл(АнализируемыйФайл, КаталогИсходныхФайлов, ДополнительныеПараметры) Экспорт
	
	Лог 					= ДополнительныеПараметры.Лог;
	НастройкиСценария 		= ДополнительныеПараметры.УправлениеНастройками.Настройка("Precommt4onecСценарии\НастройкиСценариев").Получить(ИмяСценария());
		
	Если АнализируемыйФайл.Существует() И ТипыФайлов.ЭтоФайлИсходников(АнализируемыйФайл) Тогда
		
		Лог.Информация("Обработка файла '%1' по сценарию '%2'", АнализируемыйФайл.ПолноеИмя, ИмяСценария());
		
		ПроверитьНаДублированиеМетодов(АнализируемыйФайл.ПолноеИмя);
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции // ОбработатьФайл()

// ПроверитьНаДублированиеМетодов
//	Выполняет поиск дублей имен процедур и функций файла
//
// Параметры:
//  ПутьКФайлуМодуля		- Строка - Путь до файла
//
Процедура ПроверитьНаДублированиеМетодов(ПутьКФайлуМодуля) 
	
	Текст = Новый ЧтениеТекста();
	Текст.Открыть(ПутьКФайлуМодуля, КодировкаТекста.UTF8NoBOM);
	
	ТекстМодуля = Текст.Прочитать();
	Текст.Закрыть();
	
	ТекстОшибки = "";
	
	ШаблонПоиска	= Новый РегулярноеВыражение("^\s*(?:Процедура|Функция|procedure|function)\s+?([а-яА-ЯёЁ0-9_\w]+?)\s*?\(");
	ШаблонПоиска.Многострочный			= Истина;
	ШаблонПоиска.ИгнорироватьРегистр	= Истина;
	
	Если НЕ ПустаяСтрока(ТекстМодуля) Тогда
		
		Совпадения = ШаблонПоиска.НайтиСовпадения(ТекстМодуля);
		
		Если Совпадения.Количество() Тогда
			
			ТЗПроцедуры = Новый ТаблицаЗначений;
			ТЗПроцедуры.Колонки.Добавить("ИмяПроцедуры");
			ТЗПроцедуры.Колонки.Добавить("Количество");
			
			Для Каждого Совпадение Из Совпадения Цикл
				
				СтрокаТЗ 				= ТЗПроцедуры.Добавить();
				СтрокаТЗ.ИмяПроцедуры	= НРЕГ(Совпадение.Группы[1].Значение);
				СтрокаТЗ.Количество		= 1;
				
			КонецЦикла;
			
			КоличествоПроцедур = ТЗПроцедуры.Количество();
			ТЗПроцедуры.Свернуть("ИмяПроцедуры", "Количество");
			КоличествоУникальных = ТЗПроцедуры.Количество();
			
			Если КоличествоПроцедур <> КоличествоУникальных Тогда
				
				ТекстОшибки = СтрШаблон("В файле '%1' обнаружены неуникальные имена методов " + Символы.ПС, ПутьКФайлуМодуля);
				
				Для Каждого СтрокаТЗ Из ТЗПроцедуры Цикл
					
					ТекстОшибки = ТекстОшибки + ?(СтрокаТЗ.Количество > 1, СтрокаТЗ.ИмяПроцедуры + Символы.ПС, "");
					
				КонецЦикла;
				
				Лог.Ошибка(ТекстОшибки);
				ВызватьИсключение ТекстОшибки;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ПроверитьНаДублированиеМетодов()
