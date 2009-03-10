From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: remove IPvX specific parts from
 nf_conntrack_l4proto.h
Date: Tue, 10 Mar 2009 17:15:12 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903101714170.23653@fbirervta.pbzchgretzou.qr>
References: <1236615258-12897-1-git-send-email-christoph.paasch@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, kaber@trash.net
To: Christoph Paasch <christoph.paasch@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55030 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbZCJQPO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:15:14 -0400
In-Reply-To: <1236615258-12897-1-git-send-email-christoph.paasch@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On Monday 2009-03-09 17:14, Christoph Paasch wrote:

>Moving the structure definitions to the corresponding IPvX specific header files.
>---
> include/net/netfilter/nf_conntrack_l4proto.h   |    5 +----
> net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    1 +
> net/netfilter/nf_conntrack_proto_tcp.c         |    2 ++
> net/netfilter/nf_conntrack_proto_udp.c         |    2 ++
> 4 files changed, 6 insertions(+), 4 deletions(-)


Seems good to go to me. Patrick?


>diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
>index debdaf7..16ab604 100644
>--- a/include/net/netfilter/nf_conntrack_l4proto.h
>+++ b/include/net/netfilter/nf_conntrack_l4proto.h
>@@ -90,10 +90,7 @@ struct nf_conntrack_l4proto
> 	struct module *me;
> };
> 
>-/* Existing built-in protocols */
>-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6;
>-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
>-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6;
>+/* Existing built-in generic protocol */
> extern struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
> 
> #define MAX_NF_CT_PROTO 256
>diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
>index 727b953..e6852f6 100644
>--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
>+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
>@@ -26,6 +26,7 @@
> #include <net/netfilter/nf_conntrack_l4proto.h>
> #include <net/netfilter/nf_conntrack_l3proto.h>
> #include <net/netfilter/nf_conntrack_core.h>
>+#include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
> 
> static bool ipv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
> 			      struct nf_conntrack_tuple *tuple)
>diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
>index a1edb9c..7d3944f 100644

>[...]
