From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Trivial 2.6 tftp conntrack fix
Date: Thu, 21 Aug 2003 01:00:10 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030822153414.84E262C0C4@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: davem@redhat.com, netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Name: TFTP Conntrack Helper Return Fix
Author: Rusty Russell
Status: Trivial

D: In 2.6, the TFTP conntrack helper returns -1 if the packet is too
D: short, but that is an invalid return code.  Return NF_ACCEPT
D: instead.

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .1520-linux-2.6.0-test3-bk6/net/ipv4/netfilter/ip_conntrack_tftp.c .1520-linux-2.6.0-test3-bk6.updated/net/ipv4/netfilter/ip_conntrack_tftp.c
--- .1520-linux-2.6.0-test3-bk6/net/ipv4/netfilter/ip_conntrack_tftp.c	2003-08-12 06:58:07.000000000 +1000
+++ .1520-linux-2.6.0-test3-bk6.updated/net/ipv4/netfilter/ip_conntrack_tftp.c	2003-08-21 00:58:52.000000000 +1000
@@ -44,7 +44,7 @@ static int tftp_help(struct sk_buff *skb
 
 	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4 + sizeof(struct udphdr),
 			  &tftph, sizeof(tftph)) != 0)
-		return -1;
+		return NF_ACCEPT;
 
 	switch (ntohs(tftph.opcode)) {
 	/* RRQ and WRQ works the same way */

--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
