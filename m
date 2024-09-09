Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760191B2EDC;
	Mon,  9 Sep 2024 09:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725875076; cv=none; b=d2pNfkJZo7m4NlRY2kPkJfQlxgn9YB9kfH+CWf5Qnl29TfxbKv46o3M/AUrG/TSuKLMdrG1BD6lqTaURt2bxbdXmYbYfW0XBO50uIj+Cw9U+sld5mHMu0ubS177YxZbtaadNlTPmvZP40+9l93W0l0nAqrrDR73SFyfjb61hJJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725875076; c=relaxed/simple;
	bh=NwNF4gkNZxfITFKYRW3ZBe+PB8nJJ+vaL7edxlWc3ro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eWyWMoz/5A+c30Mj06qHNxnvTEDtkMfFLxg69LG9uNPOKkSJdH2UezjjS92ENWc99FfG0KtKpL4BqnQ6c/SS3dwLXxZYWqkwo9yabiBMb9HNIsclaR1xYJ+LOWiw+jfykZvysQ4JTApCl/WXjqak8LawnGT1F8g0KpgrO0ZcgwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PA6yz94n; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PA6yz94n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725875075; x=1757411075;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NwNF4gkNZxfITFKYRW3ZBe+PB8nJJ+vaL7edxlWc3ro=;
  b=PA6yz94nIMp0FFoRFgUiQ1egfYQv7cgUZ15V9xuALmlAZ+2R/znraZD+
   H/nM1h/VwD7lf/iE/RKcHoZbkz7ZFO3g8/34wmBDtNTFVxo61Vtang+cc
   eD+nk4Sv+Q9Ml9ghWu2dtG5k3VehZCzJcHraVay2eTskRlQChGdt6i/HA
   k17WogXHZ4rgbDhEkTJG1V/Yw5V9EdlDzKfpH6Y5uQUwJW0J1gWw0vhk/
   Qi8IOp8eqqVrMMNr4MpE8sKmFQLmaLYoimWXd8Q1URNnkncJrt9qMCmgy
   mGvZhv8vSUkEUzuONlTfmuVdpfz9k1Er+mobk6b9EUPQLnh0TFB06D6nl
   g==;
X-CSE-ConnectionGUID: O5KCdt01TGWHpZ7J/SKYwQ==
X-CSE-MsgGUID: F5VQpHe9T3Kb78JWriunYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="27484047"
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="27484047"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 02:44:33 -0700
X-CSE-ConnectionGUID: bo4VfySFQ+m78PdHezdaew==
X-CSE-MsgGUID: s4xQ+8WmQlCbXSHArVx/1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="66250044"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 02:44:28 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1snawc-00000006jqy-0nMH;
	Mon, 09 Sep 2024 12:44:26 +0300
Date: Mon, 9 Sep 2024 12:44:25 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Simon Horman <horms@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH net v1 1/1] netfilter: nf_reject: Fix build error when
 CONFIG_BRIDGE_NETFILTER=n
Message-ID: <Zt7DeR6ZgtA0MhXg@smile.fi.intel.com>
References: <20240906145513.567781-1-andriy.shevchenko@linux.intel.com>
 <20240907134837.GP2097826@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240907134837.GP2097826@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Sat, Sep 07, 2024 at 02:48:37PM +0100, Simon Horman wrote:
> On Fri, Sep 06, 2024 at 05:55:13PM +0300, Andy Shevchenko wrote:

> As mentioned in relation to another similar patch,
> I'm not sure that resolution of W=1 warnings are fixes.

Up to you, I consider they as fixes as I'm pretty much annoyed each release to
have disable CONFIG_WERROR. But I got your point.

...

> Possibly it is broken for some reason - like reading nskb too late -
> but I wonder if rather than annotating niph it's scope can be reduced
> to the code that is only compiled if CONFIG_BRIDGE_NETFILTER is enabled.
> 
> This also addreses what appears to be an assingment of niph without
> the value being used - the first assingment.
> 
> E.g., for the ipv4 case (compile tested only!):

Please, submit a formal patch, I'm not so familiar with the guts of networking
core to be able to produce anything better than I already did.

Consider this as
Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Thank you!

-- 
With Best Regards,
Andy Shevchenko


