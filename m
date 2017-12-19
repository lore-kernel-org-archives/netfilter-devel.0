From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] extensions: libxt_hashlimit: Do not print default timeout and burst
Date: Tue, 19 Dec 2017 17:57:16 +0530
Message-ID: <20171219122716.19710-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, harshasharmaiitr@gmail.com
To: pablo@netfilter.org, nmalykh@bilim.com, rv@wallfire.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:45069 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751281AbdLSM2M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Dec 2017 07:28:12 -0500
Received: by mail-pl0-f68.google.com with SMTP id o2so6855072plk.12
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 04:28:11 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Do not print timeout and burst in case default values are used.
For e.g.
iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit
--hashlimit-above 200/sec --hashlimit-mode srcip,dstport
--hashlimit-name http1 -j DROP

nft add rule ip filter INPUT tcp dport 80 flow table http1 { tcp dport .
ip saddr limit rate over 200/second } counter drop

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 extensions/libxt_hashlimit.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index e51ac1ae..3206c0a4 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -7,7 +7,7 @@
  * Based on ipt_limit.c by
  * Jérôme de Vivie   <devivie@info.enserb.u-bordeaux.fr>
  * Hervé Eychenne    <rv@wallfire.org>
- * 
+ *
  * Error corections by nmalykh@bilim.com (22.01.2005)
  */
 #define _BSD_SOURCE 1
@@ -33,6 +33,8 @@
 /* miliseconds */
 #define XT_HASHLIMIT_GCINTERVAL	1000
 
+int XT_HASHLIMIT_BYTE_EXPIRE_DEFAULT;
+
 struct hashlimit_mt_udata {
 	uint32_t mult;
 };
@@ -678,6 +680,7 @@ static void hashlimit_mt_parse(struct xt_option_call *cb)
 			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
 				"--hashlimit-rate-interval", cb->arg);
 	}
+
 }
 
 static void hashlimit_check(struct xt_fcheck_call *cb)
@@ -762,8 +765,10 @@ static void hashlimit_mt_check(struct xt_fcheck_call *cb)
 	if (!(cb->xflags & (F_UPTO | F_ABOVE)))
 		xtables_error(PARAMETER_PROBLEM,
 				"You have to specify --hashlimit");
-	if (!(cb->xflags & F_HTABLE_EXPIRE))
+	if (!(cb->xflags & F_HTABLE_EXPIRE)) {
+		XT_HASHLIMIT_BYTE_EXPIRE_DEFAULT = 1;
 		info->cfg.expire = udata->mult * 1000; /* from s to msec */
+	}
 
 	if (info->cfg.mode & XT_HASHLIMIT_BYTES) {
 		uint32_t burst = 0;
@@ -1208,7 +1213,7 @@ static const struct rates rates_xlate[] = {
 	{ "second", XT_HASHLIMIT_SCALE_v2 } };
 
 static void print_packets_rate_xlate(struct xt_xlate *xl, uint64_t avg,
-				     uint64_t burst, int revision)
+				     int revision)
 {
 	unsigned int i;
 	const struct rates *_rates = (revision == 1) ?
@@ -1219,8 +1224,8 @@ static void print_packets_rate_xlate(struct xt_xlate *xl, uint64_t avg,
 		    _rates[i].mult / avg < _rates[i].mult % avg)
 			break;
 
-	xt_xlate_add(xl, " %llu/%s burst %lu packets",
-		     _rates[i-1].mult / avg, _rates[i-1].name, burst);
+	xt_xlate_add(xl, " %llu/%s ",
+		     _rates[i-1].mult / avg, _rates[i-1].name);
 }
 
 static void print_bytes_rate_xlate(struct xt_xlate *xl,
@@ -1340,7 +1345,9 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
 	xt_xlate_add(xl, "flow table %s {", name);
 	ret = hashlimit_mode_xlate(xl, cfg->mode, family,
 				   cfg->srcmask, cfg->dstmask);
-	xt_xlate_add(xl, " timeout %us limit rate", cfg->expire / 1000);
+	if (!XT_HASHLIMIT_BYTE_EXPIRE_DEFAULT)
+		xt_xlate_add(xl, " timeout %us", cfg->expire / 1000);
+	xt_xlate_add(xl, " limit rate");
 
 	if (cfg->mode & XT_HASHLIMIT_INVERT)
 		xt_xlate_add(xl, " over");
@@ -1348,8 +1355,9 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
 	if (cfg->mode & XT_HASHLIMIT_BYTES)
 		print_bytes_rate_xlate(xl, cfg);
 	else
-		print_packets_rate_xlate(xl, cfg->avg, cfg->burst, revision);
-
+		print_packets_rate_xlate(xl, cfg->avg, revision);
+	if (cfg->burst & (1 << XT_HASHLIMIT_BURST))
+		xt_xlate_add(xl, " burst %lu packets", cfg->burst);
 	xt_xlate_add(xl, "}");
 
 	return ret;
@@ -1364,7 +1372,8 @@ static int hashlimit_xlate(struct xt_xlate *xl,
 	xt_xlate_add(xl, "flow table %s {", info->name);
 	ret = hashlimit_mode_xlate(xl, info->cfg.mode, NFPROTO_IPV4, 32, 32);
 	xt_xlate_add(xl, " timeout %us limit rate", info->cfg.expire / 1000);
-	print_packets_rate_xlate(xl, info->cfg.avg, info->cfg.burst, 1);
+	print_packets_rate_xlate(xl, info->cfg.avg, 1);
+	xt_xlate_add(xl, " burst %lu packets", info->cfg.burst);
 	xt_xlate_add(xl, "}");
 
 	return ret;
-- 
2.11.0

