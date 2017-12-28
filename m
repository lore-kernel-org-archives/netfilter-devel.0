From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH v2] extensions: libxt_hashlimit: Do not print default timeout and burst
Date: Thu, 28 Dec 2017 12:58:33 +0530
Message-ID: <20171228072833.9980-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:37548 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751043AbdL1H3C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Dec 2017 02:29:02 -0500
Received: by mail-it0-f67.google.com with SMTP id d137so27841095itc.2
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Dec 2017 23:29:02 -0800 (PST)
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
Changes in v2:
 -Simple comparison for default values

 extensions/libxt_hashlimit.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index ffe342a7..472d8e7f 100644
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
@@ -1209,7 +1209,7 @@ static const struct rates rates_xlate[] = {
 	{ "second", XT_HASHLIMIT_SCALE_v2 } };
 
 static void print_packets_rate_xlate(struct xt_xlate *xl, uint64_t avg,
-				     uint64_t burst, int revision)
+				     int revision)
 {
 	unsigned int i;
 	const struct rates *_rates = (revision == 1) ?
@@ -1220,8 +1220,8 @@ static void print_packets_rate_xlate(struct xt_xlate *xl, uint64_t avg,
 		    _rates[i].mult / avg < _rates[i].mult % avg)
 			break;
 
-	xt_xlate_add(xl, " %llu/%s burst %lu packets",
-		     _rates[i-1].mult / avg, _rates[i-1].name, burst);
+	xt_xlate_add(xl, " %llu/%s ",
+		     _rates[i-1].mult / avg, _rates[i-1].name);
 }
 
 static void print_bytes_rate_xlate(struct xt_xlate *xl,
@@ -1341,7 +1341,9 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
 	xt_xlate_add(xl, "flow table %s {", name);
 	ret = hashlimit_mode_xlate(xl, cfg->mode, family,
 				   cfg->srcmask, cfg->dstmask);
-	xt_xlate_add(xl, " timeout %us limit rate", cfg->expire / 1000);
+	if (cfg->expire != 1000)
+		xt_xlate_add(xl, " timeout %us", cfg->expire / 1000);
+	xt_xlate_add(xl, " limit rate");
 
 	if (cfg->mode & XT_HASHLIMIT_INVERT)
 		xt_xlate_add(xl, " over");
@@ -1349,8 +1351,9 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
 	if (cfg->mode & XT_HASHLIMIT_BYTES)
 		print_bytes_rate_xlate(xl, cfg);
 	else
-		print_packets_rate_xlate(xl, cfg->avg, cfg->burst, revision);
-
+		print_packets_rate_xlate(xl, cfg->avg, revision);
+	if (cfg->burst != 5)
+		xt_xlate_add(xl, " burst %lu packets", cfg->burst);
 	xt_xlate_add(xl, "}");
 
 	return ret;
@@ -1365,7 +1368,8 @@ static int hashlimit_xlate(struct xt_xlate *xl,
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

