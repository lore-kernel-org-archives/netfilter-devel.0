From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf v4 1/1] netfilter: snmp: Fix one possible panic when snmp_trap_helper fail to register
Date: Mon, 27 Mar 2017 22:08:41 +0800
Message-ID: <002701d2a703$a39a8900$eacf9b00$@foxmail.com>
References: <1490408646-26051-1-git-send-email-gfree.wind@foxmail.com> <201703272146.nP5tRJya%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <kbuild-all@01.org>, <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>, "'Gao Feng'" <fgao@ikuai8.com>
To: "'kbuild test robot'" <lkp@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpproxy19.qq.com ([184.105.206.84]:36487 "EHLO
        smtpproxy19.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753363AbdC0OI5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 10:08:57 -0400
In-Reply-To: <201703272146.nP5tRJya%fengguang.wu@intel.com>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> -----Original Message-----
> From: netfilter-devel-owner@vger.kernel.org
> [mailto:netfilter-devel-owner@vger.kernel.org] On Behalf Of kbuild test
robot
> Sent: Monday, March 27, 2017 10:01 PM
> To: gfree.wind@foxmail.com
> Cc: kbuild-all@01.org; pablo@netfilter.org;
netfilter-devel@vger.kernel.org;
> gfree.wind@foxmail.com; Gao Feng <fgao@ikuai8.com>
> Subject: Re: [PATCH nf v4 1/1] netfilter: snmp: Fix one possible panic
when
> snmp_trap_helper fail to register
> 
> Hi Gao,
> 
> [auto build test WARNING on nf/master]
> 
> url:
>
https://github.com/0day-ci/linux/commits/gfree-wind-foxmail-com/netfilter-s
> nmp-Fix-one-possible-panic-when-snmp_trap_helper-fail-to-register/2017032
> 7-081220
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git
master
> config: x86_64-randconfig-s2-03272042 (attached as .config)
> compiler: gcc-4.4 (Debian 4.4.7-8) 4.4.7
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
> 
> All warnings (new ones prefixed by >>):
> 
>    net/ipv4//netfilter/nf_nat_snmp_basic.c: In function
> 'nf_nat_snmp_basic_init':
> >> net/ipv4//netfilter/nf_nat_snmp_basic.c:1281: warning: unused variable
> 'ret'
> 
> vim +/ret +1281 net/ipv4//netfilter/nf_nat_snmp_basic.c
> 
> 807467c22 Patrick McHardy   2006-12-02  1265  	.help
=
> help,
> 6002f266b Patrick McHardy   2008-03-25  1266  	.expect_policy
=
> &snmp_exp_policy,
> 807467c22 Patrick McHardy   2006-12-02  1267  	.name
=
> "snmp_trap",
> 807467c22 Patrick McHardy   2006-12-02  1268  	.tuple.src.l3num
=
> AF_INET,
> 09640e636 Harvey Harrison   2009-02-01  1269
.tuple.src.u.udp.port	=
> cpu_to_be16(SNMP_TRAP_PORT),
> 807467c22 Patrick McHardy   2006-12-02  1270  	.tuple.dst.protonum
=
> IPPROTO_UDP,
> 807467c22 Patrick McHardy   2006-12-02  1271  };
> 807467c22 Patrick McHardy   2006-12-02  1272
> 807467c22 Patrick McHardy   2006-12-02  1273
> /***************************************************************
> **************
> 807467c22 Patrick McHardy   2006-12-02  1274   *
> 807467c22 Patrick McHardy   2006-12-02  1275   * Module stuff.
> 807467c22 Patrick McHardy   2006-12-02  1276   *
> 807467c22 Patrick McHardy   2006-12-02  1277
> ****************************************************************
> *************/
> 807467c22 Patrick McHardy   2006-12-02  1278
> 807467c22 Patrick McHardy   2006-12-02  1279  static int __init
> nf_nat_snmp_basic_init(void)
> 807467c22 Patrick McHardy   2006-12-02  1280  {
> 807467c22 Patrick McHardy   2006-12-02 @1281  	int ret = 0;
> 807467c22 Patrick McHardy   2006-12-02  1282
> 93557f53e Jiri Olsa         2011-01-18  1283
> 	BUG_ON(nf_nat_snmp_hook != NULL);
> a9b3cd7f3 Stephen Hemminger 2011-08-01  1284
> 	RCU_INIT_POINTER(nf_nat_snmp_hook, help);
> 93557f53e Jiri Olsa         2011-01-18  1285
> 9b25a2987 Gao Feng          2017-03-25  1286  	return
> nf_conntrack_helper_register(&snmp_trap_helper);
> 807467c22 Patrick McHardy   2006-12-02  1287  }
> 807467c22 Patrick McHardy   2006-12-02  1288
> 807467c22 Patrick McHardy   2006-12-02  1289  static void __exit
> nf_nat_snmp_basic_fini(void)
> 
> :::::: The code at line 1281 was first introduced by commit
> :::::: 807467c22a12381985878be23c778657fc0364d0 [NETFILTER]: nf_nat: add
> SNMP NAT helper port
> 
> :::::: TO: Patrick McHardy <kaber@trash.net>
> :::::: CC: David S. Miller <davem@davemloft.net>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology
> Center
> https://lists.01.org/pipermail/kbuild-all                   Intel
> Corporation

Thanks.
It is fixed in v5 patch.

Regards
Feng



