Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A78A19C562
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 11:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726227751; cv=none; b=cc2pqkKFPuMfMYwsODK8i11TGOBwx6UNcaJPldIuBKLJgi1gsQyHU8MXu6gKnG7C3RJi1i3wbcOOeBnZzqZl7eLb4Sl2+MTriS7SGD13Y+PL/OpLwGnTV9i8EtrQyMLD2XRbQASE3tSymZ0Y60rl0osgtXB/NEhS61FmREcwjR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726227751; c=relaxed/simple;
	bh=GiZR3l9lPtBe8PVt6XGHEP8YxR/XaECpZlGI5fMBKsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e5lBiIT+HE0YRVF1Zlkt+u4N2BskA2uAlUJUbzLf99lTCUNtPUShN0yWFWr9dBsFPsxL7Wv6j3GPdMisMdVtVTQ0sD1+tCRMNyhC+aGJw/kfZVUg/NE1RHqwd3Ftk3GwhsnIhTNiNrVOLoWFPImuDCEe0sXIQbY13h4JOxvWOd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EMLAzk2g; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EMLAzk2g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QNDYG0F5hUkRHa5XLYmTtNDPW65L6lyvz3BZgZD6JWU=; b=EMLAzk2gvGY4OhByCE9iVo+KXR
	no376M17BP1tmNmeZeKU5G4hQyaqdXGDMyQRTV1MXan7Hbn5p//wM1oWFdBTOSIiJcMEymquOENxA
	43u48kPyP9Sp93xkiKLHK220p9uEqLgcgSRLk27qYijeHYBWW5OWCAZHHOHtVACzA9/hPqZ/zKuQ9
	YCdv5CtItLn+JExAurK4OK2Tc/E46S8lANO0H7BITXPeMLKRl+0Melg/Nw7ymHQWz3d2Yq+DGsyeX
	5XhUWqPY6R9YBWTOnB9BIQp0sGiUAFfufvZLokOYkygiQHx6uFc+of+qkKWt2NYxa6wHh7zcwSNFm
	/0f4a8EA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sp4gz-000000000Jr-3aKx;
	Fri, 13 Sep 2024 13:42:25 +0200
Date: Fri, 13 Sep 2024 13:42:25 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 11/16] netfilter: nf_tables: chain: Respect
 NETDEV_REGISTER events
Message-ID: <ZuQlIQpFHdlvrAuB@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-12-phil@nwl.cc>
 <20240912144041.GE2892@breakpoint.cc>
 <ZuMDTL1P-NZ_Ezyk@orbyte.nwl.cc>
 <20240912151203.GA32404@breakpoint.cc>
 <ZuMLnfwhTdyqp90C@orbyte.nwl.cc>
 <20240912160639.GA9554@breakpoint.cc>
 <ZuMV7bQXHC3J3zU8@orbyte.nwl.cc>
 <20240912204357.GB23935@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240912204357.GB23935@breakpoint.cc>

On Thu, Sep 12, 2024 at 10:43:57PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > I.e., if no matching new hook, just unreg, else register new/unregister
> > > old.
> > 
> > I can't bind a device to multiple flowtables of the same family, so I
> > can't bind first, then unbind.
> 
> I'm dense, why does that not work?

Well, nft_register_flowtable_net_hooks() searches for a same hook in
other flowtables of the same table ("same" as in hook->ops.dev and
hook->ops.pf values match) and returns -EEXIST if found.

Originally this check was added by Pablo:

| commit 32fc71875127498bf99cc648e96400ee0895edf7
| Author: Pablo Neira Ayuso <pablo@netfilter.org>
| Date:   Mon Feb 26 13:16:04 2018 +0100
| 
|     netfilter: nf_tables: return EBUSY if device already belongs to flowtable
|     
|     If the netdevice is already part of a flowtable, return EBUSY. I cannot
|     find a valid usecase for having two flowtables bound to the same
|     netdevice. We can still have two flowtable where the device set is
|     disjoint.
|     
|     Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

The comment luckily indicates there's no technical reason, so the reg
first approach may fly. Apart from that, I'll try getting rid of this
because it prevents things like ft1(eth0, eth1) && ft2(eth1, eth2) which
seems like a valid use-case to me.

Thanks for questioning the basics here! :)

Cheers, Phil
