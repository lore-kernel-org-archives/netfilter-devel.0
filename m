From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: ebt_nflog: fix unexpected truncated packet
Date: Sun, 18 Jun 2017 10:51:09 +0800
Message-ID: <1497754269-44413-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <zlpnobody@gmail.com>,
        Vishwanath Pai <vpai@akamai.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:49283 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751727AbdFRCvx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Jun 2017 22:51:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

"struct nf_loginfo li;" is a local variable, so we should set the flags
to 0 explicitly, else, packets maybe truncated unexpectedly when copied
to the userspace.

Fixes: 7643507fe8b5 ("netfilter: xt_NFLOG: nflog-range does not truncate packets")
Cc: Vishwanath Pai <vpai@akamai.com>
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/bridge/netfilter/ebt_nflog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index c1dc486..da1c2fd 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -30,6 +30,7 @@ ebt_nflog_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	li.u.ulog.copy_len = info->len;
 	li.u.ulog.group = info->group;
 	li.u.ulog.qthreshold = info->threshold;
+	li.u.ulog.flags = 0;
 
 	nf_log_packet(net, PF_BRIDGE, xt_hooknum(par), skb, xt_in(par),
 		      xt_out(par), &li, "%s", info->prefix);
-- 
2.5.5


