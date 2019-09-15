Return-Path: <SRS0=dRBk=XK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A53C4CECC
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Sep 2019 16:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B236214D8
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Sep 2019 16:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbfIOQFW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Sep 2019 12:05:22 -0400
Received: from mga06.intel.com ([134.134.136.31]:14875 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730825AbfIOQFW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Sep 2019 12:05:22 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 09:05:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,509,1559545200"; 
   d="scan'208";a="186947704"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 15 Sep 2019 09:05:20 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1i9X1b-000J6h-Tc; Mon, 16 Sep 2019 00:05:19 +0800
Date:   Mon, 16 Sep 2019 00:04:28 +0800
From:   kbuild test robot <lkp@intel.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [nf-next:master 7/27] net/netfilter/nf_tables_offload.c:316
 nft_flow_offload_chain() warn: always true condition '(policy != -1) =>
 (0-255 != (-1))'
Message-ID: <201909160022.dXjOfKz9%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/pablo/nf-next.git master
head:   0d32e7048d927418300b9f5415ca546e44621ef1
commit: 8fc618c52d163baa7ae020e4c92474159b6006b7 [7/27] netfilter: nf_tables_offload: refactor the nft_flow_offload_chain function

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

New smatch warnings:
net/netfilter/nf_tables_offload.c:316 nft_flow_offload_chain() warn: always true condition '(policy != -1) => (0-255 != (-1))'

Old smatch warnings:
include/linux/compiler.h:226 __write_once_size() warn: potential memory corrupting cast 8 vs 4 bytes

vim +316 net/netfilter/nf_tables_offload.c

   296	
   297	static int nft_flow_offload_chain(struct nft_chain *chain,
   298					  u8 *ppolicy,
   299					  enum flow_block_command cmd)
   300	{
   301		struct nft_base_chain *basechain;
   302		struct net_device *dev;
   303		u8 policy;
   304	
   305		if (!nft_is_base_chain(chain))
   306			return -EOPNOTSUPP;
   307	
   308		basechain = nft_base_chain(chain);
   309		dev = basechain->ops.dev;
   310		if (!dev)
   311			return -EOPNOTSUPP;
   312	
   313		policy = ppolicy ? *ppolicy : basechain->policy;
   314	
   315		/* Only default policy to accept is supported for now. */
 > 316		if (cmd == FLOW_BLOCK_BIND && policy != -1 && policy != NF_ACCEPT)
   317			return -EOPNOTSUPP;
   318	
   319		if (dev->netdev_ops->ndo_setup_tc)
   320			return nft_block_offload_cmd(basechain, dev, cmd);
   321		else
   322			return nft_indr_block_offload_cmd(basechain, dev, cmd);
   323	}
   324	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
