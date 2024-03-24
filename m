Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6661F1A38DA
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Mar 2024 13:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711288263; cv=none; b=r0WEA66DBZrlHkaqBe0fElmxC2gGpWpR9RGCNkPuCgs2t8nz4iw3wdTczvofzPDPNjttAQu/2+evw8KKhSpUFdUZzPUqnpjOATExZn9MYlW+Nq9twK+4zfKD/2T3zTRvNw0FJ5xd+3yCyfK8t8u5sKxC8lN7eHJp9yj2jSqiD+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711288263; c=relaxed/simple;
	bh=qc60tPDOPHemju0jO0N8Rm5tFmKjZCLYdJj4N2ZRi5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fpz1wkyP/m9VdMDsoCZ1cAwpQdKbPSelk/jmnsktpxOIlpdsYgn9C6CYvIzDDmSejudRHgwZ9fH3yDZStkwM5laOmJYSuqQ//KaO1m2ZZ2wEMy7hU4nDr7rDD42eFCW+NKNtmdyZ12eXoVuTzfD6eu+R4EyTw3Ep0AM08EPO548=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Ur0Y0MUt; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Ur0Y0MUt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fst73u0uUisWr+3mXRa8j5ZmxmgEQbRZRw86E8xdVSM=; b=Ur0Y0MUtemddQWJTbYh25pV7fC
	3iMteuRFhoLeqnO8PBu6Igzff91fwbukE4JtRyj0yyTXDx9qcKPX2aGv2N5GtSqyrU9TAzPPD3jrT
	t/pwleA9FrXBiovKELJEF+TFuwImd8NwKNiFCrfKFnWLXQLmHa8Q3Q3/VY1tS4WMpyVpy08c0gQ6t
	aBbGOI/Md4QuXWKx20C8NEwsJZIRI1aSyRwBmaIYLpyP/Kq0mQSkMEF9VAdb8XqnyMYRzWieEzYQD
	lRK3vHr93om/LemJu0ptXyt4zCQfOb/zkt78uNJvlzVdT+VmCefNbo3t24mlmL3W3NXiPFhhFdfUv
	xMeMnMrw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1roOFP-00000000422-32zH;
	Sun, 24 Mar 2024 14:50:51 +0100
Date: Sun, 24 Mar 2024 14:50:51 +0100
From: Phil Sutter <phil@nwl.cc>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@inai.de>,
	Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Subject: Re: [PATCH iptables] libxtables: Fix xtables_ipaddr_to_numeric calls
 with xtables_ipmask_to_numeric
Message-ID: <ZgAvu7pD4PJhyxB-@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Vitaly Chikunov <vt@altlinux.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@inai.de>,
	Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
References: <20240323030641.988354-1-vt@altlinux.org>
 <Zf7fm6b4SC885EcU@orbyte.nwl.cc>
 <20240323213753.cqockivt4fwan52a@altlinux.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240323213753.cqockivt4fwan52a@altlinux.org>

On Sun, Mar 24, 2024 at 12:37:53AM +0300, Vitaly Chikunov wrote:
> On Sat, Mar 23, 2024 at 02:56:43PM +0100, Phil Sutter wrote:
> > On Sat, Mar 23, 2024 at 06:06:41AM +0300, Vitaly Chikunov wrote:
> > > Frequently when addr/mask is printed xtables_ipaddr_to_numeric and
> > > xtables_ipmask_to_numeric are called together in one printf call but
> > > xtables_ipmask_to_numeric internally calls xtables_ipaddr_to_numeric
> > > which prints into the same static buffer causing buffer to be
> > > overwritten and addr/mask incorrectly printed in such call scenarios.
> > > 
> > > Make xtables_ipaddr_to_numeric to use two static buffers rotating their
> > > use. This simplistic approach will leave ABI not changed and cover all
> > > such use cases.
> > 
> > I don't quite like the cat'n'mouse game this opens, although it's
> > unlikely someone calls it a third time before copying the buffer.
> > 
> > What do you think about the attached solution?
> 
> Your approach is indeed much better. But why double underscore prefix
> to a function name, this sounds like reserved identifiers.

Well, for once it was just a quick sketch. Also, when refactoring into
an inner function it is not uncommon to prefix it this way, at least if
it's an internal-only function.

Another option I could think of is _r suffix, typically used for
reentrant variants.

Cheers, Phil
