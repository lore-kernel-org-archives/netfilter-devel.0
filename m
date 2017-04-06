From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf-next 1/1] netfilter: Remove useless variable timeouts in init_conntrack
Date: Thu, 6 Apr 2017 08:46:09 +0800
Message-ID: <002101d2ae6f$2efde600$8cf9b200$@foxmail.com>
References: <1491367754-16976-1-git-send-email-gfree.wind@foxmail.com> <201704060327.QtC31I9O%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <kbuild-all@01.org>, <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>
To: "'kbuild test robot'" <lkp@intel.com>, <gfree.wind@foxmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgau1.qq.com ([54.206.16.166]:33481 "EHLO smtpbgau1.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751655AbdDFAqQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Apr 2017 20:46:16 -0400
In-Reply-To: <201704060327.QtC31I9O%fengguang.wu@intel.com>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: kbuild test robot [mailto:lkp@intel.com]
> Sent: Thursday, April 6, 2017 4:01 AM
> To: gfree.wind@foxmail.com
> Cc: kbuild-all@01.org; pablo@netfilter.org;
netfilter-devel@vger.kernel.org;
> Gao Feng <fgao@ikuai8.com>
> Subject: Re: [PATCH nf-next 1/1] netfilter: Remove useless variable
timeouts in
> init_conntrack
> 
> Hi Gao,
> 
> [auto build test ERROR on nf-next/master]
> 
> url:
>
https://github.com/0day-ci/linux/commits/gfree-wind-foxmail-com/netfilter-R
> emove-useless-variable-timeouts-in-init_conntrack/20170406-031517
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git
> master
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
> 
> All errors (new ones prefixed by >>):
> 
> >> net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c:377:11: error:
initialization
> from incompatible pointer type [-Werror=incompatible-pointer-types]
>      .new   = icmpv6_new,
>               ^~~~~~~~~~
>    net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c:377:11: note: (near
> initialization for 'nf_conntrack_l4proto_icmpv6.new')
>    cc1: some warnings being treated as errors
> --
> >> net/netfilter/nf_conntrack_proto_generic.c:196:11: error:
initialization from
> incompatible pointer type [-Werror=incompatible-pointer-types]
>      .new   = generic_new,
>               ^~~~~~~~~~~
>    net/netfilter/nf_conntrack_proto_generic.c:196:11: note: (near
> initialization for 'nf_conntrack_l4proto_generic.new')
>    cc1: some warnings being treated as errors
> --
> >> net/netfilter/nf_conntrack_proto_gre.c:374:11: error: initialization
from
> incompatible pointer type [-Werror=incompatible-pointer-types]
>      .new   = gre_new,
>               ^~~~~~~
>    net/netfilter/nf_conntrack_proto_gre.c:374:11: note: (near
initialization for
> 'nf_conntrack_l4proto_gre4.new')
>    cc1: some warnings being treated as errors
> 
> vim +377 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> 
> 8fc027816 Gao feng            2012-06-21  361
> 08911475d Pablo Neira Ayuso   2012-06-29  362  static struct nf_proto_net
> *icmpv6_get_net_proto(struct net *net)
> 08911475d Pablo Neira Ayuso   2012-06-29  363  {
> 08911475d Pablo Neira Ayuso   2012-06-29  364  	return
> &net->ct.nf_ct_proto.icmpv6.pn;
> 08911475d Pablo Neira Ayuso   2012-06-29  365  }
> 08911475d Pablo Neira Ayuso   2012-06-29  366
> 61075af51 Patrick McHardy     2007-07-14  367  struct
> nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 __read_mostly =
> 9fb9cbb10 Yasuyuki Kozakai    2005-11-09  368  {
> 9fb9cbb10 Yasuyuki Kozakai    2005-11-09  369  	.l3proto
=
> PF_INET6,
> 605dcad6c Martin Josefsson    2006-11-29  370  	.l4proto
=
> IPPROTO_ICMPV6,
> 9fb9cbb10 Yasuyuki Kozakai    2005-11-09  371  	.name
=
> "icmpv6",
> 9fb9cbb10 Yasuyuki Kozakai    2005-11-09  372  	.pkt_to_tuple
=
> icmpv6_pkt_to_tuple,
> 9fb9cbb10 Yasuyuki Kozakai    2005-11-09  373  	.invert_tuple
=
> icmpv6_invert_tuple,
> 9fb9cbb10 Yasuyuki Kozakai    2005-11-09  374  	.print_tuple
=
> icmpv6_print_tuple,
> 9fb9cbb10 Yasuyuki Kozakai    2005-11-09  375  	.packet
=
> icmpv6_packet,
> 2c8503f55 Pablo Neira Ayuso   2012-02-28  376  	.get_timeouts
=
> icmpv6_get_timeouts,
> 9fb9cbb10 Yasuyuki Kozakai    2005-11-09 @377  	.new
=
> icmpv6_new,
> 9fb9cbb10 Yasuyuki Kozakai    2005-11-09  378  	.error
=
> icmpv6_error,
> 07a936260 Amerigo Wang        2012-10-29  379  #if
> IS_ENABLED(CONFIG_NF_CT_NETLINK)
> fdf708322 Patrick McHardy     2007-09-28  380  	.tuple_to_nlattr
=
> icmpv6_tuple_to_nlattr,
> a400c30ed Holger Eitzenberger 2009-03-25  381  	.nlattr_tuple_size
=
> icmpv6_nlattr_tuple_size,
> fdf708322 Patrick McHardy     2007-09-28  382  	.nlattr_to_tuple
=
> icmpv6_nlattr_to_tuple,
> f73e924cd Patrick McHardy     2007-09-28  383  	.nla_policy
=
> icmpv6_nla_policy,
> c1d10adb4 Pablo Neira Ayuso   2006-01-05  384  #endif
> 509784623 Pablo Neira Ayuso   2012-02-28  385  #if
> IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
> 
> :::::: The code at line 377 was first introduced by commit
> :::::: 9fb9cbb1082d6b31fb45aa1a14432449a0df6cf1 [NETFILTER]: Add
> nf_conntrack subsystem.
> 
> :::::: TO: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> :::::: CC: David S. Miller <davem@davemloft.net>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology
> Center
> https://lists.01.org/pipermail/kbuild-all                   Intel
> Corporation


It is one bad patch.
Please ignore it.

Regards
Feng




