From: kbuild test robot <fengguang.wu@intel.com>
Subject: [nf-next:for-net-next3 32/40] net/netfilter/nf_conncount.c:74:9-10:
 WARNING: return of 0/1 in function 'already_closed' with return type bool
Date: Wed, 20 Dec 2017 01:46:41 +0800
Message-ID: <201712200137.1Bakdeow%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:35519 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750825AbdLSRrp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Dec 2017 12:47:45 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git for-net-next3
head:   dfbb1c16489ca1b93e3f8aebc74d9229f1d87cc6
commit: 61b781a5a0bb7fcbbb3be316271fccf59915e3b0 [32/40] netfilter: connlimit: split xt_connlimit into front and backend


coccinelle warnings: (new ones prefixed by >>)

>> net/netfilter/nf_conncount.c:74:9-10: WARNING: return of 0/1 in function 'already_closed' with return type bool
--
>> net/netfilter/xt_connlimit.c:96:1-3: WARNING: PTR_ERR_OR_ZERO can be used

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
