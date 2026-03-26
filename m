Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4622D5412;
	Thu, 26 Mar 2026 21:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774560776; cv=none; b=AL3+wq/W0vkSEed7xSY/gBos03lqQNhRGawPXsew/AbVzeSOAMS2t9fOvsyPi7s+sNyA9NiEALSdX062oOn61IIgW2KS6L/JxYqO8S2k64mdkYH//P+N0p4yoXipz1FIFmZmfFoM+Fck7oi4WzTN2+zj42Ewd1FOWwgCxGN+Tuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774560776; c=relaxed/simple;
	bh=kgXppOLduKGmJXk8lFXiiWgfyN5qsxE+A0w6/Vig4CY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+ajSfqg8aCw3Xngm0+DutA4H7qMoKXU64PPQyus37K27+mKyJZAC/8OqpvmYUa+pE9Vsjs/3zGLtzGiVwmVHtfGs/pjPqHZJaQBXC77dxG0DlVJRtbODJAxn2iYthWUu6tplb77WUDiubimPHINRDHz3mGVSlHwe41FF66xPrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Pin5X3hV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Pin5X3hV"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 283FF600B5;
	Thu, 26 Mar 2026 22:32:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774560773;
	bh=zVFhX/Ujh0ts+zj4shUpYcLMsIYPh03ZxzQ9DKvC36A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pin5X3hVDEu2FWppEmmYmqYL8WdZ6bsDv3MJJO/9twIwrPMABEfNLmT+fTlhzShxP
	 alOW7VYYul+OUPBWTvC5jFcwNvfLdNYNvzqHVoeCg2KHvcqcBZk/KzhO+G1g4xogu9
	 +get8zaFKjBfNHCLyxBiaRnx0OnEJWIYpQ3KmRSwgHHsCNmqho/XBRW3mU0DO4z4Kr
	 h4/tjUseC1nQMmhQERXMRCWT4He+S3UsFIoTtUIwVODiSjSXlQ8nmo2F0vRLNZOO7M
	 KjlM9bI8Rm9UX5rU67UJekrpcgUbjmeO25A6fQHTFG2JkeAKQ1T5dauY168GUnPcm+
	 fuel0b24P0Qzg==
Date: Thu, 26 Mar 2026 22:32:50 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: fw@strlen.de, phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_flow_table_offload: fix heap overflow
 in flow_action_entry_next()
Message-ID: <acWmAgx8xn01nUTD@chamomile>
References: <aaxe-uH2Qr6qM4E9@v4bel>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aaxe-uH2Qr6qM4E9@v4bel>

On Sun, Mar 08, 2026 at 02:23:06AM +0900, Hyunwoo Kim wrote:
> flow_action_entry_next() increments num_entries and returns a pointer
> into the flow_action_entry array without any bounds checking.  The array
> is allocated with a fixed size of NF_FLOW_RULE_ACTION_MAX (16) entries,
> but certain combinations of IPv6 + SNAT + DNAT + double VLAN (QinQ)
> require 17 or more entries, causing a slab-out-of-bounds write in the
> kmalloc-4k slab.
> 
> The maximum possible entry count is:
>   tunnel(2) + eth(4) + VLAN(4) + IPv6_NAT(10) + redirect(1) = 21
> 
> Increase NF_FLOW_RULE_ACTION_MAX to 24 (with headroom) to cover the
> worst case.

For the record, proposed patch:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260326200935.729750-1-pablo@netfilter.org/
