Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E5AC4CECE
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 02:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5648B217F9
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 02:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfJOC7M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Oct 2019 22:59:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:43743 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727518AbfJOC7L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Oct 2019 22:59:11 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 19:59:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,297,1566889200"; 
   d="scan'208";a="279052276"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 14 Oct 2019 19:59:10 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iKD3F-000IMy-HF; Tue, 15 Oct 2019 10:59:09 +0800
Date:   Tue, 15 Oct 2019 10:58:28 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     kbuild-all@lists.01.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: don't dump ct extensions
 of unconfirmed conntracks
Message-ID: <201910151009.uhMi8FzL%lkp@intel.com>
References: <20191014194141.17626-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014194141.17626-1-fw@strlen.de>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

I love your patch! Perhaps something to improve:

[auto build test WARNING on nf-next/master]

url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/netfilter-ctnetlink-don-t-dump-ct-extensions-of-unconfirmed-conntracks/20191015-040005
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-43-g0ccb3b4-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> net/netfilter/nf_conntrack_netlink.c:520:44: sparse: sparse: incorrect type in argument 2 (different modifiers) @@    expected struct nf_conn *ct @@    got structstruct nf_conn *ct @@
>> net/netfilter/nf_conntrack_netlink.c:520:44: sparse:    expected struct nf_conn *ct
>> net/netfilter/nf_conntrack_netlink.c:520:44: sparse:    got struct nf_conn const *ct
   net/netfilter/nf_conntrack_netlink.c:521:45: sparse: sparse: incorrect type in argument 2 (different modifiers) @@    expected struct nf_conn *ct @@    got structstruct nf_conn *ct @@
   net/netfilter/nf_conntrack_netlink.c:521:45: sparse:    expected struct nf_conn *ct
   net/netfilter/nf_conntrack_netlink.c:521:45: sparse:    got struct nf_conn const *ct
   net/netfilter/nf_conntrack_netlink.c:1694:34: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nf_conntrack_netlink.c:1694:34: sparse:    struct nf_conntrack_helper [noderef] <asn:4> *
   net/netfilter/nf_conntrack_netlink.c:1694:34: sparse:    struct nf_conntrack_helper *
   net/netfilter/nf_conntrack_netlink.c:3146:29: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected char const * @@    got char [noderechar const * @@
   net/netfilter/nf_conntrack_netlink.c:3146:29: sparse:    expected char const *
   net/netfilter/nf_conntrack_netlink.c:3146:29: sparse:    got char [noderef] <asn:4> *
   net/netfilter/nf_conntrack_netlink.c:951:36: sparse: sparse: context imbalance in 'ctnetlink_dump_table' - unexpected unlock
   include/linux/rcupdate.h:651:9: sparse: sparse: context imbalance in 'ctnetlink_parse_nat_setup' - unexpected unlock

vim +520 net/netfilter/nf_conntrack_netlink.c

   508	
   509	/* all these functions access ct->ext. Caller must either hold a reference
   510	 * on ct or prevent its deletion by holding either the bucket spinlock or
   511	 * pcpu dying list lock.
   512	 */
   513	static int ctnetlink_dump_extinfo(struct sk_buff *skb,
   514					  const struct nf_conn *ct, u32 type)
   515	{
   516		if (ctnetlink_dump_acct(skb, ct, type) < 0 ||
   517		    ctnetlink_dump_timestamp(skb, ct) < 0 ||
   518		    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
   519		    ctnetlink_dump_labels(skb, ct) < 0 ||
 > 520		    ctnetlink_dump_ct_seq_adj(skb, ct) < 0 ||
   521		    ctnetlink_dump_ct_synproxy(skb, ct) < 0)
   522			return -1;
   523	
   524		return 0;
   525	}
   526	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
