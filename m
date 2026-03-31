Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B3B2BDC2F
	for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2026 11:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774955771; cv=none; b=C+e/HTuulFV/FUkRQhYRJ9Af6a+X+akjJrRDRR1JOTEYqpzWNMcLGy3VPEswgbURrQ4shpDKQ1q+nyJZ7E4ETe9OZeMDCkKTLBO+NexWvG/3tgsKjq9tKy7q0Do5upS0jaDILV9ejuhaNE7SoQyHoLSUWHlglSH5+wU0yVxwxzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774955771; c=relaxed/simple;
	bh=AWqo4QpB4i5gwkdL6jSMkEwFdKXpk+qFEpVtKh0h1QY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lFqRb3uSWKFSloL7/DF9l3kLubBG2/7Vf0Wh0cC1VIaGVyku8ynYIjyp7BL6/v51BnuzhkNzXOx9A/cDBBBiB7do7aw/JQYoGmhVTH6/ueywf1GL1AAxMSfnR7V4GTVEUL0kWM72O4DPE6lRJOkDmrK1xMCzClNRg3Bxtrq4Eik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B23CE60A49; Tue, 31 Mar 2026 13:16:07 +0200 (CEST)
Date: Tue, 31 Mar 2026 13:16:06 +0200
From: Florian Westphal <fw@strlen.de>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: security@kernel.org, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
	dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, yifanwucs@gmail.com,
	tomapufckgml@gmail.com, yuantan098@gmail.com, bird@lzu.edu.cn,
	enjou1224z@gmail.com, zcliangcn@gmail.com
Subject: Re: [PATCH 1/1] netfilter: ip6t_eui64: validate MAC header before
 using it
Message-ID: <acus9gpd-oKl_6dg@strlen.de>
References: <cover.1774859629.git.zcliangcn@gmail.com>
 <5267bb5b37997fa793c28c4b928a828cfb3a3927.1774859629.git.zcliangcn@gmail.com>
 <acuTO7bnCukKSpme@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acuTO7bnCukKSpme@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Ren Wei <n05ec@lzu.edu.cn> wrote:
> > From: Zhengchuan Liang <zcliangcn@gmail.com>
> > 
> > `eui64_mt6()` derives a modified EUI-64 from the Ethernet source
> > address and compares it with the low 64 bits of the IPv6 source
> > address.
> > 
> > The match unconditionally reaches `skb_mac_header()` and `eth_hdr(skb)`
> > after a guard that only rejects an invalid MAC header when
> > `par->fragoff != 0`. As a result, non-fragment packets can still reach
> > `eth_hdr(skb)` even when the skb has no MAC header set, or when the MAC
> > header does not cover a full Ethernet header.
> > 
> > Fix this by first checking that the MAC header is set and spans a full
> > Ethernet header before accessing it, then using that validated header
> > directly for the EUI-64 comparison. Preserve the existing hotdrop
> > behavior for non-first fragments with an invalid MAC header.
> 
> I find this rather confusing.  E.g. why is net/netfilter/xt_mac.c safe?
> I get the feeling that this patch is not sufficient?
> 
> > +	if (!skb_mac_header_was_set(skb)) {
> 
> Makes sense to me.
> 
> > +	mac = skb_mac_header(skb);
> > +	if (mac < skb->head || mac + ETH_HLEN > skb->data) {
> > +		if (par->fragoff != 0)
> > +			par->hotdrop = true;
> > +		return false;
> 
> Why do we still need this stunt?  Why not:
> 
> mac_len = skb_mac_header_len(skb);
> if (mac_len < ETH_HLEN) {
> 	par->hotdrop = true;
> 	return false;
> }
> 
> ?
> 
> I also feel there should be a check for ethernet, i.e.
>         if (skb->dev == NULL || skb->dev->type != ARPHRD_ETHER)
> 
> ... like in xt_mac.c.

There are other suspicious spots, e.g. in nf_log_syslog.c and in ipset.

Will you make a patch to cover all of these?
