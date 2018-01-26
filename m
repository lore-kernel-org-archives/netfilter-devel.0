From: shyam saini <mayhs11saini@gmail.com>
Subject: [Iptables PATCH] extensions: Rename 'flow table' keyword to meter
Date: Sat, 27 Jan 2018 00:11:16 +0530
Message-ID: <1516992076-10321-1-git-send-email-mayhs11saini@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
        shyam saini <mayhs11saini@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35641 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751879AbeAZSli (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Jan 2018 13:41:38 -0500
Received: by mail-pf0-f193.google.com with SMTP id t12so825785pfg.2
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jan 2018 10:41:38 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After nft v0.8.1 "flow table" is renamed as meter.
This should reflect in iptables to nftables translation.

Before this patch:
$ iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit
--hashlimit-above 200/sec --hashlimit-mode srcip,dstport
--hashlimit-name http1 -j DROP

nft add rule ip filter INPUT tcp dport 80 flow table http1 { tcp dport .
ip saddr limit rate over 200/second } counter drop

After this patch:
$ iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit
--hashlimit-upto 200 --hashlimit-mode srcip --hashlimit-name http3
--hashlimit-srcmask 24 -j DROP

nft add rule ip filter INPUT tcp dport 80 meter http3 { ip saddr and
255.255.255.0 limit rate 200/second } counter drop

Signed-off-by: shyam saini <mayhs11saini@gmail.com>
---
 extensions/libxt_hashlimit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 3fa5719127db..86234e3d6089 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -1338,7 +1338,7 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
 {
 	int ret = 1;
 
-	xt_xlate_add(xl, "flow table %s {", name);
+	xt_xlate_add(xl, "meter %s {", name);
 	ret = hashlimit_mode_xlate(xl, cfg->mode, family,
 				   cfg->srcmask, cfg->dstmask);
 	if (cfg->expire != 1000)
@@ -1367,7 +1367,7 @@ static int hashlimit_xlate(struct xt_xlate *xl,
 	const struct xt_hashlimit_info *info = (const void *)params->match->data;
 	int ret = 1;
 
-	xt_xlate_add(xl, "flow table %s {", info->name);
+	xt_xlate_add(xl, "meter %s {", info->name);
 	ret = hashlimit_mode_xlate(xl, info->cfg.mode, NFPROTO_IPV4, 32, 32);
 	xt_xlate_add(xl, " timeout %us limit rate", info->cfg.expire / 1000);
 	print_packets_rate_xlate(xl, info->cfg.avg, 1);
-- 
1.9.1

