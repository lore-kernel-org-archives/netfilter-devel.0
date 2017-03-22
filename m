From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH RESENT nf 1/1] netfilter: ctlink: Fix one possible use-after-free in ctnetlink_create_expect
Date: Wed, 22 Mar 2017 09:36:41 +0800
Message-ID: <001101d2a2ac$c20a1140$461e33c0$@foxmail.com>
References: <1490145919-110417-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Gao Feng'" <fgao@ikuai8.com>
To: <pablo@netfilter.org>, <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg65.qq.com ([103.7.28.233]:4523 "EHLO smtpbg65.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758022AbdCVBha (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 21:37:30 -0400
In-Reply-To: <1490145919-110417-1-git-send-email-gfree.wind@foxmail.com>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> -----Original Message-----
> From: netfilter-devel-owner@vger.kernel.org
> [mailto:netfilter-devel-owner@vger.kernel.org] On Behalf Of
> gfree.wind@foxmail.com
> Sent: Wednesday, March 22, 2017 9:25 AM
> To: pablo@netfilter.org; netfilter-devel@vger.kernel.org;
> gfree.wind@foxmail.com
> Cc: Gao Feng <fgao@ikuai8.com>
> Subject: [PATCH RESENT nf 1/1] netfilter: ctlink: Fix one possible
use-after-free
> in ctnetlink_create_expect
> 
> From: Gao Feng <fgao@ikuai8.com>
> 
> There is no rcu_read_lock during ctlink gets the helper and inserts the
> expectation. So there is one possible use-after-free issue when unload the
> helper module.
> 
> For example:
> 
>         CPU1                                CPU2
> ctlink gets the helper
>                             helper module unload and remove all
> expectations insert the expectation
> 
> Now there is one expectation which references one helper whose module is
> unloaded.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c
> b/net/netfilter/nf_conntrack_netlink.c
> index 6806b5e..f6d1d63 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -3133,23 +3133,27 @@ static int ctnetlink_del_expect(struct net *net,
> struct sock *ctnl,
>  		return -ENOENT;
>  	ct = nf_ct_tuplehash_to_ctrack(h);
> 
> +	rcu_read_lock();
>  	if (cda[CTA_EXPECT_HELP_NAME]) {
>  		const char *helpname = nla_data(cda[CTA_EXPECT_HELP_NAME]);
> 
>  		helper = __nf_conntrack_helper_find(helpname, u3,
>  						    nf_ct_protonum(ct));
>  		if (helper == NULL) {
> +			rcu_read_unlock();
>  #ifdef CONFIG_MODULES
>  			if (request_module("nfct-helper-%s", helpname) < 0)
{
>  				err = -EOPNOTSUPP;
>  				goto err_ct;
>  			}
> +			rcu_read_lock();
>  			helper = __nf_conntrack_helper_find(helpname, u3,
>
nf_ct_protonum(ct));
>  			if (helper) {
>  				err = -EAGAIN;
> -				goto err_ct;
> +				goto err_rcu;
>  			}
> +			rcu_read_unlock();
>  #endif
>  			err = -EOPNOTSUPP;
>  			goto err_ct;
> @@ -3159,11 +3163,13 @@ static int ctnetlink_del_expect(struct net *net,
> struct sock *ctnl,
>  	exp = ctnetlink_alloc_expect(cda, ct, helper, &tuple, &mask);
>  	if (IS_ERR(exp)) {
>  		err = PTR_ERR(exp);
> -		goto err_ct;
> +		goto err_rcu;
>  	}
> 
>  	err = nf_ct_expect_related_report(exp, portid, report);
>  	nf_ct_expect_put(exp);
> +err_rcu:
> +	rcu_read_unlock();
>  err_ct:
>  	nf_ct_put(ct);
>  	return err;
> --
> 1.9.1
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Let's me explain why I resend this patch without any change.
Actually I did checked all callers of __nf_conntrack_helper_find before.

There are 
1. ctnetlink_create_expect: No rcu lock, and it is my fix;
2. ctnetlink_change_helper: It is protected by
spin_lock_bh(&nf_conntrack_expect_lock), although no rcu. I think it is not
necessary to add rcu again;
3. ctnetlink_create_conntrack: rcu lock already
4. ctnetlink_glue_attach_expect: Its caller holds the rcu lock already.
nfnl_ct_hook->ctnetlink_glue_hook->ctnetlink_glue_attach_expect. 
The nfnl_ct_hook is one RCU pointer, it should be protected by RCU.
5. nf_conntrack_helper_try_module_get: It returns the helper pointer. So it
is necessary that its caller hold the rcu lock.

But I checked the caller of nf_conntrack_helper_try_module_get.
They are xt_ct_set_helper and ovs_ct_add_helper, and it seems they don't
hold the rcu lock.
It should be another patch I think.

What's your opinion, Pablo?

Best Regards
Feng




