From: Kristof Provost <kristof@sigsegv.be>
Subject: IPv6 fragment packet handling
Date: Thu, 28 Jun 2012 17:50:50 +0200
Message-ID: <20120628155050.GK9423@thebe.jupiter.sigsegv.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mercury.codepro.be ([95.142.164.132]:59147 "EHLO
	mercury.codepro.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2F1QAs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:00:48 -0400
Received: from adrastea.jupiter.sigsegv.be (adrastea.jupiter.sigsegv.be [IPv6:2001:6f8:1498:1::3])
	by mercury.codepro.be (Postfix) with ESMTP id D4EF211F
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jun 2012 17:51:20 +0200 (CEST)
Received: from thebe.jupiter.sigsegv.be (thebe.jupiter.sigsegv.be [172.16.1.5])
	by adrastea.jupiter.sigsegv.be (Postfix) with ESMTP id 9EA6499DD
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jun 2012 17:50:50 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I've noticed an annoying difference between IPv4 and IPv6 regarding
fragmented packet handling.
The IPv4 netfilter code defragments packets before the hit the filter
table, but the IPv6 code does not.

As a result the following means that the host won't receive fragmented 
ICMPv6 echo packets (for example ping6 -s 3000 <host>):

ip6tables -F INPUT
ip6tables -I INPUT -p icmpv6 -m icmp6 --icmpv6-type 128 -j ACCEPT
ip6tables -P INPUT DROP

The first fragment makes it through (hitting the icmpv6 rule), but
subsequent fragments are dropped.
In the IPv4 case the packet does make it through. 'iptables -L INPUT
-vn' then shows that the ICMP rule hit one packet for about 3000 bytes.

Am I missing something obvious? Is there a reason for this difference?

The following proof-of-concept patch changes the IPv6 behavior to match
that of IPv4:

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index c9c78c2..5bb44eb 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -593,6 +593,11 @@ void nf_ct_frag6_output(unsigned int hooknum, struct sk_buff *skb,
 {
 	struct sk_buff *s, *s2;
 
+	nf_conntrack_get_reasm(skb);
+
+	NF_HOOK_THRESH(NFPROTO_IPV6, hooknum, skb, in, out, okfn,
+		       NF_IP6_PRI_CONNTRACK_DEFRAG + 1);
+
 	for (s = NFCT_FRAG6_CB(skb)->orig; s;) {
 		nf_conntrack_put_reasm(s->nfct_reasm);
 		nf_conntrack_get_reasm(skb);
@@ -601,8 +606,8 @@ void nf_ct_frag6_output(unsigned int hooknum, struct sk_buff *skb,
 		s2 = s->next;
 		s->next = NULL;
 
-		NF_HOOK_THRESH(NFPROTO_IPV6, hooknum, s, in, out, okfn,
-			       NF_IP6_PRI_CONNTRACK_DEFRAG + 1);
+		nf_conntrack_put_reasm(s);
+
 		s = s2;
 	}
 	nf_conntrack_put_reasm(skb);

Regards,
Kristof

