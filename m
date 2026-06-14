Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6491B76026
	for <netfilter-devel@vger.kernel.org>; Sun, 14 Jun 2026 09:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781430246; cv=none; b=Z8JfLyg5XcFoS8dZCn98IXeeKC3+evxG06j5f39mjmbvI0cUfC/6q5nhIwNPfPQuHXiDVC48g2VR/rhPq1ldsKpfBiFXtImseRM45Ha2kOsgmhGQ8pcX+tMOgu71kod0wJHWqF6nN8jb+0QNmp0nwexJGpnELn3Vmv9FropkrVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781430246; c=relaxed/simple;
	bh=hLhmsHbH3c0hdFBXDggS0MozkqHjGU46n8T9maycEzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n7JILEcEgWJT11J6/HF7gVi8WjLsscuv0AYmhfMtYYGTVDdbs09CU0d6IongxJc0TyvDEFYHhIwWMkMiuFrcpdqKtHth5EjTNha3r75oTFlL83GcQfNnD+UA02lI9A4MrzxUzOsr011F7MMVACgm9h4jX06jlz6Qqi29bx91GIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aHpxIlfq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aHpxIlfq"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A9C33600B9;
	Sun, 14 Jun 2026 11:44:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781430240;
	bh=XDAMQOr73GKZJrNeKgsFABpU25aYlne3kQY49CFKGaA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aHpxIlfqL4z2w6f7Guo8tWe4sY2sHRLv22cuRrnT3SxqmLvl8+sheoNkYWy7fKV+q
	 2DY8Egd5F5cxapQbSkUjFTZfchdC2ZmrbKuKkOKpXowmDgnbv94S6fzD7fMYXMSHME
	 ozbNO3iM4KXvyj1WzMM+3XgYKRWRswu+LuHpWEbJAfAHoQskV2HDKy9XLoknbUhR79
	 7kIKuJ7sNGyFbPUnrUyAmgCIFwt01jZQBGOv3dsmKfznkmTXaDw+l9MzTShg70YfdO
	 jz/Mgs5Hd8nLaxjytowozdDTa90ExN5not2RCF9GPUSTjUi7/xWOK4q30Iz9yCjIDP
	 iCQ9xyAMb7pnQ==
Date: Sun, 14 Jun 2026 11:43:58 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Ren Wei <n05ec@lzu.edu.cn>, netfilter-devel@vger.kernel.org,
	phil@nwl.cc, yuantan098@gmail.com, yifanwucs@gmail.com,
	tomapufckgml@gmail.com, zcliangcn@gmail.com, bird@lzu.edu.cn,
	bronzed_45_vested@icloud.com
Subject: Re: [PATCH nf 1/1] netfilter: xt_nat: reject unsupported target
 families
Message-ID: <ai533miYJF9-J3yB@chamomile>
References: <cover.1781144570.git.bronzed_45_vested@icloud.com>
 <5722ce33544cc22da3f811de77ab57847eb58366.1781144570.git.bronzed_45_vested@icloud.com>
 <ai3MJ2P2MnXLxcmb@strlen.de>
 <ai3TGFyMlkS1m8O3@strlen.de>
 <ai3WcsS00Rbjy61u@chamomile>
 <ai3Y68Fqd-V3cpOS@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ai3Y68Fqd-V3cpOS@strlen.de>

On Sun, Jun 14, 2026 at 12:25:47AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > We can only use NFPROTO_BRIDGE targets, never UNSPEC, for NF_BRIDGE
> > > caller.
> > 
> > Maybe it is simply this patch:
> > 
> > commit b6fe26f86a1649f84e057f3f15605b08eda15497
> > Author: Pablo Neira Ayuso <pablo@netfilter.org>
> > Date:   Wed Apr 15 12:21:00 2026 +0200
> >  
> >     netfilter: xtables: restrict several matches to inet family
> > 
> > which was missing xt_nat.c?
> 
> No, ebtables targets are incompatible, they return different
> values compared to ip/ip6tables.
> 
> We need a nft_target_bridge_validate (or alternative method) that
> rejects all targets that are not NFPROTO_BRIDGE.

Yes, but there are still around 33 match/targets extensions in the
tree that use NFPROTO_UNSPEC as a .family.

And some of these NFPROTO_UNSPEC are supported by ebtables, eg.
xt_string (match), see ebt_string.c in ebtables userspace.

I think NFPROTO_UNSPEC should be replaced by explicit families that
are supported.

> This is wnat ebtables.c already does which is why this poc would
> not work for classic xtables.

Do you refer to targets specifically, correct?

        /* Reject UNSPEC, xtables verdicts/return values are incompatible */
        if (target->family != NFPROTO_BRIDGE) {
                module_put(target->me);
                ret = -ENOENT;
                goto cleanup_watchers;
        }

> That said, this patch (the xt_nat.c patch) might be a good idea
> anyway, but I don't think its enough.

I would probably replace all of the remaining NFPROTO_UNSPEC by
explicit families.

As for xt_nat_target_reg, it does not set NFPROTO_UNSPEC explicitly,
but given that target is allocated in the BSS, it results in an
implicit NFPROTO_UNSPEC, which is the reason why it when uncaught by
b6fe26f86a1649f84e057f3f15605b08eda15497.
