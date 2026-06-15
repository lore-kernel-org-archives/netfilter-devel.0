Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABC215CD7E;
	Mon, 15 Jun 2026 00:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781483899; cv=none; b=pYzOouwHsEXXey9uEyKJ35kxNDV9b8QbVPtA8nyl2Gj7BE+QxBIVfJXLXiummEaIv2mPi37xklLaiaxyUoLUeoRodfpW971krAWJnSokCYipshJ/gToUjknlGWHtSnJjDGUyAsELOY27FfDJhHy81Hrq4nEEIE82dBR86sE6tzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781483899; c=relaxed/simple;
	bh=x7Baw3v2AaNLY94j7SiqoQfh1bcLC24lGt0gRNQISzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QEVlviqNCflwNr8nUDW4+Bw7KCdBRz6d/Zr9z5OSXmswX7p78fm1HXbro0zZXTzJzERFs8Sl90vcU42ws3sc5LtKZJJQ6zC5kpf8cyzPdD/R4tDWxjonO/C2ZDzQffBxyDLuABxvHstV2DrkQDkqT3H5mwxSvO/DpX3ekAGo8+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EB61560529; Mon, 15 Jun 2026 02:38:09 +0200 (CEST)
Date: Mon, 15 Jun 2026 02:38:09 +0200
From: Florian Westphal <fw@strlen.de>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-nf-next:for-netdev-nf-next-26-06-14 3/11]
 net/netfilter/nf_conncount.c:502:18: sparse: sparse: incompatible types in
 comparison expression (different address spaces):
Message-ID: <ai9JaPRfvc3R_9Uz@strlen.de>
References: <202606150616.cpmJToWO-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202606150616.cpmJToWO-lkp@intel.com>

kernel test robot <lkp@intel.com> wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git for-netdev-nf-next-26-06-14
> head:   2354e975932dabb06fad239f07a3b68fd1809737
> commit: 64d7d5abe2160bba369b4a8f06bdf5630573bab0 [3/11] netfilter: nf_conncount: callers must hold rcu read lock
> config: x86_64-randconfig-123-20260614 (https://download.01.org/0day-ci/archive/20260615/202606150616.cpmJToWO-lkp@intel.com/config)
> compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
> sparse: v0.6.5-rc1
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260615/202606150616.cpmJToWO-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202606150616.cpmJToWO-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
> >> net/netfilter/nf_conncount.c:502:18: sparse: sparse: incompatible types in comparison expression (different address spaces):
>    net/netfilter/nf_conncount.c:502:18: sparse:    struct rb_node [noderef] __rcu *
>    net/netfilter/nf_conncount.c:502:18: sparse:    struct rb_node *
>    net/netfilter/nf_conncount.c:510:34: sparse: sparse: incompatible types in comparison expression (different address spaces):
>    net/netfilter/nf_conncount.c:510:34: sparse:    struct rb_node [noderef] __rcu *
>    net/netfilter/nf_conncount.c:510:34: sparse:    struct rb_node *
>    net/netfilter/nf_conncount.c:512:34: sparse: sparse: incompatible types in comparison expression (different address spaces):
>    net/netfilter/nf_conncount.c:512:34: sparse:    struct rb_node [noderef] __rcu *
>    net/netfilter/nf_conncount.c:512:34: sparse:    struct rb_node *

Thanks but I have no intent to fix this.

Between rcu_dereference_raw() not giving sparse warnings but also not
providing any hints when callers don't hold rcu read lock and plain
rcu_dereference() that does give runtime coverage but results in above
sparse output I will pick the latter and just ignore these warnings.
