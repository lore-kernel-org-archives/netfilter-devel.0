Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8492868D
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Sep 2024 19:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726948328; cv=none; b=GJTxW08zICiIbafy2vpsunEOoadcEHuH/hef6nGYlHQIik3W6qv4WwpSdxrCPSOd+2dr1KXYteSYBl/yCsbF2UmI3+WsfaXnDJl6UJ4cs7wgDx2L2tlFZbhV0Sqz6oByhi1S9bquYpRmrxMG1zunwqUX0h/zG638CMjGwvftDQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726948328; c=relaxed/simple;
	bh=nbAvpGKuqrH7LVdMKRZUV17kWcRWLbVOmkXf5IlwCdo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KK+DxpUIiC4NLDC4t82/BYu3NPO0ysowuaLcdOBucTRcIyxRpCw7tBJ9r1bbdu38n1ijN69vyh2ougCx6X1MviPTsc313Dx6Cyo3eTMMXpeS42vAoOJqpFyJJOiTBBWUvS+zze5TRUzKI5VAgA+vQzBxChx1f46MmhCfS8Wqaok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T90G/BIW; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T90G/BIW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726948326; x=1758484326;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=nbAvpGKuqrH7LVdMKRZUV17kWcRWLbVOmkXf5IlwCdo=;
  b=T90G/BIWa+dgcWUOQ1fNOEU12lYUfV91LMCrT9V0e/fphPllE7KTOltx
   71Cytv4sRX29kZd6wKQl675ia9oR42c5rh4jyZg8mytCg6qNDCiWwpN6g
   ksMxREEwn7mraEnVQktFsrOcDHjicU3SARQqSS3jwHb9b9gfKubhbT4Wi
   G2HSGjUPX6oQVFS7sOrKHOC0WVhR3RmBDLKGRHL6ytuYmnBjf+YW5qwXE
   Qd6VVkiP1w/n9HWLn8WzBq60o/hne0KXAOq42hBlHJzKiaFYZw6AhGO4i
   B/OaO24uEcOqzGG4RHu7dIY7+EuRBqdpXbia1WjQyyXhzBGoJ6zzB7VUH
   w==;
X-CSE-ConnectionGUID: hi4bw9H7SXO/x7KXXNAWVQ==
X-CSE-MsgGUID: phVUq/NTR4q8ItLkpT1WIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11202"; a="25452746"
X-IronPort-AV: E=Sophos;i="6.10,247,1719903600"; 
   d="scan'208";a="25452746"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2024 12:52:06 -0700
X-CSE-ConnectionGUID: B3QUcu6DTbCI+gQpOSQraQ==
X-CSE-MsgGUID: lT5g/ZmBSKeyZBgTJcWcGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,247,1719903600"; 
   d="scan'208";a="93982653"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 21 Sep 2024 12:52:04 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ss69B-000FlG-35;
	Sat, 21 Sep 2024 19:52:01 +0000
Date: Sun, 22 Sep 2024 03:51:43 +0800
From: kernel test robot <lkp@intel.com>
To: Florian Westphal <fw@strlen.de>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [nf-next:testing 4/5] net/netfilter/nf_nat_masquerade.c:252:30:
 warning: variable 'newrange' set but not used
Message-ID: <202409220325.Fe1kvl39-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git testing
head:   eb5a3496084f9a3ea3fb4c4d22b4c661d46a2743
commit: ecc701a3bd9890f83ea89337c64d4f14aba9f091 [4/5] netfilter: nf_nat: use skb_drop_reason
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20240922/202409220325.Fe1kvl39-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240922/202409220325.Fe1kvl39-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409220325.Fe1kvl39-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/netfilter/nf_nat_masquerade.c: In function 'nf_nat_masquerade_ipv6':
>> net/netfilter/nf_nat_masquerade.c:252:30: warning: variable 'newrange' set but not used [-Wunused-but-set-variable]
     252 |         struct nf_nat_range2 newrange;
         |                              ^~~~~~~~


vim +/newrange +252 net/netfilter/nf_nat_masquerade.c

d1aca8ab3104aa Florian Westphal 2019-02-19  243  
d1aca8ab3104aa Florian Westphal 2019-02-19  244  unsigned int
d1aca8ab3104aa Florian Westphal 2019-02-19  245  nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
d1aca8ab3104aa Florian Westphal 2019-02-19  246  		       const struct net_device *out)
d1aca8ab3104aa Florian Westphal 2019-02-19  247  {
d1aca8ab3104aa Florian Westphal 2019-02-19  248  	enum ip_conntrack_info ctinfo;
d1aca8ab3104aa Florian Westphal 2019-02-19  249  	struct nf_conn_nat *nat;
d1aca8ab3104aa Florian Westphal 2019-02-19  250  	struct in6_addr src;
d1aca8ab3104aa Florian Westphal 2019-02-19  251  	struct nf_conn *ct;
d1aca8ab3104aa Florian Westphal 2019-02-19 @252  	struct nf_nat_range2 newrange;
ecc701a3bd9890 Florian Westphal 2023-05-14  253  	int ret;
d1aca8ab3104aa Florian Westphal 2019-02-19  254  
d1aca8ab3104aa Florian Westphal 2019-02-19  255  	ct = nf_ct_get(skb, &ctinfo);
d1aca8ab3104aa Florian Westphal 2019-02-19  256  	WARN_ON(!(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
d1aca8ab3104aa Florian Westphal 2019-02-19  257  			 ctinfo == IP_CT_RELATED_REPLY)));
d1aca8ab3104aa Florian Westphal 2019-02-19  258  
d1aca8ab3104aa Florian Westphal 2019-02-19  259  	if (nat_ipv6_dev_get_saddr(nf_ct_net(ct), out,
d1aca8ab3104aa Florian Westphal 2019-02-19  260  				   &ipv6_hdr(skb)->daddr, 0, &src) < 0)
ecc701a3bd9890 Florian Westphal 2023-05-14  261  		return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EADDRNOTAVAIL);
d1aca8ab3104aa Florian Westphal 2019-02-19  262  
d1aca8ab3104aa Florian Westphal 2019-02-19  263  	nat = nf_ct_nat_ext_add(ct);
d1aca8ab3104aa Florian Westphal 2019-02-19  264  	if (nat)
d1aca8ab3104aa Florian Westphal 2019-02-19  265  		nat->masq_index = out->ifindex;
d1aca8ab3104aa Florian Westphal 2019-02-19  266  
d1aca8ab3104aa Florian Westphal 2019-02-19  267  	newrange.flags		= range->flags | NF_NAT_RANGE_MAP_IPS;
d1aca8ab3104aa Florian Westphal 2019-02-19  268  	newrange.min_addr.in6	= src;
d1aca8ab3104aa Florian Westphal 2019-02-19  269  	newrange.max_addr.in6	= src;
d1aca8ab3104aa Florian Westphal 2019-02-19  270  	newrange.min_proto	= range->min_proto;
d1aca8ab3104aa Florian Westphal 2019-02-19  271  	newrange.max_proto	= range->max_proto;
d1aca8ab3104aa Florian Westphal 2019-02-19  272  
ecc701a3bd9890 Florian Westphal 2023-05-14  273  	if (ret == NF_DROP)
ecc701a3bd9890 Florian Westphal 2023-05-14  274  		return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
ecc701a3bd9890 Florian Westphal 2023-05-14  275  
ecc701a3bd9890 Florian Westphal 2023-05-14  276  	return ret;
d1aca8ab3104aa Florian Westphal 2019-02-19  277  }
d1aca8ab3104aa Florian Westphal 2019-02-19  278  EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6);
d1aca8ab3104aa Florian Westphal 2019-02-19  279  

:::::: The code at line 252 was first introduced by commit
:::::: d1aca8ab3104aa7131f5ab144c6f586b54df084b netfilter: nat: merge ipv4 and ipv6 masquerade functionality

:::::: TO: Florian Westphal <fw@strlen.de>
:::::: CC: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
