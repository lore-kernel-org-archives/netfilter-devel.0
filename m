From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH V5 5/5] netfilter: nf_nat_snmp_basic: use asn1 decoder
 library
Date: Mon, 8 Jan 2018 12:53:45 +0800
Message-ID: <201801081210.3IwNhfgy%fengguang.wu@intel.com>
References: <20180107151033.26377-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, ap420073@gmail.com
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31813 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755245AbeAHEyc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jan 2018 23:54:32 -0500
Content-Disposition: inline
In-Reply-To: <20180107151033.26377-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Taehee,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on nf-next/master]
[also build test WARNING on v4.15-rc7 next-20180105]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Taehee-Yoo/netfilter-nf_nat_snmp_basic-remove-useless-comment/20180108-110506
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> net/ipv4/netfilter/nf_nat_snmp_basic_main.c:222:9: sparse: incompatible types in comparison expression (different address spaces)
   net/ipv4/netfilter/nf_nat_snmp_basic_main.c:229:9: sparse: incompatible types in comparison expression (different address spaces)

vim +222 net/ipv4/netfilter/nf_nat_snmp_basic_main.c

   218	
   219	static int __init nf_nat_snmp_basic_init(void)
   220	{
   221		BUG_ON(nf_nat_snmp_hook != NULL);
 > 222		RCU_INIT_POINTER(nf_nat_snmp_hook, help);
   223	
   224		return nf_conntrack_helper_register(&snmp_trap_helper);
   225	}
   226	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
