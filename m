Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B87E1B815
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Jan 2025 14:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736605038; cv=none; b=U3bEExSWp+cwQ1svGfP8R36jBX9EicF2QooYuiywydGBYdAHK7vbHgw04dVlDfU1a8cOr1AU8OplyS+6ZzEJtcB/OHdmSn0yoZ+XEWvXIlvaFR572EeNaW1Gcc2aFTpEmouZJ6I450Aj2CbRv6sUlpY4ZwVZQ6z13g8vkXEupTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736605038; c=relaxed/simple;
	bh=xO+hzq5KemGnI4/vpiJPJv6s4UYnRMz44r/soEdCmy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JMGZB5rTKBNZbW1jvAEdJKqJOBREntlhw9Oj3DjNyYn24wvurrMAvz12cDwOxNzU+pxc7N6hAy68zfnlZ06INV1Bm6M28wC1EsaQZtS/silOp3ZR+gZVkKMlDbQV00X1OJ8pxKAa+9xVG1myLT4QD/CXrMlr0gznXELXCqvL2A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Sat, 11 Jan 2025 15:17:12 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: Re: Android boot failure with 6.12
Message-ID: <Z4J9aM40NuYLakiy@calendula>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16d951e0-5fce-c227-5f50-10ecf3f16967@netfilter.org>

Hi Jozsef,

On Sat, Jan 11, 2025 at 02:31:18PM +0100, Jozsef Kadlecsik wrote:
> Hi,
> 
> On Fri, 10 Jan 2025, Maciej Żenczykowski wrote:
> 
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
>         {
>                 .name           = "MARK",
>                 .revision       = 2,
>                 .family         = NFPROTO_ARP,
>                 .target         = mark_tg,
>                 .targetsize     = sizeof(struct xt_mark_tginfo2),
>                 .me             = THIS_MODULE,
>         },
> #endif
> #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
>         {
>                 .name           = "MARK",
>                 .revision       = 2,
>                 .family         = NFPROTO_IPV6,
>                 .target         = mark_tg,
>                 .targetsize     = sizeof(struct xt_mark_tginfo2),
>                 .me             = THIS_MODULE,
>         },
> #endif
> };
> 
> How is it supposed to work for IPv4?
> 
> Why the "IS_ENABLED(CONFIG_IP6_NF_IPTABLES)" part was not enough for the 
> IPv6-specific MARK target to be compiled in? Isn't it an issue about 
> selecting CONFIG_IP6_NF_IPTABLES vs CONFIG_IP6_NF_IPTABLES_LEGACY?

This was fixed by an incremental patch:

  306ed1728e84 ("netfilter: xtables: fix typo causing some targets not to load on IPv6")

so there is no two MARK targets for NFPROTO_IPV6.

> Also, why the "mark" match was not split into NFPROTO_IPV4, NFPROTO_ARP,
> NFPROTO_IPV6 explicitly (and other matches where the target was split)?

The audit to tighten this interface searched for:

- use of xtables verdicts are incompatible with ebtables.
- IP header cannot be assumed to be linear on ebtables.

xt_mark match can be restricted too, ebtables uses ebt_mark. But this
should be safe, so this patch should probably go via nf-next.

Thanks.
