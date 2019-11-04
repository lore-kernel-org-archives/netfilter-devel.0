Return-Path: <SRS0=62bg=Y4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 267E7CA9EA0
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Nov 2019 12:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2790222C2
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Nov 2019 12:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfKDM16 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Nov 2019 07:27:58 -0500
Received: from mga03.intel.com ([134.134.136.65]:58502 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727332AbfKDM16 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Nov 2019 07:27:58 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 04:27:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,267,1569308400"; 
   d="scan'208";a="376321440"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 04 Nov 2019 04:27:56 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iRbSe-000AAE-69; Mon, 04 Nov 2019 20:27:56 +0800
Date:   Mon, 4 Nov 2019 20:27:11 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kbuild-all@lists.01.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables_offload: pass extack to
 nft_flow_cls_offload_setup()
Message-ID: <201911042000.sDYuFIQa%lkp@intel.com>
References: <20191102142805.25340-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191102142805.25340-1-pablo@netfilter.org>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

I love your patch! Perhaps something to improve:

[auto build test WARNING on nf-next/master]

url:    https://github.com/0day-ci/linux/commits/Pablo-Neira-Ayuso/netfilter-nf_tables_offload-pass-extack-to-nft_flow_cls_offload_setup/20191103-115127
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-6-g57f8611-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   net/netfilter/nf_tables_offload.c:165:24: sparse: sparse: incorrect type in initializer (different base types) @@    expected restricted __be16 [usertype] proto @@    got e] proto @@
   net/netfilter/nf_tables_offload.c:165:24: sparse:    expected restricted __be16 [usertype] proto
   net/netfilter/nf_tables_offload.c:165:24: sparse:    got int
>> net/netfilter/nf_tables_offload.c:218:17: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected void *s @@    got struct netlink_exvoid *s @@
>> net/netfilter/nf_tables_offload.c:218:17: sparse:    expected void *s
>> net/netfilter/nf_tables_offload.c:218:17: sparse:    got struct netlink_ext_ack extack

vim +218 net/netfilter/nf_tables_offload.c

   157	
   158	static void nft_flow_cls_offload_setup(struct flow_cls_offload *cls_flow,
   159					       const struct nft_base_chain *basechain,
   160					       const struct nft_rule *rule,
   161					       const struct nft_flow_rule *flow,
   162					       struct netlink_ext_ack *extack,
   163					       enum flow_cls_command command)
   164	{
 > 165		__be16 proto = ETH_P_ALL;
   166	
   167		memset(cls_flow, 0, sizeof(*cls_flow));
   168	
   169		if (flow)
   170			proto = flow->proto;
   171	
   172		nft_flow_offload_common_init(&cls_flow->common, proto,
   173					     basechain->ops.priority, extack);
   174		cls_flow->command = command;
   175		cls_flow->cookie = (unsigned long) rule;
   176		if (flow)
   177			cls_flow->rule = flow->rule;
   178	}
   179	
   180	static int nft_flow_offload_rule(struct nft_chain *chain,
   181					 struct nft_rule *rule,
   182					 struct nft_flow_rule *flow,
   183					 enum flow_cls_command command)
   184	{
   185		struct netlink_ext_ack extack = {};
   186		struct flow_cls_offload cls_flow;
   187		struct nft_base_chain *basechain;
   188	
   189		if (!nft_is_base_chain(chain))
   190			return -EOPNOTSUPP;
   191	
   192		basechain = nft_base_chain(chain);
   193		nft_flow_cls_offload_setup(&cls_flow, basechain, rule, flow, &extack,
   194					   command);
   195	
   196		return nft_setup_cb_call(TC_SETUP_CLSFLOWER, &cls_flow,
   197					 &basechain->flow_block.cb_list);
   198	}
   199	
   200	static int nft_flow_offload_bind(struct flow_block_offload *bo,
   201					 struct nft_base_chain *basechain)
   202	{
   203		list_splice(&bo->cb_list, &basechain->flow_block.cb_list);
   204		return 0;
   205	}
   206	
   207	static int nft_flow_offload_unbind(struct flow_block_offload *bo,
   208					   struct nft_base_chain *basechain)
   209	{
   210		struct flow_block_cb *block_cb, *next;
   211		struct flow_cls_offload cls_flow;
   212		struct netlink_ext_ack extack;
   213		struct nft_chain *chain;
   214		struct nft_rule *rule;
   215	
   216		chain = &basechain->chain;
   217		list_for_each_entry(rule, &chain->rules, list) {
 > 218			memset(extack, 0, sizeof(extack));
   219			nft_flow_cls_offload_setup(&cls_flow, basechain, rule, NULL,
   220						   &extack, FLOW_CLS_DESTROY);
   221			nft_setup_cb_call(TC_SETUP_CLSFLOWER, &cls_flow, &bo->cb_list);
   222		}
   223	
   224		list_for_each_entry_safe(block_cb, next, &bo->cb_list, list) {
   225			list_del(&block_cb->list);
   226			flow_block_cb_free(block_cb);
   227		}
   228	
   229		return 0;
   230	}
   231	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
