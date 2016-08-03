From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: use_nf_conn_expires helper in more
 places
Date: Wed, 3 Aug 2016 14:53:19 +0200
Message-ID: <20160803125319.GB30905@breakpoint.cc>
References: <1470185107-17332-1-git-send-email-fw@strlen.de>
 <201608031302.wzV7WZoE%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, kbuild-all@01.org,
	netfilter-devel@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:55784 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753253AbcHCMxx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Aug 2016 08:53:53 -0400
Content-Disposition: inline
In-Reply-To: <201608031302.wzV7WZoE%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

kbuild test robot <lkp@intel.com> wrote:
> Hi Florian,
> 
> [auto build test ERROR on nf-next/master]
> 
> url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/netfilter-use_nf_conn_expires-helper-in-more-places/20160803-124239
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
> config: i386-randconfig-x018-201631 (attached as .config)
> compiler: gcc-6 (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    net/netfilter/nf_conntrack_standalone.c: In function 'ct_seq_show':
> >> net/netfilter/nf_conntrack_standalone.c:227:6: error: implicit declaration of function 'nf_ct_expires' [-Werror=implicit-function-declaration]
>          nf_ct_expires(ct)  / HZ);
>          ^~~~~~~~~~~~~

It would be nice to see the sha1 of 'master'.

Builds fine with this config for me; nf-next master is

commit 6a492b0f23d28e1f946cdf08e54617484400dafb
Merge: d85486d 354a086
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 27 14:48:37 2016 -0700

I guess this was with an older tree...?
