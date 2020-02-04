Return-Path: <SRS0=DSQd=3Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99EB7C35247
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 17:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B92E2082E
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 17:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbgBDRbr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Feb 2020 12:31:47 -0500
Received: from mga03.intel.com ([134.134.136.65]:12339 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727415AbgBDRbr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Feb 2020 12:31:47 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 09:31:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,402,1574150400"; 
   d="gz'50?scan'50,208,50";a="224674122"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 04 Feb 2020 09:31:43 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iz234-00032u-Tg; Wed, 05 Feb 2020 01:31:42 +0800
Date:   Wed, 5 Feb 2020 01:31:29 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Manoj Basapathi <manojbm@codeaurora.org>
Cc:     kbuild-all@lists.01.org, netfilter-devel@vger.kernel.org,
        fw@strlen.de, pablo@netfilter.org, sharathv@qti.qualcomm.com,
        ssaha@qti.qualcomm.com, vidulak@qti.qualcomm.com,
        manojbm@qti.qualcomm.com, Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH] [nf-next v3] netfilter: xtables: Add snapshot of
 hardidletimer target
Message-ID: <202002050118.gApTSpQc%lkp@intel.com>
References: <20200204112153.24063-1-manojbm@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6ofzjhdq2daz72bh"
Content-Disposition: inline
In-Reply-To: <20200204112153.24063-1-manojbm@codeaurora.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--6ofzjhdq2daz72bh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Manoj,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on nf-next/master]
[also build test WARNING on nf/master v5.5 next-20200204]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Manoj-Basapathi/netfilter-xtables-Add-snapshot-of-hardidletimer-target/20200204-195814
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
config: m68k-multi_defconfig (attached as .config)
compiler: m68k-linux-gcc (GCC) 7.5.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.5.0 make.cross ARCH=m68k 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/linux/kernel.h:15:0,
                    from include/linux/list.h:9,
                    from include/linux/module.h:12,
                    from net/netfilter/xt_IDLETIMER.c:19:
   net/netfilter/xt_IDLETIMER.c: In function 'idletimer_tg_checkentry_v1':
>> include/linux/kern_levels.h:5:18: warning: format '%ld' expects argument of type 'long int', but argument 2 has type 'time64_t {aka long long int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/printk.h:137:10: note: in definition of macro 'no_printk'
      printk(fmt, ##__VA_ARGS__);  \
             ^~~
   include/linux/kern_levels.h:15:20: note: in expansion of macro 'KERN_SOH'
    #define KERN_DEBUG KERN_SOH "7" /* debug-level messages */
                       ^~~~~~~~
   include/linux/printk.h:341:12: note: in expansion of macro 'KERN_DEBUG'
     no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
               ^~~~~~~~~~
   net/netfilter/xt_IDLETIMER.c:376:5: note: in expansion of macro 'pr_debug'
        pr_debug("time_expiry_remaining %ld\n",
        ^~~~~~~~
--
   In file included from include/linux/kernel.h:15:0,
                    from include/linux/list.h:9,
                    from include/linux/module.h:12,
                    from net//netfilter/xt_IDLETIMER.c:19:
   net//netfilter/xt_IDLETIMER.c: In function 'idletimer_tg_checkentry_v1':
>> include/linux/kern_levels.h:5:18: warning: format '%ld' expects argument of type 'long int', but argument 2 has type 'time64_t {aka long long int}' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/printk.h:137:10: note: in definition of macro 'no_printk'
      printk(fmt, ##__VA_ARGS__);  \
             ^~~
   include/linux/kern_levels.h:15:20: note: in expansion of macro 'KERN_SOH'
    #define KERN_DEBUG KERN_SOH "7" /* debug-level messages */
                       ^~~~~~~~
   include/linux/printk.h:341:12: note: in expansion of macro 'KERN_DEBUG'
     no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
               ^~~~~~~~~~
   net//netfilter/xt_IDLETIMER.c:376:5: note: in expansion of macro 'pr_debug'
        pr_debug("time_expiry_remaining %ld\n",
        ^~~~~~~~

vim +5 include/linux/kern_levels.h

314ba3520e513a Joe Perches 2012-07-30  4  
04d2c8c83d0e3a Joe Perches 2012-07-30 @5  #define KERN_SOH	"\001"		/* ASCII Start Of Header */
04d2c8c83d0e3a Joe Perches 2012-07-30  6  #define KERN_SOH_ASCII	'\001'
04d2c8c83d0e3a Joe Perches 2012-07-30  7  

:::::: The code at line 5 was first introduced by commit
:::::: 04d2c8c83d0e3ac5f78aeede51babb3236200112 printk: convert the format for KERN_<LEVEL> to a 2 byte pattern

:::::: TO: Joe Perches <joe@perches.com>
:::::: CC: Linus Torvalds <torvalds@linux-foundation.org>

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--6ofzjhdq2daz72bh
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--6ofzjhdq2daz72bh--
