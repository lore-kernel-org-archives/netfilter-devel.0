From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH] netfilter: Kill unreplied conntracks by ICMP errors
Date: Sun, 15 Dec 2013 07:57:02 +0100
Message-ID: <2247276.HWz9edslhi@gentoovm>
References: <1386861575-121885-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: xiaosuo@gmail.xom
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:53909 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3LOG6H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Dec 2013 01:58:07 -0500
In-Reply-To: <1386861575-121885-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 12 December 2013 10:19:34 Changli Gao wrote:
> Think about the following scenario:
> 
> +--------+      +-------+      +----------+
> 
> | Server +------+ NAT 1 +------| Client 1 |
> 
> +---+----+      +-------+      +----------+
> 
>     |           +-------+      +----------+
> 
>     +-----------+ NAT 2 +------| Client 2 |
>                 +-------+      +----------+
> 
> The following UDP punching steps are used to to establish a direct session
> between Client 1 and Client 2 with the help from Server.
> 
> 1. Client 1 sends a UDP packet to Server, and Server learned the public IP
> and port of Client 1.
> 2. Client 2 sends a UDP packet to Server, and Server learned the public IP
> and port of Client 2.
> 3. Server tells Client 1 the public IP and port of Client 2.
> 4. Server tells Client 2 the public IP and port of Client 1.
> 5. Client 1 sends UDP packets to the public IP and port of Client 2.
> 6. Client 2 sends UDP packets to the public IP and port of Client 1.
> 
> If both NAT 1 and NAT 2 are Cone NAT, Client 1 and Client 2 can communicate
> with each other directly.
> 
> Linux tries its best to be a Port Restricted NAT. But there is a race
> condition between 5 and 6.
> 
> Suppose the packet from Client 1 to the public IP and port of Client 2
> reaches NAT 2 before the packet from Client 2 to the public IP and port of
> Client 1, and it belongs to a new session to NAT 2 itself since there isn't
> any corresponding conntrack in NAT 2, and it is likely that port isn't
> opened at NAT 2, so at last, a Port Unreachable ICMP packet will be
> delivered to Client 1.

I don't think that's universally the case; whether or not a port unreachable 
happens is going to depend on the configured behaviour; it may very well just 
silently drop the packet.

> 
> Then, the packet from Client 2 to the public IP and port of Client 1 reaches
> NAT 2, and NAT 2 fails to use the same public IP and port of the packet
> sent to Server as the source IP and port, because the corresponding tuple
> is in use, at last, NAT 2 has to allocate a new pair of IP and port.
> 
> One and simplest solution is killing unreplied conntracks by ICMP errors.
> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ---
>  net/ipv4/netfilter/nf_conntrack_proto_icmp.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
> b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c index a338dad..6210820
> 100644
> --- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
> +++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
> @@ -135,6 +135,7 @@ icmp_error_message(struct net *net, struct nf_conn
> *tmpl, struct sk_buff *skb, const struct nf_conntrack_l4proto *innerproto;
>  	const struct nf_conntrack_tuple_hash *h;
>  	u16 zone = tmpl ? nf_ct_zone(tmpl) : NF_CT_DEFAULT_ZONE;
> +	struct nf_conn *ct;
> 
>  	NF_CT_ASSERT(skb->nfct == NULL);
> 
> @@ -169,8 +170,12 @@ icmp_error_message(struct net *net, struct nf_conn
> *tmpl, struct sk_buff *skb, if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
>  		*ctinfo += IP_CT_IS_REPLY;
> 
> +	ct = nf_ct_tuplehash_to_ctrack(h);
> +	if (!test_bit(IPS_SEEN_REPLY, &ct->status))
> +		nf_ct_kill_acct(ct, *ctinfo, skb);
> +
Perhaps I'm mistaken here so please correct me if so:

Firstly, I don't see why this is necessary as once the client does hole punch, 
the conntrack entry should still be good to go providing the other end is 
adhering to the port it's supposed to use. UDP is unreliable so an application 
shouldn't be expecting perfect delivery; once Client B finally does their 
initial transmit, a retransmit on the part of Client A should succeed without 
any special behaviour on the part of Netfilter.

Secondly; I see this as a great opportunity for a DoS attack if someone can 
spam ICMP errors down the pipe at you.
>  	/* Update skb to refer to this connection */
> -	skb->nfct = &nf_ct_tuplehash_to_ctrack(h)->ct_general;
> +	skb->nfct = &ct->ct_general;
>  	skb->nfctinfo = *ctinfo;
>  	return NF_ACCEPT;
>  }

Regards,
Oliver.
