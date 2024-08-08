Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CC81487C1
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Aug 2024 12:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723119580; cv=none; b=sVDGqv3ZRStnG2PKgZ7iErCZCPuP4J/mgjRcZNgju99owKiHxOGiv15qVMRHtSb9oienIPL8V3e+7pbgJ8BBpji4O7+vN5cRbQc2jiKNtZdjOXFvSex7QbBnxLJfDJ9RNA+0B+CKvF6jQNCaizjT75hxgFiHjf18JA2sDK26tSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723119580; c=relaxed/simple;
	bh=1R9mjACoXrONWPxE7o8MExYnGoLqNZ59+TtgLcmuEYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQndfcsem+GtDEqAGJZStO5KaAa5eHAYYmb/A+4aLAraaLkcia+eZq3cGLiiw12p89Q6lb+nIPH/Jo7038qWLXeXVuq1dHgmWyG3+peiQxPtatb/16uuS/2jS5FcTUkdW6RSL/mpqgBJfgAekXlGRbA8p7WIZxJL6bYv6tPPMMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sc1W8-0006qJ-NK; Thu, 08 Aug 2024 13:41:16 +0200
Date: Thu, 8 Aug 2024 13:41:16 +0200
From: Florian Westphal <fw@strlen.de>
To: Joshua Lant <joshualant@googlemail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: iptables: compiling with kernel headers
Message-ID: <20240808114116.GC20589@breakpoint.cc>
References: <20240808095901.2844386-1-joshualant@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240808095901.2844386-1-joshualant@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Joshua Lant <joshualant@googlemail.com> wrote:
> > Why are you interested in getting iptables to work?
> > 
> > It would be better to ensure that nftables is working properly; unlike
> > with xtables the kernel representation is hidden from userspace.
> 
> Sorry I should have been clear initially, I am trying to compile using nftables.

No, I was talking about:
https://git.netfilter.org/nftables/

which doesn't use any of the old xtables structures and
is not supposed to have any 'binary blobs' passed between
kernel and userland.

iptables-nft still uses some parts of xtables, most of the
matches and targets are handled this way, and binary blob is
passed to kernel via netlink.  See net/netfilter/nft_compat.c

Admittingly, its less bad than the get/setsockopt format, but you've
already encountered things like include/uapi/linux/netfilter/xt_TEE.h

As for a way foward, there are several options:
1. "unsupported, use native nft binary"
2. what you did: force pointers to be sizeof(unsigned long), they
   aren't used by userland, they are placeholders for kernel only
3. Once https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240731222703.22741-8-phil@nwl.cc/
   discussion is resolved, aggressively convert itpables-nft to
   prefer native nft expressions instead of the nft_compat proxy.

3) is definitely a lot more work than 2).
Furthermore iptables-nft cannot be made a full nft client because
iptables syntax lacks aequivalents for native nft constructs like
jump maps or sets, so users cannot mix nft and iptables-nft anyway.

Personally I think it would be better to let iptables move
to maintenance only mode and let it die rather than continue
to spending time on it, but this is the minority opinion so far.
