Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789A12EF67A
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Nov 2025 10:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763549330; cv=none; b=J+E27YKirOJm2/s57bs+yaIAiJlgY4t1uDbKtmuH13MDL5TCYly9K4SzUYs/4byq3YiQeX55DIaeLCVFSEmdIrYqgN7EnrL6TKk04Waud6YF6UKRNCHq9ZcisFOqnhz/KjtCbJxgEFISIjSjhgXpDAVKv7PTvTGF678OYSzQAmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763549330; c=relaxed/simple;
	bh=r+zHhDTTsLheXQ42KOIVPHzhIsLIvjZkq0TNZT6eZwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R13CvNlligpwMY3rIyPbsbKos+6G74UhuZt6fR3q99Q8nY/Rgko7IqKyj9G27ZyQC45e4JbCa/KZ737l9yr8l1dX0J4BtIhFZ+CkoIedpFf1eLKjoAdAqO96OB8ZFzXA3JVVpxv9yd73YsAea4hwWCqOv8cIuj7qgchLHzkcJsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 736B9604EF; Wed, 19 Nov 2025 11:48:46 +0100 (CET)
Date: Wed, 19 Nov 2025 11:48:47 +0100
From: Florian Westphal <fw@strlen.de>
To: kernel test robot <lkp@intel.com>
Cc: netfilter-devel@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH nf-next 3/3] netfilter: nft_set_rbtree: do not modifiy
 live tree
Message-ID: <aR2gjylheAUlWlhv@strlen.de>
References: <20251118111657.12003-4-fw@strlen.de>
 <202511191544.ss8W56uH-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202511191544.ss8W56uH-lkp@intel.com>

kernel test robot <lkp@intel.com> wrote:
> sparse warnings: (new ones prefixed by >>)
> >> net/netfilter/nft_set_rbtree.c:893:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
>    net/netfilter/nft_set_rbtree.c:893:9: sparse:    struct rb_node [noderef] __rcu *
>    net/netfilter/nft_set_rbtree.c:893:9: sparse:    struct rb_node *
>    net/netfilter/nft_set_rbtree.c: note: in included file (through include/linux/mm_types.h, include/linux/page-flags.h, arch/arm64/include/asm/mte.h, ...):
>    include/linux/rbtree.h:74:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
>    include/linux/rbtree.h:74:9: sparse:    struct rb_node [noderef] __rcu *
>    include/linux/rbtree.h:74:9: sparse:    struct rb_node *

Sigh.

>  > 893		rcu_assign_pointer(priv->root[genbit].rb_node, NULL);

This can be replaced by

WRITE_ONCE(priv->root[genbit].rb_node, NULL);
