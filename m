Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F0713E02E
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Oct 2024 10:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728037141; cv=none; b=l4eoxmEz3lOe0opPizfgFBbdgNxEPXR2yvS3ecg1OpvstKpc2hXcfQ+eK3d5DsukNHAwwBlwSdsub5BqV2h/t5zcQ210h7nISUzjs+sNFH2JUSgBgbLGAodXXJxQOrZ1ZwliNO2m2WNSzxGhOtl2QFIRXY5mR/uFSzSoqRRD01Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728037141; c=relaxed/simple;
	bh=IJSFV6NxX/rA+//1Qi3dZacQ58/r25mbK553V6jVHrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=efs7215BkQEU7m0uRfzeyuAliNzDhjLMa8RUUkDwXtKBRF7vsAEB/UiR1jlsuaLPH4wOOY10gD1KxxYOAJ0BeDa5qv5A5X/NB/MrT7x0IxURsqcDFwLEvPeUnYjLPu1RKACdOmVsWAqnvaPk2G1AZDcdMx23d1O7OfslLR1IqHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1swfOd-0004BD-WF; Fri, 04 Oct 2024 12:18:52 +0200
Date: Fri, 4 Oct 2024 12:18:51 +0200
From: Florian Westphal <fw@strlen.de>
To: Jan Engelhardt <ej@inai.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+256c348558aa5cf611a9@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: xt_cluster: enable ebtables operation?
Message-ID: <20241004101851.GA15968@breakpoint.cc>
References: <20241003183053.8555-1-fw@strlen.de>
 <0n89n176-p660-1953-3sn7-0q4rn8359sso@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0n89n176-p660-1953-3sn7-0q4rn8359sso@vanv.qr>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jan Engelhardt <ej@inai.de> wrote:
> >Module registers to NFPROTO_UNSPEC, but it assumes ipv4/ipv6 packet
> >processing.  As this is only useful to restrict locally terminating
                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >TCP/UDP traffic, reject non-ip families at rule load time.

> >@@ -124,6 +124,14 @@ static int xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
> > 	struct xt_cluster_match_info *info = par->matchinfo;
> > 	int ret;
> > 
> >+	switch (par->family) {
> >+	case NFPROTO_IPV4:
> >+	case NFPROTO_IPV6:
> >+		break;
> >+	default:
> >+		return -EAFNOSUPPORT;
> >+	}
> 
> I wonder if we could just implement the logic for it.

Whats the use case?

> Like this patch [untested!]:
> 
> From d534984879b9b3c4b8cf536cad1044c29b843a2d Mon Sep 17 00:00:00 2001
> From: Jan Engelhardt <jengelh@inai.de>
> Date: Thu, 3 Oct 2024 20:49:02 +0200
> Subject: [PATCH] xt_cluster: add logic for use from NFPROTO_BRIDGE
> 
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>  net/netfilter/xt_cluster.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
> index a047a545371e..cf4a74d68577 100644
> --- a/net/netfilter/xt_cluster.c
> +++ b/net/netfilter/xt_cluster.c
> @@ -68,6 +68,9 @@ xt_cluster_is_multicast_addr(const struct sk_buff *skb, u_int8_t family)
>  	case NFPROTO_IPV6:
>  		is_multicast = ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr);
>  		break;
> +	case NFPROTO_BRIDGE:
> +		is_multicast = is_multicast_ether_addr(eth_hdr(skb)->h_dest);
> +		break;

AFAIU this is always true: l2 address is always a multicast mac in
xt_cluster setups, we would need to peek into the L3 address to see if
its also multicast or if its the expected l3-unicast-in-l2-mcast.

I don't see a use case for supporting this from a bridge, but maybe I
missed something.
