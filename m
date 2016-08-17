From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH v3] netfilter: nft_numgen: add number generator expression
Date: Wed, 17 Aug 2016 15:59:53 +0200
Message-ID: <20160817135951.GA21214@sonyv>
References: <20160813223941.GA11051@sonyv>
 <201608142357.TpQNQHIT%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35528 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbcHQN75 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 09:59:57 -0400
Received: by mail-wm0-f65.google.com with SMTP id i5so24472860wmg.2
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 06:59:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <201608142357.TpQNQHIT%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 15, 2016 at 12:03:19AM +0800, kbuild test robot wrote:
> Hi Laura,
> 
> [auto build test ERROR on nf-next/master]
> [also build test ERROR on v4.8-rc1 next-20160812]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Laura-Garcia-Liebana/netfilter-nft_numgen-add-number-generator-expression/20160814-185132
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
> config: i386-allyesconfig (attached as .config)
> compiler: gcc-6 (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
> >> net/netfilter/nft_numgen.o:(.discard+0x0): multiple definition of `__pcpu_unique_nft_prandom_state'
>    net/netfilter/nft_meta.o:(.discard+0x0): first defined here
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

Hi, I've been compiling with several options like:

CONFIG_NFT_META=m
CONFIG_NFT_NUMGEN=m

and

CONFIG_NFT_META=y
CONFIG_NFT_NUMGEN=y

but I was unable to reproduce it.

Anyway, I'll rename the identifier in a new patch.

Thanks.

