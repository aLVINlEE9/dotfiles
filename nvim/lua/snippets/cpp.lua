local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local extras = require("luasnip.extras")
local rep = extras.rep

local function filename_to_guard()
	local filename = vim.fn.expand("%:t")
	if filename == "" then
		return "HEADER_H_"
	end
	local guard = filename:upper():gsub("[.-]", "_"):gsub("%.", "_")
	if not guard:match("_$") then
		guard = guard .. "_"
	end
	return guard
end

return {
	-- header guard snippet
	s({
		trig = "guard",
		name = "Header Guard",
		dscr = "C++ header guard",
	}, {
		t("#ifndef "),
		d(1, function()
			return sn(nil, { i(1, filename_to_guard()) })
		end),
		t({ "", "#define " }),
		rep(1),
		t({ "", "", "" }),
		i(0),
		t({ "", "", "#endif // " }),
		rep(1),
	}),

	-- Big Six for struct
	s({
		trig = "struct",
		name = "Struct with Big Six",
		dscr = "C++ struct with Rule of Six",
	}, {
		t("struct "),
		i(1, "MyStruct"),
		t({ " {", "\t// Default constructor", "\t" }),
		rep(1),
		t("() = default;"),
		t({ "", "", "\t// Destructor", "\t~" }),
		rep(1),
		t("() = default;"),
		t({ "", "", "\t// Copy constructor", "\t" }),
		rep(1),
		t("(const "),
		rep(1),
		t("& other) = default;"),
		t({ "", "", "\t// Copy assignment operator", "\t" }),
		rep(1),
		t("& operator=(const "),
		rep(1),
		t("& other) = default;"),
		t({ "", "", "\t// Move constructor", "\t" }),
		rep(1),
		t("("),
		rep(1),
		t("&& other) noexcept = default;"),
		t({ "", "", "\t// Move assignment operator", "\t" }),
		rep(1),
		t("& operator=("),
		rep(1),
		t("&& other) noexcept = default;"),
		t({ "", "", "\t// Members", "\t" }),
		i(0),
		t({ "", "};" }),
	}),

	-- Big Six for class
	s({
		trig = "class",
		name = "Class with Big Six",
		dscr = "C++ class with Rule of Six",
	}, {
		t("class "),
		i(1, "MyClass"),
		t({ " {", "public:", "\t// Default constructor", "\t" }),
		rep(1),
		t("() = default;"),
		t({ "", "", "\t// Destructor", "\t~" }),
		rep(1),
		t("() = default;"),
		t({ "", "", "\t// Copy constructor", "\t" }),
		rep(1),
		t("(const "),
		rep(1),
		t("& other) = default;"),
		t({ "", "", "\t// Copy assignment operator", "\t" }),
		rep(1),
		t("& operator=(const "),
		rep(1),
		t("& other) = default;"),
		t({ "", "", "\t// Move constructor", "\t" }),
		rep(1),
		t("("),
		rep(1),
		t("&& other) noexcept = default;"),
		t({ "", "", "\t// Move assignment operator", "\t" }),
		rep(1),
		t("& operator=("),
		rep(1),
		t("&& other) noexcept = default;"),
		t({ "", "", "private:", "\t" }),
		i(0),
		t({ "", "};" }),
	}),
}
