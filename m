Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DE21850A4;
	Tue, 10 Sep 2024 08:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725957440; cv=none; b=G6AxReHJyts1jeivjMQtwPPFXLME5I8DPb6RcmwUqHQ6snlj0HI5fKpeSebSVS+hwm8OhTRArRmEOqh1HuIEc2pf7XwilI0D1vbbg+6UvjevFf/6UO+OqZiGfFuqF1lhoX6Y2TZAfxBkd7RQGp7dbRUT0j/YEq7NSff17wSfS7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725957440; c=relaxed/simple;
	bh=U4vZj52NB5milRFEpws1fUA4U+pVdLmHLqJ+9K91t3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Em4246Llk06YBo1Fed25QKojWFwU3YD3NlsYx3C6l6j2nkJdW1K+/O9KlZHWRKP2agf9ugO21PnsfHG7pBVZttjQRtKGLzbT33Db+SQnrKUrwcnvbxja3c9wwyUl/pilDfokFgjRZwL1YK4oFA1HWkXvvAXbb8f4nC8TraAJf6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NhEO7W3l; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NhEO7W3l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725957439; x=1757493439;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U4vZj52NB5milRFEpws1fUA4U+pVdLmHLqJ+9K91t3g=;
  b=NhEO7W3lfRLKuxgdoz8Lo6nR17S8nXqrkoBRnNlYnahcosjvGKWSw6pl
   nJ5dQHt99yQ4yVEIlgLddPY8Tw+N8DEBSTPPx4iGxXruQuaWursWi+eyY
   C/WS1FbAeUsjzRjLVhRiIoCjWVapkG1FAgsTt9qnIAeAMUEeuf8GALbWP
   PlUs9lq8yXJunZx2t1fMlcoyLKutLr21TUzzPeMliOb+qmcIYT9JlzWPz
   orTaaet3N7dPZQwfQe0C+BgbcaT36cKRPxofebMo5AmjKErfKPhqpUNTl
   15+Q6N8cRS45nSCDbgiM90abZ9OKhglveXmtZZSa/vevklmgpkMOlnawB
   A==;
X-CSE-ConnectionGUID: 72/EcU9LTDiv5KVlZsicfg==
X-CSE-MsgGUID: 9CXDgI/RQZqjGYY4aEi+1Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="35356057"
X-IronPort-AV: E=Sophos;i="6.10,216,1719903600"; 
   d="scan'208";a="35356057"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 01:37:18 -0700
X-CSE-ConnectionGUID: a3i8FuqTQoiuFh6tZkXP7Q==
X-CSE-MsgGUID: dogKNTkMT/Cix+OM0R7PdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,216,1719903600"; 
   d="scan'208";a="67487165"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 01:37:14 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1snwN5-000000077pF-0obo;
	Tue, 10 Sep 2024 11:37:11 +0300
Date: Tue, 10 Sep 2024 11:37:10 +0300
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
Subject: Re: [PATCH net-next v2 1/1] netfilter: conntrack: Guard possible
 unused functions
Message-ID: <ZuAFNv5zjkR-J-Kv@smile.fi.intel.com>
References: <20240909154043.1381269-2-andriy.shevchenko@linux.intel.com>
 <20240909183546.GF2097826@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909183546.GF2097826@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Mon, Sep 09, 2024 at 07:35:46PM +0100, Simon Horman wrote:
> On Mon, Sep 09, 2024 at 06:39:56PM +0300, Andy Shevchenko wrote:

...

> > Fix this by guarding possible unused functions with ifdeffery.
> 
> I think it would be worth mentioning, that
> the condition is that neither CONFIG_NETFILTER_NETLINK_GLUE_CT
> nor CONFIG_NF_CONNTRACK_EVENTS are defined (enabled).

Done in v3.

-- 
With Best Regards,
Andy Shevchenko


