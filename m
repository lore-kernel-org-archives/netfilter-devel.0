From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/1] netfilter: expect: Add one common func
 nf_ct_remove_expect to simplify codes
Date: Thu, 6 Apr 2017 18:37:30 +0200
Message-ID: <20170406163730.GA6747@salvia>
References: <1490581886-53648-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39354 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751283AbdDFQhi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 12:37:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C099A11ADC7
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 18:37:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE930BAAB2
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 18:37:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F225BBAAA8
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 18:37:30 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1490581886-53648-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 27, 2017 at 10:31:26AM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> When remove one expect, it needs three statements. And there are
> multiple duplicated codes in current codes. So add one common func
> nf_ct_remove_expect to simplify the codes.

Applied with short name:

netfilter: nf_ct_expect: Add nf_ct_remove_expect()

And...

> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index 6dc44d9..97bc0d2 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -448,10 +448,8 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
>  			if ((rcu_dereference_protected(
>  					help->helper,
>  					lockdep_is_held(&nf_conntrack_expect_lock)
> -					) == me || exp->helper == me) &&
> -			    del_timer(&exp->timeout)) {
> -				nf_ct_unlink_expect(exp);
> -				nf_ct_expect_put(exp);
> +					) == me || exp->helper == me)) {
> +				nf_ct_remove_expect(exp);
>  			}

We can now remove braces for single statement in if(), I've done this
manually here.
