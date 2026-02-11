Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB05E35292E
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 18:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770836377; cv=none; b=kJFfF6sAn4cBDXaeMPfIJUlIy5p+s6O0/+D0cheCqzlJ+R2iVtMmGPi6M8jpemv2p1ueZqdZb8TmcSJkSvv+xXTx0UirxzeyWzdTPNtIcZTbSccDpoAFPDeyexQXKQqosg6U4HPQcFGIEdBumrItfc/DGJ2i/ZTKRZdrCP6Di38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770836377; c=relaxed/simple;
	bh=0iNS86GZ8d/La/LnTRcGkUNaOEbdS6Au0KpphJCIol0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUXwx4B6LogBWfbV/WYSxUoxJx4Tz8KNAODiYeaGeKbviHSFCScoHDqW5Q66qjeYyiT4p7V3w1n2R5VXAwEDMjvHgW2U4JwcZCuo883uzhB6P+hAl6IzhU9gaLueurtADldnwXdPiDilUbPT5GK46yZ3ciXkCzVA2KzLuI33DVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=eCHWSA6u; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="eCHWSA6u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MiG4Ghaay/9qJbUFGI/4iWRA2McC+O4SMR4Kp9eZazI=; b=eCHWSA6uomqJ1LT3mz+Xmq9rto
	DAW4rTlqBXlZLq6xUbAqaQlhjeslNYtzAnuIyglu5sF2cndyS+lfGst2u3QX3nPkTYF5ykOqwtkGf
	HcqOE9nptcd3WRz7egRKKmjYjGkvwoLRHXr8GjsjNUwy5EcmmI1D8JXy+znQhSabre0oZE7hV7d/r
	uHH2UOJgrxU1PTfzB41v6NWcu+l1rjJ7d3AHtOsY7tCdoCbt68WSLJNRA4RCgSzj+8AzevEtAhEYm
	KqqF+szfAp0aYyjt+fzUP+bZycdFMXcvs4Bc7AgJHiNYVFcKYdmdhBOnnMa5zGrc3G38SM3eR1xBr
	NaKHMvMQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vqFQz-000000006wY-3Ame;
	Wed, 11 Feb 2026 19:59:33 +0100
Date: Wed, 11 Feb 2026 19:59:33 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Alyssa Ross <hi@alyssa.is>,
	netfilter-devel@vger.kernel.org,
	Joshua Lant <joshualant@googlemail.com>
Subject: Re: [PATCH nftables] include: fix for musl with iptables v1.8.11
Message-ID: <aYzRlXaSetejciwU@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Alyssa Ross <hi@alyssa.is>,
	netfilter-devel@vger.kernel.org,
	Joshua Lant <joshualant@googlemail.com>
References: <20241219231001.1166085-2-hi@alyssa.is>
 <Z2VaEv0u3ZPcWqye@orbyte.nwl.cc>
 <v654rm6mbtymzhavlbg2fu7irth4mkz4motq7vb7rzjql5ccqa@u7xv7uvdfvsl>
 <Z2VkJrkSLRmY9lAE@orbyte.nwl.cc>
 <Z38Ladz49yJcTC8p@calendula>
 <Z38PIVmu2jAVl1k2@orbyte.nwl.cc>
 <Z38STV2bWSlz4uxo@calendula>
 <Z3-emP_FzgGAYGUJ@orbyte.nwl.cc>
 <aYyI9kN4FAgbFUA-@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYyI9kN4FAgbFUA-@strlen.de>

On Wed, Feb 11, 2026 at 02:49:42PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Thu, Jan 09, 2025 at 01:03:25AM +0100, Pablo Neira Ayuso wrote:
> > > Hm. I am looking at include/uapi/linux/netfilter_bridge.h and...
> > > 
> > > #include <linux/in.h>
> > > #include <linux/netfilter.h>
> > > #include <linux/if_ether.h>
> > > #include <linux/if_vlan.h>
> > > #include <linux/if_pppox.h>
> > > 
> > > I don't understand why all those #include need to be there, this
> > > header file contains only defines an enumeration... git annotate takes
> > > me to:
> > > 
> > >   607ca46e97a1 ("UAPI: (Scripted) Disintegrate include/linux")
> > > 
> > > Silly question: Does it break any netfilter userspace software if
> > > #include <linux/if_ether.h> is moved from that kernel header file to
> > > to the non-uapi netfilter_bridge.h header file.
> > 
> > Silly counter question: Does removing an include statement break UAPI?
> 
> Yes, it risks uapi breakage.

I hope this extra include is safe in that regard.

> > BTW: I see only a single UAPI kernel header include from netinet space
> > (include/uapi/linux/mptcp.h) and it's for compat reasons (06e445f740c1
> > ("mptcp: fix conflict with <netinet/in.h>")). Speaking of which, what if
> > we added:
> > 
> > | #ifndef __KERNEL__
> > | #include <netinet/if_ether.h>
> > | #endif
> > 
> > early into include/uapi/linux/if_ether.h? Aside from any header caches,
> > this should fix all of user space at once, no?
> 
> Phil, would you send a formal patch to make this workaround *ONLY* in
> netfilter_bridge.h (06e445f740c1)?

DONE.

> That way the fix can be propagated to nftables.git without having to
> adjust cached headers on every update.

I assume you prefer to keep headers untouched which are
iptables-specific. But why not attempt to patch if_ether.h itself?

Cheers, Phil
