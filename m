Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E1A443311;
	Fri, 31 Jul 2026 15:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512866; cv=none; b=CWi3PLUxsy5FmvclaVa8Afb2TWpN5LahRGjT4KZvA4TeA4J6UTiGdKtB8gHrX5YZbyLiwfIxf88pquomOks4g/4EfGluvww15LxT53hS+CLymVaL73A7SjooL7PPWpeGdt3x1WeqKmhNHHaVXO50wqOLvAeR9XUII6o03R/nVTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512866; c=relaxed/simple;
	bh=/IJwHqjmTXLNDi9+f7Jq20EAgi7qI99KySOm+dl8fYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qg3OYYuSsdl/MjvWKUoEiU8FOfIGTBMSlApaySsYTUWx7IlLseMSmIiH3TPUD/YzhndzGNkJgpnE1krQRaNbIcxJABki9hozp/YkR+4raGa6KhgHSBBbL1Q4iAMd6xhKOuGHFgHQZP5hn06TfOQsOeCFGRuoegSNWOesussfhhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AViRU+UK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AViRU+UK"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 60334601A6;
	Fri, 31 Jul 2026 17:47:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785512863;
	bh=O/3G3HCfWlgBgJ00yPfEN3DKrDl1GzpN/k6fokooYts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AViRU+UKMC++YfYfuAtfgGKqXMiUC2dlsHoqayzPXHuGmM34dJjUeDiNgv0oYCvob
	 PHk4MHB7SdQxH1xAGtenCFp9thBuJeMADwpI5tjkLR1w0fBjD0RhF2Smk4mMtw6E/D
	 cSI+XOQT667dpDRAjvSqIzXusvLpPZuolYa/R1cbIUjfnrUdtOpYeMRqCN+yRmsI3O
	 5jCbZoX9FSGwoiO/QP4w81Zsgz9RXP4EFTcM3roP2uT6X2OO6pjYMTKnQ8mzalkBmu
	 es3toSHWGHOh/Vs0QmunCQoECH2vvFIncIT1va0R61daG1alLJGKHTLViCdjDqujGO
	 VQ1qKXINmPXIA==
Date: Fri, 31 Jul 2026 17:47:40 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Zhiling Zou <zhilinz@nebusec.ai>, netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org, fw@strlen.de,
	phil@nwl.cc, razor@blackwall.org, idosch@nvidia.com,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	horms@kernel.org, vega@nebusec.ai
Subject: Re: [PATCH nf 1/1] netfilter: bridge: release template ct on non-IP
 path
Message-ID: <amzDnLMB9bZDP4rw@chamomile>
References: <cover.1785479514.git.zhilinz@nebusec.ai>
 <3cf187b612fd78f8835fa9dad870326ce380f82f.1785479514.git.zhilinz@nebusec.ai>
 <20260731080233.1956d41c@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260731080233.1956d41c@kernel.org>

On Fri, Jul 31, 2026 at 08:02:33AM -0700, Jakub Kicinski wrote:
> On Fri, 31 Jul 2026 14:36:53 +0800 Zhiling Zou wrote:
> > A bridge nftables ct zone set rule can attach a conntrack template to
> > an skb before nf_ct_bridge_pre() sees it. For non-IPv4 and non-IPv6
> > EtherTypes, nf_ct_bridge_pre() currently overwrites skb->_nfct with
> > IP_CT_UNTRACKED without releasing the existing template reference.
> 
> could be a coincidence but around the time this landed in our test tree
> the nft_queue.sh test became more flaky.

Maybe this patch could be causing it?

[nf,v3,1/1] netfilter: validate L4 headers after userspace packet writes
https://patchwork.ozlabs.org/project/netfilter-devel/patch/587830a57a593c4b621f7e8e94b2ddc73e6becb0.1785468829.git.zhilinz@nebusec.ai/

This is related to nfqueue specifically and it also was posted a few
hours before the same day?

Thanks.
