Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A4182488;
	Sat,  4 Jan 2025 04:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735966325; cv=none; b=u3lqdmBN1xnjYeM4Tv3A1ZEqo+XCG6nEWeRxv/TjqrFR1mfKOi4PCP8XjU07S+GSJ+e/53XfhJUK8RdAobwS0BdhhSZurJSHGfddPW/CH5zvrg/OjAgre6OOQMj8Eo2KZpUGLIUPguaVe1/oCVd1TO5wSM5wnRaF5+OiuhS/UeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735966325; c=relaxed/simple;
	bh=XtPmeWVkebOoMdkHg3hOLrL0p5OFrWmqRjAi0s+IH2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MH9YWuDuCoCCexmXFPgqBiwwZPp+llDRXaCiJeqf/ahx/k+u5UPMH7i+h9+mNi83IipkG5niCJVB4gc/JLO0zCt/J7IHeb9ODYr8DWqeYECePUOZFAosarHBaQOs9tfY7C9aymSJe1N9q60W9MArHJpjBs6uHuJctrUltT2/WrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J1n1fXfh; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J1n1fXfh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735966323; x=1767502323;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XtPmeWVkebOoMdkHg3hOLrL0p5OFrWmqRjAi0s+IH2A=;
  b=J1n1fXfhJHigBZaGGRr0zHSB4Iopm8nHX3irBAa8hb3n1GKLzGl8fCWz
   qx9zQUy6iU8VMhNeq1xh02Gi35bu/tXZC8L3ZNVCys4yVOeW7B0I/K0Ao
   dx2/mUZUyNua04DV1beCf1QyWl9Hmy509h3Zkw2VrGmgcHZTPFcj0ZBdU
   pvloOB5MN8Dxc3Ogm+qOBNZsj6nmc7fqCBgo/ihnK5kqU73W9zRXXlEbF
   d+N84uf/twHbk3/kf4wIZa9OVpy8KlRLpF/wL839cqJsaVPLKIIlHrP5/
   Q4RvBaztirvL6AkQuaT60sV696BGyce7bSGCaJmYGxF6/n6/tmGR4ONbZ
   Q==;
X-CSE-ConnectionGUID: mrSAz270RXST2K2qF8xWAw==
X-CSE-MsgGUID: s0hCtHb8Qg+weP94cMOjxA==
X-IronPort-AV: E=McAfee;i="6700,10204,11304"; a="46701212"
X-IronPort-AV: E=Sophos;i="6.12,288,1728975600"; 
   d="scan'208";a="46701212"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2025 20:52:03 -0800
X-CSE-ConnectionGUID: Ra75Vt6/RB+Ueyz3adysHw==
X-CSE-MsgGUID: fs6xALnoT7elwTJ3yN+1YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="102446466"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 03 Jan 2025 20:51:58 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tTw8h-000AcV-2u;
	Sat, 04 Jan 2025 04:51:55 +0000
Date: Sat, 4 Jan 2025 12:51:48 +0800
From: kernel test robot <lkp@intel.com>
To: egyszeregy@freemail.hu, fw@strlen.de, pablo@netfilter.org,
	lorenzo@kernel.org, daniel@iogearbox.net, leitao@debian.org,
	amiculas@cisco.com, kadlec@netfilter.org, davem@davemloft.net,
	dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, jengelh@medozas.de,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Paul Gazzillo <paul@pgazz.com>,
	Necip Fazil Yildiran <fazilyildiran@gmail.com>,
	oe-kbuild-all@lists.linux.dev,
	Benjamin =?utf-8?B?U3rFkWtl?= <egyszeregy@freemail.hu>
Subject: Re: [PATCH v3] netfilter: x_tables: Merge xt_*.c source files which
 has same name.
Message-ID: <202501041223.aaw6sh0q-lkp@intel.com>
References: <20250103140158.69041-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250103140158.69041-1-egyszeregy@freemail.hu>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on netfilter-nf/main]
[also build test WARNING on linus/master v6.13-rc5 next-20241220]
[cannot apply to nf-next/master horms-ipvs/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/egyszeregy-freemail-hu/netfilter-x_tables-Merge-xt_-c-source-files-which-has-same-name/20250103-221402
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20250103140158.69041-1-egyszeregy%40freemail.hu
patch subject: [PATCH v3] netfilter: x_tables: Merge xt_*.c source files which has same name.
config: nios2-kismet-CONFIG_NETFILTER_XT_DSCP-CONFIG_NETFILTER_XT_MATCH_DSCP-0-0 (https://download.01.org/0day-ci/archive/20250104/202501041223.aaw6sh0q-lkp@intel.com/config)
reproduce: (https://download.01.org/0day-ci/archive/20250104/202501041223.aaw6sh0q-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501041223.aaw6sh0q-lkp@intel.com/

kismet warnings: (new ones prefixed by >>)
>> kismet: WARNING: unmet direct dependencies detected for NETFILTER_XT_DSCP when selected by NETFILTER_XT_MATCH_DSCP
   WARNING: unmet direct dependencies detected for NETFILTER_XT_HL
     Depends on [n]: NET [=y] && INET [=y] && NETFILTER [=y] && NETFILTER_XTABLES [=y] && (IP_NF_MANGLE [=n] || IP6_NF_MANGLE [=n] || NFT_COMPAT [=n]) && NETFILTER_ADVANCED [=y]
     Selected by [y]:
     - NETFILTER_XT_MATCH_HL [=y] && NET [=y] && INET [=y] && NETFILTER [=y] && NETFILTER_XTABLES [=y] && NETFILTER_ADVANCED [=y]
   
   WARNING: unmet direct dependencies detected for NETFILTER_XT_DSCP
     Depends on [n]: NET [=y] && INET [=y] && NETFILTER [=y] && NETFILTER_XTABLES [=y] && (IP_NF_MANGLE [=n] || IP6_NF_MANGLE [=n] || NFT_COMPAT [=n]) && NETFILTER_ADVANCED [=y]
     Selected by [y]:
     - NETFILTER_XT_MATCH_DSCP [=y] && NET [=y] && INET [=y] && NETFILTER [=y] && NETFILTER_XTABLES [=y] && NETFILTER_ADVANCED [=y]

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
