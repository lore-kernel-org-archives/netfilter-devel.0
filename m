From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: conntrack: allow increasing bucket
 size via sysctl too
Date: Wed, 25 May 2016 12:04:50 +0200
Message-ID: <20160525100450.GA22288@breakpoint.cc>
References: <1463334309-8685-1-git-send-email-fw@strlen.de>
 <201605251426.gLgNgu5U%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, kbuild-all@01.org,
	netfilter-devel@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59649 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769AbcEYKE6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2016 06:04:58 -0400
Content-Disposition: inline
In-Reply-To: <201605251426.gLgNgu5U%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

kbuild test robot <lkp@intel.com> wrote:
> url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/netfilter-conntrack-allow-increasing-bucket-size-via-sysctl-too/20160516-014623
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next master
> config: x86_64-randconfig-n0-05251422 (attached as .config)
> compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> Note: the linux-review/Florian-Westphal/netfilter-conntrack-allow-increasing-bucket-size-via-sysctl-too/20160516-014623 HEAD 5f39f4af5e5d9cf4d678faa29015e6aa5b89513d builds fine.
>       It only hurts bisectibility.
> 
> All errors (new ones prefixed by >>):
> 
>    net/netfilter/nf_conntrack_standalone.c: In function 'nf_conntrack_standalone_init':
> >> net/netfilter/nf_conntrack_standalone.c:640:2: error: 'nf_conntrack_htable_size_user' undeclared (first use in this function)
>      nf_conntrack_htable_size_user = nf_conntrack_htable_size;
>      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    net/netfilter/nf_conntrack_standalone.c:640:2: note: each undeclared identifier is reported only once for each function it appears in

I'll send a v2 once -next is open again.
