------------------------------------------------------------------------------------------------------------------------
-- 永久破解所有lua时间限制(包括加密宏)
-- 使用方法：在下面的时间修改处修改成需要的时间(未过期的时间)，然后把本文档全部复制，粘贴到要破解的lua最前面即可，重新运行就能发现破解成功。
------------------------------------------------------------------------------------------------------------------------
do
    local function createGetDateModule()
        local startTime = {

---------------  时间修改处  ---------------

            year = 2023,  -- 年
            month = 1,  -- 月
            day = 1,  -- 日
            
----------- 以下三行可不修改，时分秒一般不影响(除非对脚本启动时间做了判定)。

            hour = 13,  -- 时
            min = 30,  -- 分
            sec = 30  -- 秒
  
---------------  时间修改处结束  ---------------
        }
        -- 保存原始的 GetDate 函数
        local RawGetDate = GetDate

        -- 初次调用 RawGetDate 获取的时间戳保存为 runTime
        local function convertToTimestamp(dateTable)
            local year, month, day, hour, min, sec = dateTable.year, dateTable.month, dateTable.day, dateTable.hour, dateTable.min, dateTable.sec
            -- 计算时间戳
            local daysInMonths = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
            local function isLeapYear(year)
                return (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0)
            end
            -- 计算从1970年1月1日至今的总天数
            local days = 0
            for y = 1970, year - 1 do
                days = days + (isLeapYear(y) and 366 or 365)
            end
            for m = 1, month - 1 do
                days = days + daysInMonths[m]
                if m == 2 and isLeapYear(year) then
                    days = days + 1
                end
            end
            days = days + day - 1
            -- 将天数转换为秒数，并减去8小时（时区调整）
            return days * 86400 + hour * 3600 + min * 60 + sec - 8 * 3600
        end
        
        local startTime = convertToTimestamp(startTime)

        local runTime = convertToTimestamp(RawGetDate("*t"))

        -- 定义新的 GetDate 函数
        local function GetDate(format, time)
            if time then  -- 如果传入了自定义参数，则调用原API
                return RawGetDate(format, time)
            end
            -- 获取当前的实际时间戳
            local currentRunTime = convertToTimestamp(RawGetDate("*t"))
            
            -- 计算调整后的当前时间
            local currentTime = startTime + (currentRunTime - runTime)
            
            -- 调用原始函数 RawGetDate，并传递调整后的时间表
            return RawGetDate(format, currentTime)
        end

        -- 返回包含 GetDate 函数的表
        return { GetDate = GetDate }
    end

   -- 创建时间欺骗模块
    local GetDateModule = createGetDateModule()

    -- 将新的 GetDate 函数赋值给全局变量
    _G.GetDate = GetDateModule.GetDate
end

-- 此时 createGetDateModule 以及其内部的局部变量均已不可见

