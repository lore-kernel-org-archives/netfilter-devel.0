From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH v3] netfilter: nf_tables: Ensure init attributes are
 within the bounds
Date: Mon, 22 Aug 2016 11:17:40 +0200
Message-ID: <20160822091739.GA8984@sonyv>
References: <20160818114521.GA32566@sonyv>
 <201608221704.lvYxjLQL%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35102 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750892AbcHVJRo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 05:17:44 -0400
Received: by mail-wm0-f68.google.com with SMTP id i5so12495042wmg.2
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 02:17:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <201608221704.lvYxjLQL%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 22, 2016 at 05:10:02PM +0800, kbuild test robot wrote:
> Hi Laura,
> 
> [auto build test ERROR on nf-next/master]
> [also build test ERROR on v4.8-rc3 next-20160822]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> [Suggest to use git(>=2.9.0) format-patch --base=<commit> (or --base=auto for convenience) to record what (public, well-known) commit your patch series was built on]
> [Check https://git-scm.com/docs/git-format-patch for more information]
> 
> url:    https://github.com/0day-ci/linux/commits/Laura-Garcia-Liebana/netfilter-nf_tables-Ensure-init-attributes-are-within-the-bounds/20160818-194709
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
> config: x86_64-rhel (attached as .config)
> compiler: gcc-6 (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    net/netfilter/nft_cmp.c: In function 'nft_cmp_init':
> >> net/netfilter/nft_cmp.c:91:18: error: 'NFT_CMP_MAX' undeclared (first use in this function)
>      if (priv->op >= NFT_CMP_MAX)
>                      ^~~~~~~~~~~
>    net/netfilter/nft_cmp.c:91:18: note: each undeclared identifier is reported only once for each function it appears in
> 
> vim +/NFT_CMP_MAX +91 net/netfilter/nft_cmp.c
> 
>     85			return err;
>     86	
>     87		if (desc.len > U8_MAX)
>     88			return -ERANGE;
>     89		priv->len = desc.len;
>     90		priv->op  = ntohl(nla_get_be32(tb[NFTA_CMP_OP]));
>   > 91		if (priv->op >= NFT_CMP_MAX)
>     92			return -ERANGE;
>     93	
>     94		return 0;
>

A later patch version (v4) was sent to fix that.

Thanks.

> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation


