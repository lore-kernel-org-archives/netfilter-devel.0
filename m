From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 2/3] netfilter: nf_ct_helper: use
 nf_ct_iterate_cleanup to unlink helper objs
Date: Sun, 21 May 2017 10:15:21 +0200
Message-ID: <20170521081521.GD1004@breakpoint.cc>
References: <1495345149-57674-1-git-send-email-zlpnobody@163.com>
 <1495345149-57674-3-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36830 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750786AbdEUIQI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 May 2017 04:16:08 -0400
Content-Disposition: inline
In-Reply-To: <1495345149-57674-3-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> When we unlink the helper objects, we will iterate the nf_conntrack_hash,
> iterate the unconfirmed list, handle the hash resize situation, etc.
> 
> Actually this logic is same as the nf_ct_iterate_cleanup, so we can use it
> to remove these copy & paste codes.

Agree, this is a good idea.  However:

> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -274,16 +274,16 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
>  EXPORT_SYMBOL_GPL(__nf_ct_try_assign_helper);
>  
>  /* appropriate ct lock protecting must be taken by caller */
> -static inline int unhelp(struct nf_conntrack_tuple_hash *i,
> -			 const struct nf_conntrack_helper *me)
> +static int unhelp(struct nf_conn *ct, void *me)
>  {
> -	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(i);
>  	struct nf_conn_help *help = nfct_help(ct);
>  
>  	if (help && rcu_dereference_raw(help->helper) == me) {
>  		nf_conntrack_event(IPCT_HELPER, ct);
>  		RCU_INIT_POINTER(help->helper, NULL);
>  	}

this is broken for unconfirmed conntracks, as
other cpu can reallocate the extension area.

For the module removal case, we have no choice but to toss the
unconfirmed conntracks.

Same for patch #3.

I plan to submit my patches soon, perhaps its best if I only
submit the first couple of patches so you can rebase on top of that?

Alternatively, I'm fine if your patches go in first, I can also
just rebase on top.

