Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E9CC43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jun 2022 22:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354743AbiFUWhV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jun 2022 18:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354561AbiFUWhU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jun 2022 18:37:20 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B69326DF
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jun 2022 15:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655851038; x=1687387038;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qD2U96q+G+j9whYN0j6fuwqInLH36zjhWVl011UOIV4=;
  b=b9SGIbYB3eAmkNPoCKxaH0VvTbJQxf1dzTuglZIosfh7cg92W3tG3fBp
   9gHOIIj4v54h//xq7AGrLExZ+T/86CdORyP+ET4TVBWFxCZ8RA5dAly9s
   G+aiGADcInymbOCbXuVkJ8GFjVSy1GND0GDxcYz8zZm2Gt6JNXg6pi+7q
   2UCRKbjOhUz7g4LdszRMseDSx5YhspE91lEz5he0MjhlPvN9bWGP4MHnB
   lCgD7/bQV2Luox50F4ixKwU35rQhxYsKf3st4Gg2KNXMWVJJ1aI2hLuIy
   cPh7N9PPmcMeWc6tzA7L/Ufj5sjvE/N//6KEufwRigkZC4dkD2d4FEK3D
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="263289494"
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="263289494"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 15:37:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="833794367"
Received: from lkp-server02.sh.intel.com (HELO a67cc04a5eeb) ([10.239.97.151])
  by fmsmga006.fm.intel.com with ESMTP; 21 Jun 2022 15:37:17 -0700
Received: from kbuild by a67cc04a5eeb with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o3mUm-0000VQ-N5;
        Tue, 21 Jun 2022 22:37:16 +0000
Date:   Wed, 22 Jun 2022 06:36:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 3/3] netfilter: h323: merge nat hook pointers
 into one
Message-ID: <202206220643.5qOb2por-lkp@intel.com>
References: <20220621105057.24394-4-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621105057.24394-4-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

I love your patch! Yet something to improve:

[auto build test ERROR on nf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/netfilter-conntrack-sparse-annotations/20220621-185333
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
config: x86_64-rhel-8.3-func (https://download.01.org/0day-ci/archive/20220622/202206220643.5qOb2por-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/39109262d79a0c05cd090ebd94819babdf6d39a6
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Florian-Westphal/netfilter-conntrack-sparse-annotations/20220621-185333
        git checkout 39109262d79a0c05cd090ebd94819babdf6d39a6
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "get_h225_addr" [net/ipv4/netfilter/nf_nat_h323.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
