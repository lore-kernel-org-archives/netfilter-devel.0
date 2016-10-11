From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: xt_NFLOG: fix unexpected truncated packet
Date: Tue, 11 Oct 2016 22:26:27 +0800
Message-ID: <1476195987-3129-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:43491 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753220AbcJKO13 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Oct 2016 10:27:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Justin and Chris spotted that iptables NFLOG target was broken when they
upgraded the kernel to 4.8: "ulogd-2.0.5- IPs are no longer logged" or
"results in segfaults in ulogd-2.0.5".

Because "struct nf_loginfo li;" is a local variable, and flags will be
filled with garbage value, not inited to zero. So if it contains 0x1,
packets will not be logged to the userspace anymore.

Fixes: 7643507fe8b5 ("netfilter: xt_NFLOG: nflog-range does not truncate packets")
Reported-by: Justin Piszcz <jpiszcz@lucidpixels.com>
Reported-by: Chris Caputo <ccaputo@alt.net>
Tested-by: Chris Caputo <ccaputo@alt.net>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 Sorry to redeliver this patch, my mail server told me that it failed.

 net/netfilter/xt_NFLOG.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index 018eed7..8668a5c 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -32,6 +32,7 @@ nflog_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	li.u.ulog.copy_len   = info->len;
 	li.u.ulog.group	     = info->group;
 	li.u.ulog.qthreshold = info->threshold;
+	li.u.ulog.flags	     = 0;
 
 	if (info->flags & XT_NFLOG_F_COPY_LEN)
 		li.u.ulog.flags |= NF_LOG_F_COPY_LEN;
-- 
2.5.5


