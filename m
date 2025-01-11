Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75029B661
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Jan 2025 14:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736604349; cv=none; b=sCgKi5ttih47Eg8f6JoqsGlBo++OmUCoVRMSE6MlHxvqgjN5uHvhQXjSoQsewOLaRg8k9X9e6DtP5tIxnu0mTbS/3GPoQYOeoijceJNlj+j3oCqQg1Phi42dAA3c5AMdsUxbcjgsrTY72ku7WqghiaevLVBNpXW9HWWC6Zfzy40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736604349; c=relaxed/simple;
	bh=pALlDJB9zzBHiaMLGRuIlZ8sOlX63zaADJXzs6KIHQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SYLXRvOi8p7GBdkDMWOXNHDuJVHhyr3UJU5gq7umFp9ucGBrT4eyii8gNuMNMS6jm4IHnstxqfx6sh+MUO+OqLA+GX4k/ho7Cofan72aqGqcXcjVrkfkqnfa2B5qs064N+9fwfm6muNhh2h0IZx2dW6xsaFxvlVMpJBVlPv2Kn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tWc7T-0004bn-BN; Sat, 11 Jan 2025 15:05:43 +0100
Date: Sat, 11 Jan 2025 15:05:43 +0100
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Android boot failure with 6.12
Message-ID: <20250111140543.GB14912@breakpoint.cc>
References: <CAHo-OozVuh4wbTHLxM2Y2+qgQqHTwcmhAfeFOM9W8thqzz6gdg@mail.gmail.com>
 <CAHo-OozPA7Z9pwBgEA3whh_e3NBhVi1D7EC4EXjNJdVHYNToKg@mail.gmail.com>
 <CAHo-Ooz-_idiFe4RD8DtbojKJFEa1N-pdA8pdwUPLJTp7iwGhw@mail.gmail.com>
 <CAHo-OozUg4UWvaP-FtHL44mygWwsnGO_eeFREhHddf=cc2-+ww@mail.gmail.com>
 <16d951e0-5fce-c227-5f50-10ecf3f16967@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16d951e0-5fce-c227-5f50-10ecf3f16967@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > nvm - https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/net/netfilter/xt_mark.c?id=306ed1728e8438caed30332e1ab46b28c25fe3d8
> 
> Sorry, but I don't understand the patch at all. With it applied now it'd 
> be not possible to load in the "MARK" target with IPv4. The code segment 
> after the patch:
> 
> static struct xt_target mark_tg_reg[] __read_mostly = {
>         {
>                 .name           = "MARK",
>                 .revision       = 2,
>                 .family         = NFPROTO_IPV6,
>                 .target         = mark_tg,
>                 .targetsize     = sizeof(struct xt_mark_tginfo2),
>                 .me             = THIS_MODULE,
>         },
> #if IS_ENABLED(CONFIG_IP_NF_ARPTABLES)

Then you re-applied the patch, its already in 6.12.
NFPROTO_IPV6 is only set in the IP6_NF_IPTABLES section.

> Why the "IS_ENABLED(CONFIG_IP6_NF_IPTABLES)" part was not enough for the 
> IPv6-specific MARK target to be compiled in? Isn't it an issue about 
> selecting CONFIG_IP6_NF_IPTABLES vs CONFIG_IP6_NF_IPTABLES_LEGACY?

No, _LEGACY is about the set/gersockopt interface and the old
xt traversers, we could still use e.g. xt_mark.ko via NFT_COMPAT
interface.

> Also, why the "mark" match was not split into NFPROTO_IPV4, NFPROTO_ARP, 
> NFPROTO_IPV6 explicitly (and other matches where the target was split)?

mark match is fine, afaics.  Whats the concern?

The target got split because ebtables EBT_CONTINUE isn't equal to
XT_CONTINUE, so it won't do the right thing.
