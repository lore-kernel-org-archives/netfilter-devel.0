Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A47818952B;
	Wed, 18 Sep 2024 13:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726667723; cv=none; b=mq2bK4xVozdF6LmlDhPRX3BsRZLnWvTBthzXiC+v0yhSN7qfSdku1rHztxhDnQpCP1cqHELcA45UuLnIBasNjqzKhEPzNuXd4BvcmwrVU1etsQRwNDL7/wsk+Id8i9zXjvhUWDzZVvoASSCwuMsn/MUkUbAam1fy9ibjA7TQZsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726667723; c=relaxed/simple;
	bh=86vDqK2x0ER6NDvUrKKmlLDQ0tfjJ5Et5if/AV9scEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gk0TyS/23xHHl/A+cAYB5/ZzRgz6PPxqXoPj/hfdl92KjEeLuMKdcLGOQeL5Y4tPtOMGeki7oov7xPmIaSJ4q+27FE3Bl9cUb7A2OtYmd/TD8v1EZaZGZjtGgUu14Zj86W1VlXFl27XwWlIJcJni/5fUqMMMUA5HV2U33drWtzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V5+KC3Bi; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V5+KC3Bi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726667722; x=1758203722;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=86vDqK2x0ER6NDvUrKKmlLDQ0tfjJ5Et5if/AV9scEY=;
  b=V5+KC3BiRSJT7L5q/964K573A4Fmu8z7nwFWRVj1CDZiIke0lodx3Yd0
   4LjCTQAgEkRkHW5rtfOTvkme2Y5EyigMJ964HZrgBBCZCWFXthdLvCj4P
   2trt/J6Ernnn4oxBsW75eW+suwdxshReUlfP4vrLDuL7OkObUT6x/3Nbw
   /SV5pBcEbN3LKLBDdSVF/DXM0QLo65JAQLzN4iFxVG/Lb9d7qBgstLg+q
   WUoUbaYgaq+/wlq27SNlxjZj2iGVWBKB/WHydkuEIOBu3q6B/3Q/TRLtM
   hBipHS06U5vdzLCPAcqa5rCndHDC2YTzN5Don8wi94HPEi1IkSte484Lw
   g==;
X-CSE-ConnectionGUID: VsA44QOWRQGT79VD+Ci2hw==
X-CSE-MsgGUID: avt3SzbpTXin3YKcEKKS9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="36940749"
X-IronPort-AV: E=Sophos;i="6.10,238,1719903600"; 
   d="scan'208";a="36940749"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 06:55:21 -0700
X-CSE-ConnectionGUID: UHPVH35YSSuP8YZSa0yZEw==
X-CSE-MsgGUID: zsjxup1lSJSosZTWEJl6PA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,238,1719903600"; 
   d="scan'208";a="100402367"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 06:55:18 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1sqv9H-0000000ACEi-2vDZ;
	Wed, 18 Sep 2024 16:55:15 +0300
Date: Wed, 18 Sep 2024 16:55:15 +0300
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
Message-ID: <Zurbw1-Fl0EfdC0l@smile.fi.intel.com>
References: <20240916-ct-ifdef-v1-0-81ef1798143b@kernel.org>
 <Zuq-7kULeAMPRmFg@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zuq-7kULeAMPRmFg@calendula>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Wed, Sep 18, 2024 at 01:52:14PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 16, 2024 at 04:14:40PM +0100, Simon Horman wrote:
> > Hi,
> > 
> > This short series updates conditional compilation of label helpers to:
> > 
> > 1) Compile them regardless of if CONFIG_NF_CONNTRACK_LABELS is enabled
> >    or not. It is safe to do so as the functions will always return 0 if
> >    CONFIG_NF_CONNTRACK_LABELS is not enabled.  And the compiler should
> >    optimise waway the code.  Which is the desired behaviour.
> > 
> > 2) Only compile ctnetlink_label_size if CONFIG_NF_CONNTRACK_EVENTS is
> >    enabled.  This addresses a warning about this function being unused
> >    in this case.
> 
> Patch 1)
> 
> -#ifdef CONFIG_NF_CONNTRACK_LABELS
>  static inline int ctnetlink_label_size(const struct nf_conn *ct)
> 
> Patch 2)
> 
> +#ifdef CONFIG_NF_CONNTRACK_EVENTS
>  static inline int ctnetlink_label_size(const struct nf_conn *ct)
> 
> They both refer to ctnetlink_label_size(), #ifdef check is not
> correct.

But the first one touches more, no?

-- 
With Best Regards,
Andy Shevchenko


