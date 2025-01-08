Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58EF1A23A9
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jan 2025 23:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736380205; cv=none; b=oT/MJBPuxdR5pY7VHNZnQWcCo7+xj6tirZugecPfQ5StolMblnJhfm5Ob27M4Vl4v5j0RqLeU+JouXKGvfosWWZaXchyz3RNuABzdq//2yI7aU3NHJWXa213mOpbSJ7wkjESkWwN6v0Q1SchGh+k4hGFpE6+xn4Y4azWyNCYUXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736380205; c=relaxed/simple;
	bh=7Z8lM33nXVVDkgPEv3fNNDnWuD8A+q2PhsbtJKRYIdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lVQPYL8V9kOA2KWw3JJjy/LTY2w2VqBghGPubBmyS8kl85KaHlc+DmOSPx3DGaa7cAM5IBLuBAPR+SHseU0hQaZGRizDT3eIO9hfWJHb4H/YgLqkEkF3ql4jl8P2m4poztCF51/qjEHkKvlAJO69zc9rldROSCqiRQt4jzX6LCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=TvJgSqJs; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="TvJgSqJs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BXdrMlOaP9w58Z78YF5qS7e129aalb3K2K9UoaMFczw=; b=TvJgSqJsBaM1AP61b01dABO5hF
	UfO6tSC8W3ckqKyE0z/+ZhQuGnevb/Aw4dnAAngtl/dOKUuIqJzvRbIabZLKZDR29vF2X/H3+5fbN
	58EHGTmXtqkgeBICeNyGBtQZd6GAHuszjh5VAXAJpvLHTE+boei1JBA2SmGlCAHJXxWaZjdmZ4wey
	VmWXOMQDomKRSuV2i14UuSu1of9xuBP71KNY8EBsPpem7h31sOYny6pVStt0HD2eZaoVEdz6X0kiP
	mAU8xMM+t4/UFuJ3AVGB4g0wWtnkbE6uoIsaWkSgKSwMMZGJswSQXgdtbxrG96LsfIV4ZDMrK41Ef
	RJFHOv8Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tVfo9-000000005mV-1QmO;
	Thu, 09 Jan 2025 00:49:53 +0100
Date: Thu, 9 Jan 2025 00:49:53 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Alyssa Ross <hi@alyssa.is>, netfilter-devel@vger.kernel.org,
	Joshua Lant <joshualant@googlemail.com>
Subject: Re: [PATCH nftables] include: fix for musl with iptables v1.8.11
Message-ID: <Z38PIVmu2jAVl1k2@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Alyssa Ross <hi@alyssa.is>,
	netfilter-devel@vger.kernel.org,
	Joshua Lant <joshualant@googlemail.com>
References: <20241219231001.1166085-2-hi@alyssa.is>
 <Z2VaEv0u3ZPcWqye@orbyte.nwl.cc>
 <v654rm6mbtymzhavlbg2fu7irth4mkz4motq7vb7rzjql5ccqa@u7xv7uvdfvsl>
 <Z2VkJrkSLRmY9lAE@orbyte.nwl.cc>
 <Z38Ladz49yJcTC8p@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z38Ladz49yJcTC8p@calendula>

Hi Pablo,

On Thu, Jan 09, 2025 at 12:34:01AM +0100, Pablo Neira Ayuso wrote:
> On Fri, Dec 20, 2024 at 01:33:42PM +0100, Phil Sutter wrote:
> > On Fri, Dec 20, 2024 at 01:07:56PM +0100, Alyssa Ross wrote:
> > > On Fri, Dec 20, 2024 at 12:50:42PM +0100, Phil Sutter wrote:
> > > > Hi Alyssa,
> > > >
> > > > On Fri, Dec 20, 2024 at 12:10:02AM +0100, Alyssa Ross wrote:
> > > > > Since iptables commit 810f8568 (libxtables: xtoptions: Implement
> > > > > XTTYPE_ETHERMACMASK), nftables failed to build for musl libc:
> > > > >
> > > > > 	In file included from /nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/netinet/et…
> > > > > 	                 from /nix/store/kz6fymqpgbrj6330s6wv4idcf9pwsqs4-iptables-1.8.10-de…
> > > > > 	                 from src/xt.c:30:
> > > > > 	/nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/netinet/if_ether.h:115:8: error: redefinition of 'struct ethhdr'
> > > > > 	  115 | struct ethhdr {
> > > > > 	      |        ^~~~~~
> > > > > 	In file included from ./include/linux/netfilter_bridge.h:8,
> > > > > 	                 from ./include/linux/netfilter_bridge/ebtables.h:1,
> > > > > 	                 from src/xt.c:27:
> > > > > 	/nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/linux/if_ether.h:173:8: note: originally defined here
> > > > > 	  173 | struct ethhdr {
> > > > > 	      |        ^~~~~~
> > > > >
> > > > > The fix is to use libc's version of if_ether.h before any kernel
> > > > > headers, which takes care of conflicts with the kernel's struct ethhdr
> > > > > definition by defining __UAPI_DEF_ETHHDR, which will tell the kernel's
> > > > > header not to define its own version.
> > > >
> > > > What I don't like about this is how musl tries to force projects to not
> > > > include linux/if_ether.h directly. From the project's view, this is a
> > > > workaround not a fix.
> > > 
> > > My understanding is that it's a general principle of using any libc on
> > > Linux that if there's both a libc and kernel header for the same thing,
> > > the libc header should be used.  libc headers will of course include
> > > other libc headers in preference to kernel headers, so if you also
> > > include the kernel headers you're likely to end up with conflicts.
> > > Whether conflicts occur in any particular case depends on how a
> > > particular libc chooses to expose a particular kernel API.  I could be
> > > misremembering, but I believe the same thing can happen with Glibc —
> > > some headers under sys/ cause conflicts with their corresponding kernel
> > > headers if both are included.  While this case is musl specific, I
> > > think the principle applies to all libcs.
> > 
> > While this may be true for the vast majority of user space programs,
> > netfilter tools and libraries are a bit special in how close they
> > interface with the kernel. Not all netfilter-related kernel API is
> > exposed by glibc, for instance. Including (some) kernel headers is
> > therefore unavoidable, and (as your patch shows) order of inclusion
> > becomes subtly relevant in ways which won't show when compile-testing
> > against glibc only.
> > 
> > > > > Signed-off-by: Alyssa Ross <hi@alyssa.is>
> > > > > ---
> > > > > A similar fix would solve the problem properly in iptables, which was
> > > > > worked around with 76fce228 ("configure: Determine if musl is used for build").
> > > > > The __UAPI_DEF_ETHHDR is supposed to be set by netinet/if_ether.h,
> > > > > rather than manually by users.
> > > >
> > > > Why does 76fce228 not work for you?
> > > 
> > > It does work, but that's a fix for iptables.  This is a fix for
> > > nftables.  I could have submitted a copy of the iptables fix, but I
> > > don't think it's the best fix due to its reliance on internal macros
> > > that are not part of the public interface.
> > 
> > Ah, sorry! Patch subject and description managed to confuse me.
> > 
> > Pablo, what's your opinion? Maybe we should strive for the same solution
> > for the problem in all netfilter user space, so either take what we have
> > in iptables or adjust iptables to what nftables decides how things
> > should be?
> 
> I see, you mean to use this (from iptables):
> 
> commit 76fce22826f8e860b5eb5b5a2463040c17ff85da
> Author: Joshua Lant <joshualant@googlemail.com>
> Date:   Wed Aug 28 13:47:31 2024 +0100
> 
>     configure: Determine if musl is used for build
> 
> and adapt to use it from nftables (and everywhere else).
> 
> Alyssa's patch is more simple, but it is mangling a cache kernel
> header.

Right, so the fixing should start in kernel repo, then update the cached
header in nftables.

> Is this configure.ac workaround needed everywhere in the netfilter.org
> trees to make musl happy?

AIUI, only in those including linux/if_ether.h directly. ;)
Though there is such include in nftables' src/payload.c which remains
unchanged by Alyssa's patch. Not sure if intentional, maybe there are
factors which make the include harmless.

> I don't see any better option at this stage.

According to a quick grep, there are currently six spots including
linux/if_ether.h (including one cached kernel header). I like about the
configure hack that it avoids breaking musl by accident via some
seemingly unrelated patch. Just one less thing to keep in mind, but this
is just me. I appreciate other opinions!

Cheers, Phil

PS: Can't we just fix musl instead? *hides*
