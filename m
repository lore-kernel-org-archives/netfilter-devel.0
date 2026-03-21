Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B833BB48
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Mar 2026 05:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774070439; cv=none; b=aZM5pGllDKbnI9ISfqlVmch7rE91rnKjTv9xEaUJGUQ/PHCZAMwQfHk+jS99XSV16+JGsniY49l9XeZOFLbRCymO2Sa/z0Sbjcfn+BvyVyfmYZNMHfI87qezWvjz/VrJYU6BXL35tV5tJ+blrfM6DwMQF5sxhBbzt7/g5gZSsuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774070439; c=relaxed/simple;
	bh=IgG2PfEXVCh4PoHFo3zXHpKJX40L0a1Q/0fTHZ7yc8o=;
	h=Date:From:To:Cc:Subject:Message-ID; b=OQ4PLh+tup8rYk/eTp6xPxk4bPRLPv/JwmZHFgtr+hleInREgHWZT+U63Ix6gjM4I+EzibjzKkkVN2rCa6x0mwc0ilBqWLWkUNolzRiGEQ4TrxhSfiHZwvTGqeYxtWIif2xkfotWg0C4tpLqHiie7woza0akEW3UZ3JLQTyZnf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BnjobUKD; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BnjobUKD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774070437; x=1805606437;
  h=date:from:to:cc:subject:message-id;
  bh=IgG2PfEXVCh4PoHFo3zXHpKJX40L0a1Q/0fTHZ7yc8o=;
  b=BnjobUKDwR8gapTUeBVK+YPJ1G3juCJ0EPszI63AnYUdGb39pR0oLAdZ
   EuHT641BvvYF3cq7tqg+cFXf8J6zK5ajJmtpjGUFqlVd53NpsKxutvDNT
   TKCxxxAt30+ZQGJTER+AmmiVUy9K9yjcqkmIPhOTzBYw0YhiAqVMwQ1nf
   74oKYg51mzhgegDLUr4mwC/oYVFy9Uwg0i/38bYCEsRwU6l85JcsWZXmu
   HoD4xSB11NnaTeAsm23jlpiCBDM1Fi29JI3bMbHwgFJ8IT1z5xq/NTvY6
   W+sukbXCRQxEBs431fqNmJiDsyfFBy6szEGzyRsgvnlw8nNXYlcb6m0oo
   Q==;
X-CSE-ConnectionGUID: n0UFfWGUQ2W8rlcr33vHhw==
X-CSE-MsgGUID: ts0N4IsaTmiNALMPpzka8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="86233253"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="86233253"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 22:20:37 -0700
X-CSE-ConnectionGUID: QjBWOS9UTgOielkZt3AHRw==
X-CSE-MsgGUID: PEnGzgAMS1C+UMvyVsW3ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="218783214"
Received: from lkp-server02.sh.intel.com (HELO d7fefbca0d04) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 20 Mar 2026 22:20:34 -0700
Received: from kbuild by d7fefbca0d04 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3ol4-000000000LD-1Bqk;
	Sat, 21 Mar 2026 05:20:24 +0000
Date: Sat, 21 Mar 2026 13:19:19 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, Florian Westphal <fw@strlen.de>
Subject: [netfilter-nf:testing 8/9]
 net/netfilter/nf_conntrack_expect.c:341:12: error: 'struct
 nf_conntrack_expect' has no member named 'zone'
Message-ID: <202603211306.QR8V8nsC-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git testing
head:   b1bad43d8b00ab31c8f93145a4c8db1567f0d2fe
commit: 5559719129b7370573ae4892829ea7c55f702b27 [8/9] netfilter: nf_conntrack_expect: store netns and zone in expectation
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20260321/202603211306.QR8V8nsC-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260321/202603211306.QR8V8nsC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603211306.QR8V8nsC-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/netfilter/nf_conntrack_expect.c: In function 'nf_ct_expect_init':
>> net/netfilter/nf_conntrack_expect.c:341:12: error: 'struct nf_conntrack_expect' has no member named 'zone'
     341 |         exp->zone = exp->master->zone;
         |            ^~
>> net/netfilter/nf_conntrack_expect.c:341:32: error: 'struct nf_conn' has no member named 'zone'
     341 |         exp->zone = exp->master->zone;
         |                                ^~
--
   net/netfilter/nf_conntrack_netlink.c: In function 'ctnetlink_alloc_expect':
>> net/netfilter/nf_conntrack_netlink.c:3583:12: error: 'struct nf_conntrack_expect' has no member named 'zone'
    3583 |         exp->zone = ct->zone;
         |            ^~
>> net/netfilter/nf_conntrack_netlink.c:3583:23: error: 'struct nf_conn' has no member named 'zone'
    3583 |         exp->zone = ct->zone;
         |                       ^~


vim +341 net/netfilter/nf_conntrack_expect.c

   316	
   317	/* This function can only be used from packet path, where accessing
   318	 * master's helper is safe, because the packet holds a reference on
   319	 * the conntrack object. Never use it from control plane.
   320	 */
   321	void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
   322			       u_int8_t family,
   323			       const union nf_inet_addr *saddr,
   324			       const union nf_inet_addr *daddr,
   325			       u_int8_t proto, const __be16 *src, const __be16 *dst)
   326	{
   327		struct net *net = read_pnet(&exp->master->ct_net);
   328	
   329		int len;
   330	
   331		if (family == AF_INET)
   332			len = 4;
   333		else
   334			len = 16;
   335	
   336		exp->flags = 0;
   337		exp->class = class;
   338		exp->expectfn = NULL;
   339		rcu_assign_pointer(exp->helper, nfct_help(exp->master)->helper);
   340		write_pnet(&exp->net, net);
 > 341		exp->zone = exp->master->zone;
   342		exp->tuple.src.l3num = family;
   343		exp->tuple.dst.protonum = proto;
   344	
   345		if (saddr) {
   346			memcpy(&exp->tuple.src.u3, saddr, len);
   347			if (sizeof(exp->tuple.src.u3) > len)
   348				/* address needs to be cleared for nf_ct_tuple_equal */
   349				memset((void *)&exp->tuple.src.u3 + len, 0x00,
   350				       sizeof(exp->tuple.src.u3) - len);
   351			memset(&exp->mask.src.u3, 0xFF, len);
   352			if (sizeof(exp->mask.src.u3) > len)
   353				memset((void *)&exp->mask.src.u3 + len, 0x00,
   354				       sizeof(exp->mask.src.u3) - len);
   355		} else {
   356			memset(&exp->tuple.src.u3, 0x00, sizeof(exp->tuple.src.u3));
   357			memset(&exp->mask.src.u3, 0x00, sizeof(exp->mask.src.u3));
   358		}
   359	
   360		if (src) {
   361			exp->tuple.src.u.all = *src;
   362			exp->mask.src.u.all = htons(0xFFFF);
   363		} else {
   364			exp->tuple.src.u.all = 0;
   365			exp->mask.src.u.all = 0;
   366		}
   367	
   368		memcpy(&exp->tuple.dst.u3, daddr, len);
   369		if (sizeof(exp->tuple.dst.u3) > len)
   370			/* address needs to be cleared for nf_ct_tuple_equal */
   371			memset((void *)&exp->tuple.dst.u3 + len, 0x00,
   372			       sizeof(exp->tuple.dst.u3) - len);
   373	
   374		exp->tuple.dst.u.all = *dst;
   375	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
