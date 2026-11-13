Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539943;
	b=Q0+kTT0KXjGZ4ldODIvcL7RCXlmaM8JFxyV4aqwOuNovDSx73vXgt0bHMYrNRPQZsctc
	 MhLkC8ILQ9R5RX6++Z/6164EsBaWE+VOyf+ucZ5Z+p0klKJVukWTPVNyBciGjEml/sKJr
	 +i6k8yMTjJB7Vo67keGUAfmchv1lsyZRaN9Fh7FVG/7dMzGr+fZB7jt0NuJYSZCv4ekIO
	 3swYG0481qitqyyiqwLnrHqYt+GbF4ouygoAtCpRB47PPNvbe0lGAE0BDCI8f9C1LtGiH
	 QMghPjPgUDP6MEBpEk8jo+GuKXsCKa1TJ8X7djY2J/pfkjjU/i63meqO4wc4Lu+mB8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539943;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=WlCIR0lBySoZF4Voi/JAcmttwaefyiT6JiQc0FBL09c=;
	b=4aAc8pup65xPT7XI+bckR/7OrI5FW6HObwDQZ2QEPmIbJOpfZBdu8Y+eFBlawQzDLmGU
	 yyCzt678XwYQfkaTHlyCzdUPFYUKCOmOwhn34ueCpXMw8FYPR/UFtQvL3jlWW22jaBuiC
	 OTfYLGKJIwdSzA7bhlGTLAbPuHoqPtjXBVF3LKx/DtmQwMIbsAZawVuLN3fNMqhEM/5R5
	 yBhXCq8yitgh6LlYz+5gfXVrrAQEcavvq1jcyJvOca7addNj+dggY3ifRaQpIvYIKzPdZ
	 ARKEoD/4PIMy3pHgPk0cT/i/1jucQMJbta/+vrWJhaJrae1gkdYbsfOt2Tjh5I1G1+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=QVIgRKtb;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id AB903606A31C
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2026 03:19:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB903606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=QVIgRKtb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794539940;
	bh=WlCIR0lBySoZF4Voi/JAcmttwaefyiT6JiQc0FBL09c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QVIgRKtbfxXMtq7C/I/QhE34QZIcGGHhHxin+N+GByDjQjoz4k4kSlssfNUZQLj+6
	 9Pi/xlWgFGlioPlBctFMla/A/cDQfG8jFXn/S94zP0JcBQHvknZoxyvtTSq09fMLpB
	 nRvcmORg2r53yZwnv6T33SuqHqpGJuobLekCicc1ezRbU2+zCiFFS8wZbAfdbNETV7
	 PnSU0Lqri+2IjvKJ4+ZfG/YY+Yjfexi2AjEh1eEpTAUTz2w+YI4H8OszycdJ+O8OLr
	 yGGGGb1DtYOlREisFtFepMking8f3f02zVBr2WyPKkAOfWReBy5BnsYX0ieMAvtOh7
	 oMxCvPWMOHiNw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 690C060055;
	Fri, 13 Nov 2026 04:19:00 +0100 (CET)
Date: Fri, 13 Nov 2026 04:18:57 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Daehyeon Ko <4ncienth@gmail.com>
Subject: Re: [PATCH nf v2] netfilter: nf_conntrack: limit expectation master
 chain depth
Message-ID: <avaBoYJncuLbY2nk@chamomile>
References: <20261110133443.21073-1-fw@strlen.de>
 <avZRah74LdH7P9LH@chamomile>
 <avZr8lPA-bN9Z9_t@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <avZr8lPA-bN9Z9_t@strlen.de>

On Fri, Nov 13, 2026 at 02:46:26AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Nov 10, 2026 at 02:34:43PM +0100, Florian Westphal wrote:
> > > A conntrack can point to a master conntrack, which itself may point to
> > > another master, and so on.  There is currently no bound on how deep this
> > > chain can grow.
> > > 
> > > Force a max depth in nf_ct_expect_alloc(): walk the master chain and
> > > reject allocation if it would exceed 8 levels of nesting.
> > > 
> > > Also add ctnetlink_find_get_master and use it so that ctnetlink create
> > > paths return -EMLINK instead of falling through to nf_ct_expect_alloc()
> > > and returning a misleading -ENOMEM.
> > > 
> > > This prevents unbounded ct->master->master->... chains.
> > > 
> > > This also restricts the number of call forward/redirects that h323 and sip
> > > helpers will follow.
> > 
> > "Should ctnetlink_glue_attach_expect() or ctnetlink_alloc_expect() also
> > check nf_ct_master_acceptable(ct) and return -EMLINK?"
> 
> I saw that but there are many patches in flight in this area, so I don't
> want to meddle with those.

OK.

> > It would be great to collapse this patch to v3 too:
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20261101225435.447072-1-pablo@netfilter.org/
> 
> ?
> 
> Not following.
> 
> ct_expect_help() calls nf_ct_expect_alloc(), so I don't see how nft_ct
> can create long chains after this patch.

Indeed, then the patch above is obsolete, I'll drop it.

Thanks
