Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8103F788A;
	Fri, 29 May 2026 20:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780088097; cv=none; b=hSWbjzB36V/G+lQdIDba7dubmQd8pwmqVXbr6AOhXyIYzia4RGA10aAy5TmGA+ppJnOE8oTEQGFDr9Rkh5h4qO1wXTSAS37NfFwgYLRWOphtXkrdVZrCAb6d8I/l7Lh/NVHvonZHUfAG9m+W65alZ7CwKxi8PSMaT2JIICjI8eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780088097; c=relaxed/simple;
	bh=/S5opQBS0Ej1USU/abspGG6ppFq446gxLFslHhfOoBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxNvcTvHkXS3hf53lEvbeABUIoGSnYZF7tHbZY1AswAAFQon74MLtIeLjXrt2z1+WZQmIixl/S2+qaDNXnlOXyDJ9JljfsArTI+OZBcfH8S0WB8F/WUkY60dUVsv3jRO50RBNRhSRa0E/EqxUr6FY+7IbetP+qOGAeBeeWeRbcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DE3edK9K; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DE3edK9K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780088096; x=1811624096;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/S5opQBS0Ej1USU/abspGG6ppFq446gxLFslHhfOoBA=;
  b=DE3edK9KRM11gOQFjs+pl+IXtOhwVRok3xNrXcsdYm0+8Zal2hyGIHnM
   CfUtZvys39s42I9ILlPKvnqGa4uNcOL2PcEKndlozjVkXBs5r8ykG15Rw
   Mr+UG/z+E1JSmJe8rEYexkNh0SxqLEF3/kTDQ78lcO+3vviG+lTJOhOWC
   DTqwxuJ5WAVnIfH4zMTBgAWjnvXC030tWi25HmoNoL8zA5miCIX1lW+VZ
   Z9TgQezvUmSyisZMZXmAN0CepgO6F9ISabNyvrlDcXNTKVefBpt8tj7Kq
   F7cVIbVegnJ/3hFKAb7w+aiQEJSx0CCAf8l8lX2QxYgrlT57403iiEqiK
   w==;
X-CSE-ConnectionGUID: z3SiQPyrRhWY4peyS8MFwg==
X-CSE-MsgGUID: SpkJiwUyRUC43usc1CIurw==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="84806035"
X-IronPort-AV: E=Sophos;i="6.24,176,1774335600"; 
   d="scan'208";a="84806035"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 13:54:55 -0700
X-CSE-ConnectionGUID: LXmduyQWTgC5f/i4ueVE5Q==
X-CSE-MsgGUID: JzBUgapxRuy8vKMrDUZ7PA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,176,1774335600"; 
   d="scan'208";a="243045869"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 29 May 2026 13:54:51 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wT4EB-000000007h8-3tDW;
	Fri, 29 May 2026 20:54:47 +0000
Date: Sat, 30 May 2026 04:54:19 +0800
From: kernel test robot <lkp@intel.com>
To: Kacper Kokot <kacper.kokot.44@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	stable@vger.kernel.org, Kacper Kokot <kacper.kokot.44@gmail.com>
Subject: Re: [PATCH] netfilter: TCPMSS: fix dropped packets when MSS option
 is unaligned
Message-ID: <202605300415.wk7l0cyV-lkp@intel.com>
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
[also build test WARNING on netfilter-nf/main horms-ipvs/master linus/master v7.1-rc5 next-20260528]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kacper-Kokot/netfilter-TCPMSS-fix-dropped-packets-when-MSS-option-is-unaligned/20260526-041308
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git main
patch link:    https://lore.kernel.org/r/20260525201116.407338-2-kacper.kokot.44%40gmail.com
patch subject: [PATCH] netfilter: TCPMSS: fix dropped packets when MSS option is unaligned
config: arc-randconfig-r133-20260529 (https://download.01.org/0day-ci/archive/20260530/202605300415.wk7l0cyV-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 10.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260530/202605300415.wk7l0cyV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605300415.wk7l0cyV-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> net/netfilter/xt_TCPMSS.c:134:37: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] csum_oldmss @@     got restricted __be16 [usertype] @@
   net/netfilter/xt_TCPMSS.c:134:37: sparse:     expected unsigned short [usertype] csum_oldmss
   net/netfilter/xt_TCPMSS.c:134:37: sparse:     got restricted __be16 [usertype]
>> net/netfilter/xt_TCPMSS.c:135:37: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] csum_newmss @@     got restricted __be16 [usertype] @@
   net/netfilter/xt_TCPMSS.c:135:37: sparse:     expected unsigned short [usertype] csum_newmss
   net/netfilter/xt_TCPMSS.c:135:37: sparse:     got restricted __be16 [usertype]
>> net/netfilter/xt_TCPMSS.c:146:50: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __be16 [usertype] from @@     got unsigned short [assigned] [usertype] csum_oldmss @@
   net/netfilter/xt_TCPMSS.c:146:50: sparse:     expected restricted __be16 [usertype] from
   net/netfilter/xt_TCPMSS.c:146:50: sparse:     got unsigned short [assigned] [usertype] csum_oldmss
>> net/netfilter/xt_TCPMSS.c:146:63: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected restricted __be16 [usertype] to @@     got unsigned short [assigned] [usertype] csum_newmss @@
   net/netfilter/xt_TCPMSS.c:146:63: sparse:     expected restricted __be16 [usertype] to
   net/netfilter/xt_TCPMSS.c:146:63: sparse:     got unsigned short [assigned] [usertype] csum_newmss

vim +134 net/netfilter/xt_TCPMSS.c

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
 > 134				csum_oldmss = htons(oldmss);
 > 135				csum_newmss = htons(newmss);
   136	
   137				/* MSS may be unaligned; fix up the incremental checksum
   138				 * to avoid an invalid checksum and a dropped packet.
   139				 */
   140				if (((char *)&opt[i + 2] - (char *)tcph) & 0x1 != 0) {
   141					csum_oldmss = swab16(csum_oldmss);
   142					csum_newmss = swab16(csum_newmss);
   143				}
   144	
   145				inet_proto_csum_replace2(&tcph->check, skb,
 > 146							 csum_oldmss, csum_newmss,
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
