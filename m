From: Michael Farrell <micolous+nf@gmail.com>
Subject: xtables-addons: patch for addition of "no-change" option for
 xt_quota2
Date: Tue, 29 Dec 2009 01:53:57 +1030
Message-ID: <1262013837.19823.48.camel@milliways>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-uY2y0dIB+oHfLyFODpEN"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:60418 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751727AbZL1Pi5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Dec 2009 10:38:57 -0500
Received: from [172.20.0.3] (unverified [203.122.251.29])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id 10788532-1927428
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Dec 2009 01:53:47 +1030 (CDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-uY2y0dIB+oHfLyFODpEN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hello,

I've written a patch to add an option to xt_quota2 called "no-change".
The effect of this option, while it is enabled, is that it will skip
incrementing or decrementing the quota counter.

The reason for implementing this is so that I could have a rule check if
quota is available for a rule in the PREROUTING tables, without actually
decrementing the amount of available quota.  I only wanted to decrement
the amount of available quota in the FORWARD rule.  Otherwise, the first
packet of every connection would be counted twice.

My goal was to be able to use this to implement a captive portal for
users who did not have sufficient quota available to otherwise have
their requests forwarded to the internet.

While I implemented the no-change option for both the quota and grow /
counter modes of xt_quota2, it is only really useful in quota mode.  I
implemented it in both modes to be consistent.

This patch is against the current git version of xtables-addons.  I've
successfully built the patch on i386 and amd64, and tested it on i386,
though I don't believe there to be any architecture-specific additions
that would cause problems.


--Michael Farrell



--=-uY2y0dIB+oHfLyFODpEN
Content-Disposition: attachment; filename="xt-quota2-no-change.patch"
Content-Type: text/x-patch; name="xt-quota2-no-change.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/extensions/libxt_quota2.c b/extensions/libxt_quota2.c
index db144f9..4bbb04b 100644
--- a/extensions/libxt_quota2.c
+++ b/extensions/libxt_quota2.c
@@ -2,6 +2,7 @@
  *	"quota2" match extension for iptables
  *	Sam Johnston <samj [at] samj net>
  *	Jan Engelhardt <jengelh [at] medozas de>, 2008
+ *	Michael Farrell <micolous+nf [at] gmail com>, 2009
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License; either
@@ -17,17 +18,19 @@
 #include "xt_quota2.h"
 
 enum {
-	FL_QUOTA  = 1 << 0,
-	FL_NAME   = 1 << 1,
-	FL_GROW   = 1 << 2,
-	FL_PACKET = 1 << 3,
+	FL_QUOTA     = 1 << 0,
+	FL_NAME      = 1 << 1,
+	FL_GROW      = 1 << 2,
+	FL_PACKET    = 1 << 3,
+	FL_NO_CHANGE = 1 << 4,
 };
 
 static const struct option quota_mt2_opts[] = {
-	{.name = "grow",    .has_arg = false, .val = 'g'},
-	{.name = "name",    .has_arg = true,  .val = 'n'},
-	{.name = "quota",   .has_arg = true,  .val = 'q'},
-	{.name = "packets", .has_arg = false, .val = 'p'},
+	{.name = "grow",      .has_arg = false, .val = 'g'},
+	{.name = "no-change", .has_arg = false, .val = 'c'},
+	{.name = "name",      .has_arg = true,  .val = 'n'},
+	{.name = "quota",     .has_arg = true,  .val = 'q'},
+	{.name = "packets",   .has_arg = false, .val = 'p'},
 	{NULL},
 };
 
@@ -36,6 +39,7 @@ static void quota_mt2_help(void)
 	printf(
 	"quota match options:\n"
 	"    --grow           provide an increasing counter\n"
+	"    --no-change      never change counter/quota value for matching packets\n"
 	"    --name name      name for the file in sysfs\n"
 	"[!] --quota quota    initial quota (bytes or packets)\n"
 	"    --packets        count packets instead of bytes\n"
@@ -56,6 +60,12 @@ quota_mt2_parse(int c, char **argv, int invert, unsigned int *flags,
 		info->flags |= XT_QUOTA_GROW;
 		*flags |= FL_GROW;
 		return true;
+	case 'c': // no-change
+		xtables_param_act(XTF_ONLY_ONCE, "quota", "--no-change", *flags & FL_NO_CHANGE);
+		xtables_param_act(XTF_NO_INVERT, "quota", "--no-change", invert);
+		info->flags |= XT_QUOTA_NO_CHANGE;
+		*flags |= FL_NO_CHANGE;
+		return true;
 	case 'n':
 		/* zero termination done on behalf of the kernel module */
 		xtables_param_act(XTF_ONLY_ONCE, "quota", "--name", *flags & FL_NAME);
@@ -92,6 +102,8 @@ quota_mt2_save(const void *ip, const struct xt_entry_match *match)
 		printf("! ");
 	if (q->flags & XT_QUOTA_GROW)
 		printf("--grow ");
+	if (q->flags & XT_QUOTA_NO_CHANGE)
+	  printf("--no-change ");
 	if (q->flags & XT_QUOTA_PACKET)
 		printf("--packets ");
 	if (*q->name != '\0')
@@ -117,11 +129,13 @@ static void quota_mt2_print(const void *ip, const struct xt_entry_match *match,
 		printf("packets ");
 	else
 		printf("bytes ");
+	if (q->flags & XT_QUOTA_NO_CHANGE)
+		printf("(no-change mode) ");
 }
 
 static struct xtables_match quota_mt2_reg = {
 	.family        = AF_UNSPEC,
-	.revision      = 3,
+	.revision      = 4,
 	.name          = "quota2",
 	.version       = XTABLES_VERSION,
 	.size          = XT_ALIGN(sizeof (struct xt_quota_mtinfo2)),
diff --git a/extensions/libxt_quota2.man b/extensions/libxt_quota2.man
index affa32f..3fa2f5b 100644
--- a/extensions/libxt_quota2.man
+++ b/extensions/libxt_quota2.man
@@ -10,6 +10,12 @@ the match will return false, just like the original "quota" match. In growing
 \fB\-\-grow\fP
 Count upwards instead of downwards.
 .TP
+\fB\-\-no\-change\fP
+Makes it so the counter or quota amount is never changed by packets matching
+this rule.  This is only really useful in "quota" mode, as it will allow you
+to use complex prerouting rules in association with the quota system, without
+counting a packet twice.  In "grow" mode, this option is entirely pointless.
+.TP
 \fB\-\-name\fP \fIname\fP
 Assign the counter a specific name. This option must be present, as an empty
 name is not allowed. Names starting with a dot or names containing a slash are
diff --git a/extensions/xt_quota2.Kconfig b/extensions/xt_quota2.Kconfig
index 74744af..3b9b42b 100644
--- a/extensions/xt_quota2.Kconfig
+++ b/extensions/xt_quota2.Kconfig
@@ -5,4 +5,5 @@ config NETFILTER_XT_MATCH_QUOTA2
 	This option adds the "quota2" match which is an advanced form of
 	xt_quota that also allows counting upwards, and where the counter can
 	be set through procfs. This allows for simple interfacing of
-	accounting information.
+	accounting information. It also allows for no-change quota, allowing advanced
+	prerouting and postrounting rules based on quota amounts.
diff --git a/extensions/xt_quota2.c b/extensions/xt_quota2.c
index fbc8aab..a34dfbf 100644
--- a/extensions/xt_quota2.c
+++ b/extensions/xt_quota2.c
@@ -3,6 +3,8 @@
  * as a minimal accounting match.
  * by Jan Engelhardt <jengelh@medozas.de>, 2008
  *
+ * no-change option added by Michael Farrell <micolous+nf@gmail.com>, 2009
+ *
  * Originally based on xt_quota.c:
  * 	netfilter module to enforce network quotas
  * 	Sam Johnston <samj@samj.net>
@@ -199,12 +201,17 @@ quota_mt2(const struct sk_buff *skb, const struct xt_match_param *par)
 
 	spin_lock_bh(&e->lock);
 	if (q->flags & XT_QUOTA_GROW) {
-		e->quota += (q->flags & XT_QUOTA_PACKET) ? 1 : skb->len;
-		q->quota = e->quota;
+		// while no_change is pointless in "grow" mode, we'll implement it here
+		// simply to have consistent behaviour.
+		if (!(q->flags & XT_QUOTA_NO_CHANGE)) {
+			e->quota += (q->flags & XT_QUOTA_PACKET) ? 1 : skb->len;
+			q->quota = e->quota;
+		}
 		ret = true;
 	} else {
 		if (e->quota >= skb->len) {
-			e->quota -= (q->flags & XT_QUOTA_PACKET) ? 1 : skb->len;
+			if (!(q->flags & XT_QUOTA_NO_CHANGE))
+				e->quota -= (q->flags & XT_QUOTA_PACKET) ? 1 : skb->len;
 			ret = !ret;
 		} else {
 			/* we do not allow even small packets from now on */
@@ -219,7 +226,7 @@ quota_mt2(const struct sk_buff *skb, const struct xt_match_param *par)
 static struct xt_match quota_mt2_reg[] __read_mostly = {
 	{
 		.name       = "quota2",
-		.revision   = 3,
+		.revision   = 4,
 		.family     = NFPROTO_IPV4,
 		.checkentry = quota_mt2_check,
 		.match      = quota_mt2,
@@ -229,7 +236,7 @@ static struct xt_match quota_mt2_reg[] __read_mostly = {
 	},
 	{
 		.name       = "quota2",
-		.revision   = 3,
+		.revision   = 4,
 		.family     = NFPROTO_IPV6,
 		.checkentry = quota_mt2_check,
 		.match      = quota_mt2,
@@ -264,6 +271,7 @@ module_exit(quota_mt2_exit);
 MODULE_DESCRIPTION("Xtables: countdown quota match; up counter");
 MODULE_AUTHOR("Sam Johnston <samj@samj.net>");
 MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
+MODULE_AUTHOR("Michael Farrell <micolous+nf@gmail.com>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_quota2");
 MODULE_ALIAS("ip6t_quota2");
diff --git a/extensions/xt_quota2.h b/extensions/xt_quota2.h
index 05e3e20..eadc690 100644
--- a/extensions/xt_quota2.h
+++ b/extensions/xt_quota2.h
@@ -2,10 +2,11 @@
 #define _XT_QUOTA_H
 
 enum xt_quota_flags {
-	XT_QUOTA_INVERT = 1 << 0,
-	XT_QUOTA_GROW   = 1 << 1,
-	XT_QUOTA_PACKET = 1 << 2,
-	XT_QUOTA_MASK   = 0x7,
+	XT_QUOTA_INVERT    = 1 << 0,
+	XT_QUOTA_GROW      = 1 << 1,
+	XT_QUOTA_PACKET    = 1 << 2,
+	XT_QUOTA_NO_CHANGE = 1 << 3,
+	XT_QUOTA_MASK      = 0x0F,
 };
 
 struct xt_quota_counter;

--=-uY2y0dIB+oHfLyFODpEN--

