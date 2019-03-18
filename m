Return-Path: <SRS0=5Ubq=RV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC2FCC4360F
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 02:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAFD720857
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 02:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfCRCKs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 Mar 2019 22:10:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:41962 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726906AbfCRCKs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Mar 2019 22:10:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Mar 2019 19:10:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,491,1544515200"; 
   d="scan'208";a="152578102"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 17 Mar 2019 19:10:47 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1h5hjg-0009Ya-TU; Mon, 18 Mar 2019 10:10:44 +0800
Date:   Mon, 18 Mar 2019 10:10:20 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Jacky Hu <hengqing.hu@gmail.com>
Cc:     kbuild-all@01.org, hengqing.hu@gmail.com, jacky.hu@walmart.com,
        jason.niesz@walmart.com, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v4] ipvs: allow tunneling with gue encapsulation
Message-ID: <201903181001.7czsRhlB%lkp@intel.com>
References: <20190317155200.16586-1-hengqing.hu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190317155200.16586-1-hengqing.hu@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jacky,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on ipvs-next/master]
[also build test WARNING on v5.1-rc1 next-20190306]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Jacky-Hu/ipvs-allow-tunneling-with-gue-encapsulation/20190318-070156
base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs-next.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'


sparse warnings: (new ones prefixed by >>)

   net/netfilter/ipvs/ip_vs_ctl.c:835:42: sparse: incorrect type in argument 2 (different base types) @@    expected int [signed] i @@    got restricted __be1int [signed] i @@
   net/netfilter/ipvs/ip_vs_ctl.c:835:42:    expected int [signed] i
   net/netfilter/ipvs/ip_vs_ctl.c:835:42:    got restricted __be16 [usertype] tun_port
   net/netfilter/ipvs/ip_vs_ctl.c:1197:44: sparse: expression using sizeof(void)
>> net/netfilter/ipvs/ip_vs_ctl.c:3207:37: sparse: incorrect type in argument 3 (different base types) @@    expected restricted __be16 [usertype] value @@    got e] value @@
   net/netfilter/ipvs/ip_vs_ctl.c:3207:37:    expected restricted __be16 [usertype] value
   net/netfilter/ipvs/ip_vs_ctl.c:3207:37:    got int
   net/netfilter/ipvs/ip_vs_ctl.c:1313:27: sparse: dereference of noderef expression

vim +3207 net/netfilter/ipvs/ip_vs_ctl.c

  3187	
  3188	static int ip_vs_genl_fill_dest(struct sk_buff *skb, struct ip_vs_dest *dest)
  3189	{
  3190		struct nlattr *nl_dest;
  3191		struct ip_vs_kstats kstats;
  3192	
  3193		nl_dest = nla_nest_start(skb, IPVS_CMD_ATTR_DEST);
  3194		if (!nl_dest)
  3195			return -EMSGSIZE;
  3196	
  3197		if (nla_put(skb, IPVS_DEST_ATTR_ADDR, sizeof(dest->addr), &dest->addr) ||
  3198		    nla_put_be16(skb, IPVS_DEST_ATTR_PORT, dest->port) ||
  3199		    nla_put_u32(skb, IPVS_DEST_ATTR_FWD_METHOD,
  3200				(atomic_read(&dest->conn_flags) &
  3201				 IP_VS_CONN_F_FWD_MASK)) ||
  3202		    nla_put_u32(skb, IPVS_DEST_ATTR_WEIGHT,
  3203				atomic_read(&dest->weight)) ||
  3204		    nla_put_u8(skb, IPVS_DEST_ATTR_TUN_TYPE,
  3205			       atomic_read(&dest->tun_type)) ||
  3206		    nla_put_be16(skb, IPVS_DEST_ATTR_TUN_PORT,
> 3207				 atomic_read(&dest->tun_port)) ||
  3208		    nla_put_u32(skb, IPVS_DEST_ATTR_U_THRESH, dest->u_threshold) ||
  3209		    nla_put_u32(skb, IPVS_DEST_ATTR_L_THRESH, dest->l_threshold) ||
  3210		    nla_put_u32(skb, IPVS_DEST_ATTR_ACTIVE_CONNS,
  3211				atomic_read(&dest->activeconns)) ||
  3212		    nla_put_u32(skb, IPVS_DEST_ATTR_INACT_CONNS,
  3213				atomic_read(&dest->inactconns)) ||
  3214		    nla_put_u32(skb, IPVS_DEST_ATTR_PERSIST_CONNS,
  3215				atomic_read(&dest->persistconns)) ||
  3216		    nla_put_u16(skb, IPVS_DEST_ATTR_ADDR_FAMILY, dest->af))
  3217			goto nla_put_failure;
  3218		ip_vs_copy_stats(&kstats, &dest->stats);
  3219		if (ip_vs_genl_fill_stats(skb, IPVS_DEST_ATTR_STATS, &kstats))
  3220			goto nla_put_failure;
  3221		if (ip_vs_genl_fill_stats64(skb, IPVS_DEST_ATTR_STATS64, &kstats))
  3222			goto nla_put_failure;
  3223	
  3224		nla_nest_end(skb, nl_dest);
  3225	
  3226		return 0;
  3227	
  3228	nla_put_failure:
  3229		nla_nest_cancel(skb, nl_dest);
  3230		return -EMSGSIZE;
  3231	}
  3232	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
