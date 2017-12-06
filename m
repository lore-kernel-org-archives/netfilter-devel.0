From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next:master 14/14] net/bridge/br_netfilter_hooks.c:994:30:
 error: 'struct netns_nf' has no member named 'hooks_bridge'; did you mean
 'hooks_ipv4'?
Date: Wed, 6 Dec 2017 19:12:25 +0100
Message-ID: <20171206181225.GA1681@salvia>
References: <201712070130.XynY7vJw%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, kbuild-all@01.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46178 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752151AbdLFSMb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Dec 2017 13:12:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F40101B8413
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2017 19:12:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E57A7DA80E
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2017 19:12:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <201712070130.XynY7vJw%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Thu, Dec 07, 2017 at 01:59:32AM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
> head:   bcbfcb63a93704140d66f49b6f7d783988f37b4e
> commit: bcbfcb63a93704140d66f49b6f7d783988f37b4e [14/14] netfilter: reduce hook array sizes to what is needed
> config: i386-randconfig-x002-201749 (attached as .config)
> compiler: gcc-7 (Debian 7.2.0-12) 7.2.1 20171025
> reproduce:
>         git checkout bcbfcb63a93704140d66f49b6f7d783988f37b4e
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    In file included from include/linux/srcu.h:33:0,
>                     from include/linux/notifier.h:16,
>                     from include/linux/memory_hotplug.h:7,
>                     from include/linux/mmzone.h:780,
>                     from include/linux/gfp.h:6,
>                     from include/linux/umh.h:4,
>                     from include/linux/kmod.h:22,
>                     from include/linux/module.h:13,
>                     from net/bridge/br_netfilter_hooks.c:17:
>    net/bridge/br_netfilter_hooks.c: In function 'br_nf_hook_thresh':
> >> net/bridge/br_netfilter_hooks.c:994:30: error: 'struct netns_nf' has no member named 'hooks_bridge'; did you mean 'hooks_ipv4'?
>      e = rcu_dereference(net->nf.hooks_bridge[hook]);
>                                  ^

I'm going to toss this patch from nf-next, will trigger a rebase,
please take the time to review this.

Thanks.
