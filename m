Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794233716;
	b=EZa38/7aLvo3xiSnOCmtGZ8fQljRvKQhl9MuWDeQNfEmam1TKkyj/tVxHBgpF8lWtlya
	 pS1mUnuRZdN0Q3DX3hDmtTUuRAPHHCT4kyve7tHMQNOqYQLEz128xigGHcQ/hT2zkDkMG
	 EDCBj+VW4yqYPypmrhycg70UwRs8E4nQYceoqQxIb30+fGRUfaURl8v87GaaZYfsaBcEF
	 ePyj1ZKm4TVW9IAyfuPQGXrg+F5Tz6/Pxlcl5jNk8/nuI5R+bQjjdfo1F0udO/ePRwOdq
	 dFnBv7yaHHH6VUJ+btW+wGyi25RsPSSjLJU/FY10ZMfXOhbJav2Ru+U5LSriu05A/AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794233716;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=SRFhDAOpOlDXu8T99KIZm4AeZ7YAJS3gsEEJR7t8hZI=;
	b=ZG+2EFocj8gr/LsA+WzqOZA7w0NfqP9U40a1tPowYRcAQA45HdTNLJLpHAs1KR6St0jN
	 OSmiLMEAdlfLC/fjG76SY4wgk+CdOkeyqqlv/1YZkOn+WT90jMKvwUVCoFOPApGEZDRkD
	 7RkugGAdmokOfZLRfKoPjJAnCU8fmguqef0j9W8VkOx3xi9wnWpdtQWFyyTduO+bgn4ty
	 arykYIxO4XN6tm9iYoIIyuyMvd8cwzqUxfyQZ7Gh1yarLZBN1CLHHdwHZQYREFITqx1LJ
	 75ASiCbxbO+6bsnTKX7dSmXjf9680SweTN/2h9bWSZEpIrUPDvH5JqpB5/2vM4pfgTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE7F606A323
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2026 14:15:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FE7F606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CC0DB6055A; Mon, 09 Nov 2026 15:15:12 +0100 (CET)
Date: Mon, 9 Nov 2026 15:15:10 +0100
From: Florian Westphal <fw@strlen.de>
To: xujiahao <xujiahao@cmss.chinamobile.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: xt_nat: allow IP_CT_RELATED_REPLY in DNAT
 targets
Message-ID: <avHVbkTbMxfJi9kR@strlen.de>
References: <20261106065651.3504452-1-xujiahao@cmss.chinamobile.com>
 <au2ClIl_C1RnEv_L@strlen.de>
 <20261109025392.reply@cmss.chinamobile.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109025392.reply@cmss.chinamobile.com>

xujiahao <xujiahao@cmss.chinamobile.com> wrote:
>   a) nf_ct_attach(new, skb, bool tcp_rst) -- changes the exported symbol, or
>   b) keep nf_ct_attach() as is and add a separate helper for the reject path?

Why not nf_ct_attach(new, skb, u8 l4proto) ?

This makes things easier to read, instead of
nf_ct_attach(new, skb, true)

readers see
nf_ct_attach(new, skb, IPPROTO_TCP).

> Either way ICMP keeps IP_CT_RELATED/_REPLY, and only the RST built by
> nf_reject_ipv4.c / nf_reject_ipv6.c would get IP_CT_ESTABLISHED/_REPLY.

Makes sense to me.
