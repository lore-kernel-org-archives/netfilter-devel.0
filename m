Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5A824EA9D
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2025 13:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684283; cv=none; b=a78ObmBPA6TejRhQqM2I5uH/04Gm8VjCeHHvxfjdTJ2CozYPlWGGDN8/egxYJYRNcoabmgzRqGiqhBlpvZyyTOHHr9N9XGNtvDmoFByHnJn8KmfIHpdg/pfkvQ78sEM0uUhgkR+9ItzRGux34ujYn3wpR937xXPEgVdv3lx2Ej0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684283; c=relaxed/simple;
	bh=Yq7AujlZv0bPjXs3BqNdg4b5yjlQWcBYodCM0tJx1/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=isC5q6gTC8aYMmBFFfJQ8IsxVihZhrV8b+Rvc93l2S+ZWqrZXLkLrz1fdpTW40/drOjggDwvltswUm1z+ExAfDMK9o4cxxhoDEGzkF5NEpVWwK/YE8w14mwNpwrkHOSFnJ6zJrp+xZzAvFKhPNx4QgUg3VYPVzFywWneTkNQGrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D029A60388; Mon, 23 Jun 2025 15:11:17 +0200 (CEST)
Date: Mon, 23 Jun 2025 15:11:12 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Heiss <c.heiss@proxmox.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools v3 0/2] conntrack: introduce --labelmap
 option to specify connlabel.conf path
Message-ID: <aFlScG0GhslCbuEC@strlen.de>
References: <20250623092948.200330-1-c.heiss@proxmox.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250623092948.200330-1-c.heiss@proxmox.com>

Christoph Heiss <c.heiss@proxmox.com> wrote:
> Enables specifying a path to a connlabel.conf to load instead of the
> default one at /etc/xtables/connlabel.conf.
> 
> nfct_labelmap_new() already allows supplying a custom path to load
> labels from, so it just needs to be passed in there.
> 
> First patch is preparatory only; to make --labelmap
> position-independent.
> 
> v1: https://lore.kernel.org/netfilter-devel/20250613102742.409820-1-c.heiss@proxmox.com/
> v2: https://lore.kernel.org/netfilter-devel/20250617104837.939280-1-c.heiss@proxmox.com/
> 
> Changes v2 -> v3:
>   * addressed minor cosmetic nits, no functional changes

Applied, thanks for following up and addressing all comments.
