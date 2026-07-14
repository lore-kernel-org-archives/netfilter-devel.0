Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E25C30C155;
	Tue, 14 Jul 2026 22:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784068049; cv=none; b=R4n05XsmEJnJSlrQIGCxrIMu80WMnPz5o+qpcKBky7SU754WVFxmtaL/7PKTZ9b9zXJwF7DwDtdFuVpvoSI1kt8LDvqvSAl7HMfJCZfBMcjZYstkpm6WFTJ1hH4cKXd48CwSl6QxiGd6awHCxX8qZPmRDqZ8coVIOPNhsJxI630=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784068049; c=relaxed/simple;
	bh=eS7weUHccKmcxG10A7cz/wI12Hn/QpdOc1wTo6mv1hI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WnOC8f1x1yKjELMKRDgMdZ1qXvFH3ODey+kSy4g9lvr6Od4UAHbNww+PYdL9MiMVPuhWkmiYeuBGGWx+iZFK8ao3n2Zoulp3HdS+I5p6zbI1PMly74aPc6KwTITn98oRYP2vPZtlgfAblvG5T/QlKGdJMKqeu9+XcsMhUtu9YVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YTkeFOlP; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YTkeFOlP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784068047; x=1815604047;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eS7weUHccKmcxG10A7cz/wI12Hn/QpdOc1wTo6mv1hI=;
  b=YTkeFOlPvewa/hheHo2iacylfJ/eUmNhxUp8PB80/I2q2W1uWZ2i4sDV
   0qsGe3WSPlBXh+fvtRMSsuRLRs5SbMUCjKtOYG5346cHXirwmpuJOFLiy
   m+Ti7ZtsFs7VOJpf3uWIXgeVqSRJsApSu4CCsIfuOCdhhzakXNCdSjA9g
   21zeAnD3IEUcQpCmmwy7jxiaT7sxGrZN/zTy+xormEf68XOiREZEehoM3
   UT30mjBTc2h+0QvpPj+GEE14I9Meb02/q8h/836sFj5GMLvGUjodtNf7r
   1UiCLSs9+FeZR47p6Y9y52mesKxmhP4v5PIbaGDe4iEiYYKNEwwZ1hll0
   A==;
X-CSE-ConnectionGUID: f2uEyeooTbC+2uvrK4RldA==
X-CSE-MsgGUID: j7OBIFtbTLifDXynhCrsVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="102122555"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="102122555"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 15:27:27 -0700
X-CSE-ConnectionGUID: 9JXcEjX7RVa+fgtvK1EfQQ==
X-CSE-MsgGUID: xz62DWtHSfGIpQEiT3vF/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="252021695"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 14 Jul 2026 15:27:24 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wjlax-00000000N4C-1GZD;
	Tue, 14 Jul 2026 22:27:19 +0000
Date: Wed, 15 Jul 2026 06:26:42 +0800
From: kernel test robot <lkp@intel.com>
To: Zhixing Chen <running910@gmail.com>, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>
Cc: oe-kbuild-all@lists.linux.dev, "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	Zhixing Chen <running910@gmail.com>
Subject: Re: [PATCH nf v2] netfilter: ip6tables: set hotdrop for malformed
 extension header matches
Message-ID: <202607150533.nQvx3zgH-lkp@intel.com>
References: <20260714032124.7042-1-running910@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714032124.7042-1-running910@gmail.com>

Hi Zhixing,

kernel test robot noticed the following build warnings:

[auto build test WARNING on netfilter-nf/main]
[also build test WARNING on nf-next/main linus/master v7.2-rc3 next-20260713]
[cannot apply to linux-review/Zhixing-Chen/netfilter-ip6tables-set-hotdrop-for-malformed-extension-header-matches/20260709-143240 horms-ipvs/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Zhixing-Chen/netfilter-ip6tables-set-hotdrop-for-malformed-extension-header-matches/20260714-114506
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20260714032124.7042-1-running910%40gmail.com
patch subject: [PATCH nf v2] netfilter: ip6tables: set hotdrop for malformed extension header matches
config: openrisc-allmodconfig (https://download.01.org/0day-ci/archive/20260715/202607150533.nQvx3zgH-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260715/202607150533.nQvx3zgH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607150533.nQvx3zgH-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/ipv6/netfilter/ip6t_ipv6header.c: In function 'ipv6header_mt6':
>> net/ipv6/netfilter/ip6t_ipv6header.c:31:13: warning: variable 'len' set but not used [-Wunused-but-set-variable=]
      31 |         int len;
         |             ^~~


vim +/len +31 net/ipv6/netfilter/ip6t_ipv6header.c

^1da177e4c3f41 Linus Torvalds           2005-04-16   25  
1d93a9cbad608f Jan Engelhardt           2007-07-07   26  static bool
62fc8051083a33 Jan Engelhardt           2009-07-07   27  ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
^1da177e4c3f41 Linus Torvalds           2005-04-16   28  {
f7108a20dee44e Jan Engelhardt           2008-10-08   29  	const struct ip6t_ipv6header_info *info = par->matchinfo;
^1da177e4c3f41 Linus Torvalds           2005-04-16   30  	unsigned int temp;
^1da177e4c3f41 Linus Torvalds           2005-04-16  @31  	int len;
^1da177e4c3f41 Linus Torvalds           2005-04-16   32  	u8 nexthdr;
^1da177e4c3f41 Linus Torvalds           2005-04-16   33  	unsigned int ptr;
^1da177e4c3f41 Linus Torvalds           2005-04-16   34  
^1da177e4c3f41 Linus Torvalds           2005-04-16   35  	/* Make sure this isn't an evil packet */
^1da177e4c3f41 Linus Torvalds           2005-04-16   36  
^1da177e4c3f41 Linus Torvalds           2005-04-16   37  	/* type of the 1st exthdr */
0660e03f6b18f1 Arnaldo Carvalho de Melo 2007-04-25   38  	nexthdr = ipv6_hdr(skb)->nexthdr;
^1da177e4c3f41 Linus Torvalds           2005-04-16   39  	/* pointer to the 1st exthdr */
^1da177e4c3f41 Linus Torvalds           2005-04-16   40  	ptr = sizeof(struct ipv6hdr);
^1da177e4c3f41 Linus Torvalds           2005-04-16   41  	/* available length */
^1da177e4c3f41 Linus Torvalds           2005-04-16   42  	len = skb->len - ptr;
^1da177e4c3f41 Linus Torvalds           2005-04-16   43  	temp = 0;
^1da177e4c3f41 Linus Torvalds           2005-04-16   44  
44dde23698a7a8 Jeremy Sowden            2019-09-13   45  	while (nf_ip6_ext_hdr(nexthdr)) {
3cf93c96af7adf Jan Engelhardt           2008-04-14   46  		const struct ipv6_opt_hdr *hp;
3cf93c96af7adf Jan Engelhardt           2008-04-14   47  		struct ipv6_opt_hdr _hdr;
^1da177e4c3f41 Linus Torvalds           2005-04-16   48  		int hdrlen;
^1da177e4c3f41 Linus Torvalds           2005-04-16   49  
^1da177e4c3f41 Linus Torvalds           2005-04-16   50  		/* No more exthdr -> evaluate */
^1da177e4c3f41 Linus Torvalds           2005-04-16   51  		if (nexthdr == NEXTHDR_NONE) {
^1da177e4c3f41 Linus Torvalds           2005-04-16   52  			temp |= MASK_NONE;
^1da177e4c3f41 Linus Torvalds           2005-04-16   53  			break;
^1da177e4c3f41 Linus Torvalds           2005-04-16   54  		}
^1da177e4c3f41 Linus Torvalds           2005-04-16   55  		/* ESP -> evaluate */
^1da177e4c3f41 Linus Torvalds           2005-04-16   56  		if (nexthdr == NEXTHDR_ESP) {
^1da177e4c3f41 Linus Torvalds           2005-04-16   57  			temp |= MASK_ESP;
^1da177e4c3f41 Linus Torvalds           2005-04-16   58  			break;
^1da177e4c3f41 Linus Torvalds           2005-04-16   59  		}
^1da177e4c3f41 Linus Torvalds           2005-04-16   60  
^1da177e4c3f41 Linus Torvalds           2005-04-16   61  		hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
70c0eb1ca016f7 Florian Westphal         2018-09-04   62  		if (!hp) {
70c0eb1ca016f7 Florian Westphal         2018-09-04   63  			par->hotdrop = true;
70c0eb1ca016f7 Florian Westphal         2018-09-04   64  			return false;
70c0eb1ca016f7 Florian Westphal         2018-09-04   65  		}
^1da177e4c3f41 Linus Torvalds           2005-04-16   66  
^1da177e4c3f41 Linus Torvalds           2005-04-16   67  		/* Calculate the header length */
7c4e36bc172ae1 Jan Engelhardt           2007-07-07   68  		if (nexthdr == NEXTHDR_FRAGMENT)
^1da177e4c3f41 Linus Torvalds           2005-04-16   69  			hdrlen = 8;
7c4e36bc172ae1 Jan Engelhardt           2007-07-07   70  		else if (nexthdr == NEXTHDR_AUTH)
416e8126a2672f yangxingwu               2019-07-10   71  			hdrlen = ipv6_authlen(hp);
^1da177e4c3f41 Linus Torvalds           2005-04-16   72  		else
^1da177e4c3f41 Linus Torvalds           2005-04-16   73  			hdrlen = ipv6_optlen(hp);
^1da177e4c3f41 Linus Torvalds           2005-04-16   74  
^1da177e4c3f41 Linus Torvalds           2005-04-16   75  		/* set the flag */
^1da177e4c3f41 Linus Torvalds           2005-04-16   76  		switch (nexthdr) {
^1da177e4c3f41 Linus Torvalds           2005-04-16   77  		case NEXTHDR_HOP:
^1da177e4c3f41 Linus Torvalds           2005-04-16   78  			temp |= MASK_HOPOPTS;
^1da177e4c3f41 Linus Torvalds           2005-04-16   79  			break;
^1da177e4c3f41 Linus Torvalds           2005-04-16   80  		case NEXTHDR_ROUTING:
^1da177e4c3f41 Linus Torvalds           2005-04-16   81  			temp |= MASK_ROUTING;
^1da177e4c3f41 Linus Torvalds           2005-04-16   82  			break;
^1da177e4c3f41 Linus Torvalds           2005-04-16   83  		case NEXTHDR_FRAGMENT:
^1da177e4c3f41 Linus Torvalds           2005-04-16   84  			temp |= MASK_FRAGMENT;
^1da177e4c3f41 Linus Torvalds           2005-04-16   85  			break;
^1da177e4c3f41 Linus Torvalds           2005-04-16   86  		case NEXTHDR_AUTH:
^1da177e4c3f41 Linus Torvalds           2005-04-16   87  			temp |= MASK_AH;
^1da177e4c3f41 Linus Torvalds           2005-04-16   88  			break;
^1da177e4c3f41 Linus Torvalds           2005-04-16   89  		case NEXTHDR_DEST:
^1da177e4c3f41 Linus Torvalds           2005-04-16   90  			temp |= MASK_DSTOPTS;
^1da177e4c3f41 Linus Torvalds           2005-04-16   91  			break;
^1da177e4c3f41 Linus Torvalds           2005-04-16   92  		default:
1d93a9cbad608f Jan Engelhardt           2007-07-07   93  			return false;
^1da177e4c3f41 Linus Torvalds           2005-04-16   94  		}
^1da177e4c3f41 Linus Torvalds           2005-04-16   95  
^1da177e4c3f41 Linus Torvalds           2005-04-16   96  		nexthdr = hp->nexthdr;
^1da177e4c3f41 Linus Torvalds           2005-04-16   97  		len -= hdrlen;
^1da177e4c3f41 Linus Torvalds           2005-04-16   98  		ptr += hdrlen;
aebe9616a67760 Zhixing Chen             2026-07-14   99  		if (ptr > skb->len) {
aebe9616a67760 Zhixing Chen             2026-07-14  100  			par->hotdrop = true;
aebe9616a67760 Zhixing Chen             2026-07-14  101  			return false;
aebe9616a67760 Zhixing Chen             2026-07-14  102  		}
^1da177e4c3f41 Linus Torvalds           2005-04-16  103  	}
^1da177e4c3f41 Linus Torvalds           2005-04-16  104  
7c4e36bc172ae1 Jan Engelhardt           2007-07-07  105  	if (nexthdr != NEXTHDR_NONE && nexthdr != NEXTHDR_ESP)
^1da177e4c3f41 Linus Torvalds           2005-04-16  106  		temp |= MASK_PROTO;
^1da177e4c3f41 Linus Torvalds           2005-04-16  107  
^1da177e4c3f41 Linus Torvalds           2005-04-16  108  	if (info->modeflag)
^1da177e4c3f41 Linus Torvalds           2005-04-16  109  		return !((temp ^ info->matchflags ^ info->invflags)
^1da177e4c3f41 Linus Torvalds           2005-04-16  110  			 & info->matchflags);
^1da177e4c3f41 Linus Torvalds           2005-04-16  111  	else {
^1da177e4c3f41 Linus Torvalds           2005-04-16  112  		if (info->invflags)
^1da177e4c3f41 Linus Torvalds           2005-04-16  113  			return temp != info->matchflags;
^1da177e4c3f41 Linus Torvalds           2005-04-16  114  		else
^1da177e4c3f41 Linus Torvalds           2005-04-16  115  			return temp == info->matchflags;
^1da177e4c3f41 Linus Torvalds           2005-04-16  116  	}
^1da177e4c3f41 Linus Torvalds           2005-04-16  117  }
^1da177e4c3f41 Linus Torvalds           2005-04-16  118  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
