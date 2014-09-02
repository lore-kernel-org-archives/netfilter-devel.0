From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 3/3] rhashtable: fix lockdep splat in rhashtable_destroy()
Date: Tue, 2 Sep 2014 12:02:56 +0100
Message-ID: <20140902110256.GB6778@casper.infradead.org>
References: <1409650721-9621-1-git-send-email-pablo@netfilter.org>
 <1409650721-9621-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33271 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaIBLC5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:02:57 -0400
Content-Disposition: inline
In-Reply-To: <1409650721-9621-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/02/14 at 11:38am, Pablo Neira Ayuso wrote:
> No need for rht_dereference() from rhashtable_destroy() since the
> existing callers don't hold the mutex when invoking this function
> from:
> 
> 1) Netlink, this is called in case of memory allocation errors in the
>    initialization path, no nl_sk_hash_lock is held.
> 2) Netfilter, this is called from the rcu callback, no nfnl_lock is
>    held either.
> 
> I think it's reasonable to assume that the caller has to make sure
> that no hash resizing may happen before releasing the bucket array.
> Therefore, the caller should be responsible for releasing this in a
> safe way, document this to make people aware of it.
> 
> This resolves a rcu lockdep splat in nft_hash:
> 
> ===============================
> [ INFO: suspicious RCU usage. ]
> 3.16.0+ #178 Not tainted
> -------------------------------
> lib/rhashtable.c:596 suspicious rcu_dereference_protected() usage!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 1, debug_locks = 1
> 1 lock held by ksoftirqd/2/18:
>  #0:  (rcu_callback){......}, at: [<ffffffff810918fd>] rcu_process_callbacks+0x27e/0x4c7
> 
> stack backtrace:
> CPU: 2 PID: 18 Comm: ksoftirqd/2 Not tainted 3.16.0+ #178
> Hardware name: LENOVO 23259H1/23259H1, BIOS G2ET32WW (1.12 ) 05/30/2012
>  0000000000000001 ffff88011706bb68 ffffffff8143debc 0000000000000000
>  ffff880117062610 ffff88011706bb98 ffffffff81077515 ffff8800ca041a50
>  0000000000000004 ffff8800ca386480 ffff8800ca041a00 ffff88011706bbb8
> Call Trace:
>  [<ffffffff8143debc>] dump_stack+0x4e/0x68
>  [<ffffffff81077515>] lockdep_rcu_suspicious+0xfa/0x103
>  [<ffffffff81228b1b>] rhashtable_destroy+0x46/0x52
>  [<ffffffffa06f21a7>] nft_hash_destroy+0x73/0x82 [nft_hash]
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Thomas Graf <tgraf@suug.ch>
