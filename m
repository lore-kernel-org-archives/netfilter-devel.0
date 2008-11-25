From: BORBELY Zoltan <bozo@andrews.hu>
Subject: Re: crash in death_by_timeout()
Date: Tue, 25 Nov 2008 09:09:03 +0100
Message-ID: <20081125080903.GA3195@zebra.home>
References: <20081117221855.GD3271@zebra.home> <4922A1E8.7080405@trash.net> <20081118123830.GD3201@zebra.home> <4922C0F7.3050604@trash.net> <4922C2D0.9060207@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx6.datanet.hu ([194.149.13.165]:63760 "EHLO mx6.datanet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbYKYIJp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:09:45 -0500
Received: from dolphin (tng660dvmi.adsl.datanet.hu [195.56.206.203])
	by mx6.datanet.hu (DataNet) with ESMTP id 22425130F36
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Nov 2008 09:09:42 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <4922C2D0.9060207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, Nov 18, 2008 at 02:27:44PM +0100, Patrick McHardy wrote:
> Could you try whether this patch fixes the problem?
>
> Pablo, do you recall the reason why the lock isn't held in
> ctnetlink_create_conntrack()?

> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 622d7c6..233fdd2 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -305,9 +305,7 @@ void nf_conntrack_hash_insert(struct nf_conn *ct)
>  	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
>  	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
>  
> -	spin_lock_bh(&nf_conntrack_lock);
>  	__nf_conntrack_hash_insert(ct, hash, repl_hash);
> -	spin_unlock_bh(&nf_conntrack_lock);
>  }
>  EXPORT_SYMBOL_GPL(nf_conntrack_hash_insert);
>  
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index a040d46..3b009a3 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1090,7 +1090,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
>  	struct nf_conn_help *help;
>  	struct nf_conntrack_helper *helper;
>  
> -	ct = nf_conntrack_alloc(&init_net, otuple, rtuple, GFP_KERNEL);
> +	ct = nf_conntrack_alloc(&init_net, otuple, rtuple, GFP_ATOMIC);
>  	if (ct == NULL || IS_ERR(ct))
>  		return -ENOMEM;
>  
> @@ -1212,13 +1212,14 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
>  			atomic_inc(&master_ct->ct_general.use);
>  		}
>  
> -		spin_unlock_bh(&nf_conntrack_lock);
>  		err = -ENOENT;
>  		if (nlh->nlmsg_flags & NLM_F_CREATE)
>  			err = ctnetlink_create_conntrack(cda,
>  							 &otuple,
>  							 &rtuple,
>  							 master_ct);
> +		spin_unlock_bh(&nf_conntrack_lock);
> +
>  		if (err < 0 && master_ct)
>  			nf_ct_put(master_ct);
>  

We didn't see any kernel crashes during a half day heavy work (without the
patch the kernel crashed in 3-4 hours every time), but we found a lot of
BUG messages in the log (maybe for every new entry):

    Nov 24 14:45:43 test kernel: BUG: sleeping function called from invalid context at mm/slab.c:3043
    Nov 24 14:45:43 test kernel: in_atomic():1, irqs_disabled():0
    Nov 24 14:45:43 test kernel: 3 locks held by test/3586:
    Nov 24 14:45:43 test kernel:  #0:  (nfnl_mutex){--..}, at: [<d081500f>] nfnetlink_rcv+0xf/0x30 [nfnetlink]
    Nov 24 14:45:43 test kernel:  #1:  (nf_conntrack_lock){-+..}, at: [<d08c979f>] ctnetlink_new_conntrack+0x7f/0x770 [nf_conntrack_netlink]
    Nov 24 14:45:43 test kernel:  #2:  (rcu_read_lock){..--}, at: [<d08c98ee>] ctnetlink_new_conntrack+0x1ce/0x770 [nf_conntrack_netlink]
    Nov 24 14:45:43 test kernel: Pid: 3586, comm: test Not tainted 2.6.27.6bozotest #1
    Nov 24 14:45:43 test kernel:  [<c027a566>] __kmalloc_track_caller+0x126/0x160
    Nov 24 14:45:43 test kernel:  [<c052a7a5>] __nf_ct_ext_add+0xb5/0x290
    Nov 24 14:45:43 test kernel:  [<c026411d>] __krealloc+0x5d/0x80
    Nov 24 14:45:44 test kernel:  [<c052a7a5>] __nf_ct_ext_add+0xb5/0x290
    Nov 24 14:45:44 test kernel:  [<c052a71d>] __nf_ct_ext_add+0x2d/0x290
    Nov 24 14:45:44 test kernel:  [<d08c9af8>] ctnetlink_new_conntrack+0x3d8/0x770 [nf_conntrack_netlink]
    Nov 24 14:45:44 test kernel:  [<d08c98ee>] ctnetlink_new_conntrack+0x1ce/0x770 [nf_conntrack_netlink]
    Nov 24 14:45:44 test kernel:  [<c0248910>] validate_chain+0x380/0xed0
    Nov 24 14:45:44 test kernel:  [<d0815220>] nfnetlink_rcv_msg+0xf0/0x180 [nfnetlink]
    Nov 24 14:45:44 test kernel:  [<d0815130>] nfnetlink_rcv_msg+0x0/0x180 [nfnetlink]
    Nov 24 14:45:44 test kernel:  [<c0520ebc>] netlink_rcv_skb+0x7c/0xa0
    Nov 24 14:45:44 test kernel:  [<d081501b>] nfnetlink_rcv+0x1b/0x30 [nfnetlink]
    Nov 24 14:45:44 test kernel:  [<c0520c50>] netlink_unicast+0x250/0x280
    Nov 24 14:45:44 test kernel:  [<c052145e>] netlink_sendmsg+0x1ee/0x2c0
    Nov 24 14:45:44 test kernel:  [<c04fad7f>] sock_sendmsg+0xbf/0xf0
    Nov 24 14:45:44 test kernel:  [<c02496e5>] __lock_acquire+0x285/0x9e0
    Nov 24 14:45:44 test kernel:  [<c0239790>] autoremove_wake_function+0x0/0x50
    Nov 24 14:45:44 test kernel:  [<c0248910>] validate_chain+0x380/0xed0
    Nov 24 14:45:44 test kernel:  [<c027ee33>] fget_light+0xd3/0xf0
    Nov 24 14:45:44 test kernel:  [<c031bea8>] copy_from_user+0x38/0x80
    Nov 24 14:45:44 test kernel:  [<c031bea8>] copy_from_user+0x38/0x80
    Nov 24 14:45:44 test kernel:  [<c0502e2a>] verify_iovec+0x2a/0x90
    Nov 24 14:45:44 test kernel:  [<c04faf14>] sys_sendmsg+0x164/0x280
    Nov 24 14:45:44 test kernel:  [<c027ee33>] fget_light+0xd3/0xf0
    Nov 24 14:45:44 test kernel:  [<c031c16a>] copy_to_user+0x3a/0x70
    Nov 24 14:45:44 test kernel:  [<c04fb98f>] move_addr_to_user+0x5f/0x70
    Nov 24 14:45:44 test kernel:  [<c04fbf0d>] sys_getsockname+0xcd/0xd0
    Nov 24 14:45:44 test kernel:  [<c022ad6c>] local_bh_enable_ip+0x7c/0xc0
    Nov 24 14:45:44 test kernel:  [<c0247e64>] trace_hardirqs_on_caller+0xc4/0x140
    Nov 24 14:45:44 test kernel:  [<c022ad6c>] local_bh_enable_ip+0x7c/0xc0
    Nov 24 14:45:44 test kernel:  [<c04fe578>] sock_setsockopt+0x128/0x590
    Nov 24 14:45:44 test kernel:  [<c027edb3>] fget_light+0x53/0xf0
    Nov 24 14:45:44 test kernel:  [<c04fa552>] sockfd_lookup_light+0x32/0x60
    Nov 24 14:45:44 test kernel:  [<c04fc39b>] sys_socketcall+0x25b/0x2b0
    Nov 24 14:45:44 test kernel:  [<c031ba44>] trace_hardirqs_on_thunk+0xc/0x10
    Nov 24 14:45:44 test kernel:  [<c031ba44>] trace_hardirqs_on_thunk+0xc/0x10
    Nov 24 14:45:44 test kernel:  [<c0203029>] sysenter_do_call+0x12/0x35
    Nov 24 14:45:44 test kernel:  =======================

Bye,
Zoltan
