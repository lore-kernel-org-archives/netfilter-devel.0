From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv3] extensions: libip6t_frag: Add translation to nft
Date: Tue, 7 Jun 2016 12:46:49 +0200
Message-ID: <20160607104649.GA1766@salvia>
References: <20160607073309.GA9381@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33591 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155AbcFGKq4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2016 06:46:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2A6F3499973
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 12:46:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 17A7A9EBA9
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 12:46:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B8CE69EBC3
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 12:46:51 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160607073309.GA9381@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 07, 2016 at 09:33:13AM +0200, Laura Garcia Liebana wrote:
> diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
> index 023df62..7871fb9 100644
> --- a/extensions/libip6t_frag.c
> +++ b/extensions/libip6t_frag.c
> @@ -173,6 +173,35 @@ static void frag_save(const void *ip, const struct xt_entry_match *match)
>  		printf(" --fraglast");
>  }
>  
> +static int frag_xlate(const void *ip, const struct xt_entry_match *match,
> +		      struct xt_xlate *xl, int numeric)
> +{
> +	const struct ip6t_frag *fraginfo = (struct ip6t_frag *)match->data;
> +
> +	if (!(fraginfo->ids[0] == 0 && fraginfo->ids[1] == 0xFFFFFFFF)) {
> +		xt_xlate_add(xl, "frag id %s",
> +			     (fraginfo->invflags & IP6T_FRAG_INV_IDS) ?
> +			     "!= " : "");
> +		if (fraginfo->ids[0] != fraginfo->ids[1])
> +			xt_xlate_add(xl, "%u-%u ", fraginfo->ids[0],
> +				     fraginfo->ids[1]);
> +		else
> +			xt_xlate_add(xl, "%u ", fraginfo->ids[0]);
> +	}
> +
> +	if (fraginfo->flags & IP6T_FRAG_RES)
> +		xt_xlate_add(xl, "frag reserved 1 ");
> +
> +	if (fraginfo->flags & IP6T_FRAG_FST)
> +		xt_xlate_add(xl, "frag frag-off 0 ");
> +
> +	if ((fraginfo->flags & IP6T_FRAG_MF) ||
> +	    (fraginfo->flags & IP6T_FRAG_NMF))
> +		xt_xlate_add(xl, "frag more-fragments 1 ");

I think IP6T_FRAG_NMF means no more fragments, ie. frag more-fragments 0.
While IP6T_FRAG_MF means more fragments, ie. frag more-fragments 1.

Please, review the logic that we have in the kernel module when
providing correct translations.

http://lxr.free-electrons.com/source/net/ipv6/netfilter/ip6t_frag.c

It would be also good if you test these rules from the packet path, by
generating traffic to trigger matches, not only from a control plane
perspective.

Thanks.
