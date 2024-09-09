Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E541B3732;
	Mon,  9 Sep 2024 09:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725874015; cv=none; b=RWWaYZuMEkOZfTjjTi3W2e6VITfSQdIXwTG1jTn8L8Mj5vpxfjlJ1/g0BO8fdPAOppvdf7CiDfhSUHRkuv8NKQa0e1angBPvsugyUJuAG2dmJXxCiJkySq86pgZxA88m+ERQV+LrHrQa8sahkMC1ZgaodvigQQnCIvYUh3Y24Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725874015; c=relaxed/simple;
	bh=YMfDOUXP8QWcgZnPeCfOORRIXgzJrJORZJWFxCKAw1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ph9czympGyqNd4YX3g48cFN9lLCGX47X0XfBUIOotjDnpsNveFL8NEsgFo0itNYiBg7/it1M9mTikqGMIwpTDcsjmUA/YzAPS7JFyZQgWryiuY26JLJYyTme1KD+P23oBBcGqLXgb/DoeWqmyC3rfBWQt/X3hjve9QUBTtWazzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L+gw2Oog; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L+gw2Oog"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725874014; x=1757410014;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YMfDOUXP8QWcgZnPeCfOORRIXgzJrJORZJWFxCKAw1U=;
  b=L+gw2Oog51Qe9RU40G3pMujdZGqaWTSp0K2vTKKkKL9zeYqnYXgzbBA+
   4ebVKRb/rucjHhlXnFhyF/ajTN5a1lTmz76y8YU3almg8CzQTikxIV7nQ
   I9ATF8HhsIQEcMCRGFhZ+GKHdm4AQ1giD1CHRjgkJxJYwZYeXma8qMq8c
   LMNcdHMpW/47FBQX8dAgEN7dLkuVDWLFGv58lxj1fC79MxO3pxgRmJ2pD
   RSe6SD7ARs2D0EXGnl4y5NGRghPy+9cpY2vrjnVPFYFRA28rO08SakM8l
   peAFe1RXYcq1T8o47g4uTOmRWbgxdtHClZT6eVewepFDWRxrCOmPkvJur
   A==;
X-CSE-ConnectionGUID: KeNzKqyjQ/eclhR+l3gxBQ==
X-CSE-MsgGUID: M9cNSMz4Rd2v7Trz2lVVmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="24718765"
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="24718765"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 02:26:53 -0700
X-CSE-ConnectionGUID: 9SN7b16eQ7aeQERUUwenrQ==
X-CSE-MsgGUID: O8pxyOc7S7Gk/VEVAOIJ+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="66324974"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 02:26:42 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1snafP-00000006jXU-2nYN;
	Mon, 09 Sep 2024 12:26:39 +0300
Date: Mon, 9 Sep 2024 12:26:39 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Simon Horman <horms@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Felix Huettner <felix.huettner@mail.schwarz>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH net v1 1/1] netfilter: conntrack: Guard possoble unused
 functions
Message-ID: <Zt6_T2INKWSm7YK8@smile.fi.intel.com>
References: <20240905203612.333421-1-andriy.shevchenko@linux.intel.com>
 <20240906162938.GH2097826@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906162938.GH2097826@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Fri, Sep 06, 2024 at 05:29:38PM +0100, Simon Horman wrote:
> On Thu, Sep 05, 2024 at 11:36:12PM +0300, Andy Shevchenko wrote:
> > Some of the functions may be unused, it prevents kernel builds
> > with clang, `make W=1` and CONFIG_WERROR=y:
> > 
> > net/netfilter/nf_conntrack_netlink.c:657:22: error: unused function 'ctnetlink_acct_size' [-Werror,-Wunused-function]
> >   657 | static inline size_t ctnetlink_acct_size(const struct nf_conn *ct)
> >       |                      ^~~~~~~~~~~~~~~~~~~
> > net/netfilter/nf_conntrack_netlink.c:667:19: error: unused function 'ctnetlink_secctx_size' [-Werror,-Wunused-function]
> >   667 | static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
> >       |                   ^~~~~~~~~~~~~~~~~~~~~
> > net/netfilter/nf_conntrack_netlink.c:683:22: error: unused function 'ctnetlink_timestamp_size' [-Werror,-Wunused-function]
> >   683 | static inline size_t ctnetlink_timestamp_size(const struct nf_conn *ct)
> >       |                      ^~~~~~~~~~~~~~~~~~~~~~~~
> 
> Hi Andy,
> 
> Local testing seems to show that the warning is still emitted
> for ctnetlink_label_size if CONFIG_NETFILTER_NETLINK_GLUE_CT is enabled
> but CONFIG_NF_CONNTRACK_EVENTS is not.

Hmm... Let me try that. I am using mostly x86_64_defconfig for the testing.
The idea is to have once x86_64_defconfig to be clean with W=1 and since then
it will be easier to enable it unconditionally for CIs for _that_ particular
configuration(s) ("s" in case of i386_defconfig to be at the same level).

> > Fix this by guarding possible unused functions with ifdeffery.
> > 
> > See also commit 6863f5643dd7 ("kbuild: allow Clang to find unused static
> > inline functions for W=1 build").
> > 
> > Fixes: 4a96300cec88 ("netfilter: ctnetlink: restore inlining for netlink message size calculation")
> 
> I'm not sure that this qualifies as a fix, rather I think it should
> be targeted at net-next without a Fixes tag.

Okay.

Thank you for the review!

-- 
With Best Regards,
Andy Shevchenko


