Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85465224B0E
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Jul 2025 19:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751916358; cv=none; b=awBoHJ6S1GzS1NCj895dsIJurjT6IgyWE2Rt/TUrBnA3tdIq56QVJnArb+pOlxziLemd0ijKxpesYw+PE5WPA24aLJXbLQbGS/O83Z9S188jK8gPtP0vZPgB7Eb4g50TO6fOAo1Ov4ysWGgJKYeZfNovomIK8CTypYuOy3QaZYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751916358; c=relaxed/simple;
	bh=492LG/9p/2M+9v2et/k432ZzC6cPHqHQcNxS2Py7dBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FCBk4kA7rYNrvUyIubBce0nDX2qgEmEtZiMZn/fFwIjkyIg/giGuIDFgWkaCS4H0tmYkDzojBZum5rSd77ruQS5+S0purIGJOZ0wdNbWI3RUciC9OCgnFBhk08SKmIyydh/u1YUi07enqCgI8SIeALj/sF+6LP7Nfr5+/iKp48U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QlYqNbMy; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KVYZJKq6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QlYqNbMy";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KVYZJKq6"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7C1BC60272; Mon,  7 Jul 2025 21:25:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751916353;
	bh=sR8E9X5V+tx6B8hofLck1LUhNZDagfxCGqJn1psw1j0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QlYqNbMyB1i3EG7eOzPMda0LR2+TbnVHoubL1RfI93FHFBxA+zJpBsIkRRloolakl
	 SytHg3f3svfYJG7Uesna2y8lxaTD1TJDFBjKozSgKT9eIjw5Kc3XUyBS6sllpt20dm
	 GbKmQ2pytVSMSCM4iisB17FFwHokezECxNgBMoHw5jpxncvQM7O/zGvRAnrsJTAJLi
	 l6MIcQl7dDwWQ8X+C1Ti26RAsomN7S+j9jPgkBFeBZj2P9RYLMzdV2BpRDrMkMF/LR
	 XRg/u46EGxVueQhu1M4XL5bRMOHX0r7zk6ebH/OEZndjmbYwnWEPsBAVYAXUItbucK
	 fpmW0WVFnRcsg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A1F9860269;
	Mon,  7 Jul 2025 21:25:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751916352;
	bh=sR8E9X5V+tx6B8hofLck1LUhNZDagfxCGqJn1psw1j0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KVYZJKq6S4zvygsXvXiyGBP3CV2B4HS0ilyZbv/XAs+nsNLkV6x85kkFUjA7Jtf4s
	 MFbn7vpZHG8n+7iqiTQ4o+HA5ZApy5/usL6CdhimSPIjNv+mQEZCRU6POpFiw1A3ty
	 WfOz6YLqXt4WJTzNxJq/jjqpJ/Hy07kBtezcwQwQCyHSs65wBwX1bXS4DKjQI3bbK9
	 uuGNzrLx1KGppkz1ZPx9Lx9tRfHLyF+bu3yIglydPIFyXEpvkUp36JWkREVD9djuwb
	 txHbu2qiSd7KIdFQd7hQ1WGg7nUfugxmqLhIaA/1O80m+9FjiZajHmuidntwhaxkhK
	 rQqttswOW3snA==
Date: Mon, 7 Jul 2025 21:25:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGwfPqpymU17BFHw@calendula>
References: <aGZ21NE61B4wdlq8@orbyte.nwl.cc>
 <aGZ6E0k0AyYMiMvp@strlen.de>
 <aGZ75G4SVuwkNDb9@orbyte.nwl.cc>
 <aGZ9jNVIiq9NrUdi@strlen.de>
 <aGaC0vHnoIEz8sTc@orbyte.nwl.cc>
 <aGaRaHoawJ-DbNUl@calendula>
 <aGaUzVUf_-xbowvO@orbyte.nwl.cc>
 <aGbu5ugsBY8Bu3Ad@calendula>
 <aGfL3Q2huYeiOH1O@orbyte.nwl.cc>
 <aGffdwjA23MaNgPQ@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aGffdwjA23MaNgPQ@strlen.de>

On Fri, Jul 04, 2025 at 04:04:39PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Please keep in mind we already have 'nft list hooks' which provides
> > hints in that direction. It does not show which flowtable/chain actually
> > binds to a given device, though.
> 
> Its possible to extend it:
> - add NF_HOOK_OP_NFT_FT to enum nf_hook_ops_type
> - add
> 
> static int nfnl_hook_put_nft_ft_info(struct sk_buff *nlskb,
>                                    const struct nfnl_dump_hook_data *ctx,
>                                    unsigned int seq,
>                                    struct nf_flowtable *ft)
> 
> to nfnetlink_hook.c
> 
> it can use container_of to get to the nft_flowtable struct.
> It might be possibe to share some code with nfnl_hook_put_nft_chain_info
> and reuse some of the same netlink attributes.
> 
> - call it from nfnl_hook_dump_one.
> 
> I think it would use useful to have, independent of "eth*" support.

This is a good idea to place this in nfnetlink_hook, that
infrastructure is for debugging purpose indeed.

If this update is made, I also think it makes sense to remove the
netlink event notification code for devices, I don't have a use case
for that code in the new device group other than debugging.

If Phil's intention is to make code savings, then extending
nfnetlink_hook and removing the existing device notification group
make sense to me.

User can simply resort to check via dump if a matching hook is
registered for eth* in nfnetlink_hook.
