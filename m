Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C876976026;
	Wed,  1 Jan 2025 22:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735770688; cv=none; b=ik9qZaFTWWa8Q8r/ZQ1cMC+PXoWIePUBRmv5edZKP+Pnq+gg/UA3t8XIAhdznu+I+Ic845Ja+UXAFNFWjuKwrIa3EIC9upn8wa88g97o3hhwGSk5gPIGNKaxhnOeX7wJ/7lR9boGtqmuxJBGLe5nVsnPiyC+8LK0YSKTPDGNZ/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735770688; c=relaxed/simple;
	bh=Xg8m+5IFZ8iFR3tGiL/aONoxjuQK0q98LycsYSpPaTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=slji1DuoAN+7YbRErqAl5KS1IKef8vJI/z9xofe5EaR+oKBa3Dj+5366V4L9dotGCPXbBqG+4N2p4Vj6ydsl9Kh5sI/5kRRhlyKeU+/mQASZofuJBcHJ8b67lpG8PSUsZsBVpE0JQlPVTnJ0wq+eNDleBu4NA4yqBM7MepHZz0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ae71RNuG; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ae71RNuG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735770687; x=1767306687;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Xg8m+5IFZ8iFR3tGiL/aONoxjuQK0q98LycsYSpPaTU=;
  b=ae71RNuGCrrc9rrXcn3z5eIKFgfLSQbT8uawDSKnBkW+KQ2cvYIXpM7Z
   F2tRzhKjrkKlIFtdJAqDyZZpgljhJTEptz8vSmy/Fnlle0jF//wN3WVC6
   XV6CrglqD9+7/DAftWabfcyY1x1T60OLIQlvMy9KJ9EjQYCNxa8vEBHgV
   NJd9Eq6LnSrFTbpQiBxMb/pgsVE0tij1wPKm7cZKBsx9x9+5Tmch85iLV
   /WzeIPVeJ/DoOUbOrTv3VfXVJRuBNMhQPrfMIhV1tGt2spUe0BRblvMHQ
   4h33Mf53DT6yG5nfn0Rx8QttAeWt9OctSAxCeDPKVuK1fVMpq6O2O+At8
   Q==;
X-CSE-ConnectionGUID: oQ4HYGR/RoulKsGVVtiiWw==
X-CSE-MsgGUID: 3s3pM2A5Saap11A+leJwkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11302"; a="23596944"
X-IronPort-AV: E=Sophos;i="6.12,283,1728975600"; 
   d="scan'208";a="23596944"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jan 2025 14:31:24 -0800
X-CSE-ConnectionGUID: BG02LjkXTtW+gn4U0t2LQA==
X-CSE-MsgGUID: fkYgbpHPSQeYfJO17KE1lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,283,1728975600"; 
   d="scan'208";a="101110087"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 01 Jan 2025 14:31:20 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tT7FG-00087J-1h;
	Wed, 01 Jan 2025 22:31:18 +0000
Date: Thu, 2 Jan 2025 06:30:33 +0800
From: kernel test robot <lkp@intel.com>
To: egyszeregy@freemail.hu, fw@strlen.de, pablo@netfilter.org,
	lorenzo@kernel.org, daniel@iogearbox.net, leitao@debian.org,
	amiculas@cisco.com, kadlec@netfilter.org, davem@davemloft.net,
	dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Benjamin =?utf-8?B?U3rFkWtl?= <egyszeregy@freemail.hu>
Subject: Re: [PATCH] netfilter: uapi: Merge xt_*.h/c and ipt_*.h which has
 same name.
Message-ID: <202501020613.zfPO1hvh-lkp@intel.com>
References: <20250101192015.1577-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250101192015.1577-1-egyszeregy@freemail.hu>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]
[also build test ERROR on linus/master v6.13-rc5 next-20241220]
[cannot apply to nf-next/master horms-ipvs/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/egyszeregy-freemail-hu/netfilter-uapi-Merge-xt_-h-c-and-ipt_-h-which-has-same-name/20250102-032847
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20250101192015.1577-1-egyszeregy%40freemail.hu
patch subject: [PATCH] netfilter: uapi: Merge xt_*.h/c and ipt_*.h which has same name.
config: arm64-randconfig-001-20250102 (https://download.01.org/0day-ci/archive/20250102/202501020613.zfPO1hvh-lkp@intel.com/config)
compiler: clang version 20.0.0git (https://github.com/llvm/llvm-project ed572f2003275da8e06a634b4d6658b7921e8334)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250102/202501020613.zfPO1hvh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501020613.zfPO1hvh-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from net/ipv4/netfilter/ipt_ECN.c:9:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:8:
   In file included from include/linux/cacheflush.h:5:
   In file included from arch/arm64/include/asm/cacheflush.h:11:
   In file included from include/linux/kgdb.h:19:
   In file included from include/linux/kprobes.h:28:
   In file included from include/linux/ftrace.h:13:
   In file included from include/linux/kallsyms.h:13:
   In file included from include/linux/mm.h:2223:
   include/linux/vmstat.h:504:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     504 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     505 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:511:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     511 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     512 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:524:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     524 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     525 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   In file included from net/ipv4/netfilter/ipt_ECN.c:17:
>> include/uapi/linux/netfilter_ipv4/ipt_ecn.h:19:2: error: expected identifier
      19 |         IPT_ECN_IP_MASK       = XT_ECN_IP_MASK,
         |         ^
   include/uapi/linux/netfilter_ipv4/ipt_ecn.h:11:25: note: expanded from macro 'IPT_ECN_IP_MASK'
      11 | #define IPT_ECN_IP_MASK (~XT_DSCP_MASK)
         |                         ^
   4 warnings and 1 error generated.


vim +19 include/uapi/linux/netfilter_ipv4/ipt_ecn.h

4b5f2ebf33bae9 include/uapi/linux/netfilter_ipv4/ipt_ecn.h Benjamin Szőke 2025-01-01  17  
a4c6f9d3636db5 include/linux/netfilter_ipv4/ipt_ecn.h      Jan Engelhardt 2011-06-09  18  enum {
a4c6f9d3636db5 include/linux/netfilter_ipv4/ipt_ecn.h      Jan Engelhardt 2011-06-09 @19  	IPT_ECN_IP_MASK       = XT_ECN_IP_MASK,
a4c6f9d3636db5 include/linux/netfilter_ipv4/ipt_ecn.h      Jan Engelhardt 2011-06-09  20  	IPT_ECN_OP_MATCH_IP   = XT_ECN_OP_MATCH_IP,
a4c6f9d3636db5 include/linux/netfilter_ipv4/ipt_ecn.h      Jan Engelhardt 2011-06-09  21  	IPT_ECN_OP_MATCH_ECE  = XT_ECN_OP_MATCH_ECE,
a4c6f9d3636db5 include/linux/netfilter_ipv4/ipt_ecn.h      Jan Engelhardt 2011-06-09  22  	IPT_ECN_OP_MATCH_CWR  = XT_ECN_OP_MATCH_CWR,
a4c6f9d3636db5 include/linux/netfilter_ipv4/ipt_ecn.h      Jan Engelhardt 2011-06-09  23  	IPT_ECN_OP_MATCH_MASK = XT_ECN_OP_MATCH_MASK,
a4c6f9d3636db5 include/linux/netfilter_ipv4/ipt_ecn.h      Jan Engelhardt 2011-06-09  24  };
a4c6f9d3636db5 include/linux/netfilter_ipv4/ipt_ecn.h      Jan Engelhardt 2011-06-09  25  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
