From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netfilter: xt_hashlimit: fix proc entry leak in netns destroy
 path
Date: Sat, 7 Dec 2013 23:35:27 +0100
Message-ID: <20131207223527.GA4050@localhost>
References: <4921954.LHAAuZqxp3@tuxracer>
 <1420070.tCgfU14zqt@tuxracer>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Sergey Popovich <popovich_sergei@mail.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42081 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab3LGWfb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Dec 2013 17:35:31 -0500
Content-Disposition: inline
In-Reply-To: <1420070.tCgfU14zqt@tuxracer>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 06, 2013 at 10:57:19AM +0200, Sergey Popovich wrote:
> commit 32263dd1b43378b4f7d7796ed713f77e95f27e8a
> Author: Vitaly E. Lavrov <>
> Date:   Mon Dec 24 14:42:17 2012 +0100
> 
>     netfilter: xt_hashlimit: fix namespace destroy path
> 
> Takes into account fact, that hashlimit_net_exit() called right before
> hashlimit_mt_destroy() and fixes destroy path for netns.
> 
> However using xt_hashlimit for IPv4 and IPv6 together produces following
> output on netconsole from one of our servers on netns destroy:
> 
>  Pid: 9499, comm: kworker/u:0 Tainted: G        WC O 3.2.0-5-netctl-amd64-core2
>  Call Trace:
>   [<ffffffff8104708d>] ? warn_slowpath_common+0x78/0x8c
>   [<ffffffff81047139>] ? warn_slowpath_fmt+0x45/0x4a
>   [<ffffffff81144a99>] ? remove_proc_entry+0xd8/0x22e
>   [<ffffffff810ebbaa>] ? kfree+0x5b/0x6c
>   [<ffffffffa043c501>] ? hashlimit_net_exit+0x45/0x8d [xt_hashlimit]
>   [<ffffffff8128ab30>] ? ops_exit_list+0x1c/0x44
>   [<ffffffff8128b28e>] ? cleanup_net+0xf1/0x180
>   [<ffffffff810369fc>] ? should_resched+0x5/0x23
>   [<ffffffff8105b8f9>] ? process_one_work+0x161/0x269
>   [<ffffffff8105aea5>] ? cwq_activate_delayed_work+0x3c/0x48
>   [<ffffffff8105c8c2>] ? worker_thread+0xc2/0x145
>   [<ffffffff8105c800>] ? manage_workers.isra.25+0x15b/0x15b
>   [<ffffffff8105fa01>] ? kthread+0x76/0x7e
>   [<ffffffff813581f4>] ? kernel_thread_helper+0x4/0x10
>   [<ffffffff8105f98b>] ? kthread_worker_fn+0x139/0x139
>   [<ffffffff813581f0>] ? gs_change+0x13/0x13
>  ---[ end trace d8c3cc0ad163ef79 ]---
>  ------------[ cut here ]------------
>  WARNING: at /usr/src/linux-3.2.52/debian/build/source_netctl/fs/proc/generic.c:849
>  remove_proc_entry+0x217/0x22e()
>  Hardware name:
>  remove_proc_entry: removing non-empty directory 'net/ip6t_hashlimit', leaking at least 'IN-REJECT'
> 
> This is due to lack of removal net/ip6t_hashlimit/* entries in
> hashlimit_proc_net_exit().

Applied, thanks Sergey.
