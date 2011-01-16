From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 6/6] netfilter: do not omit re-route check on NF_QUEUE verdict
Date: Sun, 16 Jan 2011 14:19:07 +0100
Message-ID: <1295183947-12786-7-git-send-email-fw@strlen.de>
References: <1295183947-12786-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42911 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417Ab1APNYr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:24:47 -0500
In-Reply-To: <1295183947-12786-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ret != NF_QUEUE only works in the "--queue-num 0" case; for
queues > 0 the test should be '(ret & NF_VERDICT_MASK) != NF_QUEUE'.

However, NF_QUEUE no longer DROPs the skb unconditionally if queueing
fails (due to NF_VERDICT_FLAG_QUEUE_BYPASS verdict flag), so the
re-route test should also be performed if this flag is set in the
verdict.

The full test would then look something like

&& ((ret & NF_VERDICT_MASK) == NF_QUEUE && (ret & NF_VERDICT_FLAG_QUEUE_BYPASS))

This is rather ugly, so just remove the NF_QUEUE test altogether.

The only effect is that we might perform an unnecessary route lookup
in the NF_QUEUE case.

ip6table_mangle did not have such a check.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes since v1.

diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 294a2a3..aef5d1f 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -60,7 +60,7 @@ ipt_mangle_out(struct sk_buff *skb, const struct net_device *out)
 	ret = ipt_do_table(skb, NF_INET_LOCAL_OUT, NULL, out,
 			   dev_net(out)->ipv4.iptable_mangle);
 	/* Reroute for ANY change. */
-	if (ret != NF_DROP && ret != NF_STOLEN && ret != NF_QUEUE) {
+	if (ret != NF_DROP && ret != NF_STOLEN) {
 		iph = ip_hdr(skb);
 
 		if (iph->saddr != saddr ||
-- 
1.7.2.2

