Return-Path: <SRS0=iSAz=WD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E57C433FF
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 15:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C03A21E73
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 15:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388630AbfHGP2l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Aug 2019 11:28:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:56763 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387827AbfHGP2k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Aug 2019 11:28:40 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 08:28:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,357,1559545200"; 
   d="scan'208";a="198701426"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 07 Aug 2019 08:28:39 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hvNri-00080X-Kl; Wed, 07 Aug 2019 23:28:38 +0800
Date:   Wed, 7 Aug 2019 23:27:52 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     kbuild-all@01.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3] netfilter: nft_meta: support for time matching
Message-ID: <201908072207.PfTHrUGc%lkp@intel.com>
References: <20190802071233.5580-1-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802071233.5580-1-a@juaristi.eus>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Ander,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[cannot apply to v5.3-rc3 next-20190807]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Ander-Juaristi/netfilter-nft_meta-support-for-time-matching/20190804-141253
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   include/linux/sched.h:609:43: sparse: sparse: bad integer constant expression
   include/linux/sched.h:609:73: sparse: sparse: invalid named zero-width bitfield `value'
   include/linux/sched.h:610:43: sparse: sparse: bad integer constant expression
   include/linux/sched.h:610:67: sparse: sparse: invalid named zero-width bitfield `bucket_id'
   net/bridge/netfilter/nft_meta_bridge.c:41:14: sparse: sparse: undefined identifier 'NFT_META_BRI_IIFPVID'
   net/bridge/netfilter/nft_meta_bridge.c:52:14: sparse: sparse: undefined identifier 'NFT_META_BRI_IIFVPROTO'
>> net/bridge/netfilter/nft_meta_bridge.c:41:14: sparse: sparse: incompatible types for 'case' statement
   net/bridge/netfilter/nft_meta_bridge.c:52:14: sparse: sparse: incompatible types for 'case' statement
   net/bridge/netfilter/nft_meta_bridge.c:88:14: sparse: sparse: undefined identifier 'NFT_META_BRI_IIFPVID'
   net/bridge/netfilter/nft_meta_bridge.c:89:14: sparse: sparse: undefined identifier 'NFT_META_BRI_IIFVPROTO'
   net/bridge/netfilter/nft_meta_bridge.c:88:14: sparse: sparse: incompatible types for 'case' statement
   net/bridge/netfilter/nft_meta_bridge.c:89:14: sparse: sparse: incompatible types for 'case' statement
   net/bridge/netfilter/nft_meta_bridge.c:41:14: sparse: sparse: Expected constant expression in case statement
   net/bridge/netfilter/nft_meta_bridge.c:52:14: sparse: sparse: Expected constant expression in case statement
   net/bridge/netfilter/nft_meta_bridge.c:88:14: sparse: sparse: Expected constant expression in case statement
   net/bridge/netfilter/nft_meta_bridge.c:89:14: sparse: sparse: Expected constant expression in case statement

vim +/case +41 net/bridge/netfilter/nft_meta_bridge.c

30e103fe24debc wenxu 2019-07-05  20  
30e103fe24debc wenxu 2019-07-05  21  static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
30e103fe24debc wenxu 2019-07-05  22  				     struct nft_regs *regs,
30e103fe24debc wenxu 2019-07-05  23  				     const struct nft_pktinfo *pkt)
30e103fe24debc wenxu 2019-07-05  24  {
30e103fe24debc wenxu 2019-07-05  25  	const struct nft_meta *priv = nft_expr_priv(expr);
30e103fe24debc wenxu 2019-07-05  26  	const struct net_device *in = nft_in(pkt), *out = nft_out(pkt);
30e103fe24debc wenxu 2019-07-05  27  	u32 *dest = &regs->data[priv->dreg];
9d6a1ecdc99717 wenxu 2019-07-05  28  	const struct net_device *br_dev;
30e103fe24debc wenxu 2019-07-05  29  
30e103fe24debc wenxu 2019-07-05  30  	switch (priv->key) {
30e103fe24debc wenxu 2019-07-05  31  	case NFT_META_BRI_IIFNAME:
9d6a1ecdc99717 wenxu 2019-07-05  32  		br_dev = nft_meta_get_bridge(in);
9d6a1ecdc99717 wenxu 2019-07-05  33  		if (!br_dev)
30e103fe24debc wenxu 2019-07-05  34  			goto err;
30e103fe24debc wenxu 2019-07-05  35  		break;
30e103fe24debc wenxu 2019-07-05  36  	case NFT_META_BRI_OIFNAME:
9d6a1ecdc99717 wenxu 2019-07-05  37  		br_dev = nft_meta_get_bridge(out);
9d6a1ecdc99717 wenxu 2019-07-05  38  		if (!br_dev)
30e103fe24debc wenxu 2019-07-05  39  			goto err;
30e103fe24debc wenxu 2019-07-05  40  		break;
c54c7c685494fc wenxu 2019-07-05 @41  	case NFT_META_BRI_IIFPVID: {
c54c7c685494fc wenxu 2019-07-05  42  		u16 p_pvid;
c54c7c685494fc wenxu 2019-07-05  43  
c54c7c685494fc wenxu 2019-07-05  44  		br_dev = nft_meta_get_bridge(in);
c54c7c685494fc wenxu 2019-07-05  45  		if (!br_dev || !br_vlan_enabled(br_dev))
c54c7c685494fc wenxu 2019-07-05  46  			goto err;
c54c7c685494fc wenxu 2019-07-05  47  
c54c7c685494fc wenxu 2019-07-05  48  		br_vlan_get_pvid_rcu(in, &p_pvid);
c54c7c685494fc wenxu 2019-07-05  49  		nft_reg_store16(dest, p_pvid);
c54c7c685494fc wenxu 2019-07-05  50  		return;
c54c7c685494fc wenxu 2019-07-05  51  	}
2a3a93ef0ba516 wenxu 2019-07-05  52  	case NFT_META_BRI_IIFVPROTO: {
2a3a93ef0ba516 wenxu 2019-07-05  53  		u16 p_proto;
2a3a93ef0ba516 wenxu 2019-07-05  54  
2a3a93ef0ba516 wenxu 2019-07-05  55  		br_dev = nft_meta_get_bridge(in);
2a3a93ef0ba516 wenxu 2019-07-05  56  		if (!br_dev || !br_vlan_enabled(br_dev))
2a3a93ef0ba516 wenxu 2019-07-05  57  			goto err;
2a3a93ef0ba516 wenxu 2019-07-05  58  
2a3a93ef0ba516 wenxu 2019-07-05  59  		br_vlan_get_proto(br_dev, &p_proto);
2a3a93ef0ba516 wenxu 2019-07-05  60  		nft_reg_store16(dest, p_proto);
2a3a93ef0ba516 wenxu 2019-07-05  61  		return;
2a3a93ef0ba516 wenxu 2019-07-05  62  	}
30e103fe24debc wenxu 2019-07-05  63  	default:
30e103fe24debc wenxu 2019-07-05  64  		goto out;
30e103fe24debc wenxu 2019-07-05  65  	}
30e103fe24debc wenxu 2019-07-05  66  
9d6a1ecdc99717 wenxu 2019-07-05  67  	strncpy((char *)dest, br_dev->name, IFNAMSIZ);
30e103fe24debc wenxu 2019-07-05  68  	return;
30e103fe24debc wenxu 2019-07-05  69  out:
30e103fe24debc wenxu 2019-07-05  70  	return nft_meta_get_eval(expr, regs, pkt);
30e103fe24debc wenxu 2019-07-05  71  err:
30e103fe24debc wenxu 2019-07-05  72  	regs->verdict.code = NFT_BREAK;
30e103fe24debc wenxu 2019-07-05  73  }
30e103fe24debc wenxu 2019-07-05  74  

:::::: The code at line 41 was first introduced by commit
:::::: c54c7c685494fc0f1662091d4d0c4fc26e810471 netfilter: nft_meta_bridge: add NFT_META_BRI_IIFPVID support

:::::: TO: wenxu <wenxu@ucloud.cn>
:::::: CC: Pablo Neira Ayuso <pablo@netfilter.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
