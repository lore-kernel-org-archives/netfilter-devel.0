Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD853F7865;
	Tue, 26 May 2026 16:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779814016; cv=none; b=YMKxsVQ9mffn23vxTmphoaArxitETKy7jZu0wPEU+ly/6LVGY+28i3phosBz0vpnY47RxkfVvdJTKn3iDbycCanF78+hF2Zow8tUxZhUh/DFstACikSvpf6+AiuzyE9YeMikkWlI1JGW9WHgJZJ3j1PAAU75qO3oI1WJ/TTJgiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779814016; c=relaxed/simple;
	bh=eyExZQ5qOIW5RPYesIfSIwMzdqiF+4kYY3+m5Mx4eCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uAdNK80mIsxcCIaHQX8F+lDSSIddQZL6J8T66R31cAnOgRrt+sC6Ey2QWx1llRAA5WR6liSVzClxT1svu8cx3xQpSYP3/1FDTK7xBvYz9E4wMyO2zazYH/XaRVi1XPWkYfn322GeEkvquAHcl982Ip0f5+X7w/jNaODoys2rbn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G1k9pJfo; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G1k9pJfo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779814007; x=1811350007;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eyExZQ5qOIW5RPYesIfSIwMzdqiF+4kYY3+m5Mx4eCw=;
  b=G1k9pJfoPQ555I3QJP6MDp204LAQin7Vfu7QrHfiVkjPGI4zAQFysVVM
   Gk1B/i5shGhjnfuUAXr84LVsSlu+ZjJ++WXSOehq71HZPzEGNJIRd8qSo
   qK76SqomQpcFAK6xRLbIXyqGLTIam0i3HDKvpBE3q8IS3gQ903uwjpnaH
   mQf30DOfCm7Ps96twPlCe6LsZKhT2FO7yGvsOSPRI9LwEiUVlyNSjfClJ
   rnCB/5WB0CWldqS0yEpqLn9us89C39wtwbZ4HdDWFJleMP7iPv30Cs2j/
   eQH2f/oRWUt/7lxEV1QiufplsNDfvSNHNI54UgV3ZDjHb5oPgPxBqlUwZ
   g==;
X-CSE-ConnectionGUID: zOg1gK0MQCylJWnrcJNJXw==
X-CSE-MsgGUID: zIpjYBTUQe+5RFyPrpzVmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="84259144"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="84259144"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 09:46:40 -0700
X-CSE-ConnectionGUID: UNAdDtUdT/SRr0ZI7k3ocQ==
X-CSE-MsgGUID: a1/CbnR7SmmuIJrUzv2LRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="237805852"
Received: from igk-lkp-server01.igk.intel.com (HELO bdf09bfdbd5f) ([10.211.93.152])
  by fmviesa010.fm.intel.com with ESMTP; 26 May 2026 09:46:36 -0700
Received: from kbuild by bdf09bfdbd5f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wRuvI-00000000CSH-1d07;
	Tue, 26 May 2026 16:46:32 +0000
Date: Tue, 26 May 2026 18:46:16 +0200
From: kernel test robot <lkp@intel.com>
To: Kacper Kokot <kacper.kokot.44@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, stable@vger.kernel.org,
	Kacper Kokot <kacper.kokot.44@gmail.com>
Subject: Re: [PATCH] netfilter: TCPMSS: fix dropped packets when MSS option
 is unaligned
Message-ID: <202605261807.YY0PWuhX-lkp@intel.com>
References: <20260525201116.407338-2-kacper.kokot.44@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525201116.407338-2-kacper.kokot.44@gmail.com>

Hi Kacper,

kernel test robot noticed the following build warnings:

[auto build test WARNING on nf-next/main]
[also build test WARNING on netfilter-nf/main linus/master v6.16-rc1 next-20260526]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kacper-Kokot/netfilter-TCPMSS-fix-dropped-packets-when-MSS-option-is-unaligned/20260526-041308
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git main
patch link:    https://lore.kernel.org/r/20260525201116.407338-2-kacper.kokot.44%40gmail.com
patch subject: [PATCH] netfilter: TCPMSS: fix dropped packets when MSS option is unaligned
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20260526/202605261807.YY0PWuhX-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260526/202605261807.YY0PWuhX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605261807.YY0PWuhX-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/netfilter/xt_TCPMSS.c:140:45: warning: & has lower precedence than !=; != will be evaluated first [-Wparentheses]
     140 |                         if (((char *)&opt[i + 2] - (char *)tcph) & 0x1 != 0) {
         |                                                                  ^~~~~~~~~~
   net/netfilter/xt_TCPMSS.c:140:45: note: place parentheses around the '!=' expression to silence this warning
     140 |                         if (((char *)&opt[i + 2] - (char *)tcph) & 0x1 != 0) {
         |                                                                  ^         
         |                                                                    (       )
   net/netfilter/xt_TCPMSS.c:140:45: note: place parentheses around the & expression to evaluate it first
     140 |                         if (((char *)&opt[i + 2] - (char *)tcph) & 0x1 != 0) {
         |                                                                  ^
         |                             (                                         )
   1 warning generated.


vim +140 net/netfilter/xt_TCPMSS.c

    69	
    70	static int
    71	tcpmss_mangle_packet(struct sk_buff *skb,
    72			     const struct xt_action_param *par,
    73			     unsigned int family,
    74			     unsigned int tcphoff,
    75			     unsigned int minlen)
    76	{
    77		const struct xt_tcpmss_info *info = par->targinfo;
    78		struct tcphdr *tcph;
    79		int len, tcp_hdrlen;
    80		unsigned int i;
    81		__be16 oldval;
    82		u16 newmss;
    83		u8 *opt;
    84	
    85		/* This is a fragment, no TCP header is available */
    86		if (par->fragoff != 0)
    87			return 0;
    88	
    89		if (skb_ensure_writable(skb, skb->len))
    90			return -1;
    91	
    92		len = skb->len - tcphoff;
    93		if (len < (int)sizeof(struct tcphdr))
    94			return -1;
    95	
    96		tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
    97		tcp_hdrlen = tcph->doff * 4;
    98	
    99		if (len < tcp_hdrlen || tcp_hdrlen < sizeof(struct tcphdr))
   100			return -1;
   101	
   102		if (info->mss == XT_TCPMSS_CLAMP_PMTU) {
   103			struct net *net = xt_net(par);
   104			unsigned int in_mtu = tcpmss_reverse_mtu(net, skb, family);
   105			unsigned int min_mtu = min(dst_mtu(skb_dst(skb)), in_mtu);
   106	
   107			if (min_mtu <= minlen) {
   108				net_err_ratelimited("unknown or invalid path-MTU (%u)\n",
   109						    min_mtu);
   110				return -1;
   111			}
   112			newmss = min_mtu - minlen;
   113		} else
   114			newmss = info->mss;
   115	
   116		opt = (u_int8_t *)tcph;
   117		for (i = sizeof(struct tcphdr); i <= tcp_hdrlen - TCPOLEN_MSS; i += optlen(opt, i)) {
   118			if (opt[i] == TCPOPT_MSS && opt[i+1] == TCPOLEN_MSS) {
   119				u_int16_t oldmss;
   120				u16 csum_oldmss, csum_newmss;
   121	
   122				oldmss = (opt[i+2] << 8) | opt[i+3];
   123	
   124				/* Never increase MSS, even when setting it, as
   125				 * doing so results in problems for hosts that rely
   126				 * on MSS being set correctly.
   127				 */
   128				if (oldmss <= newmss)
   129					return 0;
   130	
   131				opt[i+2] = (newmss & 0xff00) >> 8;
   132				opt[i+3] = newmss & 0x00ff;
   133	
   134				csum_oldmss = htons(oldmss);
   135				csum_newmss = htons(newmss);
   136	
   137				/* MSS may be unaligned; fix up the incremental checksum
   138				 * to avoid an invalid checksum and a dropped packet.
   139				 */
 > 140				if (((char *)&opt[i + 2] - (char *)tcph) & 0x1 != 0) {
   141					csum_oldmss = swab16(csum_oldmss);
   142					csum_newmss = swab16(csum_newmss);
   143				}
   144	
   145				inet_proto_csum_replace2(&tcph->check, skb,
   146							 csum_oldmss, csum_newmss,
   147							 false);
   148				return 0;
   149			}
   150		}
   151	
   152		/* There is data after the header so the option can't be added
   153		 * without moving it, and doing so may make the SYN packet
   154		 * itself too large. Accept the packet unmodified instead.
   155		 */
   156		if (len > tcp_hdrlen)
   157			return 0;
   158	
   159		/* tcph->doff has 4 bits, do not wrap it to 0 */
   160		if (tcp_hdrlen >= 15 * 4)
   161			return 0;
   162	
   163		/*
   164		 * MSS Option not found ?! add it..
   165		 */
   166		if (skb_tailroom(skb) < TCPOLEN_MSS) {
   167			if (pskb_expand_head(skb, 0,
   168					     TCPOLEN_MSS - skb_tailroom(skb),
   169					     GFP_ATOMIC))
   170				return -1;
   171			tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
   172		}
   173	
   174		skb_put(skb, TCPOLEN_MSS);
   175	
   176		/*
   177		 * IPv4: RFC 1122 states "If an MSS option is not received at
   178		 * connection setup, TCP MUST assume a default send MSS of 536".
   179		 * IPv6: RFC 2460 states IPv6 has a minimum MTU of 1280 and a minimum
   180		 * length IPv6 header of 60, ergo the default MSS value is 1220
   181		 * Since no MSS was provided, we must use the default values
   182		 */
   183		if (xt_family(par) == NFPROTO_IPV4)
   184			newmss = min(newmss, (u16)536);
   185		else
   186			newmss = min(newmss, (u16)1220);
   187	
   188		opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
   189		memmove(opt + TCPOLEN_MSS, opt, len - sizeof(struct tcphdr));
   190	
   191		inet_proto_csum_replace2(&tcph->check, skb,
   192					 htons(len), htons(len + TCPOLEN_MSS), true);
   193		opt[0] = TCPOPT_MSS;
   194		opt[1] = TCPOLEN_MSS;
   195		opt[2] = (newmss & 0xff00) >> 8;
   196		opt[3] = newmss & 0x00ff;
   197	
   198		inet_proto_csum_replace4(&tcph->check, skb, 0, *((__be32 *)opt), false);
   199	
   200		oldval = ((__be16 *)tcph)[6];
   201		tcph->doff += TCPOLEN_MSS/4;
   202		inet_proto_csum_replace2(&tcph->check, skb,
   203					 oldval, ((__be16 *)tcph)[6], false);
   204		return TCPOLEN_MSS;
   205	}
   206	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
