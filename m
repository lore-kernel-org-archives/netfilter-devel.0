Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D035D2F5A36;
	Fri, 14 Nov 2025 06:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763102888; cv=none; b=fvocqd9EiNd/4EFkp5hmNTmttcEahLIqfdpAK9LarAHor9pQ5xc6naAP2ieHwQF82vqi5KLxTpsWKPxVzdv1Cjn1F7LpfZ3R4S5J2M2wApaOUaC4dN3Ksz5y5xbfwSu6PZBfgxEkk++xWjrGYk9qQrqyvztfHoJCfwagHBbQ4QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763102888; c=relaxed/simple;
	bh=BhIDIUAnNaEog0l6zLoPRo7Yj7mwoi5bVNdb7P/KQB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QkW3splDiUutZ/IqJh5VLwB35ar39pqUNWfMj9OrdF56CRvrYHTz+g9PnDA0A8u9Wu3oD5SO1TsDRkXkj9sEvcR7bYz4Sw1HYTtl9MWsH8LdOXZJvmec9MI17HifpQFu8aVZqfZL2dtL2huvBIIl/TR7T67antqaNJ70UU8Uh98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AHHcdGK5; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AHHcdGK5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763102887; x=1794638887;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BhIDIUAnNaEog0l6zLoPRo7Yj7mwoi5bVNdb7P/KQB0=;
  b=AHHcdGK5p//8NI8mz+IgpA8EGqDwj0iFmTBYQW9ARfAsKKDVNMNPXVgN
   oWlQdbzSvyshlaA4ubKZsQEVxFW5BXHjZAaDdNliOu8rbAwI+yC4BVhBU
   onAqMWtKOwpkFIqnfh/g3bvMkME9qxVfZKIPsqXTNHa4Efb58HJFCfCrU
   FwFUPdrMsNChPAzCBGzdSMmTvF9ALiRhQXjDkPw62HHw7W+MTT/HFESgs
   vmySxuTVdDd00vdgAekclw4oYBGyAr67UhKj9a8thTYEM636W/OxvrdbO
   maiu9943go8Vcn9J/xWPKE1qgM8rOnj405tLi3ykPrv/PS/0ed5TxMt4T
   Q==;
X-CSE-ConnectionGUID: X9DK7cZzSGyUCbUUvmvAYg==
X-CSE-MsgGUID: NTVB7La+T5CDh7c/9TtL5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65132787"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65132787"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 22:48:03 -0800
X-CSE-ConnectionGUID: c9DIy3vdSm6LUswGiO86zA==
X-CSE-MsgGUID: YgjCGt55R3y7O/nwK7dj2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="189554982"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 13 Nov 2025 22:47:59 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJnbB-0006Fn-1G;
	Fri, 14 Nov 2025 06:47:57 +0000
Date: Fri, 14 Nov 2025 14:47:38 +0800
From: kernel test robot <lkp@intel.com>
To: Ricardo Robaina <rrobaina@redhat.com>, audit@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: oe-kbuild-all@lists.linux.dev, paul@paul-moore.com, eparis@redhat.com,
	fw@strlen.de, pablo@netfilter.org, kadlec@netfilter.org,
	Ricardo Robaina <rrobaina@redhat.com>
Subject: Re: [PATCH v6 1/2] audit: add audit_log_nf_skb helper function
Message-ID: <202511141355.QCbxBTw0-lkp@intel.com>
References: <589b485078a65c766bcdee2fd9881c540813f8c5.1763036807.git.rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <589b485078a65c766bcdee2fd9881c540813f8c5.1763036807.git.rrobaina@redhat.com>

Hi Ricardo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on pcmoore-audit/next]
[also build test WARNING on netfilter-nf/main nf-next/master linus/master v6.18-rc5 next-20251113]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ricardo-Robaina/audit-include-source-and-destination-ports-to-NETFILTER_PKT/20251113-223721
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/audit.git next
patch link:    https://lore.kernel.org/r/589b485078a65c766bcdee2fd9881c540813f8c5.1763036807.git.rrobaina%40redhat.com
patch subject: [PATCH v6 1/2] audit: add audit_log_nf_skb helper function
config: arm-randconfig-002-20251114 (https://download.01.org/0day-ci/archive/20251114/202511141355.QCbxBTw0-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 14.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511141355.QCbxBTw0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511141355.QCbxBTw0-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/netfilter/xt_AUDIT.c: In function 'audit_tg':
>> net/netfilter/xt_AUDIT.c:35:13: warning: unused variable 'fam' [-Wunused-variable]
      35 |         int fam = -1;
         |             ^~~


vim +/fam +35 net/netfilter/xt_AUDIT.c

43f393caec0362a Thomas Graf        2011-01-16  30  
43f393caec0362a Thomas Graf        2011-01-16  31  static unsigned int
43f393caec0362a Thomas Graf        2011-01-16  32  audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
43f393caec0362a Thomas Graf        2011-01-16  33  {
43f393caec0362a Thomas Graf        2011-01-16  34  	struct audit_buffer *ab;
2173c519d5e912a Richard Guy Briggs 2017-05-02 @35  	int fam = -1;
43f393caec0362a Thomas Graf        2011-01-16  36  
f7859590d976148 Richard Guy Briggs 2018-06-05  37  	if (audit_enabled == AUDIT_OFF)
ed018fa4dfc3d26 Gao feng           2013-03-04  38  		goto errout;
43f393caec0362a Thomas Graf        2011-01-16  39  	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
43f393caec0362a Thomas Graf        2011-01-16  40  	if (ab == NULL)
43f393caec0362a Thomas Graf        2011-01-16  41  		goto errout;
43f393caec0362a Thomas Graf        2011-01-16  42  
43f393caec0362a Thomas Graf        2011-01-16  43  	audit_log_format(ab, "mark=%#x", skb->mark);
43f393caec0362a Thomas Graf        2011-01-16  44  
832662a8b1d3d70 Ricardo Robaina    2025-11-13  45  	audit_log_nf_skb(ab, skb, xt_family(par));
131ad62d8fc06d9 Mr Dash Four       2011-06-30  46  
43f393caec0362a Thomas Graf        2011-01-16  47  	audit_log_end(ab);
43f393caec0362a Thomas Graf        2011-01-16  48  
43f393caec0362a Thomas Graf        2011-01-16  49  errout:
43f393caec0362a Thomas Graf        2011-01-16  50  	return XT_CONTINUE;
43f393caec0362a Thomas Graf        2011-01-16  51  }
43f393caec0362a Thomas Graf        2011-01-16  52  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
