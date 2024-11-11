Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBE814600D
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Nov 2024 09:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731318980; cv=none; b=KkC14QCl1T/oQB+kWm1Wh+I7f9M/Xlm1dpgK9t4Gon5Hd3AQ3KvJ6gIwL2jJAAf4S3RoxltRnW/CjCTOf4HgDUX0qFaL2LSZ9+lhOGG/8oYXd9lzs7uOItxJ+kC49eWYPuD6cW5PHJ1e58U2Yohvf5fn6NlghPE20QMzQPFOd/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731318980; c=relaxed/simple;
	bh=fZGKHVIKfuGsYdRcmLy+MILRwocd+so37/mlxmSmiHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fF+cTe5j8LZ1AFLgEC4UNec8XTjQhkj4cRBNnUKJn3rs7ECHpb3LlO+8vb+JEV9LRCeYVU2V6rBqQT6g28dkYWVFQ5u1385WVSfunq0q/PBdHgS1wJlFil4+v0EBdAwSp/Qj6NjSK7lp2ods27P6pCZYBGbfoZwFOvU6cpfe8F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=58954 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tAR9Q-001Hxo-VW; Mon, 11 Nov 2024 10:56:07 +0100
Date: Mon, 11 Nov 2024 10:56:03 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Yadan Fan <ydfan@suse.com>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, Michal Kubecek <mkubecek@suse.de>,
	Hannes Reinecke <hare@kernel.org>
Subject: Re: [PATCH] nf_conntrack_proto_udp: Set ASSURED for NAT_CLASH
 entries to avoid packets dropped
Message-ID: <ZzHUsxsJExXq1Zcp@calendula>
References: <fd991e87-a97b-49af-892f-685b93833bd8@suse.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fd991e87-a97b-49af-892f-685b93833bd8@suse.com>
X-Spam-Score: -1.9 (-)

Hi,

On Thu, Oct 10, 2024 at 08:19:16PM +0800, Yadan Fan wrote:
> c46172147ebb brought the logic that never setting ASSURED to drop NAT_CLASH replies
> in case server is very busy and early_drop logic kicks in.
> 
> However, this will drop all subsequent UDP packets that sent through multiple threads
> of application, we already had a customer reported this issue that impacts their business,
> so deleting this logic to avoid this issue at the moment.
> 
> Fixes: c46172147ebb ("netfilter: conntrack: do not auto-delete clash entries on reply")
> 
> Signed-off-by: Yadan Fan <ydfan@suse.com>
> ---
>  net/netfilter/nf_conntrack_proto_udp.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
> index 0030fbe8885c..def3e06430eb 100644
> --- a/net/netfilter/nf_conntrack_proto_udp.c
> +++ b/net/netfilter/nf_conntrack_proto_udp.c
> @@ -116,10 +116,6 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
>  
>  		nf_ct_refresh_acct(ct, ctinfo, skb, extra);
>  
> -		/* never set ASSURED for IPS_NAT_CLASH, they time out soon */
> -		if (unlikely((status & IPS_NAT_CLASH)))
> -			return NF_ACCEPT;

This update is obsoleting several comments in the code, such as:

        /* IPS_NAT_CLASH removes the entry automatically on the first
         * reply.  Also prevents UDP tracker from moving the entry to
         * ASSURED state, i.e. the entry can always be evicted under
         * pressure.
         */
        loser_ct->status |= IPS_FIXED_TIMEOUT | IPS_NAT_CLASH;

According to 6a757c07e51f ("netfilter: conntrack: allow insertion of
clashing entries"), the idea is to let this packet go through (no
drop!) while next packets will already find the conntrack entry that
won race.

You mentioned this fix is for IPVS, you said:

> We have a customer who encountered an issue that UDP packets kept in
> UNREPLIED in conntrack table when there is large number of UDP packets
> sent from their application, the application send packets through multiple
> threads, it caused NAT clash because the same SNATs were used for multiple connections

Hm. But this IPS_NAT_CLASH entry should not be ever found by other
packets, this is just a dummy entry for _this_ packet that has a
clashing entry, to let it go through.

> setup, so that initial packets will be flagged with IPS_NAT_CLASH, and this snippet
> of codes just makes IPS_NAT_CLASH flagged packets never be marked as ASSURED, which
> caused all subsequent UDP packets got dropped.
> Issue just disappeared after deleting this portion.

Something is missing here, I still don't see how all this make sense.

> -
>  		/* Also, more likely to be important, and not a probe */
>  		if (stream && !test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
>  			nf_conntrack_event_cache(IPCT_ASSURED, ct);
> -- 
> 2.34.1
