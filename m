From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [nf-next:master 16/16]
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:68:9: error: 'struct sk_buff' has no
 member named '_nfct'
Date: Thu, 11 Jan 2018 23:08:14 -0700
Message-ID: <15a034edb8c37604b166f0863c012742@codeaurora.org>
References: <201801121333.idzQ0Oyn%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Pablo Neira Ayuso <pablo@netfilter.org>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45398 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751786AbeALGIP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 01:08:15 -0500
In-Reply-To: <201801121333.idzQ0Oyn%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2018-01-11 22:10, kbuild test robot wrote:
> tree:   
> https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git 
> master
> head:   902d6a4c2a4f411582689e53fb101895ffe99028
> commit: 902d6a4c2a4f411582689e53fb101895ffe99028 [16/16] netfilter:
> nf_defrag: Skip defrag if NOTRACK is set
> config: x86_64-randconfig-it0-01121151 (attached as .config)
> compiler: gcc-7 (Debian 7.2.0-12) 7.2.1 20171025
> reproduce:
>         git checkout 902d6a4c2a4f411582689e53fb101895ffe99028
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
> 
> All error/warnings (new ones prefixed by >>):
> 
>    In file included from include/uapi/linux/swab.h:6:0,
>                     from include/linux/swab.h:5,
>                     from 
> include/uapi/linux/byteorder/little_endian.h:13,
>                     from include/linux/byteorder/little_endian.h:5,
>                     from arch/x86/include/uapi/asm/byteorder.h:5,
>                     from include/uapi/linux/ipv6.h:8,
>                     from include/linux/ipv6.h:5,
>                     from net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:10:
>    net/ipv6/netfilter/nf_defrag_ipv6_hooks.c: In function 
> 'ipv6_defrag':
>>> net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:68:9: error: 'struct 
>>> sk_buff' has no member named '_nfct'
>      if (skb->_nfct == IP_CT_UNTRACKED)

Hi Fengguang

I have sent a patch to fix this now.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
