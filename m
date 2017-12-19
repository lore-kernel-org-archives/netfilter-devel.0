From: kbuild test robot <fengguang.wu@intel.com>
Subject: [nf-next:for-net-next3 28/40] net/netfilter/core.c:403:6: sparse:
 symbol '__nf_unregister_net_hook' was not declared. Should it be static?
Date: Wed, 20 Dec 2017 01:25:40 +0800
Message-ID: <201712200120.UwkYYVXx%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:44783 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750798AbdLSR0d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Dec 2017 12:26:33 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git for-net-next3
head:   dfbb1c16489ca1b93e3f8aebc74d9229f1d87cc6
commit: ac119d8cd0892526ea8c6c7ed30dce0ea75b1b03 [28/40] netfilter: core: support for NFPROTO_INET hook registration
reproduce:
        # apt-get install sparse
        git checkout ac119d8cd0892526ea8c6c7ed30dce0ea75b1b03
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)


Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
