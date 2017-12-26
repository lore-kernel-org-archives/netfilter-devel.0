From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH V4 5/5] netfilter: nf_nat_snmp_basic: use asn1 decoder
 library
Date: Tue, 26 Dec 2017 11:25:56 +0800
Message-ID: <201712261131.qSbH31MC%fengguang.wu@intel.com>
References: <20171225150046.4227-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, ap420073@gmail.com
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:44616 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750810AbdLZD3s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Dec 2017 22:29:48 -0500
Content-Disposition: inline
In-Reply-To: <20171225150046.4227-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Taehee,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on nf-next/master]
[also build test WARNING on v4.15-rc5 next-20171222]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Taehee-Yoo/netfilter-nf_nat_snmp_basic-use-ASN-1-decoder/20171226-091030
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
