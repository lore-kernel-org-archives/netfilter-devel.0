From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH nf 1/3] netfilter: conntrack: fix crash on timeout object
 removal
Date: Mon, 5 Oct 2015 23:08:57 +0800
Message-ID: <201510052348.MdM5Kc4Y%fengguang.wu@intel.com>
References: <1444056663-5913-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
	stephen@networkplumber.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58702 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbbJEPKK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 11:10:10 -0400
Content-Disposition: inline
In-Reply-To: <1444056663-5913-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

[auto build test WARNING on v4.3-rc4 -- if it's inappropriate base, please ignore]

reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> net/netfilter/nf_conntrack_core.c:956:54: sparse: incorrect type in argument 2 (different address spaces)
   net/netfilter/nf_conntrack_core.c:956:54:    expected struct ctnl_timeout *timeout
   net/netfilter/nf_conntrack_core.c:956:54:    got struct ctnl_timeout [noderef] <asn:4>*timeout
   net/netfilter/nf_conntrack_core.c:1463:9: sparse: incompatible types in comparison expression (different address spaces)
   net/netfilter/nf_conntrack_core.c:1468:9: sparse: incompatible types in comparison expression (different address spaces)
   net/netfilter/nf_conntrack_core.c:1744:9: sparse: incompatible types in comparison expression (different address spaces)
   net/netfilter/nf_conntrack_core.c:1745:9: sparse: incompatible types in comparison expression (different address spaces)

vim +956 net/netfilter/nf_conntrack_core.c

60b5f8f7 Pablo Neira Ayuso       2012-03-23  940  	timeout_ext = tmpl ? nf_ct_timeout_find(tmpl) : NULL;
2d28d14a Pablo Neira Ayuso       2015-10-05  941  	if (timeout_ext) {
2d28d14a Pablo Neira Ayuso       2015-10-05  942  		timeouts = nf_ct_timeout_data(timeout_ext);
2d28d14a Pablo Neira Ayuso       2015-10-05  943  		if (unlikely(!timeouts))
2d28d14a Pablo Neira Ayuso       2015-10-05  944  			timeouts = l4proto->get_timeouts(net);
2d28d14a Pablo Neira Ayuso       2015-10-05  945  	} else {
60b5f8f7 Pablo Neira Ayuso       2012-03-23  946  		timeouts = l4proto->get_timeouts(net);
2d28d14a Pablo Neira Ayuso       2015-10-05  947  	}
60b5f8f7 Pablo Neira Ayuso       2012-03-23  948  
2c8503f5 Pablo Neira Ayuso       2012-02-28  949  	if (!l4proto->new(ct, skb, dataoff, timeouts)) {
c88130bc Patrick McHardy         2008-01-31  950  		nf_conntrack_free(ct);
0d53778e Patrick McHardy         2007-07-07  951  		pr_debug("init conntrack: can't track with proto module\n");
9fb9cbb1 Yasuyuki Kozakai        2005-11-09  952  		return NULL;
9fb9cbb1 Yasuyuki Kozakai        2005-11-09  953  	}
9fb9cbb1 Yasuyuki Kozakai        2005-11-09  954  
60b5f8f7 Pablo Neira Ayuso       2012-03-23  955  	if (timeout_ext)
60b5f8f7 Pablo Neira Ayuso       2012-03-23 @956  		nf_ct_timeout_ext_add(ct, timeout_ext->timeout, GFP_ATOMIC);
60b5f8f7 Pablo Neira Ayuso       2012-03-23  957  
58401572 Krzysztof Piotr Oledzki 2008-07-21  958  	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
a992ca2a Pablo Neira Ayuso       2011-01-19  959  	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
c539f017 Florian Westphal        2013-01-11  960  	nf_ct_labels_ext_add(ct);
b2a15a60 Patrick McHardy         2010-02-03  961  
b2a15a60 Patrick McHardy         2010-02-03  962  	ecache = tmpl ? nf_ct_ecache_find(tmpl) : NULL;
b2a15a60 Patrick McHardy         2010-02-03  963  	nf_ct_ecache_ext_add(ct, ecache ? ecache->ctmask : 0,
b2a15a60 Patrick McHardy         2010-02-03  964  				 ecache ? ecache->expmask : 0,

:::::: The code at line 956 was first introduced by commit
:::::: 60b5f8f745739a4789395648595ed31ede582448 netfilter: nf_conntrack: permanently attach timeout policy to conntrack

:::::: TO: Pablo Neira Ayuso <pablo@netfilter.org>
:::::: CC: Pablo Neira Ayuso <pablo@netfilter.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
