From: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: RFC: net/netfilter reorganization
Date: Mon, 13 Oct 2008 20:52:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810132042170.12399@localhost.localdomain>
References: <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0810052101090.17356@blackhole.kfki.hu>
 <20081005.132850.34376215.davem@davemloft.net>
 <alpine.LNX.1.10.0810051632400.32566@fbirervta.pbzchgretzou.qr>
 <alpine.LNX.1.10.0810051641220.32566@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0810052258460.17462@blackhole.kfki.hu> <48E938F6.8080108@trash.net>
 <alpine.LNX.1.10.0810051909430.3354@fbirervta.pbzchgretzou.qr>
 <48E9E368.50901@trash.net> <alpine.LNX.1.10.0810062106260.438@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0810071331170.12399@localhost.localdomain>
 <alpine.LNX.1.10.0810071129180.23228@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0810071856010.12399@localhost.localdomain>
 <alpine.LNX.1.10.0810071343290.23228@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-668692207-1223923947=:12399"
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	David Miller <davem@davemloft.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, sam@ravnborg.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3670 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbYJMSwv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:52:51 -0400
In-Reply-To: <alpine.LNX.1.10.0810071343290.23228@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-668692207-1223923947=:12399
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hi,

On Tue, 7 Oct 2008, Jan Engelhardt wrote:

> We are trying to combine TARGET_CONNMARK and MATCH_CONNMARK into a
> new option, and doing so without showing {TARGET,MATCH}, yet
> selecting BOTH_CONNMARK when either of {TARGET,MATCH} was previously
> selected (e.g by feeding oldconfig something that has these options
> active).

Try the patch below, you can define an alias (e.g. add "option 
alias=TARGET_CONNMARK" to BOTH_CONNMARK) and kconfig will use the alias 
while reading the .config file (unless there is already a value for it).
Previously .config data was only used as a preset for user prompts, for 
any other derived symbol it's ignored.
If it does what you need, I can get it merged as quickly as possible 
after adding a bit of documentation. I maybe also give it another name, as 
"alias" is a little general and it's not a generally usable alias.

bye, Roman

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index b91cf24..7c9f229 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -151,6 +151,7 @@ int conf_read_simple(const char *name, int def)
 	char line[1024];
 	char *p, *p2;
 	struct symbol *sym;
+	struct expr *e;
 	int i, def_flags;
 
 	if (name) {
@@ -307,6 +308,23 @@ load:
 
 	if (modules_sym)
 		sym_calc_value(modules_sym);
+
+	expr_list_for_each_sym(sym_alias_list, e, sym) {
+		struct symbol *sym2;
+		struct property *prop;
+
+		if (!(sym->flags & def_flags))
+			continue;
+
+		for_all_properties(sym, prop, P_ALIAS) {
+			sym2 = prop_get_symbol(prop);
+			if (!(sym2->flags & def_flags)) {
+				sym2->def[def] = sym->def[def];
+				sym2->flags |= def_flags;
+			}
+		}
+	}
+
 	return 0;
 }
 
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 9d4cba1..224bf4a 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -107,7 +107,7 @@ struct symbol {
 
 enum prop_type {
 	P_UNKNOWN, P_PROMPT, P_COMMENT, P_MENU, P_DEFAULT, P_CHOICE,
-	P_SELECT, P_RANGE, P_ENV
+	P_SELECT, P_RANGE, P_ENV, P_ALIAS
 };
 
 struct property {
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index 4a9af6f..7ea2bc4 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -53,6 +53,7 @@ enum conf_def_mode {
 #define T_OPT_MODULES		1
 #define T_OPT_DEFCONFIG_LIST	2
 #define T_OPT_ENV		3
+#define T_OPT_ALIAS		4
 
 struct kconf_id {
 	int name;
@@ -97,6 +98,7 @@ void menu_add_symbol(enum prop_type type, struct symbol *sym, struct expr *dep);
 void menu_add_option(int token, char *arg);
 void menu_finalize(struct menu *parent);
 void menu_set_type(int type);
+void sym_check_prop(struct symbol *sym);
 
 /* util.c */
 struct file *file_lookup(const char *name);
@@ -115,6 +117,7 @@ const char *str_get(struct gstr *gs);
 
 /* symbol.c */
 extern struct expr *sym_env_list;
+extern struct expr *sym_alias_list;
 
 void sym_init(void);
 void sym_clear_all_valid(void);
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 07ff8d1..e1d8686 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -175,6 +175,11 @@ void menu_add_option(int token, char *arg)
 	case T_OPT_ENV:
 		prop_add_env(arg);
 		break;
+	case T_OPT_ALIAS:
+		prop = prop_alloc(P_ALIAS, sym_lookup(arg, 0));
+		prop->menu = current_entry;
+		prop->expr = expr_alloc_symbol(current_entry->sym);
+		break;
 	}
 }
 
@@ -219,6 +224,23 @@ void sym_check_prop(struct symbol *sym)
 			    !menu_range_valid_sym(sym, prop->expr->right.sym))
 				prop_warn(prop, "range is invalid");
 			break;
+		case P_ALIAS:
+			if (sym->prop->type != P_ALIAS ||
+			    (prop->next && prop->next->type != P_ALIAS)) {
+				prop_warn(prop, "alias is invalid");
+				break;
+			}
+			sym2 = prop_get_symbol(prop);
+			if (sym->type != S_UNKNOWN && sym->type != sym2->type) {
+				prop_warn(prop, "conflicting alias type");
+				break;
+			}
+			sym->type = sym2->type;
+			if (!prop->next) {
+				sym_alias_list = expr_alloc_one(E_LIST, sym_alias_list);
+				sym_alias_list->right.sym = sym;
+			}
+			break;
 		default:
 			;
 		}
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 18f3e5c..f25fb3d 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -34,7 +34,7 @@ struct symbol *sym_defconfig_list;
 struct symbol *modules_sym;
 tristate modules_val;
 
-struct expr *sym_env_list;
+struct expr *sym_env_list, *sym_alias_list;
 
 void sym_add_default(struct symbol *sym, const char *def)
 {
@@ -937,6 +937,8 @@ const char *prop_get_type_name(enum prop_type type)
 		return "select";
 	case P_RANGE:
 		return "range";
+	case P_ALIAS:
+		return "alias";
 	case P_UNKNOWN:
 		break;
 	}
diff --git a/scripts/kconfig/zconf.gperf b/scripts/kconfig/zconf.gperf
index 25ef5d0..2816585 100644
--- a/scripts/kconfig/zconf.gperf
+++ b/scripts/kconfig/zconf.gperf
@@ -41,4 +41,5 @@ on,		T_ON,		TF_PARAM
 modules,	T_OPT_MODULES,	TF_OPTION
 defconfig_list,	T_OPT_DEFCONFIG_LIST,TF_OPTION
 env,		T_OPT_ENV,	TF_OPTION
+alias,		T_OPT_ALIAS,	TF_OPTION
 %%
diff --git a/scripts/kconfig/zconf.hash.c_shipped b/scripts/kconfig/zconf.hash.c_shipped
index 5c73d51..cd2f361 100644
--- a/scripts/kconfig/zconf.hash.c_shipped
+++ b/scripts/kconfig/zconf.hash.c_shipped
@@ -53,10 +53,10 @@ kconf_id_hash (register const char *str, register unsigned int len)
       49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
       49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
       49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 11,  5,
+      49, 49, 49, 49, 49, 49, 49,  0, 35,  5,
        0,  0,  5, 49,  5, 20, 49, 49,  5, 20,
        5,  0, 30, 49,  0, 15,  0, 10,  0, 49,
-      25, 49, 49, 49, 49, 49, 49, 49, 49, 49,
+      10, 49, 49, 49, 49, 49, 49, 49, 49, 49,
       49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
       49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
       49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
@@ -100,24 +100,25 @@ struct kconf_id_strings_t
     char kconf_id_strings_str12[sizeof("default")];
     char kconf_id_strings_str13[sizeof("def_bool")];
     char kconf_id_strings_str14[sizeof("help")];
-    char kconf_id_strings_str15[sizeof("bool")];
     char kconf_id_strings_str16[sizeof("config")];
     char kconf_id_strings_str17[sizeof("def_tristate")];
-    char kconf_id_strings_str18[sizeof("boolean")];
+    char kconf_id_strings_str18[sizeof("hex")];
     char kconf_id_strings_str19[sizeof("defconfig_list")];
     char kconf_id_strings_str21[sizeof("string")];
     char kconf_id_strings_str22[sizeof("if")];
     char kconf_id_strings_str23[sizeof("int")];
+    char kconf_id_strings_str25[sizeof("alias")];
     char kconf_id_strings_str26[sizeof("select")];
     char kconf_id_strings_str27[sizeof("modules")];
     char kconf_id_strings_str28[sizeof("tristate")];
     char kconf_id_strings_str29[sizeof("menu")];
     char kconf_id_strings_str31[sizeof("source")];
     char kconf_id_strings_str32[sizeof("comment")];
-    char kconf_id_strings_str33[sizeof("hex")];
     char kconf_id_strings_str35[sizeof("menuconfig")];
     char kconf_id_strings_str36[sizeof("prompt")];
     char kconf_id_strings_str37[sizeof("depends")];
+    char kconf_id_strings_str39[sizeof("bool")];
+    char kconf_id_strings_str42[sizeof("boolean")];
     char kconf_id_strings_str48[sizeof("mainmenu")];
   };
 static struct kconf_id_strings_t kconf_id_strings_contents =
@@ -134,24 +135,25 @@ static struct kconf_id_strings_t kconf_id_strings_contents =
     "default",
     "def_bool",
     "help",
-    "bool",
     "config",
     "def_tristate",
-    "boolean",
+    "hex",
     "defconfig_list",
     "string",
     "if",
     "int",
+    "alias",
     "select",
     "modules",
     "tristate",
     "menu",
     "source",
     "comment",
-    "hex",
     "menuconfig",
     "prompt",
     "depends",
+    "bool",
+    "boolean",
     "mainmenu"
   };
 #define kconf_id_strings ((const char *) &kconf_id_strings_contents)
@@ -166,7 +168,7 @@ kconf_id_lookup (register const char *str, register unsigned int len)
 {
   enum
     {
-      TOTAL_KEYWORDS = 31,
+      TOTAL_KEYWORDS = 32,
       MIN_WORD_LENGTH = 2,
       MAX_WORD_LENGTH = 14,
       MIN_HASH_VALUE = 2,
@@ -189,16 +191,17 @@ kconf_id_lookup (register const char *str, register unsigned int len)
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str12,	T_DEFAULT,	TF_COMMAND, S_UNKNOWN},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str13,	T_DEFAULT,	TF_COMMAND, S_BOOLEAN},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str14,		T_HELP,		TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str15,		T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str16,		T_CONFIG,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str17,	T_DEFAULT,	TF_COMMAND, S_TRISTATE},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str18,	T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str18,		T_TYPE,		TF_COMMAND, S_HEX},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str19,	T_OPT_DEFCONFIG_LIST,TF_OPTION},
       {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str21,		T_TYPE,		TF_COMMAND, S_STRING},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str22,		T_IF,		TF_COMMAND|TF_PARAM},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str23,		T_TYPE,		TF_COMMAND, S_INT},
-      {-1}, {-1},
+      {-1},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str25,		T_OPT_ALIAS,	TF_OPTION},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str26,		T_SELECT,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str27,	T_OPT_MODULES,	TF_OPTION},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str28,	T_TYPE,		TF_COMMAND, S_TRISTATE},
@@ -206,13 +209,15 @@ kconf_id_lookup (register const char *str, register unsigned int len)
       {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str31,		T_SOURCE,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str32,	T_COMMENT,	TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str33,		T_TYPE,		TF_COMMAND, S_HEX},
-      {-1},
+      {-1}, {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str35,	T_MENUCONFIG,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str36,		T_PROMPT,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str37,	T_DEPENDS,	TF_COMMAND},
-      {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
       {-1},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str39,		T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {-1}, {-1},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str42,	T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {-1}, {-1}, {-1}, {-1}, {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str48,	T_MAINMENU,	TF_COMMAND}
     };
 
diff --git a/scripts/kconfig/zconf.tab.c_shipped b/scripts/kconfig/zconf.tab.c_shipped
index 95df833..05fbd1d 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -2278,6 +2278,10 @@ void conf_parse(const char *name)
 	for_all_symbols(i, sym) {
 		if (sym_check_deps(sym))
 			zconfnerrs++;
+		if (!(sym->flags & SYMBOL_WARNED)) {
+			sym_check_prop(sym);
+			sym->flags |= SYMBOL_WARNED;
+		}
         }
 	if (zconfnerrs)
 		exit(1);
diff --git a/scripts/kconfig/zconf.y b/scripts/kconfig/zconf.y
index 9710b82..bb74756 100644
--- a/scripts/kconfig/zconf.y
+++ b/scripts/kconfig/zconf.y
@@ -495,6 +495,10 @@ void conf_parse(const char *name)
 	for_all_symbols(i, sym) {
 		if (sym_check_deps(sym))
 			zconfnerrs++;
+		if (!(sym->flags & SYMBOL_WARNED)) {
+			sym_check_prop(sym);
+			sym->flags |= SYMBOL_WARNED;
+		}
         }
 	if (zconfnerrs)
 		exit(1);
--8323328-668692207-1223923947=:12399--
