Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143572594B2
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2024 12:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734698027; cv=none; b=SZ/6buONEyWHhhaBrBKPXEcDrl5LPWpqbv/TrRsD9qoylVOz1QIxVRUVKH/er2uSlnf38yDZ3hIO+Q+52RRC3kkOJfPBjFsEt7HMpt70BpE6bZ1KWbaqgyV4Hq9NYnWeXtdfKPqophITHtLKH6Buo8gTifHr1FVJSqjdw5zM4X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734698027; c=relaxed/simple;
	bh=oGDDXPwilnqURXV2b9+Uf0/SCN0zkaZg4lk0FLdX0W0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=egShgUroVMSNrMEO82Ka46xZISI+dl7IWFvJOEGDK+PQYt24z48dldc+BzqywGmcZvWPhloMitnRKpvfLQGCgraGdQnN8m2fjshVcBOV3mrdMwbWVw8GJQ59Rv7UDl27GhTqVbTLu7t5JeNZXMFfkyCD7OfzEyZHBuKg7zBgGfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cv/OfISs; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cv/OfISs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=F3v3eo19C9P+FUto3dbfIEsQ5i0HpsWOMvg3O6MjNpQ=; b=cv/OfISsueM6tE3lhFU3REysqh
	svsfadU+bqD66q+lm7vrcPu+yWdIoBk4FTskSPAHo/JRtbEn61S40WWIybV4DztpPAENS7BedMKQU
	XmGVNDO4npATjYBJH8ynI4KQi+5qXc0lOp6domadvg4qplZppKg0VDBHIJvyhqhSoeMKqXzpwcz0x
	WmtLq2/CoWuT/d1H2Qno9gJe1jb9HsArvQc6SiUfeIlOdsnPtowyAwv4FPAhsyQB3oECVw7JsVlqF
	2O1Plz1Is4gNZa5h0iI1qBqsrDMp2+tsZ3i4WgOgpxhed7f7mbq5KmkFw+Puzxgv9+KcDXBThCYeK
	XWunoeXQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tOcCM-0000000046b-19wz;
	Fri, 20 Dec 2024 13:33:42 +0100
Date: Fri, 20 Dec 2024 13:33:42 +0100
From: Phil Sutter <phil@nwl.cc>
To: Alyssa Ross <hi@alyssa.is>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Joshua Lant <joshualant@googlemail.com>
Subject: Re: [PATCH nftables] include: fix for musl with iptables v1.8.11
Message-ID: <Z2VkJrkSLRmY9lAE@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Alyssa Ross <hi@alyssa.is>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Joshua Lant <joshualant@googlemail.com>
References: <20241219231001.1166085-2-hi@alyssa.is>
 <Z2VaEv0u3ZPcWqye@orbyte.nwl.cc>
 <v654rm6mbtymzhavlbg2fu7irth4mkz4motq7vb7rzjql5ccqa@u7xv7uvdfvsl>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <v654rm6mbtymzhavlbg2fu7irth4mkz4motq7vb7rzjql5ccqa@u7xv7uvdfvsl>

On Fri, Dec 20, 2024 at 01:07:56PM +0100, Alyssa Ross wrote:
> On Fri, Dec 20, 2024 at 12:50:42PM +0100, Phil Sutter wrote:
> > Hi Alyssa,
> >
> > On Fri, Dec 20, 2024 at 12:10:02AM +0100, Alyssa Ross wrote:
> > > Since iptables commit 810f8568 (libxtables: xtoptions: Implement
> > > XTTYPE_ETHERMACMASK), nftables failed to build for musl libc:
> > >
> > > 	In file included from /nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/netinet/et…
> > > 	                 from /nix/store/kz6fymqpgbrj6330s6wv4idcf9pwsqs4-iptables-1.8.10-de…
> > > 	                 from src/xt.c:30:
> > > 	/nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/netinet/if_ether.h:115:8: error: redefinition of 'struct ethhdr'
> > > 	  115 | struct ethhdr {
> > > 	      |        ^~~~~~
> > > 	In file included from ./include/linux/netfilter_bridge.h:8,
> > > 	                 from ./include/linux/netfilter_bridge/ebtables.h:1,
> > > 	                 from src/xt.c:27:
> > > 	/nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/linux/if_ether.h:173:8: note: originally defined here
> > > 	  173 | struct ethhdr {
> > > 	      |        ^~~~~~
> > >
> > > The fix is to use libc's version of if_ether.h before any kernel
> > > headers, which takes care of conflicts with the kernel's struct ethhdr
> > > definition by defining __UAPI_DEF_ETHHDR, which will tell the kernel's
> > > header not to define its own version.
> >
> > What I don't like about this is how musl tries to force projects to not
> > include linux/if_ether.h directly. From the project's view, this is a
> > workaround not a fix.
> 
> My understanding is that it's a general principle of using any libc on
> Linux that if there's both a libc and kernel header for the same thing,
> the libc header should be used.  libc headers will of course include
> other libc headers in preference to kernel headers, so if you also
> include the kernel headers you're likely to end up with conflicts.
> Whether conflicts occur in any particular case depends on how a
> particular libc chooses to expose a particular kernel API.  I could be
> misremembering, but I believe the same thing can happen with Glibc —
> some headers under sys/ cause conflicts with their corresponding kernel
> headers if both are included.  While this case is musl specific, I
> think the principle applies to all libcs.

While this may be true for the vast majority of user space programs,
netfilter tools and libraries are a bit special in how close they
interface with the kernel. Not all netfilter-related kernel API is
exposed by glibc, for instance. Including (some) kernel headers is
therefore unavoidable, and (as your patch shows) order of inclusion
becomes subtly relevant in ways which won't show when compile-testing
against glibc only.

> > > Signed-off-by: Alyssa Ross <hi@alyssa.is>
> > > ---
> > > A similar fix would solve the problem properly in iptables, which was
> > > worked around with 76fce228 ("configure: Determine if musl is used for build").
> > > The __UAPI_DEF_ETHHDR is supposed to be set by netinet/if_ether.h,
> > > rather than manually by users.
> >
> > Why does 76fce228 not work for you?
> 
> It does work, but that's a fix for iptables.  This is a fix for
> nftables.  I could have submitted a copy of the iptables fix, but I
> don't think it's the best fix due to its reliance on internal macros
> that are not part of the public interface.

Ah, sorry! Patch subject and description managed to confuse me.

Pablo, what's your opinion? Maybe we should strive for the same solution
for the problem in all netfilter user space, so either take what we have
in iptables or adjust iptables to what nftables decides how things
should be?

Cheers, Phil
