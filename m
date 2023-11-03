Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A66C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 09:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347285AbjKCJqt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 05:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347166AbjKCJqs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 05:46:48 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E297F1BD;
        Fri,  3 Nov 2023 02:46:42 -0700 (PDT)
Received: from [78.30.35.151] (port=36732 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qyql9-00EApA-Ix; Fri, 03 Nov 2023 10:46:39 +0100
Date:   Fri, 3 Nov 2023 10:46:34 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Florian Westphal <fw@strlen.de>, oe-kbuild-all@lists.linux.dev,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: net/netfilter/nft_set_rbtree.c:636:33: warning: variable
 'nft_net' set but not used
Message-ID: <ZUTBegMOO36wC4mH@calendula>
References: <202311031627.Kx0hfrUu-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202311031627.Kx0hfrUu-lkp@intel.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 03, 2023 at 04:40:55PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   8f6f76a6a29f36d2f3e4510d0bde5046672f6924
> commit: 7d259f021aaa78904b6c836d975e8e00d83a182a netfilter: nft_set_rbtree: prefer sync gc to async worker
> date:   10 days ago
> config: s390-defconfig (https://download.01.org/0day-ci/archive/20231103/202311031627.Kx0hfrUu-lkp@intel.com/config)
> compiler: s390-linux-gcc (GCC) 13.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231103/202311031627.Kx0hfrUu-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202311031627.Kx0hfrUu-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    net/netfilter/nft_set_rbtree.c: In function 'nft_rbtree_gc':
> >> net/netfilter/nft_set_rbtree.c:636:33: warning: variable 'nft_net' set but not used [-Wunused-but-set-variable]
>      636 |         struct nftables_pernet *nft_net;
>          |                                 ^~~~~~~

Fix is here.

It is missing Fixes: tag though.

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20231101013351.55902-1-yang.lee@linux.alibaba.com/
