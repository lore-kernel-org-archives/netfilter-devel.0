Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACCA1531D2;
	Sat,  4 Jan 2025 06:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735972152; cv=none; b=ayTLNT9NSr5JGYi7GkrnZIVuFUhSVliKB+94M68jWfW4yZvB2moXIojaIaMwYzTpI1crMJ0iH0qHaBuZ6BMgRH9y2r8vT1KQPBc6jFY0Ve20ObuEPib5lWQV+a7AAKJi2bZaBIwx1Rdxokc0RcCuZshKz2ZsYbCJhzXy4E3QlPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735972152; c=relaxed/simple;
	bh=AKrpsJA9pjNGHkifNS9e+fzwCwQSmKfocNpN34qppfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aoscgN0/3uaRwZzTTI8OcMavDWLBvUn6tqUH3w8WAEdG50M1etQqiZQiParVUVu4EMS0x0yH6jVo/ClesvkQ7cNExkvpUMKQrLXkwcwDwiNJg6BM6IRvcFENwaq8xQEKcWlJfYwyuN39OCvWoxMX/K/5OLGUTRmWHFs3aNVGkxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H+Dj/1nd; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H+Dj/1nd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735972151; x=1767508151;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AKrpsJA9pjNGHkifNS9e+fzwCwQSmKfocNpN34qppfE=;
  b=H+Dj/1nded/IfMDVJWSzcAzYKH/hBWiz2MlIrgaw2041B8Qtdxe/tn8P
   QpSrAXzCWaZHr6XzOtDefF0+nK4HtHQrjE8cWSIATleserKfEwATS3ui+
   OnsikB8tiOWMXI1hUP7friR8iZrwn24QyKvAM2hKDVvsPU2fBGg9iFCNU
   nDVWcL4m86ECnlpv+ih9ddt4GkVe6rTfZgPE9yTZcyM7IkMPVjYPtIBfO
   Wz9JrAbmkPaEN1Kb+fLIn0raOFEServpnv8mJciR5IssQwT2UwndbzgJx
   8uV54S3XJh3AZgVguzfK2AbN1P/cD2wyNKZHhbjX02XAfMhPOnY8fsETp
   A==;
X-CSE-ConnectionGUID: PnHmMF++Tz2Q5VOrKbXY3w==
X-CSE-MsgGUID: OcL1FhQuSHu6PENqqH4+2Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11304"; a="47191719"
X-IronPort-AV: E=Sophos;i="6.12,288,1728975600"; 
   d="scan'208";a="47191719"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2025 22:29:11 -0800
X-CSE-ConnectionGUID: ZcvnWQFhRxOAm6vtoBM3GA==
X-CSE-MsgGUID: JAVnkUCyTKqYQp1PRMTK8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="132879354"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 03 Jan 2025 22:29:06 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tTxei-000Agl-0z;
	Sat, 04 Jan 2025 06:29:04 +0000
Date: Sat, 4 Jan 2025 14:28:44 +0800
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
Message-ID: <202501041449.OsJd9MHe-lkp@intel.com>
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
config: nios2-kismet-CONFIG_NETFILTER_XT_HL-CONFIG_NETFILTER_XT_MATCH_HL-0-0 (https://download.01.org/0day-ci/archive/20250104/202501041449.OsJd9MHe-lkp@intel.com/config)
reproduce: (https://download.01.org/0day-ci/archive/20250104/202501041449.OsJd9MHe-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501041449.OsJd9MHe-lkp@intel.com/

kismet warnings: (new ones prefixed by >>)
>> kismet: WARNING: unmet direct dependencies detected for NETFILTER_XT_HL when selected by NETFILTER_XT_MATCH_HL
   WARNING: unmet direct dependencies detected for NETFILTER_XT_HL
     Depends on [n]: NET [=y] && INET [=y] && NETFILTER [=y] && NETFILTER_XTABLES [=y] && (IP_NF_MANGLE [=n] || IP6_NF_MANGLE [=n] || NFT_COMPAT [=n]) && NETFILTER_ADVANCED [=y]
     Selected by [y]:
     - NETFILTER_XT_MATCH_HL [=y] && NET [=y] && INET [=y] && NETFILTER [=y] && NETFILTER_XTABLES [=y] && NETFILTER_ADVANCED [=y]

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
