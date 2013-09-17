From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: nfnetlink_queue: shouldn't it be entry->skb?
Date: Tue, 17 Sep 2013 13:43:48 +0800
Message-ID: <5237EC14.5010908@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16700 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab3IQFom (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 01:44:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

skb is the netlink type sk_buff, shouldn't we pass entry->skb to nfqnl_ct_seq_adjust?
Since I'm blocked by how to send proper netlink message to make nfqnl_ct_parse find
out ct :( , I haven't confirmed this problem. :(


diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queu
index 95a98c8..ae2e5c1 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -1009,7 +1009,7 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
                        verdict = NF_DROP;

                if (ct)
-                       nfqnl_ct_seq_adjust(skb, ct, ctinfo, diff);
+                       nfqnl_ct_seq_adjust(entry->skb, ct, ctinfo, diff);
        }
