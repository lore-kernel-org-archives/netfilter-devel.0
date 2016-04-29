From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nf_nat_packet: Clear skb hash after modifying packet
 headers.
Date: Fri, 29 Apr 2016 11:09:59 +0200
Message-ID: <20160429090959.GA7236@salvia>
References: <1461187870-54322-1-git-send-email-jarno@ovn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	dev@openvswitch.org, fw@strlen.de
To: Jarno Rajahalme <jarno@ovn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53968 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbcD2JKE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Apr 2016 05:10:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 08A8A4B10C
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:10:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ECA80FF2D6
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:10:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BF41A100A51
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 11:10:00 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1461187870-54322-1-git-send-email-jarno@ovn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 20, 2016 at 02:31:10PM -0700, Jarno Rajahalme wrote:
> Clear the skb hash when it does not reflect the actual header values
> any more.
> 
> Signed-off-by: Jarno Rajahalme <jarno@ovn.org>
> ---
>  net/netfilter/nf_nat_core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index 06a9f45..3c2302f 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -505,6 +505,7 @@ unsigned int nf_nat_packet(struct nf_conn *ct,
>  		if (!l3proto->manip_pkt(skb, 0, l4proto, &target, mtype))
>  			return NF_DROP;
>  	}
> +	skb_clear_hash(skb);
>  	return NF_ACCEPT;
>  }

Cc'ing Florian.

This seems to affect the new tracing infrastructure for nf_tables:

 31 static int trace_fill_id(struct sk_buff *nlskb, struct sk_buff
*skb)
 32 {
 33         __be32 id;
 34 
 35         /* using skb address as ID results in a limited number of
 36          * values (and quick reuse).
 37          *
 38          * So we attempt to use as many skb members that will not
 39          * change while skb is with netfilter.
 40          */
 41         id = (__be32)jhash_2words(hash32_ptr(skb), skb_get_hash(skb),
 42                                   skb->skb_iif);
 43 
 44         return nla_put_be32(nlskb, NFTA_TRACE_ID, id);
 45 }
