Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1593163
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2025 00:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736381016; cv=none; b=XWsFnK/iF3IY9hIlmRDglHa907DNA8veaeMjL/C4nwZ4jTr8lEx7xJDNuIsderpnlY24y94fZp8n9bwPGlLXqcAO+FR8GoDqSU7hBZik/UxJPxi7m6su0f0Katml9zQQn9hYzbznTEaXM0ceMnJRXOICe+uDrntAa7S+8MxOpBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736381016; c=relaxed/simple;
	bh=JZ2LHp4rTtj8Ku7Hz364Mxvd7/Iv4bpj+olylwf7cag=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WBe6rQCDBKjjdKYO3fGXyEJt6iCa84FUI70iHTychP08z+inZomHngGnEyQUnOvYN84VymXrQwZp4ZKRqlYCPogNFBzdhuv/IglM8AfDtVi2irhtRt6LBVADgsMSC5StVo6p4+nWzNMs/NG/tLyiRSEhP29zVg4s5YvyjZgCCAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 9 Jan 2025 01:03:25 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Alyssa Ross <hi@alyssa.is>,
	netfilter-devel@vger.kernel.org,
	Joshua Lant <joshualant@googlemail.com>
Subject: Re: [PATCH nftables] include: fix for musl with iptables v1.8.11
Message-ID: <Z38STV2bWSlz4uxo@calendula>
References: <20241219231001.1166085-2-hi@alyssa.is>
 <Z2VaEv0u3ZPcWqye@orbyte.nwl.cc>
 <v654rm6mbtymzhavlbg2fu7irth4mkz4motq7vb7rzjql5ccqa@u7xv7uvdfvsl>
 <Z2VkJrkSLRmY9lAE@orbyte.nwl.cc>
 <Z38Ladz49yJcTC8p@calendula>
 <Z38PIVmu2jAVl1k2@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z38PIVmu2jAVl1k2@orbyte.nwl.cc>

Hi Phil,

On Thu, Jan 09, 2025 at 12:49:53AM +0100, Phil Sutter wrote:
> Hi Pablo,
>
> On Thu, Jan 09, 2025 at 12:34:01AM +0100, Pablo Neira Ayuso wrote:
> > On Fri, Dec 20, 2024 at 01:33:42PM +0100, Phil Sutter wrote:
> > > On Fri, Dec 20, 2024 at 01:07:56PM +0100, Alyssa Ross wrote:
> > > > On Fri, Dec 20, 2024 at 12:50:42PM +0100, Phil Sutter wrote:
> > > > > Hi Alyssa,
> > > > >
> > > > > On Fri, Dec 20, 2024 at 12:10:02AM +0100, Alyssa Ross wrote:
> > > > > > Since iptables commit 810f8568 (libxtables: xtoptions: Implement
> > > > > > XTTYPE_ETHERMACMASK), nftables failed to build for musl libc:
> > > > > >
> > > > > > 	In file included from /nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/netinet/et…
> > > > > > 	                 from /nix/store/kz6fymqpgbrj6330s6wv4idcf9pwsqs4-iptables-1.8.10-de…
> > > > > > 	                 from src/xt.c:30:
> > > > > > 	/nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/netinet/if_ether.h:115:8: error: redefinition of 'struct ethhdr'
> > > > > > 	  115 | struct ethhdr {
> > > > > > 	      |        ^~~~~~
> > > > > > 	In file included from ./include/linux/netfilter_bridge.h:8,
> > > > > > 	                 from ./include/linux/netfilter_bridge/ebtables.h:1,
> > > > > > 	                 from src/xt.c:27:
> > > > > > 	/nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/linux/if_ether.h:173:8: note: originally defined here
> > > > > > 	  173 | struct ethhdr {
> > > > > > 	      |        ^~~~~~
> > > > > >
> > > > > > The fix is to use libc's version of if_ether.h before any kernel
> > > > > > headers, which takes care of conflicts with the kernel's struct ethhdr
> > > > > > definition by defining __UAPI_DEF_ETHHDR, which will tell the kernel's
> > > > > > header not to define its own version.
> > > > >
> > > > > What I don't like about this is how musl tries to force projects to not
> > > > > include linux/if_ether.h directly. From the project's view, this is a
> > > > > workaround not a fix.
> > > >
> > > > My understanding is that it's a general principle of using any libc on
> > > > Linux that if there's both a libc and kernel header for the same thing,
> > > > the libc header should be used.  libc headers will of course include
> > > > other libc headers in preference to kernel headers, so if you also
> > > > include the kernel headers you're likely to end up with conflicts.
> > > > Whether conflicts occur in any particular case depends on how a
> > > > particular libc chooses to expose a particular kernel API.  I could be
> > > > misremembering, but I believe the same thing can happen with Glibc —
> > > > some headers under sys/ cause conflicts with their corresponding kernel
> > > > headers if both are included.  While this case is musl specific, I
> > > > think the principle applies to all libcs.
> > >
> > > While this may be true for the vast majority of user space programs,
> > > netfilter tools and libraries are a bit special in how close they
> > > interface with the kernel. Not all netfilter-related kernel API is
> > > exposed by glibc, for instance. Including (some) kernel headers is
> > > therefore unavoidable, and (as your patch shows) order of inclusion
> > > becomes subtly relevant in ways which won't show when compile-testing
> > > against glibc only.
> > >
> > > > > > Signed-off-by: Alyssa Ross <hi@alyssa.is>
> > > > > > ---
> > > > > > A similar fix would solve the problem properly in iptables, which was
> > > > > > worked around with 76fce228 ("configure: Determine if musl is used for build").
> > > > > > The __UAPI_DEF_ETHHDR is supposed to be set by netinet/if_ether.h,
> > > > > > rather than manually by users.
> > > > >
> > > > > Why does 76fce228 not work for you?
> > > >
> > > > It does work, but that's a fix for iptables.  This is a fix for
> > > > nftables.  I could have submitted a copy of the iptables fix, but I
> > > > don't think it's the best fix due to its reliance on internal macros
> > > > that are not part of the public interface.
> > >
> > > Ah, sorry! Patch subject and description managed to confuse me.
> > >
> > > Pablo, what's your opinion? Maybe we should strive for the same solution
> > > for the problem in all netfilter user space, so either take what we have
> > > in iptables or adjust iptables to what nftables decides how things
> > > should be?
> >
> > I see, you mean to use this (from iptables):
> >
> > commit 76fce22826f8e860b5eb5b5a2463040c17ff85da
> > Author: Joshua Lant <joshualant@googlemail.com>
> > Date:   Wed Aug 28 13:47:31 2024 +0100
> >
> >     configure: Determine if musl is used for build
> >
> > and adapt to use it from nftables (and everywhere else).
> >
> > Alyssa's patch is more simple, but it is mangling a cache kernel
> > header.
>
> Right, so the fixing should start in kernel repo, then update the cached
> header in nftables.
>
> > Is this configure.ac workaround needed everywhere in the netfilter.org
> > trees to make musl happy?
>
> AIUI, only in those including linux/if_ether.h directly. ;)

Hm. I am looking at include/uapi/linux/netfilter_bridge.h and...

#include <linux/in.h>
#include <linux/netfilter.h>
#include <linux/if_ether.h>
#include <linux/if_vlan.h>
#include <linux/if_pppox.h>

I don't understand why all those #include need to be there, this
header file contains only defines an enumeration... git annotate takes
me to:

  607ca46e97a1 ("UAPI: (Scripted) Disintegrate include/linux")

Silly question: Does it break any netfilter userspace software if
#include <linux/if_ether.h> is moved from that kernel header file to
to the non-uapi netfilter_bridge.h header file.

> Though there is such include in nftables' src/payload.c which remains
> unchanged by Alyssa's patch. Not sure if intentional, maybe there are
> factors which make the include harmless.

This is userspace, I guess we can replace it with userspace netinet/
header variant.

> > I don't see any better option at this stage.
>
> According to a quick grep, there are currently six spots including
> linux/if_ether.h (including one cached kernel header). I like about the
> configure hack that it avoids breaking musl by accident via some
> seemingly unrelated patch. Just one less thing to keep in mind, but this
> is just me. I appreciate other opinions!

Agreed, avoiding the configure kludge would be good.

> Cheers, Phil
>
> PS: Can't we just fix musl instead? *hides*
