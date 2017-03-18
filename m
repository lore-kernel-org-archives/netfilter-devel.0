From: Feng Gao <gfree.wind@gmail.com>
Subject: Re: [PATCH v2 nf 1/1] netfilter: helper: Fix possible panic caused by
 invoking expectfn unloaded
Date: Sat, 18 Mar 2017 15:57:47 +0800
Message-ID: <CA+6hz4pdRzHaOsgX5mn-GUGacvDnmGGoepiSCd0iZeyo7W=KsQ@mail.gmail.com>
References: <1489823439-32077-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Feng Gao <gfree.wind@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, Gao Feng <fgao@ikuai8.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34383 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbdCRIGc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Mar 2017 04:06:32 -0400
Received: by mail-pf0-f196.google.com with SMTP id o126so11063649pfb.1
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Mar 2017 01:05:23 -0700 (PDT)
In-Reply-To: <1489823439-32077-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Sat, Mar 18, 2017 at 3:50 PM,  <fgao@ikuai8.com> wrote:
> From: Gao Feng <fgao@ikuai8.com>
>
> The helper module could register one helper expectfn by the function
> nf_ct_helper_expectfn_register. When the module is unloaded, it invokes
> the nf_ct_helper_expectfn_unregister to unregister the expectfn. But
> it doesn't remove the expectations which refer to this expectfn. Then
> there is one possible use-after-free issue.
>
> Because ctnetlink_alloc_expect could create one expecatation whose
> helper and expectfn belong to different modules. So I bring one
> new member expectfn_module in nf_conntrack_expect. Then when unload
> one helper module, we could remove all expectation whose helper or
> expectfn belong to this module.
>
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  v2: Create one new function to remove expectations, per Pablo
>  v1: Initial version
>
>  include/net/netfilter/nf_conntrack_expect.h |  2 +
>  include/net/netfilter/nf_conntrack_helper.h |  1 +
>  net/ipv4/netfilter/nf_nat_h323.c            |  2 +
>  net/netfilter/nf_conntrack_broadcast.c      |  1 +
>  net/netfilter/nf_conntrack_expect.c         |  1 +
>  net/netfilter/nf_conntrack_helper.c         | 63 ++++++++++++++++++-----------
>  net/netfilter/nf_conntrack_netlink.c        |  5 ++-
>  net/netfilter/nf_nat_core.c                 |  1 +
>  net/netfilter/nf_nat_sip.c                  |  1 +
>  9 files changed, 52 insertions(+), 25 deletions(-)
>
> diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
> index 5ed33ea..76e2858 100644
> --- a/include/net/netfilter/nf_conntrack_expect.h
> +++ b/include/net/netfilter/nf_conntrack_expect.h
> @@ -26,6 +26,8 @@ struct nf_conntrack_expect {
>         /* Function to call after setup and insertion */
>         void (*expectfn)(struct nf_conn *new,
>                          struct nf_conntrack_expect *this);
> +       /* The moudule which expectfn belongs to */
> +       struct module *expectfn_module;
>
>         /* Helper to assign to new connection */
>         struct nf_conntrack_helper *helper;
> diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> index 1eaac1f..c4d88d4 100644
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -114,6 +114,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb, unsigned int protoff,
>  struct nf_ct_helper_expectfn {
>         struct list_head head;
>         const char *name;
> +       struct module *me;
>         void (*expectfn)(struct nf_conn *ct, struct nf_conntrack_expect *exp);
>  };
>
> diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
> index 574f7eb..a5fa8de 100644
> --- a/net/ipv4/netfilter/nf_nat_h323.c
> +++ b/net/ipv4/netfilter/nf_nat_h323.c
> @@ -569,11 +569,13 @@ static int nat_callforwarding(struct sk_buff *skb, struct nf_conn *ct,
>
>  static struct nf_ct_helper_expectfn q931_nat = {
>         .name           = "Q.931",
> +       .me             = THIS_MODULE,
>         .expectfn       = ip_nat_q931_expect,
>  };
>
>  static struct nf_ct_helper_expectfn callforwarding_nat = {
>         .name           = "callforwarding",
> +       .me             = THIS_MODULE,
>         .expectfn       = ip_nat_callforwarding_expect,
>  };
>
> diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
> index 4e99cca..edce551 100644
> --- a/net/netfilter/nf_conntrack_broadcast.c
> +++ b/net/netfilter/nf_conntrack_broadcast.c
> @@ -66,6 +66,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
>         exp->mask.src.u.udp.port  = htons(0xFFFF);
>
>         exp->expectfn             = NULL;
> +       exp->expectfn_module      = NULL;
>         exp->flags                = NF_CT_EXPECT_PERMANENT;
>         exp->class                = NF_CT_EXPECT_CLASS_DEFAULT;
>         exp->helper               = NULL;
> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> index 4b2e1fb..1e58a0e 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -296,6 +296,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
>         exp->flags = 0;
>         exp->class = class;
>         exp->expectfn = NULL;
> +       exp->expectfn_module = NULL;
>         exp->helper = NULL;
>         exp->tuple.src.l3num = family;
>         exp->tuple.dst.protonum = proto;
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index 6dc44d9..6c840af 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -130,6 +130,42 @@ static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
>         return NULL;
>  }
>
> +static void
> +nf_ct_remove_expect_refer_dying_module(const struct module *me)
> +{
> +       struct nf_conntrack_expect *exp;
> +       const struct hlist_node *next;
> +       u32 i;
> +
> +       if (!me)
> +               return;
> +
> +       /* Make sure no one is still using the moudule unless
> +        * its a connection in the hash.
> +        */
> +       synchronize_rcu();
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
> +                           exp->expectfn_module == me) {
> +                               /* This expect belongs to the dying module */
> +                               if (del_timer(&exp->timeout)) {
> +                                       nf_ct_unlink_expect(exp);
> +                                       nf_ct_expect_put(exp);
> +                               }
> +                       }
> +               }
> +       }
> +       spin_unlock_bh(&nf_conntrack_expect_lock);
> +}
> +
>  struct nf_conntrack_helper *
>  __nf_conntrack_helper_find(const char *name, u16 l3num, u8 protonum)
>  {
> @@ -308,6 +344,8 @@ void nf_ct_helper_expectfn_unregister(struct nf_ct_helper_expectfn *n)
>         spin_lock_bh(&nf_conntrack_expect_lock);
>         list_del_rcu(&n->head);
>         spin_unlock_bh(&nf_conntrack_expect_lock);
> +
> +       nf_ct_remove_expect_refer_dying_module(n->me);
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_unregister);
>
> @@ -421,8 +459,6 @@ static void __nf_conntrack_helper_unregister(struct nf_conntrack_helper *me,
>  void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
>  {
>         struct nf_conntrack_tuple_hash *h;
> -       struct nf_conntrack_expect *exp;
> -       const struct hlist_node *next;
>         const struct hlist_nulls_node *nn;
>         unsigned int last_hsize;
>         spinlock_t *lock;
> @@ -434,28 +470,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
>         nf_ct_helper_count--;
>         mutex_unlock(&nf_ct_helper_mutex);
>
> -       /* Make sure every nothing is still using the helper unless its a
> -        * connection in the hash.
> -        */
> -       synchronize_rcu();
> -
> -       /* Get rid of expectations */
> -       spin_lock_bh(&nf_conntrack_expect_lock);
> -       for (i = 0; i < nf_ct_expect_hsize; i++) {
> -               hlist_for_each_entry_safe(exp, next,
> -                                         &nf_ct_expect_hash[i], hnode) {
> -                       struct nf_conn_help *help = nfct_help(exp->master);
> -                       if ((rcu_dereference_protected(
> -                                       help->helper,
> -                                       lockdep_is_held(&nf_conntrack_expect_lock)
> -                                       ) == me || exp->helper == me) &&
> -                           del_timer(&exp->timeout)) {
> -                               nf_ct_unlink_expect(exp);
> -                               nf_ct_expect_put(exp);
> -                       }
> -               }
> -       }
> -       spin_unlock_bh(&nf_conntrack_expect_lock);
> +       nf_ct_remove_expect_refer_dying_module(me->me);
>
>         rtnl_lock();
>         for_each_net(net)
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 6806b5e..704023a 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -3078,8 +3078,11 @@ static int ctnetlink_del_expect(struct net *net, struct sock *ctnl,
>                         goto err_out;
>                 }
>                 exp->expectfn = expfn->expectfn;
> -       } else
> +               exp->expectfn_module = expfn->me;
> +       } else {
>                 exp->expectfn = NULL;
> +               exp->expectfn_module = NULL;
> +       }
>
>         exp->class = class;
>         exp->master = ct;
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index 94b14c5..806655d 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -850,6 +850,7 @@ static void __net_exit nf_nat_net_exit(struct net *net)
>
>  static struct nf_ct_helper_expectfn follow_master_nat = {
>         .name           = "nat-follow-master",
> +       .me             = THIS_MODULE,
>         .expectfn       = nf_nat_follow_master,
>  };
>
> diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
> index 791fac4..35f1965 100644
> --- a/net/netfilter/nf_nat_sip.c
> +++ b/net/netfilter/nf_nat_sip.c
> @@ -620,6 +620,7 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
>
>  static struct nf_ct_helper_expectfn sip_nat = {
>         .name           = "sip",
> +       .me             = THIS_MODULE,
>         .expectfn       = nf_nat_sip_expected,
>  };
>
> --
> 1.9.1
>

Actually I prefer to the original patch which uses the expectfn to
remove the expectations.
There are too many changes in v2 patch to fix bug, and it brings one new member.

Because the helper and expectfn of expectation could belong to
different modules.
I have to use the module as the identifier to check the expect belongs
to the dying module.

Then what's your opinion or do you have any other good advice?

Regards
Feng
