Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5199EA2D;
	Wed, 18 Sep 2024 17:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726678889; cv=none; b=Sa4l6nzUcrEK3zDglaNph3PtKCzyc8byPtZJmW69cCRwPqUiCSMhb3Ce/EnXzjN457dyBP1w+puGJWy29xQ/ofjn4mnoEn445bSY1CuHJ+qzVOuw6wuvqrR4iqsWYYUMU4sSIkv3oLRgTojzKcls3YqrDGSWem/jN9fKLEUQ9Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726678889; c=relaxed/simple;
	bh=lwww9BoASplazXZpyotmxjh2HPqKe07Rd0qofPTCWsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cqjp2kXNYUnt7hLvuiomuWymEemhTzlaNmeBp+U+DNa+Zzst9kcZKsHZXjcn5/WjkA8l4/Kcp43KE30TK74EZCQ5ZAhlQWOSsHRFnXtDAusO+VkKTFUNIWhmO5kX4SQhS+vnAdyUzDR09Evw1XV+4A3zUaWuDtkya0ibKQUcKZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dw+Hh3U3; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dw+Hh3U3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726678889; x=1758214889;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lwww9BoASplazXZpyotmxjh2HPqKe07Rd0qofPTCWsQ=;
  b=dw+Hh3U3rmBSIBLT5F2kEGLQ+mOrD9emwCIW0D6tmaOmQ04YdwF+E6BY
   ZArriempWAwk/LDWaPC4aheEsQtHpDVxRXYg+wekXmsI2wOUReBfog65V
   TlUpPTqjKsc5U9/aH2kmIGnDPhy1f3lOaSeFkLfosV3AT2etmCy5A/9kV
   QD3qL9lmQbNZhkDj2+LKKZuFEEmTM+AKntF3zTtsQtYLY2NWAcP/aaQXU
   i17AOLewtwFUmCy3wru3Jllin5SeQJ7gH9Y7gTSnoIAgoQfGDyQ+dyKYr
   3NrvGIHBIl8NKbGkUt1dGlQvCt0EITHrHtdz9xmWSjoiPVhTNNjESdDvm
   g==;
X-CSE-ConnectionGUID: Qk5kG7oKS7iy1KzIZ64C+Q==
X-CSE-MsgGUID: qncrIotaSEqfnG+XpSgccg==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25764223"
X-IronPort-AV: E=Sophos;i="6.10,239,1719903600"; 
   d="scan'208";a="25764223"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 10:01:28 -0700
X-CSE-ConnectionGUID: fqEZfu0ITrSUNKfdFFQ+LA==
X-CSE-MsgGUID: S+aFv47VTHaUKlaMYvdpug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,239,1719903600"; 
   d="scan'208";a="69753322"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 10:01:24 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1sqy3N-0000000AFJ0-3HuA;
	Wed, 18 Sep 2024 20:01:21 +0300
Date: Wed, 18 Sep 2024 20:01:21 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Simon Horman <horms@kernel.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH nf-next 0/2] netfilter: conntrack: label helpers
 conditional compilation updates
Message-ID: <ZusHYUGYPADO1SgY@smile.fi.intel.com>
References: <20240916-ct-ifdef-v1-0-81ef1798143b@kernel.org>
 <Zuq-7kULeAMPRmFg@calendula>
 <Zurbw1-Fl0EfdC0l@smile.fi.intel.com>
 <Zurjur431P7DqifB@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zurjur431P7DqifB@calendula>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Wed, Sep 18, 2024 at 04:29:14PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 18, 2024 at 04:55:15PM +0300, Andy Shevchenko wrote:
> > On Wed, Sep 18, 2024 at 01:52:14PM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Sep 16, 2024 at 04:14:40PM +0100, Simon Horman wrote:
> > > > Hi,
> > > > 
> > > > This short series updates conditional compilation of label helpers to:
> > > > 
> > > > 1) Compile them regardless of if CONFIG_NF_CONNTRACK_LABELS is enabled
> > > >    or not. It is safe to do so as the functions will always return 0 if
> > > >    CONFIG_NF_CONNTRACK_LABELS is not enabled.  And the compiler should
> > > >    optimise waway the code.  Which is the desired behaviour.
> > > > 
> > > > 2) Only compile ctnetlink_label_size if CONFIG_NF_CONNTRACK_EVENTS is
> > > >    enabled.  This addresses a warning about this function being unused
> > > >    in this case.
> > > 
> > > Patch 1)
> > > 
> > > -#ifdef CONFIG_NF_CONNTRACK_LABELS
> > >  static inline int ctnetlink_label_size(const struct nf_conn *ct)
> > > 
> > > Patch 2)
> > > 
> > > +#ifdef CONFIG_NF_CONNTRACK_EVENTS
> > >  static inline int ctnetlink_label_size(const struct nf_conn *ct)
> > > 
> > > They both refer to ctnetlink_label_size(), #ifdef check is not
> > > correct.
> > 
> > But the first one touches more, no?
> 
> Yes, it also remove a #define ctnetlink_label_size() macro in patch #1.
> I am fine with this series as is.

What I meant is that the original patch 1 takes care about definitions of
two functions. Not just a single one.

-- 
With Best Regards,
Andy Shevchenko


