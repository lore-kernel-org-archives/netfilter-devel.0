Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68141629
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Nov 2024 00:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731024642; cv=none; b=V+hkba2iOS8vOGCkVZpJ5iTAkS96W0vEW+thmuvqojwCSZokhztsCivWuc/b7A/N3wjRz2J5J7fe0vMBXx9jngljmYdgIBuaMbUNZ2fRUk397vIMen8LN7YME4AU3b9/CgyXaxXkeK5+UQbNu8MdUGF62RsMB77u6aj8XYsptPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731024642; c=relaxed/simple;
	bh=oz0Kbp4MCkiGsbN1VoVn3BR02sk9JjCagSuI4ET2614=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J7+zttFuuZy+L1quDPAwcxDphED4te8lX0878ugIErKVXgzJSgwkw7471zHmMEygTlIy6va2Oxa6FsILyS5Dz++H522VW1tGMzMgoMHtZs4ytXvrEHcCdNbjY/fRFJa2lXlPXVR9CYY6WxqgQfQwwPoi/1+3nYq4TRVD2WM58GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mHfl09Ei; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mHfl09Ei"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731024640; x=1762560640;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oz0Kbp4MCkiGsbN1VoVn3BR02sk9JjCagSuI4ET2614=;
  b=mHfl09EiaBQ0cm7CF9Mq3wbiW4ZkkQS8+kScCZZpOZ68icWP40lh2TGW
   8T3vHyvxwUFQByaUzrx237iCk1yQYlvyZAqG/vs+PBU4J3Jtl1KoOmOu3
   Jo34jX9Yb5fvlTd53IZ8EZDj7DfQxce/4zz9NDWfMggOug0abTIqim+S1
   1WTx9iaaxd9DNMmFzkXQf2IbGAL4/nzSCxzG5MOUfD8y9MoktgU9z3dFc
   bgmn/GxkcCz+xRATmFC2AEBfmnG3sMEnZx1zp1fghupyOXCEHOTD/6V8c
   T+kuRNwcbnhLO7EHmxnhg/1DCYKduLd1RDh95k5SjHycQYke90U1heURw
   Q==;
X-CSE-ConnectionGUID: 0OiGTjVdS2+EKKlraOADXQ==
X-CSE-MsgGUID: mnM/eRQLTMueB6yqhBNaoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="41495777"
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="41495777"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 16:10:40 -0800
X-CSE-ConnectionGUID: WhoXpdTaRcKQsRRqLX2csg==
X-CSE-MsgGUID: NwmjCmU8TwSHw5tFwINjqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="122799433"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 07 Nov 2024 16:10:38 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t9CaC-000qoG-0Z;
	Fri, 08 Nov 2024 00:10:36 +0000
Date: Fri, 8 Nov 2024 08:09:41 +0800
From: kernel test robot <lkp@intel.com>
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Florian Westphal <fw@strlen.de>,
	Nadia Pinaeva <n.m.pinaeva@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add conntrack event
 timestamp
Message-ID: <202411080731.bDRRTgah-lkp@intel.com>
References: <20241107194117.32116-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107194117.32116-1-fw@strlen.de>

Hi Florian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on netfilter-nf/main]
[also build test WARNING on linus/master v6.12-rc6 next-20241107]
[cannot apply to nf-next/master horms-ipvs/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/netfilter-conntrack-add-conntrack-event-timestamp/20241108-034444
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20241107194117.32116-1-fw%40strlen.de
patch subject: [PATCH nf-next] netfilter: conntrack: add conntrack event timestamp
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20241108/202411080731.bDRRTgah-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241108/202411080731.bDRRTgah-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411080731.bDRRTgah-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/netfilter/nf_conntrack_netlink.c:386:1: warning: 'ctnetlink_dump_event_timestamp' defined but not used [-Wunused-function]
     386 | ctnetlink_dump_event_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/ctnetlink_dump_event_timestamp +386 net/netfilter/nf_conntrack_netlink.c

   384	
   385	static int
 > 386	ctnetlink_dump_event_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
   387	{
   388	#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
   389		const struct nf_conntrack_ecache *e = nf_ct_ecache_find(ct);
   390	
   391		if (e) {
   392			u64 ts = local64_read(&e->timestamp);
   393	
   394			if (ts)
   395				return nla_put_be64(skb, CTA_TIMESTAMP_EVENT,
   396						    cpu_to_be64(ts), CTA_TIMESTAMP_PAD);
   397		}
   398	#endif
   399		return 0;
   400	}
   401	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
