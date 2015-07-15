From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/2] extensions: restore matching any SPI id by default
Date: Wed, 15 Jul 2015 14:53:39 +0200
Message-ID: <1436964819-28109-3-git-send-email-jengelh@inai.de>
References: <1436964819-28109-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:33671 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbbGOMxm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 08:53:42 -0400
In-Reply-To: <1436964819-28109-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is the same as commit v1.4.15-12-g8a988f6.

If no id option is given, the extensions only match packets with a
zero-valued identification field. This behavior deviates from what it
used to do back in v1.4.10-273-g6944f2c^.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libip6t_ah.c | 9 +++++++++
 extensions/libip6t_ah.t | 1 +
 extensions/libip6t_rt.c | 8 ++++++++
 extensions/libip6t_rt.t | 1 +
 extensions/libipt_ah.c  | 8 ++++++++
 extensions/libipt_ah.t  | 1 +
 extensions/libxt_esp.c  | 8 ++++++++
 extensions/libxt_esp.t  | 1 +
 8 files changed, 37 insertions(+)

diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 26f8140..174d6d1 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -28,6 +28,14 @@ static const struct xt_option_entry ah_opts[] = {
 };
 #undef s
 
+static void ah_init(struct xt_entry_match *m)
+{
+	struct ip6t_ah *ahinfo = (void *)m->data;
+
+	/* Defaults for when no --ahspi is used at all */
+	ahinfo->spis[1] = ~0U;
+}
+
 static void ah_parse(struct xt_option_call *cb)
 {
 	struct ip6t_ah *ahinfo = cb->data;
@@ -127,6 +135,7 @@ static struct xtables_match ah_mt6_reg = {
 	.size          = XT_ALIGN(sizeof(struct ip6t_ah)),
 	.userspacesize = XT_ALIGN(sizeof(struct ip6t_ah)),
 	.help          = ah_help,
+	.init          = ah_init,
 	.print         = ah_print,
 	.save          = ah_save,
 	.x6_parse      = ah_parse,
diff --git a/extensions/libip6t_ah.t b/extensions/libip6t_ah.t
index 459e9ec..36ca7df 100644
--- a/extensions/libip6t_ah.t
+++ b/extensions/libip6t_ah.t
@@ -12,3 +12,4 @@
 -m ah --ahspi invalid;;FAIL
 -m ah --ahspi 0:invalid;;FAIL
 -m ah --ahspi;;FAIL
+-m ah;-m ah --ahspi 0;FAIL
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index d470488..cada779 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -99,6 +99,13 @@ parse_addresses(const char *addrstr, struct in6_addr *addrp)
 	return i;
 }
 
+static void rt_init(struct xt_entry_match *m)
+{
+	struct ip6t_rt *rtinfo = (void *)m->data;
+
+	rtinfo->segsleft[1] = ~0U;
+}
+
 static void rt_parse(struct xt_option_call *cb)
 {
 	struct ip6t_rt *rtinfo = cb->data;
@@ -245,6 +252,7 @@ static struct xtables_match rt_mt6_reg = {
 	.size		= XT_ALIGN(sizeof(struct ip6t_rt)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_rt)),
 	.help		= rt_help,
+	.init		= rt_init,
 	.x6_parse	= rt_parse,
 	.print		= rt_print,
 	.save		= rt_save,
diff --git a/extensions/libip6t_rt.t b/extensions/libip6t_rt.t
index 7170138..553123e 100644
--- a/extensions/libip6t_rt.t
+++ b/extensions/libip6t_rt.t
@@ -2,3 +2,4 @@
 -m rt --rt-type 0 --rt-segsleft 1:23 --rt-len 42 --rt-0-res;=;OK
 -m rt --rt-type 0 ! --rt-segsleft 1:23 ! --rt-len 42 --rt-0-res;=;OK
 -m rt ! --rt-type 1 ! --rt-segsleft 12:23 ! --rt-len 42;=;OK
+-m rt;-m rt --rtsegsleft 0;FAIL
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 8cf167c..a490729 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -21,6 +21,13 @@ static const struct xt_option_entry ah_opts[] = {
 	XTOPT_TABLEEND,
 };
 
+static void ah_init(struct xt_entry_match *m)
+{
+	struct ipt_ah *ahinfo = (void *)m->data;
+
+	ahinfo->spis[1] = ~0U;
+}
+
 static void ah_parse(struct xt_option_call *cb)
 {
 	struct ipt_ah *ahinfo = cb->data;
@@ -92,6 +99,7 @@ static struct xtables_match ah_mt_reg = {
 	.size		= XT_ALIGN(sizeof(struct ipt_ah)),
 	.userspacesize 	= XT_ALIGN(sizeof(struct ipt_ah)),
 	.help 		= ah_help,
+	.init		= ah_init,
 	.print 		= ah_print,
 	.save 		= ah_save,
 	.x6_parse	= ah_parse,
diff --git a/extensions/libipt_ah.t b/extensions/libipt_ah.t
index a0ce3b0..2993906 100644
--- a/extensions/libipt_ah.t
+++ b/extensions/libipt_ah.t
@@ -10,3 +10,4 @@
 -m ah --ahspi 0;;FAIL
 -m ah --ahspi;;FAIL
 -m ah;;FAIL
+-p ah -m ah;-p ah -m ah --ahspi 0;FAIL
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 294338b..773d6af 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -21,6 +21,13 @@ static const struct xt_option_entry esp_opts[] = {
 	XTOPT_TABLEEND,
 };
 
+static void esp_init(struct xt_entry_match *m)
+{
+	struct xt_esp *espinfo = (void *)m->data;
+
+	espinfo->spis[1] = ~0U;
+}
+
 static void esp_parse(struct xt_option_call *cb)
 {
 	struct xt_esp *espinfo = cb->data;
@@ -86,6 +93,7 @@ static struct xtables_match esp_match = {
 	.size		= XT_ALIGN(sizeof(struct xt_esp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_esp)),
 	.help		= esp_help,
+	.init		= esp_init,
 	.print		= esp_print,
 	.save		= esp_save,
 	.x6_parse	= esp_parse,
diff --git a/extensions/libxt_esp.t b/extensions/libxt_esp.t
index 008013b..f207def 100644
--- a/extensions/libxt_esp.t
+++ b/extensions/libxt_esp.t
@@ -4,6 +4,7 @@
 -p esp -m esp --espspi 0:4294967295;-p esp -m esp;OK
 -p esp -m esp ! --espspi 0:4294967294;=;OK
 -p esp -m esp --espspi -1;;FAIL
+-p esp -m esp;-p esp -m esp --espspi 0;FAIL
 # should fail?
 -p esp -m esp;=;OK
 -m esp;;FAIL
-- 
2.4.3

