From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH nf-next] netfilter: meta: secpath support
Date: Wed, 13 Dec 2017 15:16:22 +0800
Message-ID: <201712131306.izdruXUk%fengguang.wu@intel.com>
References: <20171201124021.20973-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:3360 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753263AbdLMPV2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Dec 2017 10:21:28 -0500
Content-Disposition: inline
In-Reply-To: <20171201124021.20973-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

I love your patch! Perhaps something to improve:

[auto build test WARNING on nf-next/master]

url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/netfilter-meta-secpath-support/20171204-124857
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)


Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
