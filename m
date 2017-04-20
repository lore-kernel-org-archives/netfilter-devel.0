From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH nf-next 3/3] netfilter: conntrack: handle initial
 extension alloc via krealloc
Date: Thu, 20 Apr 2017 11:40:54 +0800
Message-ID: <201704201123.eaL50FSK%fengguang.wu@intel.com>
References: <20170419214438.20938-4-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17626 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S940704AbdDTDla (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 23:41:30 -0400
Content-Disposition: inline
In-Reply-To: <20170419214438.20938-4-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

[auto build test WARNING on nf-next/master]

url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/netfilter-conntrack-removal-prealloc-support/20170420-100813
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:264:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> net/netfilter/nf_conntrack_extend.c:83:17: sparse: incompatible types in comparison expression (different address spaces)

vim +83 net/netfilter/nf_conntrack_extend.c

    67		t = rcu_dereference(nf_ct_ext_types[id]);
    68		if (!t) {
    69			rcu_read_unlock();
    70			return NULL;
    71		}
    72	
    73		newoff = ALIGN(oldlen, t->align);
    74		newlen = newoff + t->len;
    75		rcu_read_unlock();
    76	
    77		alloc = max(newlen, NF_CT_EXT_PREALLOC);
    78		new = __krealloc(old, alloc, gfp);
    79		if (!new)
    80			return NULL;
    81	
    82		if (!old) {
  > 83			RCU_INIT_POINTER(ct->ext, new);
    84			memset(new->offset, 0, sizeof(new->offset));
    85		} else if (new != old) {
    86			kfree_rcu(old, rcu);
    87			rcu_assign_pointer(ct->ext, new);
    88		}
    89	
    90		new->offset[id] = newoff;
    91		new->len = newlen;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
