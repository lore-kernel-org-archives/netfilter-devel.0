Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222EC19047A;
	Sat,  1 Nov 2025 13:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762002859; cv=none; b=h4DPDg7Iow2NhxPxM/WzU+Mu1xkbeh7rGqeoLXfkuw1LdDG3Mc23XG8waQ6RwMuz/cbIViqyTmY/6+tkoQHtYbXtWSyzrGhzkvUJRtj0Vc1rfxJvFi2h9R7sXd/1OoMuTIi1i7xQUPrGiAOxx2tsHQCrsow7GGPW3cA/q4ixe38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762002859; c=relaxed/simple;
	bh=ucC1SBjyqXAhBZLxgwerYDBWb772Y9+WJyoKPT5a5qM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ldcYgsvhWs4Sk+wMafe2sdiWGa4+zCohh4NxHlkdT3OAUaOzExl6rk0+T/gsIZy+ixJEa23DhP/odW/9ZNosqK6gaNpGzxutDK1Y8q6bMpHelLNfcJ+cG+BGJAzHoA0T8YYF6kkRqxuqsvCDJSiz2pgg6RqiIVjKPe8iV8WlF0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aJS2B/Hz; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aJS2B/Hz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762002857; x=1793538857;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ucC1SBjyqXAhBZLxgwerYDBWb772Y9+WJyoKPT5a5qM=;
  b=aJS2B/HzHzHZI9hqKWVZiYAw+vquSRVWv+5ZNRHt4zts3ZC2BN/UrqXd
   sfhIWI56WAYEsHjqQm0h8qE6mZHSrLQJXbJ3GfGbwYzlDt/ozwYExYfnY
   62I8xIQlVFrrudNU/VRBTKUQ30STF+UtoMbbtF/JzOeiYoaIiAwp982VP
   cAFwr4Gv9uSf0Kzd7y76LTCEpc/W++Y14VHNSUKlvt1/xhkvpKOis4cfQ
   y6mNArMrGJxCcO3UY+gpAa6v34J7kYtAIyzGTBKxJWH79kI/ofTxemSgY
   sstABj/wcgq9e95ZwPAEY53iZQN7357Edxw0l2dwB37Q9Sk1HPiCzemvP
   Q==;
X-CSE-ConnectionGUID: tXrqGzXuRwqYJrlovlHM4A==
X-CSE-MsgGUID: uYyarzo2RyCRhiE64kXYpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="64176842"
X-IronPort-AV: E=Sophos;i="6.19,272,1754982000"; 
   d="scan'208";a="64176842"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2025 06:14:16 -0700
X-CSE-ConnectionGUID: iLqsQlKqThKyeTHgT5PBRg==
X-CSE-MsgGUID: A4yJHSMuQkKs8h759JW5ZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,272,1754982000"; 
   d="scan'208";a="186144478"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 01 Nov 2025 06:14:14 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vFBQp-000OHo-2a;
	Sat, 01 Nov 2025 13:14:11 +0000
Date: Sat, 1 Nov 2025 21:14:02 +0800
From: kernel test robot <lkp@intel.com>
To: Ricardo Robaina <rrobaina@redhat.com>, audit@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: oe-kbuild-all@lists.linux.dev, paul@paul-moore.com, eparis@redhat.com,
	fw@strlen.de, pablo@netfilter.org, kadlec@netfilter.org,
	Ricardo Robaina <rrobaina@redhat.com>
Subject: Re: [PATCH v4 1/2] audit: add audit_log_packet_ip4 and
 audit_log_packet_ip6 helper functions
Message-ID: <202511012016.TaXzGDDi-lkp@intel.com>
References: <cfafc5247fbfcd2561de16bcff67c1afd5676c9e.1761918165.git.rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfafc5247fbfcd2561de16bcff67c1afd5676c9e.1761918165.git.rrobaina@redhat.com>

Hi Ricardo,

kernel test robot noticed the following build errors:

[auto build test ERROR on pcmoore-audit/next]
[also build test ERROR on netfilter-nf/main nf-next/master linus/master v6.18-rc3 next-20251031]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ricardo-Robaina/audit-add-audit_log_packet_ip4-and-audit_log_packet_ip6-helper-functions/20251031-220605
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/audit.git next
patch link:    https://lore.kernel.org/r/cfafc5247fbfcd2561de16bcff67c1afd5676c9e.1761918165.git.rrobaina%40redhat.com
patch subject: [PATCH v4 1/2] audit: add audit_log_packet_ip4 and audit_log_packet_ip6 helper functions
config: m68k-defconfig (https://download.01.org/0day-ci/archive/20251101/202511012016.TaXzGDDi-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251101/202511012016.TaXzGDDi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511012016.TaXzGDDi-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/netfilter/nft_log.c: In function 'nft_log_eval_audit':
>> net/netfilter/nft_log.c:48:31: error: implicit declaration of function 'audit_log_packet_ip4'; did you mean 'audit_log_capset'? [-Wimplicit-function-declaration]
      48 |                         fam = audit_log_packet_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
         |                               ^~~~~~~~~~~~~~~~~~~~
         |                               audit_log_capset
>> net/netfilter/nft_log.c:51:31: error: implicit declaration of function 'audit_log_packet_ip6'; did you mean 'audit_log_capset'? [-Wimplicit-function-declaration]
      51 |                         fam = audit_log_packet_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
         |                               ^~~~~~~~~~~~~~~~~~~~
         |                               audit_log_capset


vim +48 net/netfilter/nft_log.c

    28	
    29	static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
    30	{
    31		struct sk_buff *skb = pkt->skb;
    32		struct audit_buffer *ab;
    33		int fam = -1;
    34	
    35		if (!audit_enabled)
    36			return;
    37	
    38		ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
    39		if (!ab)
    40			return;
    41	
    42		audit_log_format(ab, "mark=%#x", skb->mark);
    43	
    44		switch (nft_pf(pkt)) {
    45		case NFPROTO_BRIDGE:
    46			switch (eth_hdr(skb)->h_proto) {
    47			case htons(ETH_P_IP):
  > 48				fam = audit_log_packet_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
    49				break;
    50			case htons(ETH_P_IPV6):
  > 51				fam = audit_log_packet_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
    52				break;
    53			}
    54			break;
    55		case NFPROTO_IPV4:
    56			fam = audit_log_packet_ip4(ab, skb) ? NFPROTO_IPV4 : -1;
    57			break;
    58		case NFPROTO_IPV6:
    59			fam = audit_log_packet_ip6(ab, skb) ? NFPROTO_IPV6 : -1;
    60			break;
    61		}
    62	
    63		if (fam == -1)
    64			audit_log_format(ab, " saddr=? daddr=? proto=-1");
    65	
    66		audit_log_end(ab);
    67	}
    68	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
