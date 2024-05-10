Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D359376
	for <netfilter-devel@vger.kernel.org>; Fri, 10 May 2024 13:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715346732; cv=none; b=uDRT5ILPfQ0dUlALrMuF6VQ/mJHuBJ4+ZVmmDxMDNs89jgdiV3UJ7T5pRAPT5963sZqsX8JVIEF6pdNrSfmlGGFpmcsvcPjaTmm7A/YGN4dodUQlr9ClVwUStjDrixskZdVtDXMzV7E2dzamD5AApE36eiyMlj3VVjVC6Tu8bzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715346732; c=relaxed/simple;
	bh=vt5q5HjiawdpRzyWOjoYsI/fzLHLhZzJhBtgQzZ8LSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CG5BBKsDitdBZ24td4AKn60Ls3Bi4y2232QOknF6C+IS0tKXQukIFzoW1TBQUmQ6NVrf5KfEMosrN9EJeJSGDbsaxk1x8LMEzORI0BnyoCBfm0X2TJG6JF7FrQo8qzXpdW9Q17jO9Y+KWeImm7yS85FN0bW8/5riDTrXn1jY9D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ms4URf3D; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ms4URf3D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715346730; x=1746882730;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vt5q5HjiawdpRzyWOjoYsI/fzLHLhZzJhBtgQzZ8LSo=;
  b=Ms4URf3DDNNBeqdZ12FppEjAODTJv2bwoQLmUADZHSWLcTyc/tMhGGnf
   89e4sgcO4va0c9X6jxw6NKTfYy2pGj7VPRdQqWIRXDZtkfoHG0DZ0Wqmp
   ZvMLQPJ+NMdKZUh2ORa6pKfh9oitaRFZr9jVah3G6MSLX91jsaRAWxjjH
   mw+Sj3RegnoC8o3VbX4BQja8Rj8m84qjZKPZiS90/ZIR3Hj0Y4NiqKmjk
   P3Aksq5v1lcmNOp0yLVKhj/XVfEOdP9Je0A6nMvlwGhCPOpqZLUK0q2yW
   pU3s/d6cgMY0jNJMxL5nwVK97e3QMF8vxJsSTwY4wn9qIt0B8rWSd+PR6
   g==;
X-CSE-ConnectionGUID: mFSIXJVeTWm08DR18TqF7Q==
X-CSE-MsgGUID: LCSNQ38lSvKm5bEnqNGgnA==
X-IronPort-AV: E=McAfee;i="6600,9927,11068"; a="11538408"
X-IronPort-AV: E=Sophos;i="6.08,151,1712646000"; 
   d="scan'208";a="11538408"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2024 06:12:10 -0700
X-CSE-ConnectionGUID: 7GbXmLTLSGG4kOzLTEXH9w==
X-CSE-MsgGUID: 7kPHUsRoSQGKbqW9KLTKSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,151,1712646000"; 
   d="scan'208";a="30165986"
Received: from lkp-server01.sh.intel.com (HELO f8b243fe6e68) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 10 May 2024 06:12:08 -0700
Received: from kbuild by f8b243fe6e68 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s5Q2g-0006BP-0o;
	Fri, 10 May 2024 13:12:06 +0000
Date: Fri, 10 May 2024 21:11:58 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH nf-next 2/2] netfilter: nft_payload: skbuff vlan metadata
 mangle support
Message-ID: <202405102106.cxYkCzFw-lkp@intel.com>
References: <20240510000719.3205-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240510000719.3205-3-pablo@netfilter.org>

Hi Pablo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on netfilter-nf/main]
[also build test WARNING on linus/master v6.9-rc7 next-20240510]
[cannot apply to nf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-nft_payload-restore-vlan-q-in-q-match-support/20240510-080839
base:   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20240510000719.3205-3-pablo%40netfilter.org
patch subject: [PATCH nf-next 2/2] netfilter: nft_payload: skbuff vlan metadata mangle support
config: powerpc64-randconfig-r133-20240510 (https://download.01.org/0day-ci/archive/20240510/202405102106.cxYkCzFw-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 13.2.0
reproduce: (https://download.01.org/0day-ci/archive/20240510/202405102106.cxYkCzFw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405102106.cxYkCzFw-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> net/netfilter/nft_payload.c:826:36: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] vlan_proto @@     got unsigned short @@
   net/netfilter/nft_payload.c:826:36: sparse:     expected restricted __be16 [usertype] vlan_proto
   net/netfilter/nft_payload.c:826:36: sparse:     got unsigned short
>> net/netfilter/nft_payload.c:840:28: sparse: sparse: cast to restricted __be16
>> net/netfilter/nft_payload.c:840:26: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] vlan_tci @@     got unsigned short [usertype] @@
   net/netfilter/nft_payload.c:840:26: sparse:     expected restricted __be16 [usertype] vlan_tci
   net/netfilter/nft_payload.c:840:26: sparse:     got unsigned short [usertype]
>> net/netfilter/nft_payload.c:841:31: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] vlan_tci @@     got restricted __be16 [usertype] vlan_tci @@
   net/netfilter/nft_payload.c:841:31: sparse:     expected unsigned short [usertype] vlan_tci
   net/netfilter/nft_payload.c:841:31: sparse:     got restricted __be16 [usertype] vlan_tci

vim +826 net/netfilter/nft_payload.c

   809	
   810	static bool
   811	nft_payload_set_vlan(const u32 *src, struct sk_buff *skb, u8 offset, u8 len,
   812			     int *vlan_hlen)
   813	{
   814		struct nft_payload_vlan_hdr *vlanh;
   815		__be16 vlan_proto;
   816		__be16 vlan_tci;
   817	
   818		if (offset >= offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto)) {
   819			*vlan_hlen = VLAN_HLEN;
   820			return true;
   821		}
   822	
   823		switch (offset) {
   824		case offsetof(struct vlan_ethhdr, h_vlan_proto):
   825			if (len == 2) {
 > 826				vlan_proto = nft_reg_load16(src);
   827				skb->vlan_proto = vlan_proto;
   828			} else if (len == 4) {
   829				vlanh = (struct nft_payload_vlan_hdr *)src;
   830				__vlan_hwaccel_put_tag(skb, vlanh->h_vlan_proto,
   831						       ntohs(vlanh->h_vlan_TCI));
   832			} else {
   833				return false;
   834			}
   835			break;
   836		case offsetof(struct vlan_ethhdr, h_vlan_TCI):
   837			if (len != 2)
   838				return false;
   839	
 > 840			vlan_tci = ntohs(nft_reg_load16(src));
 > 841			skb->vlan_tci = vlan_tci;
   842			break;
   843		default:
   844			return false;
   845		}
   846	
   847		return true;
   848	}
   849	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
