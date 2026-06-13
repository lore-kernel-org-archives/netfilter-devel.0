Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AB2257845
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Jun 2026 22:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781388928; cv=none; b=HZ12Tbupu4h5OR8drBAYOXXwymByELaz7qhzBANiR+EgRBR6fd1+ev6085pkqpP+m7vcLh/KJI8IN861neNysiszLSQibudPU4Croux4OpGQMJnwJYUkVOe85kz7WVn8eFFM7gLusDxkLTfratFp/R44D0RRQo3BxFi8xx5IKKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781388928; c=relaxed/simple;
	bh=/zmFpkLCKBkcuKJljm9I5rQcyymybQb6wtVaAKKgpiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p63hzdgXY2nQQBoYdzZT21snEv9NFFFjY5L5wgU6Cw8KMMXAwUNVLJ+s5UtCk750jIdaVzG3iqohm7fxtBXWMMZhOyTdapYrpZ4pmjeJSmI4lSRoophImo15+UcjriSYEwmZI7cFYvJgzdM9mGa8Yuxoka2c0czm/2MCcYF+jL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oa5MGkSR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oa5MGkSR"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 2901A600B9;
	Sun, 14 Jun 2026 00:15:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781388917;
	bh=OuWQPWM/HR43TEGGaFWua+8M+ykKR8KUgxhtygzAcQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oa5MGkSRfJuFUgSP5BtUfuBdXYmfz1xT++i1E+QU9rl0pL6oUJazVhxR99uzMM4Qp
	 Pg6/j6QkZGGlJlpExNnbbQNH1oXIK0sbB5jPeM5EZhP6r4VL306U2yxSFLXNaZnxhe
	 TNb5Ytvk0JMCxgIA0+rsR2UyZE6E9VYYdFI8Pcunj7rULgLXjWpsqyYbnNv/W2NLpx
	 pgxw1uIln7Mv7pDVo9Dj2Nmc/zJuU1vZdAhbN/2tJoaOG7cIOGiZCl2MfT07b8mlbA
	 nAN4vVf8bgKB0kaBzsO/sCzD4cELCdNPv79ybYhCsBS/6aVLeehhPz1EWeYU0Y7jKL
	 dmARIjZXJoqJg==
Date: Sun, 14 Jun 2026 00:15:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Ren Wei <n05ec@lzu.edu.cn>, netfilter-devel@vger.kernel.org,
	phil@nwl.cc, yuantan098@gmail.com, yifanwucs@gmail.com,
	tomapufckgml@gmail.com, zcliangcn@gmail.com, bird@lzu.edu.cn,
	bronzed_45_vested@icloud.com
Subject: Re: [PATCH nf 1/1] netfilter: xt_nat: reject unsupported target
 families
Message-ID: <ai3WcsS00Rbjy61u@chamomile>
References: <cover.1781144570.git.bronzed_45_vested@icloud.com>
 <5722ce33544cc22da3f811de77ab57847eb58366.1781144570.git.bronzed_45_vested@icloud.com>
 <ai3MJ2P2MnXLxcmb@strlen.de>
 <ai3TGFyMlkS1m8O3@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ai3TGFyMlkS1m8O3@strlen.de>

On Sun, Jun 14, 2026 at 12:00:56AM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Ren Wei <n05ec@lzu.edu.cn> wrote:
> > > xt_nat SNAT and DNAT target handlers assume IP-family conntrack state
> > > is present and can dereference a NULL pointer when instantiated from an
> > > unsupported family through nft_compat. A bridge-family compat rule can
> > > therefore trigger a NULL-dereference in nf_nat_setup_info().
> > 
> > Are you sure this is related to nft_compat?  What prevents attaching
> > -j D|SNAT to classic ebtables?
> > 
> > > Reject non-IP families in xt_nat_checkentry() so unsupported targets
> > > cannot be installed. Keep NFPROTO_INET allowed for valid inet NAT
> > > compat users and leave the runtime fast path unchanged.
> > 
> > Not so sure, I don't think there is harm in allowing NFPROTO_INET but
> > such users should not exist.
> > 
> > Patch is fine. There are already many different targets here,
> > I don't think we should do a NFPROTO_IPV4 / IPV6 split in this case.
> 
> I take that back.  This problem goes beyond xt_nat.c;  see
> 11ff7288beb2 ("netfilter: ebtables: reject non-bridge targets")
> 
> Can you make a patch like this one for nft_compat?
> We can only use NFPROTO_BRIDGE targets, never UNSPEC, for NF_BRIDGE
> caller.

Maybe it is simply this patch:

commit b6fe26f86a1649f84e057f3f15605b08eda15497
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Wed Apr 15 12:21:00 2026 +0200
 
    netfilter: xtables: restrict several matches to inet family

which was missing xt_nat.c?
