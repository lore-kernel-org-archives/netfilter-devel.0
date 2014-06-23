From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [RFC PATCH libnetfilter_conntrack] add userspace dump filter
Date: Mon, 23 Jun 2014 19:26:50 +0900
Message-ID: <20140623102650.GD29052@gmail.com>
References: <20140617123718.GC24712@gmail.com>
 <20140618085936.GA3923@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:40209 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaFWK05 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:26:57 -0400
Received: by mail-pb0-f47.google.com with SMTP id up15so5690475pbc.6
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 03:26:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140618085936.GA3923@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Thank you for your understandable explanation. 
 
2014-06-18 17:59 GMT+09:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Tue, Jun 17, 2014 at 09:37:18PM +0900, Ken-ichirou MATSUZAWA wrote:
> Please, if you work on this, first send us a patch to generalize the
> filtering "framework" for ctnetlink dumps and then add the filtering
> by zone.
 
How about using sk_filter? I could have understood it's not efficient
than the way you told me but BPF seems more versatile and can work
on the socket which both dumping and listening event.
 
# I think your nfct-daemon.c example in libmnl
 
Also I know this changes dump behavior, I need to include an indication
in nla or somewhere which distinguishes from normal dump, but it's not
included. 
 
--------

This patch enables dump filtering by bpf. It is not efficient since every
nf_conn needs to be translated into skb, but it can be used both event and
dump socket.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netfilter/nf_conntrack_netlink.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f77024d..189f19d 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -831,10 +831,26 @@ restart:
 					    cb->nlh->nlmsg_seq,
 					    NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
 					    ct);
-			rcu_read_unlock();
-			if (res < 0) {
+			if (res >= 0) {
+				struct sk_filter *skfilter
+					= rcu_dereference(skb->sk->sk_filter);
+				int ret = 0;
+
+				if (skfilter != NULL) {
+					skb_pull(skb, cb->args[2]);
+					ret = SK_RUN_FILTER(skfilter, skb);
+					skb_push(skb, cb->args[2]);
+					if (ret)
+						cb->args[2] = res;
+					else
+						skb_trim(skb, cb->args[2]);
+				}
+				rcu_read_unlock();
+			} else {
+				rcu_read_unlock();
 				nf_conntrack_get(&ct->ct_general);
 				cb->args[1] = (unsigned long)ct;
+				cb->args[2] = 0;
 				spin_unlock(lockp);
 				goto out;
 			}
-- 
1.7.10.4

