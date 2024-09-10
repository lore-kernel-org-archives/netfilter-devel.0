Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196A2187FE2;
	Tue, 10 Sep 2024 08:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725955950; cv=none; b=SZgNBCOX9FlPKbRzHaaUuhpiOS/xYqdk4XHqj/fnIoEnPJW2UrpeuBvYrzYd99FmTjdFT0jGWzFfik0CiEf3iJMs/rDFNXCxlFyOODczYRH6bRfD0cipK23clt4tIwFHtwWvRYfYzZk3kqu5vpSSodUWWnkY+LOt+H3uUxtYCX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725955950; c=relaxed/simple;
	bh=X6w/BPx5GBKrPXBB3CaDS2kMB9yUmJ5UQVZ/g6ar698=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YegdEfdlTGseyYaKGYen+yqOhudxwpZEf0AXPpreiADeLEypm5QaQRXyAzO23IZUbDAC0Sg25qSYUUXzEhmxuFzpPsIP7XG43q0ro4WsV9HLOdG+lNKbwcnoU4HUGHybec8jvMgjmfOxkHxpqY3/MBsovFtn0Y0idUuY5tK4xD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c1JO7NKW; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c1JO7NKW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725955949; x=1757491949;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X6w/BPx5GBKrPXBB3CaDS2kMB9yUmJ5UQVZ/g6ar698=;
  b=c1JO7NKWOYPt8+q5NLhYkD7Z2AWl3620cVQL8IoL3rRzLUfvlsSEjQw/
   /Jxkdp5zhH6HLT1X5OKF+mPF6I4eOptSHNATKeyOy9bUoV7UkBeLyqfQz
   o9LW3uptwegk5DysrW4UBFfZaJY9mMy3oMHISrHKFtZpUGkWK3og6f6GH
   fdybnE8oEFX4VIwpDCm3zp2vwgfwuf2mSQkmWV0KcMDp/slqf7xW4uD+m
   kOxZqZkXOgKHT0NDVmColnXWZhqlhTf0HVcUnyYlK4APM3Xn4+WMilmmT
   v0mgnZYNUOGZdMe9dhQKg1aZkEQfcxtNGQ36ZM5xequnD76f22UDx0Oxx
   A==;
X-CSE-ConnectionGUID: THDnvafVShaDNko6ydX6yw==
X-CSE-MsgGUID: Wmk+4VwlQ9eQ2NsU5zNsYA==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="47204529"
X-IronPort-AV: E=Sophos;i="6.10,216,1719903600"; 
   d="scan'208";a="47204529"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 01:12:29 -0700
X-CSE-ConnectionGUID: fyEZI10hQyekJ/4mrj2MmQ==
X-CSE-MsgGUID: 7C9rnatgR5+/KfxNh0wgfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,216,1719903600"; 
   d="scan'208";a="97648069"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 01:12:25 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1snvz3-000000077EJ-2djD;
	Tue, 10 Sep 2024 11:12:21 +0300
Date: Tue, 10 Sep 2024 11:12:21 +0300
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
Message-ID: <Zt__ZT-P0kUY909z@smile.fi.intel.com>
References: <20240905203612.333421-1-andriy.shevchenko@linux.intel.com>
 <20240906162938.GH2097826@kernel.org>
 <Zt7B79Q3O7mNqrOl@smile.fi.intel.com>
 <20240909151712.GZ2097826@kernel.org>
 <Zt8V5xjrZaEvR8K5@smile.fi.intel.com>
 <20240909183043.GE2097826@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909183043.GE2097826@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Mon, Sep 09, 2024 at 07:30:43PM +0100, Simon Horman wrote:
> On Mon, Sep 09, 2024 at 06:36:07PM +0300, Andy Shevchenko wrote:
> > On Mon, Sep 09, 2024 at 04:17:12PM +0100, Simon Horman wrote:
> > > On Mon, Sep 09, 2024 at 12:37:51PM +0300, Andy Shevchenko wrote:
> > > > On Fri, Sep 06, 2024 at 05:29:38PM +0100, Simon Horman wrote:
> > > > > On Thu, Sep 05, 2024 at 11:36:12PM +0300, Andy Shevchenko wrote:
> > > > 
> > > > > Local testing seems to show that the warning is still emitted
> > > > > for ctnetlink_label_size if CONFIG_NETFILTER_NETLINK_GLUE_CT is enabled
> > 
> > Hold on, this is not related to the patch.
> > It might be another issue.
> 
> Yes, sorry, I see that now too.
> 
> Perhaps it can be fixed separately, something like this:

If you make a patch, it will help somebody who has that in their configuration
files enabled (with the other one being disabled). Note, I use x86_64_defconfig
which doesn't have this specific issue to be occurred.

-- 
With Best Regards,
Andy Shevchenko


