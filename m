Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A31A1B2EE0;
	Mon,  9 Sep 2024 09:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725874878; cv=none; b=XId6mvmb6e7S4vnfEuw6R2ohWciBXRXBf7fB8hrOE8E5lXbx/Y24zkkvlrMTIdEUtDompL46m62J7zBhiaShQtCL3KrkYHr4p8u0W+zt+7fX9Dk/2u00vanfs65L+1/HhDK2dVEunUZY5zynYwPSOG6ekcv9yD8yourVG4tiVp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725874878; c=relaxed/simple;
	bh=wETrHI/ShVWGV8wbgbyd9KGjFPNCXcYObn24PM2bGgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OVnLkQhmiL1gkLQJYS7LnPTr3kbrhb+mPftMaFDaREcoaktzIbqFKFwlVZhGP7hrP7nEZBve164O8rGymyp+0FhMZ+ip5fN/wnonVBO4v4rXmXK+iEufz+7hbEtJfZsUmbgx3nULLa05W6yemy04h1ztVeySHdnf6yJnr/d2JgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oA8r1wRg; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oA8r1wRg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725874878; x=1757410878;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wETrHI/ShVWGV8wbgbyd9KGjFPNCXcYObn24PM2bGgg=;
  b=oA8r1wRg5BCZXG/tzb0k8aCCYQxss2NQp0slEKujuBpQSpTHWBEy1vTB
   7bzKTFiycTG0+2U8MiNMcvvwczv33yTF44DF0qP+MrUCKrpX6lU+A2WnW
   sc3kShKleZXcNUJrYwYbSz7YHrCfprJ5S1/gc0fgPYPcajkzRzzSghymc
   0MAxjR7yaNnfEEF3/zdBDpb79HPydhDK1VZBKz347w8PtKulveaUfHOVr
   jRxBB6fLMcN781RWYpWCl0xPgUzHuGa4Y5K6wdV1tCGMlIwdUDQDKAa+c
   oQEyrHKQpLVw5EkLVJA0wxoaHrwpPd9qC3Yn9STtIp07sY9kbWCXxGu40
   Q==;
X-CSE-ConnectionGUID: KzyqZQ/2SQaLMw7zAtyFnQ==
X-CSE-MsgGUID: aCQWLV4YRq6rUlS8fxOuug==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="35941201"
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="35941201"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 02:38:11 -0700
X-CSE-ConnectionGUID: wLrI8P59Scq60Xkr/AfP+A==
X-CSE-MsgGUID: FnGgWOHURWm9lCW+zHCTiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="71021034"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 02:37:54 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1snaqF-00000006jjo-21LH;
	Mon, 09 Sep 2024 12:37:51 +0300
Date: Mon, 9 Sep 2024 12:37:51 +0300
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
Message-ID: <Zt7B79Q3O7mNqrOl@smile.fi.intel.com>
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

> Local testing seems to show that the warning is still emitted
> for ctnetlink_label_size if CONFIG_NETFILTER_NETLINK_GLUE_CT is enabled
> but CONFIG_NF_CONNTRACK_EVENTS is not.

Can you elaborate on this, please?
I can not reproduce.

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_EGRESS=y
CONFIG_NETFILTER_SKIP_EGRESS=y
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_LOG_SYSLOG=m
CONFIG_NF_CONNTRACK_SECMARK=y
# CONFIG_NF_CONNTRACK_PROCFS is not set
# CONFIG_NF_CONNTRACK_LABELS is not set
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_IRC=y
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_NETLINK_GLUE_CT=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_FTP=y
CONFIG_NF_NAT_IRC=y
CONFIG_NF_NAT_SIP=y
CONFIG_NF_NAT_MASQUERADE=y
# CONFIG_NF_TABLES is not set
CONFIG_NETFILTER_XTABLES=y
# CONFIG_NETFILTER_XTABLES_COMPAT is not set



-- 
With Best Regards,
Andy Shevchenko


