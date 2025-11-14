Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7D02F5302;
	Fri, 14 Nov 2025 06:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763102825; cv=none; b=ubCr8I23C3CB82rIje4jRxXk//DmoqsnXiQd2Jpy7gpPQDJv47Fka15+/N+McFufpi5ZhjizsOUqPXSHfTch2wUgxbjrCc2PH8Ai32IPl4/iiWSMq2aHwPkGxaXwmV1X6DIWyKnOg28t5mkPsLXgStPFbXGnbctYKv7zx8WhRB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763102825; c=relaxed/simple;
	bh=2bNbiyJhl4Jc1gvwo/vbBa9cW/SBjZcz3GWngZobUEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TKSzlppz5NRQH2dzcmGRpdSOj5gYAze+krqsWlOJK2uUnsvQY3ivipWOwZMpuBPJ93z3aifpfZFR/bZjlSYJdQOFZ9iTlX7TahtgpVrirncZw0V09oA87EzanrwVT3w21cNtySoxX3i+LQxOr8K84N2cfbAZBKhEHmL/zssMmoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D9STe0pf; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D9STe0pf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763102823; x=1794638823;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2bNbiyJhl4Jc1gvwo/vbBa9cW/SBjZcz3GWngZobUEk=;
  b=D9STe0pfJOS5lh4Jrb8+4j/hZkJaF+QtE4sqk8FLm61l6JnISutt6Gxf
   LD7eotlGnEop162v3rY7CFJbbKjpkBqtsAytARmph/nj5AgD7Szu+ESbK
   r9G7UvdYYXBaVcp2YeL2vQZ3XOGfJAjhuSOlOF//b05JwJ3mAyTN4tSXn
   wnW9tMPVoVECtIVh2KqiCK66T8FFNVCNItUbY1A6imKBji972BoB/xDwS
   4viocuN02DE2/k4UMf1ylkkkVBT0Nwu28dqpB9VaFZzkjOX20K17Pqm+G
   jPH97ntUpcuJyXZeHk+Fu0NBbLLozk6md4ALgHC7GA9i5LFvEp0i5q3Vk
   g==;
X-CSE-ConnectionGUID: 4LRLhBpVRMuNxhn3Qi3bvw==
X-CSE-MsgGUID: 2KE43yb/Q/2CWfgb9NTGXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="65227561"
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="65227561"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 22:47:02 -0800
X-CSE-ConnectionGUID: 2RAAAqvFS2mMjPWuGEXJrQ==
X-CSE-MsgGUID: k1ttSeOaQ92CmvdI2uisCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="193824044"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 13 Nov 2025 22:47:00 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJnaD-0006F7-0W;
	Fri, 14 Nov 2025 06:46:57 +0000
Date: Fri, 14 Nov 2025 14:46:02 +0800
From: kernel test robot <lkp@intel.com>
To: Ricardo Robaina <rrobaina@redhat.com>, audit@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: oe-kbuild-all@lists.linux.dev, paul@paul-moore.com, eparis@redhat.com,
	fw@strlen.de, pablo@netfilter.org, kadlec@netfilter.org,
	Ricardo Robaina <rrobaina@redhat.com>
Subject: Re: [PATCH v6 1/2] audit: add audit_log_nf_skb helper function
Message-ID: <202511141108.IPL3PRtd-lkp@intel.com>
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
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20251114/202511141108.IPL3PRtd-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511141108.IPL3PRtd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511141108.IPL3PRtd-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/netfilter/nft_log.c: In function 'nft_log_eval_audit':
>> net/netfilter/nft_log.c:33:13: warning: unused variable 'fam' [-Wunused-variable]
      33 |         int fam = -1;
         |             ^~~


vim +/fam +33 net/netfilter/nft_log.c

96518518cc417bb Patrick McHardy 2013-10-14  28  
1a893b44de45288 Phil Sutter     2018-05-30  29  static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
1a893b44de45288 Phil Sutter     2018-05-30  30  {
1a893b44de45288 Phil Sutter     2018-05-30  31  	struct sk_buff *skb = pkt->skb;
1a893b44de45288 Phil Sutter     2018-05-30  32  	struct audit_buffer *ab;
1a893b44de45288 Phil Sutter     2018-05-30 @33  	int fam = -1;
1a893b44de45288 Phil Sutter     2018-05-30  34  
1a893b44de45288 Phil Sutter     2018-05-30  35  	if (!audit_enabled)
1a893b44de45288 Phil Sutter     2018-05-30  36  		return;
1a893b44de45288 Phil Sutter     2018-05-30  37  
1a893b44de45288 Phil Sutter     2018-05-30  38  	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
1a893b44de45288 Phil Sutter     2018-05-30  39  	if (!ab)
1a893b44de45288 Phil Sutter     2018-05-30  40  		return;
1a893b44de45288 Phil Sutter     2018-05-30  41  
1a893b44de45288 Phil Sutter     2018-05-30  42  	audit_log_format(ab, "mark=%#x", skb->mark);
1a893b44de45288 Phil Sutter     2018-05-30  43  
832662a8b1d3d70 Ricardo Robaina 2025-11-13  44  	audit_log_nf_skb(ab, skb, nft_pf(pkt));
1a893b44de45288 Phil Sutter     2018-05-30  45  
1a893b44de45288 Phil Sutter     2018-05-30  46  	audit_log_end(ab);
1a893b44de45288 Phil Sutter     2018-05-30  47  }
1a893b44de45288 Phil Sutter     2018-05-30  48  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
