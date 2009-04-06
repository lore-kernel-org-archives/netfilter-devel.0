From: Patrick McHardy <kaber@trash.net>
Subject: netfilter: ctnetlink: deliver events for conntracks changed from
 userspace
Date: Mon, 06 Apr 2009 14:32:14 +0200
Message-ID: <49D9F64E.4050304@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43932 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbZDFMcV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2009 08:32:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo, I'm looking at a regression introduced by this patch
and I'm not sure about the intentions:

> +int nf_ct_expect_related(struct nf_conntrack_expect *expect)
> +{
> +       int ret;
> +
> +       spin_lock_bh(&nf_conntrack_lock);
> +       ret = __nf_ct_expect_check(expect);
> +       if (ret < 0)
> +               goto out;

This is unfortunately broken since we return 0 when refreshing an
existing expectation. This will create an identical expectation
for each refresh.
>  
>         nf_ct_expect_insert(expect);
> +       atomic_inc(&expect->use);

This I don't understand - the caller is holding a reference, why
do we need another one?

> +       spin_unlock_bh(&nf_conntrack_lock);
>         nf_ct_expect_event(IPEXP_NEW, expect);
> -       ret = 0;
> +       nf_ct_expect_put(expect);
> +       return ret;
>  out:
>         spin_unlock_bh(&nf_conntrack_lock);
>         return ret;
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_expect_related);
>  
> +int nf_ct_expect_related_report(struct nf_conntrack_expect *expect, 
> +                               u32 pid, int report)
> +{
> +       int ret;
> +
> +       spin_lock_bh(&nf_conntrack_lock);
> +       ret = __nf_ct_expect_check(expect);
> +       if (ret < 0)
> +               goto out;

Same problem

> +       nf_ct_expect_insert(expect);
> +out:
> +       spin_unlock_bh(&nf_conntrack_lock);
> +       if (ret == 0)
> +               nf_ct_expect_event_report(IPEXP_NEW, expect, pid, report);

But here we don't take the reference, despite having the exact
same situation.

The next question would be - why do we need those two functions at
all? Aside from the apparently unnecessary reference counting, the
only difference is reporting, and that actually uses the exact
same code path.

> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(nf_ct_expect_related_report);


