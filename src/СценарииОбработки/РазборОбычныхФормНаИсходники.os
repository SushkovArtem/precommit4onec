///////////////////////////////////////////////////////////////////////////////
//
// Служебный модуль с реализацией сценариев обработки файлов 
// "РазборОбычныхФормНаИсходники"
//
// (с) BIA Technologies, LLC
//
///////////////////////////////////////////////////////////////////////////////

#Использовать v8unpack

// ИмяСценария
//	Возвращает имя сценария обработки файлов
//
// Возвращаемое значение:
//   Строка   - Имя текущего сценария обработки файлов
//
Функция ИмяСценария() Экспорт
	
	Возврат "РазборОбычныхФормНаИсходники";
	
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
	
	Лог = ДополнительныеПараметры.Лог;
	НастройкиСценария = ДополнительныеПараметры.УправлениеНастройками.Настройка("Precommt4onecСценарии\НастройкиСценариев").Получить(ИмяСценария());
	
	Если ТипыФайлов.ЭтоФайлОбычнойФормы(АнализируемыйФайл) Тогда
		
		Лог.Информация("Обработка файла '%1' по сценарию '%2'", АнализируемыйФайл.ПолноеИмя, ИмяСценария());
		
		КаталогаВыгрузки = ПодготовитьКаталогВыгрузки(КаталогИсходныхФайлов, АнализируемыйФайл, ДополнительныеПараметры);
		Если Не ПустаяСтрока(КаталогаВыгрузки) Тогда
		
			ЧтениеФайла = Новый ЧтениеФайла8(АнализируемыйФайл.ПолноеИмя);
			ЧтениеФайла.ИзвлечьВсе(КаталогаВыгрузки, Истина);
			ЧтениеФайла = Неопределено;
		
			ФайлыМодулей = НайтиФайлы(КаталогаВыгрузки, "module", ИСТИНА);
			Для Каждого ФайлМодуля Из ФайлыМодулей Цикл
				
				Файл = Новый Файл(ОбъединитьПути(ФайлМодуля.Путь, "Module") + ".bsl");
				Если Файл.Существует() Тогда
					
					УдалитьФайлы(Файл.ПолноеИмя);
					
				КонецЕсли;
		
				ПереместитьФайл(ФайлМодуля.ПолноеИмя, Файл.ПолноеИмя);
				ДополнительныеПараметры.ФайлыДляПостОбработки.Добавить(Файл.ПолноеИмя);
			
			КонецЦикла;

		КонецЕсли;
		
		Возврат ИСТИНА;
		
	КонецЕсли;
	
	Возврат ЛОЖЬ;
	
КонецФункции // ОбработатьФайл()

Функция ПодготовитьКаталогВыгрузки(КаталогИсходныхФайлов, ОбрабатываемыйФайл, ДополнительныеПараметры)
	
	ФайлУдален = НЕ ОбрабатываемыйФайл.Существует();
	ИмяКаталогаВыгрузки = ОбъединитьПути(ОбрабатываемыйФайл.Путь, ОбрабатываемыйФайл.ИмяБезРасширения);
	ФайлИмяКаталогаВыгрузки = Новый Файл(ИмяКаталогаВыгрузки);
	Если НЕ ФайлИмяКаталогаВыгрузки.Существует() Тогда
		
		Если ФайлУдален Тогда
			
			ИмяКаталогаВыгрузки = "";
			
		Иначе
			
			СоздатьКаталог(ИмяКаталогаВыгрузки);
			
		КонецЕсли;
		
	Иначе
		
		ФайлыВКаталогеТВФ = НайтиФайлы(ИмяКаталогаВыгрузки, "*", ИСТИНА);
		Для каждого ФайлВКателогеТВФ Из ФайлыВКаталогеТВФ Цикл
			
			Если НЕ ФайлВКателогеТВФ.Существует() Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			УдалитьФайлы(ФайлВКателогеТВФ.ПолноеИмя);
			
		КонецЦикла;
		
		Если ФайлУдален Тогда
			
			УдалитьФайлы(ИмяКаталогаВыгрузки);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ИмяКаталогаВыгрузки) Тогда
		
		ДополнительныеПараметры.ИзмененныеКаталоги.Добавить(ИмяКаталогаВыгрузки);
		
	КонецЕсли;
	
	Если Не ФайлУдален Тогда
		
		Возврат ИмяКаталогаВыгрузки;
		
	КонецЕсли;
	
	Возврат "";
	
КонецФункции // ПодготовитьКаталогВыгрузки()
