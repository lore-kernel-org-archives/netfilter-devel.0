Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686E8249E5;
	Mon,  9 Sep 2024 15:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725896291; cv=none; b=H577ERg9Pu4sSHpYk3dKVTIZj95tNXOmkVFHW7MU3el0hKyMhLbM18ofmLZjXIdMYcw2nJUocsPaUV+UTrloMhFG/4+L8e39G43mHJTXC2yRFsEh4OPjFVVeEamhlF63/YPsKYdeACfg3eUZSzFCelUHW2GuoYPcI4dyZkZn6PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725896291; c=relaxed/simple;
	bh=lqLuuXa9R/BJfjELxzUvQapnNWsHBC63Gvs0vJ9+DlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dLKwoazzUfBMREnefSB2geo9kWFT5kBOyZzBZ+bDZ7Zh3N34jl/5c5pEakYf0napYvRA0zSfvB0HMXYB21xdAmKqkhGDqSwM45BubFMFxINrOnpkkuGbjHB3EuM9olapUI6T2KTixP/lOwtJI67CdlkaZMStezISBfX6E47syXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z1HgkTKU; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z1HgkTKU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725896290; x=1757432290;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lqLuuXa9R/BJfjELxzUvQapnNWsHBC63Gvs0vJ9+DlY=;
  b=Z1HgkTKUutvRVDlPsGusi9pQy8lR3EGBJQjEz36wGkefqQAboP0EsMac
   QnmT6EvYq+HROkaGDyb1rf/D4cFpxKt9B5eDTSJyng2Mg+WZeRv8r5kRq
   XE6i0BIf/4+DoeFzQxmosJRlKYZkbgBeZgeQBHBnKD9q4HQ1uzPUdtbHs
   H113jzuruZ8p5LyCqQ1NLA17ggkvle0PSR8A0IJM/m3Of++lbm7DeRa8f
   NMMlXbgA+9wIf8upCCsSVrmiy8P4PbMVzrizTWSWdaN3B0U+YCxfevFwt
   6zIwNPgeBAZ8qwev8CkRNrTcJdiKqCbIaEVw4LZn+QCM+cz91Ki0BTiJH
   A==;
X-CSE-ConnectionGUID: 1rj7wCmSQAOif/8F//1WXw==
X-CSE-MsgGUID: e9tK+SKSQne9E+W9yGCWkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="24401241"
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="24401241"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 08:36:14 -0700
X-CSE-ConnectionGUID: Q8jdKuSbRiGleBHvcNTbBw==
X-CSE-MsgGUID: P1n01+ITRQSUx+NXJv5i0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="66678383"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 08:36:10 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1sngQx-00000006r9G-3voN;
	Mon, 09 Sep 2024 18:36:07 +0300
Date: Mon, 9 Sep 2024 18:36:07 +0300
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
Message-ID: <Zt8V5xjrZaEvR8K5@smile.fi.intel.com>
References: <20240905203612.333421-1-andriy.shevchenko@linux.intel.com>
 <20240906162938.GH2097826@kernel.org>
 <Zt7B79Q3O7mNqrOl@smile.fi.intel.com>
 <20240909151712.GZ2097826@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909151712.GZ2097826@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Mon, Sep 09, 2024 at 04:17:12PM +0100, Simon Horman wrote:
> On Mon, Sep 09, 2024 at 12:37:51PM +0300, Andy Shevchenko wrote:
> > On Fri, Sep 06, 2024 at 05:29:38PM +0100, Simon Horman wrote:
> > > On Thu, Sep 05, 2024 at 11:36:12PM +0300, Andy Shevchenko wrote:
> > 
> > > Local testing seems to show that the warning is still emitted
> > > for ctnetlink_label_size if CONFIG_NETFILTER_NETLINK_GLUE_CT is enabled

Hold on, this is not related to the patch.
It might be another issue.

> > > but CONFIG_NF_CONNTRACK_EVENTS is not.
> > 
> > Can you elaborate on this, please?
> > I can not reproduce.
> 
> Sure, let me retest and get back to you.

-- 
With Best Regards,
Andy Shevchenko


