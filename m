From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf v6 3/3] netfilter: nat_helper: Remove the expectations
 when its module is unloaded
Date: Fri, 5 May 2017 09:59:06 +0800
Message-ID: <CAML_gOfbrRG8LDD11PzpMmGqnq0-JpXKGk4Z=OJH3gEDnzCCxg@mail.gmail.com>
References: <1493945713-67263-1-git-send-email-gfree.wind@vip.163.com> <1493945713-67263-3-git-send-email-gfree.wind@vip.163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: gfree.wind@vip.163.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:33502 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752009AbdEEB7I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2017 21:59:08 -0400
Received: by mail-ua0-f194.google.com with SMTP id z29so2839303uab.0
        for <netfilter-devel@vger.kernel.org>; Thu, 04 May 2017 18:59:07 -0700 (PDT)
In-Reply-To: <1493945713-67263-3-git-send-email-gfree.wind@vip.163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Feng,

2017-05-05 8:55 GMT+08:00  <gfree.wind@vip.163.com>:
[...]
> +static void
> +nf_ct_flush_expect(const struct module *me)
> +{
> +       struct nf_conntrack_expect *exp;
> +       const struct hlist_node *next;
> +       u32 i;
> +
> +       if (!me)
> +               return;
> +
> +       /* Get rid of expectations */
> +       spin_lock_bh(&nf_conntrack_expect_lock);
> +       for (i = 0; i < nf_ct_expect_hsize; i++) {
> +               hlist_for_each_entry_safe(exp, next,
> +                                         &nf_ct_expect_hash[i], hnode) {
> +                       struct nf_conn_help *master_help = nfct_help(exp->master);
> +
> +                       if ((master_help->helper && master_help->helper->me == me) ||
> +                           (exp->helper && exp->helper->me == me) ||
> +                           (exp->nat_helper && exp->nat_helper->me == me)) {
> +                               /* This expect belongs to the dying module */
> +                               if (del_timer(&exp->timeout)) {
> +                                       nf_ct_unlink_expect(exp);
> +                                       nf_ct_expect_put(exp);
> +                               }

Is this should be replaced with your helper function nf_ct_remove_expect()?

> +                       }
> +               }
> +       }
> +       spin_unlock_bh(&nf_conntrack_expect_lock);
