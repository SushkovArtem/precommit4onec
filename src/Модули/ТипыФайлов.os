///////////////////////////////////////////////////////////////////////////////
//
// Служебный модуль с набором методов для определения типа файла
//
// (с) BIA Technologies, LLC
//
///////////////////////////////////////////////////////////////////////////////

// ЭтоФайлИсходников
//	Возвращает истину, если файл является файлом исходных кодов 
// Параметры:
//   Файл - Строка - Полный путь к файлу
//
//  Возвращаемое значение:
//   Булево - Признак
//
Функция ЭтоФайлИсходников(Файл) Экспорт
	
	Если ПустаяСтрока(Файл.Расширение) Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат СтрСравнить(Файл.Расширение, ".bsl") = 0;
	
КонецФункции

// ЭтоФайлОписанияКонфигурации
//	Возвращает истину, если файл является файлом описания конфигурации
// Параметры:
//   Файл - Строка - Полный путь к файлу
//
//  Возвращаемое значение:
//   Булево - Признак
//
Функция ЭтоФайлОписанияКонфигурации(Файл) Экспорт
	
	Если ПустаяСтрока(Файл.Расширение) Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат СтрСравнить(Файл.Имя, "Configuration.xml") = 0;
	
КонецФункции

// ЭтоФайлОписанияКонфигурацииEDT
//	Возвращает истину, если файл является файлом описания конфигурации в формате EDT
// Параметры:
//   Файл - Строка - Полный путь к файлу
//
//  Возвращаемое значение:
//   Булево - Признак
//
Функция ЭтоФайлОписанияКонфигурацииEDT(Файл) Экспорт
	
	Если ПустаяСтрока(Файл.Расширение) Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат СтрСравнить(Файл.Имя, "Configuration.mdo") = 0;
	
КонецФункции

// ЭтоФайлОписанияКонфигурации
//	Возвращает истину, если файл является файлом описания формы
// Параметры:
//   Файл - Строка - Полный путь к файлу
//
//  Возвращаемое значение:
//   Булево - Признак
//
Функция ЭтоФайлОписанияФормы(Файл) Экспорт
	
	Если ПустаяСтрока(Файл.Расширение) Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат СтрСравнить(Файл.Имя, "Form.xml") = 0;
	
КонецФункции

// ЭтоФайлОписанияКонфигурации
//	Возвращает истину, если файл является файлом описания формы в формате EDT
// Параметры:
//   Файл - Строка - Полный путь к файлу
//
//  Возвращаемое значение:
//   Булево - Признак
//
Функция ЭтоФайлОписанияФормыEDT(Файл) Экспорт
	
	Если ПустаяСтрока(Файл.Расширение) Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат СтрСравнить(Файл.Имя, "Form.form") = 0;
	
КонецФункции
