Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653BB208C4
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728750966; cv=none; b=W2CnCeprmM3aP0m8zOnD+yxXY8TAiiHiGXIfwmKOk4PNit6/xN16/rCnOwBreru2R4qtO1WfTTgTj8/gcUlBzqhsG4ePTsBWfjO8OSJqzk690MfTIZdAIOkSYIB3Ofr1srnwRYNp9eT5cbs4wU6JFU2KNu1DPWsOnzBG06bYGZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728750966; c=relaxed/simple;
	bh=OANcwyT7FpoiZIThul0yDwwMdyCf1e3edM0hVY8cHxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKw+Re4D7efj4wz/P1aaEiFybpcIgO98pBuLmcV13haNa+7Y2Qg/pUYhx3In4lDLQjo9XrvN0vqmAlOhEfHNA2W+AYeT37B3Mg4qxhCjNFYCSx3kcu0qmYc9rfQJ2BeBF+FSCHlUDH1WgRFVYvGRHltVfpjBjQTLI32FYq2DzPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=48186 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1szf5z-001ZU1-7d; Sat, 12 Oct 2024 18:36:01 +0200
Date: Sat, 12 Oct 2024 18:35:58 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] doc: extend description of fib expression
Message-ID: <ZwqlbhdH4Fw__daA@calendula>
References: <20241010133745.28765-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241010133745.28765-1-fw@strlen.de>
X-Spam-Score: -1.8 (-)

Hi Florian,

Thanks, this is an improvement, a few comments.

On Thu, Oct 10, 2024 at 03:37:42PM +0200, Florian Westphal wrote:
> +The last argument to the *fib* expression is the desired result type.
> +
> +*oif* asks to obtain the interface index that would be used to send packets to the packets source
> +(*saddr* key) or destination (*daddr* key).  If no routing entry is found, the returned interface
> +index is 0.
> +
> +*oifname* is like *oif*, but it fills the interface name instead.  This is useful to check dynamic
> +interfaces such as ppp devices.  If no entry is found, an empty interface name is returned.
> +
> +*type* returns the address type such as unicast or multicast.
> +
> +.FIB_TUPLE keywords
>  [options="header"]
>  |==================
> -|Keyword| Description| Type
> +|flag| Description
> +|daddr| Perform a normal route lookup: search fib for route to the *destination address* of the packet.
> +|saddr| Perform a reverse route lookup: search the fib for route to the *source address* of the packet.
> +|mark | consider the packet mark (nfmark) when querying the fib.
> +|iif  | fail fib lookup unless route exists and its output interface is identical to the packets input interface

maybe easier to understand?

           if fib lookups provides a route then check its output interface is identical to the packets *input* interface.

> +|oif  | fail fib lookup unless route exists and its output interface is identical to the packets output interface.

           if fib lookups provides a route then check its output interface is identical to the packets *output* interface.

> This flag can only be used with the *type* result.

Are you sure 'oif' can only be used with type? I can see NFTA_FIB_F_OIF is available in nft_fib4_eval()

        if (priv->flags & NFTA_FIB_F_OIF)
                oif = nft_out(pkt);
        else if (priv->flags & NFTA_FIB_F_IIF)
                oif = nft_in(pkt);
        else
                oif = NULL;

One more comment below.

> +|=======================
> +
> +.FIB_RESULT keywords
> +[options="header"]
> +|==================
> +|Keyword| Description| Result Type
>  |oif|
>  Output interface index|
>  integer (32 bit)
> @@ -334,20 +365,40 @@ fib_addrtype
>  
>  Use *nft* *describe* *fib_addrtype* to get a list of all address types.
>  
> +The *oif* and *oifname* result is only valid in the *prerouting*, *input* and *forward* hooks.
> +The *type* can be queried from any one of *prerouting*, *input*, *forward* *output* and *postrouting*.
> +
> +For *type*, the presence of the *iif* keyword in the 'FIB_TUPLE' modifiers restrict the available
> +hooks to those where the packet is associated with an incoming interface, i.e. *prerouting*, *input* and *forward*.
> +Likewise, the *oif* keyword in the 'FIB_TUPLE' modifier list will limit the available hooks to
> +*forward*, *output* and *postrouting*.
> +
>  .Using fib expressions
>  ----------------------
>  # drop packets without a reverse path
>  filter prerouting fib saddr . iif oif missing drop
>  
> -In this example, 'saddr . iif' looks up routing information based on the source address and the input interface.
> -oif picks the output interface index from the routing information.
> +In this example, 'saddr . iif' looks up a route to the *source address* of the packet and restricts matching
> +results to the interface that the packet arrived on, then stores the output interface index from the obtained
> +fib route result.
>
>  If no route was found for the source address/input interface combination, the output interface index is zero.
> -In case the input interface is specified as part of the input key, the output interface index is always the same as the input interface index or zero.
> -If only 'saddr oif' is given, then oif can be any interface index or zero.
> +Hence, this rule will drop all packets that do not have a strict reverse path (hypothetical reply packet
> +would be sent via the interface the tested packet arrived on).
> +
> +If only 'saddr oif' is used as the input key, then this rule would only drop packets where the fib cannot
> +find a route. In most setups this will never drop packets because the default route is returned.
>  
> -# drop packets to address not configured on incoming interface
> +# drop packets if the destination ip address is not configured on the incoming interface
>  filter prerouting fib daddr . iif type != { local, broadcast, multicast } drop

I don't see a table in the manpage possible return values of fib type
lookups, I mean:

static const struct symbol_table addrtype_tbl = {
        .base           = BASE_DECIMAL,
        .symbols        = {
                SYMBOL("unspec",        RTN_UNSPEC),
                SYMBOL("unicast",       RTN_UNICAST),
                SYMBOL("local",         RTN_LOCAL),
                SYMBOL("broadcast",     RTN_BROADCAST),
                SYMBOL("anycast",       RTN_ANYCAST),
                SYMBOL("multicast",     RTN_MULTICAST),
                SYMBOL("blackhole",     RTN_BLACKHOLE),
                SYMBOL("unreachable",   RTN_UNREACHABLE),
                SYMBOL("prohibit",      RTN_PROHIBIT),
                SYMBOL_LIST_END
        }
};

Thanks.
