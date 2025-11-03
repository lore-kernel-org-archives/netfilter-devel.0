Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7742F1F1537;
	Mon,  3 Nov 2025 07:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762155184; cv=none; b=eGcM06iY18EZoZbpgQdzQZEmYS1oh/H45OSUg72WSinCQ6zwT9ruQdgOonNvr/dJd5A/c0wLSBJ6ByctnXYgKvnyy1gE6Un7aaG7u/h0y/tuz0FZXWdz3GLwpm/5dQkqLR9sRPkG0kxBN9QG8nVdYN5B0NWDuujIGoaBfM5Kpz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762155184; c=relaxed/simple;
	bh=l5HUEGJQ2l2mq+aTaDpihogl26Os1llfVLM76lsWO6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oDs3U1hak9QktKbxGddfHm7WUGeisAR1CbVWIJrVSvrGI2urNeJ+yEfzJckwcSjb4T9Y7w+rNp8hDX+4M3W2q5nf03W6Yai61Kd0jLrRt1ajDkdWdmwpwIeOJqewgTIEJ+FR130EEZmy6IVkFbRkIv7YrgqMfaUY+iYUvZ8IsOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=INodRjqq; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="INodRjqq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762155182; x=1793691182;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=l5HUEGJQ2l2mq+aTaDpihogl26Os1llfVLM76lsWO6s=;
  b=INodRjqq5g3YH1pVowBMEmyFoN9djrtk5imAnSs1gIqA4OXa7BBbkZF1
   ktinLYAR4Kq8m80pYRKQxElXUsdx0m4RrF8vMkDYjs5hAU2XXsQ0+WLSH
   s53U8k4jI+oixFOUJ4QuTX7ODX1KFm5EUePzY8Q5HqDCADY1btVGgb4hu
   oP6az3HMZ8dA0a80mRuXSFFG4u+RwH98Pr/fQA+9xU44Vz4tjNiAiDG1t
   LAXszUyG5fTcpi3DTVsTX8Zb1l3GjAwRcWJhN8MFLL27GlkYwlpRCTYhA
   3bVH7tHhYNS4xxM3zefh0lh85209qudigompNNpoW8v31ZzE7BangRTtl
   w==;
X-CSE-ConnectionGUID: k3b+NNwrThqQv0R3yCJkXQ==
X-CSE-MsgGUID: 6NTQKs5QSkmdUleSHu29EQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11601"; a="64112034"
X-IronPort-AV: E=Sophos;i="6.19,275,1754982000"; 
   d="scan'208";a="64112034"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2025 23:33:02 -0800
X-CSE-ConnectionGUID: wbZmldb1TQKn1RfPq/DltQ==
X-CSE-MsgGUID: bxAVY6aMRQWiQcpRMmV5Aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,275,1754982000"; 
   d="scan'208";a="187250918"
Received: from smoehrl-linux.amr.corp.intel.com (HELO ashevche-desk.local) ([10.124.220.216])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2025 23:32:57 -0800
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1vFp3a-000000054ie-2nUE;
	Mon, 03 Nov 2025 09:32:50 +0200
Date: Mon, 3 Nov 2025 09:32:49 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Raag Jadav <raag.jadav@intel.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net-next v1 1/1] treewide: Rename ERR_PTR_PCPU() -->
 PCPU_ERR_PTR()
Message-ID: <aQhaobur-9j6ye0m@smile.fi.intel.com>
References: <20251030083632.3315128-1-andriy.shevchenko@linux.intel.com>
 <20251031164958.29f75595@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031164958.29f75595@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Fri, Oct 31, 2025 at 04:49:58PM -0700, Jakub Kicinski wrote:
> On Thu, 30 Oct 2025 09:35:53 +0100 Andy Shevchenko wrote:
> > Make the namespace of specific ERR_PTR() macro leading the thing.
> > This is already done for IOMEM_ERR_PTR(). Follow the same pattern
> > in PCPU_ERR_PTR().
> 
> TBH I find the current naming to be typical. _PCPU() is the "flavor" of
> the API. Same as we usually append _rcu() to functions which expect
> to operate under RCU. All error pointer helpers end with _PCPU().

Ah, there is also IS_ERR_PCPU()...

> I don't feel strongly so fine if anyone else wants to apply this.
> But I will not :)

OK.

-- 
With Best Regards,
Andy Shevchenko


