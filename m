From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 2/2] netfilter: rename nfnetlink_queue_core.c
 to nfnetlink_queue.c
Date: Thu, 1 Oct 2015 14:22:48 +0200
Message-ID: <20151001122248.GA10264@salvia>
References: <1443700959-32673-2-git-send-email-pablo@netfilter.org>
 <201510012017.vqRsWNtm%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
	chamas@h4.dion.ne.jp, chamaken@gmail.com
To: kbuild test robot <lkp@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39186 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255AbbJAMPy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Oct 2015 08:15:54 -0400
Content-Disposition: inline
In-Reply-To: <201510012017.vqRsWNtm%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 01, 2015 at 08:07:45PM +0800, kbuild test robot wrote:
> Hi Pablo,
> 
> [auto build test results on next-20151001 -- if it's inappropriate base, please ignore]
> 
> config: m68k-sun3_defconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 31ae4524f70d7992a3f918bab674e2fe8588edfa
>         # save the attached .config to linux build tree
>         make.cross ARCH=m68k 
> 
> Note: it may well be a FALSE warning. FWIW you are at least aware of it now.
> http://gcc.gnu.org/wiki/Better_Uninitialized_Warnings
> 
> All warnings (new ones prefixed by >>):
> 
>    net/netfilter/nfnetlink_queue.c: In function '__nfqnl_enqueue_packet':
> >> net/netfilter/nfnetlink_queue.c:518:18: warning: 'nfq_ct' may be used uninitialized in this function [-Wmaybe-uninitialized]
>      if (ct && nfq_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
>                      ^
>    net/netfilter/nfnetlink_queue.c:316:22: note: 'nfq_ct' was declared here
>      struct nfq_ct_hook *nfq_ct;
>                          ^

JFYI: This is a false positive as the note above states, if ct is set
then nfq_ct is set too.
