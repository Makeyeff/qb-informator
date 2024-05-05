local Translations = {
    informator = {
        blip = 'Информатор',
        inZone = 'Нажмите Е'
    }
}

if GetConvar('qb_locale', 'en') == 'ru' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang
    })
end
