From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] Handle invalid packets in conntrack consistently
Date: Tue, 10 Apr 2012 00:42:47 +0200
Message-ID: <20120409224247.GA27514@1984>
References: <1333724253-32261-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58664 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab2DIWmx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:42:53 -0400
Content-Disposition: inline
In-Reply-To: <1333724253-32261-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jozsef,

On Fri, Apr 06, 2012 at 04:57:31PM +0200, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> As it was discussed, at the moment conntrack handles invalid packets
> differently: IPv6 conntrack marks the packets as INVALID and lets
> the user to drop them by an explicit rule, while IPv4 conntrack
> simply drops such packets.
> 
> The next two patches bring conntrack in sync by changing IPv4 conntrack
> behaviour to follow IPv6 conntrack. Invalid packet logging support is
> also added.
> 
> The patches are follow-up of the second version of the patch I sent on
> Tuesday, with the cover letter subject "Drop malformed IPv4 packets in
> conntrack, 2nd try".

If you don't mind, I'll submit the following reworked patches.
Basically, it initially fixes the inconsistency in the handling of bad
packets between IPv4 and IPv6, then the packets with wrong ihl.

I have left the change to add logging out, I think that belongs to
net-next. I'll recover that once I start collecting patches for it
(that will happen along this week).

I have kept you as author, they are basically yours with little
changes, I hope that you don't mind.

--huq684BweRXVnRxX
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_ct_ipv4-handle-invalid-IPv4-and-IPv6-pa.patch"

>From 8430eac2f6a3c2adce22d490e2ab8bb50d59077a Mon Sep 17 00:00:00 2001
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Mon, 9 Apr 2012 16:32:16 +0200
Subject: [PATCH 1/2] netfilter: nf_ct_ipv4: handle invalid IPv4 and IPv6 packets consistently

IPv6 conntrack marked invalid packets as INVALID and let the user
drop those by an explicit rule, while IPv4 conntrack dropped such
packets itself.

IPv4 conntrack is changed so that it marks INVALID packets and let
the user to drop them.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index de9da21..750b06a 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -74,12 +74,12 @@ static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 
 	iph = skb_header_pointer(skb, nhoff, sizeof(_iph), &_iph);
 	if (iph == NULL)
-		return -NF_DROP;
+		return -NF_ACCEPT;
 
 	/* Conntrack defragments packets, we might still see fragments
 	 * inside ICMP packets though. */
 	if (iph->frag_off & htons(IP_OFFSET))
-		return -NF_DROP;
+		return -NF_ACCEPT;
 
 	*dataoff = nhoff + (iph->ihl << 2);
 	*protonum = iph->protocol;
-- 
1.7.2.5


--huq684BweRXVnRxX
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-netfilter-nf_ct_ipv4-packets-with-wrong-ihl-are-inva.patch"

>From 22c6a3f87f4c36866269af66f26dd640ff2adc16 Mon Sep 17 00:00:00 2001
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Tue, 3 Apr 2012 22:02:01 +0200
Subject: [PATCH 2/2] netfilter: nf_ct_ipv4: packets with wrong ihl are invalid

It was reported that the Linux kernel sometimes logs:

klogd: [2629147.402413] kernel BUG at net / netfilter /
nf_conntrack_proto_tcp.c: 447!
klogd: [1072212.887368] kernel BUG at net / netfilter /
nf_conntrack_proto_tcp.c: 392

ipv4_get_l4proto() in nf_conntrack_l3proto_ipv4.c and tcp_error() in
nf_conntrack_proto_tcp.c should catch malformed packets, so the errors
at the indicated lines - TCP options parsing - should not happen.
However, tcp_error() relies on the "dataoff" offset to the TCP header,
calculated by ipv4_get_l4proto().  But ipv4_get_l4proto() does not check
bogus ihl values in IPv4 packets, which then can slip through tcp_error()
and get caught at the TCP options parsing routines.

The patch fixes ipv4_get_l4proto() by dropping packets with bogus
ihl value.

The patch closes netfilter bugzilla id 771.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 750b06a..7437832 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -84,6 +84,14 @@ static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 	*dataoff = nhoff + (iph->ihl << 2);
 	*protonum = iph->protocol;
 
+	/* Check bogus IP headers */
+	if (*dataoff > skb->len) {
+		pr_debug("nf_conntrack_ipv4: drop bogus IPv4 packet: "
+			 "nhoff %u, ihl %u, skblen %u\n",
+			 nhoff, iph->ihl << 2, skb->len);
+		return -NF_ACCEPT;
+	}
+
 	return NF_ACCEPT;
 }
 
-- 
1.7.2.5


--huq684BweRXVnRxX--
