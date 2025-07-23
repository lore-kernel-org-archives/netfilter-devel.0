Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A66B1D7E4A
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Jul 2025 18:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753294605; cv=none; b=srDQUpkZPk6DcHHjlEnKu+Ip0TMSDSKp5+u7m351ZSs41hqklpR4zanNBOehlwONnTZgeonRKPMOfqKuA5N6wgVy099iuQHxWnt/vo63y7ylI3UFRgOxqDZzbuyQYEyKF1ZpHzqawV4dvQJe8UxOE8QjLkFWQD6OtSv9CraYne0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753294605; c=relaxed/simple;
	bh=PgXUfjyVPAsVbF8yCgMaa8ISJ4G3/6XrnNIMyLG81+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lGRHAtDvqPNsLj4t618y4nss4CLMOLYdG7+ak2libE24vbJT0TQsPgfYo24h6cdqNP1q3wa3T5vlsr7EaMf6+wcGZfzfyOF5OHtasrQTaCwVaEVESc4PB8NQsSSssaGsZzulxijaUOZQpIKl4UsciV0TAnPNCsmAQ//4CdI8xAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9BC806035A; Wed, 23 Jul 2025 20:16:39 +0200 (CEST)
Date: Wed, 23 Jul 2025 20:16:39 +0200
From: Florian Westphal <fw@strlen.de>
To: "zs@zslab.cn" <zs@zslab.cn>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Subject: [nftables] Bug: dup rule fails to modify MAC address on
 netdev/ingress hook
Message-ID: <aIEnB7ijcw_-mzjd@strlen.de>
References: <2025072314434064423510@zslab.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025072314434064423510@zslab.cn>

zs@zslab.cn <zs@zslab.cn> wrote:
> Hello netfilter/nftables developers,
> 
> I've encountered a potential bug in nftables behavior when using the `dup` statement in the netdev/ingress hook to modify the destination MAC address. The issue only occurs when a single rule is defined, but works correctly when two identical rules are added.
> 
> ### Environment:
> - OS: openEuler 24.03 LTS-SP2
> - Kernel: 6.6.0-98.0.0.103.oe2403sp2.x86_64
> - nftables versions tested: v1.0.8 and v1.1.3
> - Interfaces: gretap10 (ingress hook), output to eth2
> 
> ### Steps to Reproduce:
> nft add table netdev mirror_nogre
> nft add chain netdev mirror_nogre ingress \
>     '{ type filter hook ingress device "gretap10" priority 0; }'
> nft insert rule netdev mirror_nogre ingress position 0 \
>     dup to eth2 ether daddr set BC:24:11:C0:CE:EB

This sets the mac address of the original packet, not the duplicated
one.

> dup to "eth2" ether daddr set bc:24:11:c0:ce:eb

This makes a clone and sends it via eth2.
Then it changes the ether daddr of the original packet.

> dup to "eth2" ether daddr set bc:24:11:c0:ce:eb

This makes a clone of the (now modified) original packet and sends it
via eth2, then alters the daddr again (to the same, already altered
value).
