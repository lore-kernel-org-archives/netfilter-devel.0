From: Patrick McHardy <kaber@trash.net>
Subject: Re: [OOPS PATCH 1/1] netfilter: fix OOPS in flush_expectations()
Date: Fri, 11 Oct 2013 15:35:41 +0100
Message-ID: <20131011143539.GA5276@macbook.localnet>
References: <20131011140204.916097373@eitzenberger.org>
 <20131011140440.339579297@eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45748 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab3JKOft (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:35:49 -0400
Content-Disposition: inline
In-Reply-To: <20131011140440.339579297@eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 11, 2013 at 04:02:05PM +0200, Holger Eitzenberger wrote:
> This is the initial report I got:
> 
>   [ 2886.953175] BUG: unable to handle kernel paging request at 00100100
>   [ 2886.956435] IP: [<f88a4ab8>] flush_expectations+0x68/0x85 [nf_conntrack_sip]
>   [ 2886.956435] *pde = 00000000
>   [ 2886.956435] Oops: 0000 [001] SMP
>   ...
>   [ 2886.956435] Pid: 5606, comm: red_server.plc Tainted: G O
>   3.3.8-79.g20f5c30-smp 001 Astaro AG ASG/i845GV-W83627HF
>   [ 2886.956435] EIP: 0060:[<f88a4ab8>] EFLAGS: 00210246 CPU: 0
>   [ 2886.956435] EIP is at flush_expectations+0x68/0x85 [nf_conntrack_sip]
>   [ 2886.956435] EAX: 00000000 EBX: 00100100 ECX: 00000000 EDX: effdc0a0
>   [ 2886.956435] ESI: 00100100 EDI: 00000001 EBP: 00000001 ESP: f5c0bd54
>   [ 2886.956435] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>   [ 2886.956435] Process red_server.plc (pid: 5606, ti=f5c0a000 task=f5da2a20 task.ti=efc62000)
>   [ 2886.956435] Stack:
>   [ 2886.956435] f490b948 00000001 00000197 f45f4f00 f88a5918 f5c0bde0 f5c0bddc 0000001c
>   [ 2886.956435] 00000014 f88a72a8 0000015d f5c0bddc 00000001 f88a472e f5c0bddc f5c0bde0
>   [ 2886.956435] 00000001 00000197 00000014 f490b948 f45f4f00 f88a72a8 00000197 00000001
> 
> Which is due to nf_conntrack_expect.lnode hlist entry not being reset
> to NULL after being removed from the list in hlist_del(), but instead to
> LIST_POISON1.  And because of this hlist_for_each_entry_safe() does
> not terminate correctly.
> 
> Therefore change nf_ct_unlink_expect_report() to use __hlist_del()
> instead.

We should be holding the conntrack lock here and in flush_expectations(),
Not sure what I'm missing here, but if locking were used correctly, this
shouldn't be happening.

> 
> Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
> 
> Index: linux-stable-3.8.y/net/netfilter/nf_conntrack_expect.c
> ===================================================================
> --- linux-stable-3.8.y.orig/net/netfilter/nf_conntrack_expect.c
> +++ linux-stable-3.8.y/net/netfilter/nf_conntrack_expect.c
> @@ -51,7 +51,7 @@ void nf_ct_unlink_expect_report(struct n
>  	hlist_del_rcu(&exp->hnode);
>  	net->ct.expect_count--;
>  
> -	hlist_del(&exp->lnode);
> +	__hlist_del(&exp->lnode);
>  	master_help->expecting[exp->class]--;
>  
>  	nf_ct_expect_event_report(IPEXP_DESTROY, exp, pid, report);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
