Return-Path: <SRS0=5Ubq=RV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A417FC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 08:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E0DB20811
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 08:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfCRIPy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 04:15:54 -0400
Received: from ja.ssi.bg ([178.16.129.10]:55306 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726291AbfCRIPy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 04:15:54 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x2I8EKDx008068;
        Mon, 18 Mar 2019 10:14:20 +0200
Date:   Mon, 18 Mar 2019 10:14:20 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Jacky Hu <hengqing.hu@gmail.com>
cc:     kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        jacky.hu@walmart.com, jason.niesz@walmart.com,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v4] ipvs: allow tunneling with gue encapsulation
In-Reply-To: <20190318032256.GA21124@i716>
Message-ID: <alpine.LFD.2.21.1903181000070.2986@ja.home.ssi.bg>
References: <20190317155200.16586-1-hengqing.hu@gmail.com> <201903181001.7czsRhlB%lkp@intel.com> <20190318032256.GA21124@i716>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Mon, 18 Mar 2019, Jacky Hu wrote:

> On Mon, Mar 18, 2019 at 10:10:20AM +0800, kbuild test robot wrote:
> > Hi Jacky,
> > 
> > Thank you for the patch! Perhaps something to improve:
> > 
> > [auto build test WARNING on ipvs-next/master]
> > [also build test WARNING on v5.1-rc1 next-20190306]
> > [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> > 
> > url:    https://github.com/0day-ci/linux/commits/Jacky-Hu/ipvs-allow-tunneling-with-gue-encapsulation/20190318-070156
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs-next.git master
> > reproduce:
> >         # apt-get install sparse
> >         make ARCH=x86_64 allmodconfig
> >         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> > 
> > 
> > sparse warnings: (new ones prefixed by >>)
> > 
> >    net/netfilter/ipvs/ip_vs_ctl.c:835:42: sparse: incorrect type in argument 2 (different base types) @@    expected int [signed] i @@    got restricted __be1int [signed] i @@
> >    net/netfilter/ipvs/ip_vs_ctl.c:835:42:    expected int [signed] i
> >    net/netfilter/ipvs/ip_vs_ctl.c:835:42:    got restricted __be16 [usertype] tun_port
> >    net/netfilter/ipvs/ip_vs_ctl.c:1197:44: sparse: expression using sizeof(void)
> > >> net/netfilter/ipvs/ip_vs_ctl.c:3207:37: sparse: incorrect type in argument 3 (different base types) @@    expected restricted __be16 [usertype] value @@    got e] value @@
> >    net/netfilter/ipvs/ip_vs_ctl.c:3207:37:    expected restricted __be16 [usertype] value
> >    net/netfilter/ipvs/ip_vs_ctl.c:3207:37:    got int
> >    net/netfilter/ipvs/ip_vs_ctl.c:1313:27: sparse: dereference of noderef expression
> > 
> > vim +3207 net/netfilter/ipvs/ip_vs_ctl.c
> > 

> > > 3207				 atomic_read(&dest->tun_port)) ||
> 
>     Should I change the type of tun_port from __be16 to u16?
>     Looks like kbuild bugs a lot on this.

	In struct ip_vs_dest you should use __be16 for tun_port and
__u16 for tun_type and avoid any atomic_t usage. To test it with sparse:

make C=2 CF="-D__CHECK_ENDIAN__" net/netfilter/ipvs/

	And this is the only problem in v4 of the patch. Then may be
you should wait when net-next opens again before submitting v5.

Regards

--
Julian Anastasov <ja@ssi.bg>
