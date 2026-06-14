Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE98B262FC0
	for <netfilter-devel@vger.kernel.org>; Sun, 14 Jun 2026 11:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781435524; cv=none; b=uzhuFmidFV9u5KH37tL1iEHBlGV4fKUudt5gpn48XkHsFRAQe8Qo3zj+UVV82D9X7+6PrpJm1tzhUgZgNj5HhsaGFTZrfhJkJ49DHoFneIzNg4Lx1UXFIcssOKGqhU7vMKP5p00dcNnAe+xOLpaHWfe5kdKOnjsDckaqnmKeD+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781435524; c=relaxed/simple;
	bh=/DQKTWfLkeSC2QxSMNXa/hJg/Jf+tGyfJnEnknHEZ/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tTk6ODBKuwIFPB6yo/FydCuiOiNS5vqYAIJrSNhvV0R8bAO9Ryju9XT1AYWtqEFJkdGuhyXuhYibZtPR6q8f5NK2jkQrBfq7/jvyB8O6MElf+t06UynuHkP5n2/rhMf4IAiz7MOR779u3X9n6rgu7QehUqJ5NfsXSQAdAD/ri74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LUcrtNQd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LUcrtNQd"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5D199600B5;
	Sun, 14 Jun 2026 13:12:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781435520;
	bh=1XmpH1Y9a4fPGWNPQSaZEudhzmvoJb7o4LZBESyk0ao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LUcrtNQdNAsfT8mlPo2I1iAESaoCohdlygcBkKVrVum+F4v5Fl9qjF2mhUt0TdRsL
	 SgkK0EMdd+cWOGbKRgqthtTdqnSN8/WlLs117Paq18SRjL2L7Ypj2DvqPZ+odLf2w1
	 NpXbQ6JbMlmGOa/pIjY1TTHMfWvSur/SvtASkCMGlWCV/n0SksWIHohsQG/FMfmSoG
	 VspHVVh0gy5ySIu706kfil5t6uYtxtJPccmiQCJRyw48KP0pdeheEtFBC9dosUUHL4
	 oceJ1aCxciod8IFYtsDcCukq4t+jQgoad8NC4b/JiiXwKmJjdU7Zl7RaUC0l+cKs0+
	 WaeFA2l+pGTrg==
Date: Sun, 14 Jun 2026 13:11:58 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Ren Wei <n05ec@lzu.edu.cn>, netfilter-devel@vger.kernel.org,
	phil@nwl.cc, yuantan098@gmail.com, yifanwucs@gmail.com,
	tomapufckgml@gmail.com, zcliangcn@gmail.com, bird@lzu.edu.cn,
	bronzed_45_vested@icloud.com
Subject: Re: [PATCH nf 1/1] netfilter: xt_nat: reject unsupported target
 families
Message-ID: <ai6Mfgdk0UmEv0Ul@chamomile>
References: <cover.1781144570.git.bronzed_45_vested@icloud.com>
 <5722ce33544cc22da3f811de77ab57847eb58366.1781144570.git.bronzed_45_vested@icloud.com>
 <ai3MJ2P2MnXLxcmb@strlen.de>
 <ai3TGFyMlkS1m8O3@strlen.de>
 <ai3WcsS00Rbjy61u@chamomile>
 <ai3Y68Fqd-V3cpOS@strlen.de>
 <ai533miYJF9-J3yB@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ai533miYJF9-J3yB@chamomile>

On Sun, Jun 14, 2026 at 11:44:01AM +0200, Pablo Neira Ayuso wrote:
> On Sun, Jun 14, 2026 at 12:25:47AM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > We can only use NFPROTO_BRIDGE targets, never UNSPEC, for NF_BRIDGE
> > > > caller.
> > > 
> > > Maybe it is simply this patch:
> > > 
> > > commit b6fe26f86a1649f84e057f3f15605b08eda15497
> > > Author: Pablo Neira Ayuso <pablo@netfilter.org>
> > > Date:   Wed Apr 15 12:21:00 2026 +0200
> > >  
> > >     netfilter: xtables: restrict several matches to inet family
> > > 
> > > which was missing xt_nat.c?
> > 
> > No, ebtables targets are incompatible, they return different
> > values compared to ip/ip6tables.
> > 
> > We need a nft_target_bridge_validate (or alternative method) that
> > rejects all targets that are not NFPROTO_BRIDGE.
> 
> Yes, but there are still around 33 match/targets extensions in the
> tree that use NFPROTO_UNSPEC as a .family.
> 
> And some of these NFPROTO_UNSPEC are supported by ebtables, eg.
> xt_string (match), see ebt_string.c in ebtables userspace.
> 
> I think NFPROTO_UNSPEC should be replaced by explicit families that
> are supported.
> 
> > This is wnat ebtables.c already does which is why this poc would
> > not work for classic xtables.
> 
> Do you refer to targets specifically, correct?
> 
>         /* Reject UNSPEC, xtables verdicts/return values are incompatible */
>         if (target->family != NFPROTO_BRIDGE) {
>                 module_put(target->me);
>                 ret = -ENOENT;
>                 goto cleanup_watchers;
>         }
> 
> > That said, this patch (the xt_nat.c patch) might be a good idea
> > anyway, but I don't think its enough.
> 
> I would probably replace all of the remaining NFPROTO_UNSPEC by
> explicit families.
> 
> As for xt_nat_target_reg, it does not set NFPROTO_UNSPEC explicitly,
> but given that target is allocated in the BSS, it results in an
> implicit NFPROTO_UNSPEC, which is the reason why it when uncaught by
> b6fe26f86a1649f84e057f3f15605b08eda15497.

Maybe also the fact that such patch probably only audited matches.
