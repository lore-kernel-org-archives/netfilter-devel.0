From: Sergey Popovich <popovich_sergei@mail.ru>
Subject: [PATCH 3/3] ipset: Follow manual page behavior for SET target on list:set
Date: Thu, 07 Nov 2013 12:56:45 +0200
Message-ID: <2035028.3MjN3UaUgL@tuxracer>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp12.mail.ru ([94.100.176.89]:34364 "EHLO smtp12.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab3KGLAq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:00:46 -0500
Received: from [2a01:6d80:103:13::c3ea:4404] (port=51654 helo=tuxracer.localnet)
	by smtp12.mail.ru with esmtpa (envelope-from <popovich_sergei@mail.ru>)
	id 1VeNKO-00068O-9Y
	for netfilter-devel@vger.kernel.org; Thu, 07 Nov 2013 15:00:44 +0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ipset(8) for list:set says:
  The match will try to find a matching entry in the sets and the
  target will try to add an entry to the first set to which it can
  be added.

However real behavior is bit differ from described. Consider example:

 # ipset create test-1-v4 hash:ip family inet
 # ipset create test-1-v6 hash:ip family inet6
 # ipset create test-1 list:set
 # ipset add test-1 test-1-v4
 # ipset add test-1 test-1-v6

 # iptables  -A INPUT -p tcp --destination-port 25 -j SET --add-set test-1 src
 # ip6tables -A INPUT -p tcp --destination-port 25 -j SET --add-set test-1 src

And then when iptables/ip6tables rule matches packet IPSET target
tries to add src from packet to the list:set test-1 where first
entry is test-1-v4 and the second one is test-1-v6.

For IPv4, as it first entry in test-1 src added to test-1-v4
correctly, but for IPv6 src not added!

Placing test-1-v6 to the first element of list:set makes behavior
correct for IPv6, but brokes for IPv4.

This is due to result, returned from ip_set_add() and ip_set_del() from
net/netfilter/ipset/ip_set_core.c when set in list:set equires more
parameters than given or address families do not match (which is this
case).

It seems wrong returning 0 from ip_set_add() and ip_set_del() in
this case, as 0 should be returned only when an element successfuly
added/deleted to/from the set, contrary to ip_set_test() which
returns 0 when no entry exists and >0 when entry found in set.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ru>
---
 kernel/net/netfilter/ipset/ip_set_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_core.c 
b/kernel/net/netfilter/ipset/ip_set_core.c
index e43d7db..31c18cf 100644
--- a/kernel/net/netfilter/ipset/ip_set_core.c
+++ b/kernel/net/netfilter/ipset/ip_set_core.c
@@ -516,7 +516,7 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
 
 	if (opt->dim < set->type->dimension ||
 	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
-		return 0;
+		return -IPSET_ERR_TYPE_MISMATCH;
 
 	write_lock_bh(&set->lock);
 	ret = set->variant->kadt(set, skb, par, IPSET_ADD, opt);
@@ -539,7 +539,7 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
 
 	if (opt->dim < set->type->dimension ||
 	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
-		return 0;
+		return -IPSET_ERR_TYPE_MISMATCH;
 
 	write_lock_bh(&set->lock);
 	ret = set->variant->kadt(set, skb, par, IPSET_DEL, opt);
-- 
1.7.10.4

