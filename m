From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Unifying ip[6]tables matches/targets: using AF_UNSPEC for
	l3-independent
Date: Tue, 24 Jul 2007 09:47:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707240940470.18990@fbirervta.pbzchgretzou.qr>
References: <200707240657.l6O6vfKE018716@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707240657.l6O6vfKE018716@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi to all,


I'm following Yasuyuki's xtableificiation of iptables, and will handle 
the libxt_connlimit and libxt_u32 (huh - libipt_u32 not merged?). A few 
questions/ideas have come up:

Matches seem to require a .family field, even though there are a handful 
which operate l3-independent, such as ipt_u32, xt_string, xt_comment, 
and others. For these, we currently have to supply one 'struct 
xtables_match' per l3 proto. How about this patch demonstrating what 
I mean:

---
 extensions/libxt_string.c |   19 +------------------
 xtables.c                 |    2 +-
 2 files changed, 2 insertions(+), 19 deletions(-)

Index: iptables/extensions/libxt_string.c
===================================================================
--- iptables.orig/extensions/libxt_string.c
+++ iptables/extensions/libxt_string.c
@@ -335,23 +335,7 @@ save(const void *ip, const struct xt_ent
 
 static struct xtables_match string = {
     .name		= "string",
-    .family			= AF_INET,
-    .version		= IPTABLES_VERSION,
-    .size		= XT_ALIGN(sizeof(struct xt_string_info)),
-    .userspacesize	= offsetof(struct xt_string_info, config),
-    .help		= help,
-    .init		= init,
-    .parse		= parse,
-    .final_check	= final_check,
-    .print		= print,
-    .save		= save,
-    .extra_opts		= opts
-};
-
-
-static struct xtables_match string6 = {
-    .name		= "string",
-    .family			= AF_INET6,
+    .family			= AF_UNSPEC,
     .version		= IPTABLES_VERSION,
     .size		= XT_ALIGN(sizeof(struct xt_string_info)),
     .userspacesize	= offsetof(struct xt_string_info, config),
@@ -367,5 +351,4 @@ static struct xtables_match string6 = {
 void _init(void)
 {
 	xtables_register_match(&string);
-	xtables_register_match(&string6);
 }
Index: iptables/xtables.c
===================================================================
--- iptables.orig/xtables.c
+++ iptables/xtables.c
@@ -469,7 +469,7 @@ void xtables_register_match(struct xtabl
 	}
 
 	/* ignore not interested match */
-	if (me->family != afinfo.family)
+	if (me->family != AF_UNSPEC && me->family != afinfo.family)
 		return;
 
 	old = find_match(me->name, DURING_LOAD, NULL);
