Return-Path: <SRS0=QQeY=TB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F4C7C43219
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 03:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAADB206DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 03:54:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jN5yAMw8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfEADyN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 23:54:13 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39580 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfEADyN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 23:54:13 -0400
Received: by mail-oi1-f196.google.com with SMTP id n187so13065720oih.6
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 20:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q9FxCIMCHorohCxY1PBWqf0BBGd61L7bLQQ2oDyUPtU=;
        b=jN5yAMw8RdIGCbNms4dx1SDl7VqXjMjzJhwH/MOv26xHgUUDn0yxvgTT1t/x1U0JeP
         edtQ/pDnz1MIKoliRY/E05v62mNfy1IVlk3zbK5Lk8bQjiGn5bKczyrrzrvp6bMELpFY
         5CMF4JVB3fp0G9u7eHmC5dcNic46sZ/K8+Kxwq3omq88fOdTKe3aIq7Cs6QJ71iuCWK1
         u2iHuu4AUfGPpkNCoNgYpEeCWgB8N4t+MtJeIG4P0IO83dtp4/Jz/om2qwwsDIGhK4Xj
         qVy3tIq0hFsQJt1r3tcbgI2wMdbhJEheBDZlliPrARLuOzzQwI74+Jm9Uhh2UpMO34zA
         vgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q9FxCIMCHorohCxY1PBWqf0BBGd61L7bLQQ2oDyUPtU=;
        b=EVz/tI1SCKqQHRJKId1cfUXL842dCSyKvW7kFXhpGcs8q3HJwqQwYvPNzm8epltLzd
         EpKUKFd/fm69cZ3LQvx6fKDNydcuLc4SUhAF8384++oizHlyQTYOQPVlpli9qbrVlzpD
         HKcaPkySKTjDHwOr9Ta4S5j16zmojVTRVwkcDg4ELtsAPKF/J4V8uL/qtbb7+Xh8wwJm
         jx2c/SxNezgrQhiJ6sELxJhyYZf9ME1EWT4qIeXMKLg3eesB3KTGBAZWD+ItsIxMnn37
         SqgGZaq9hSPQoyktdcLJI1YgL/WuAYZcC3OgHQY9zXiDw+SMzT9MCazIVQCYKOfeFqIJ
         M3Mw==
X-Gm-Message-State: APjAAAX6OFTQwTYiCN5o7R7/DC0XAC/BJpAon7jabW9sdO2m6jZE1wfC
        VghrMGFZZFyrNS3/yGFSAPSUzAXjtUy4n5xnd69fR68l
X-Google-Smtp-Source: APXvYqyfzBu3SDBwVXjbln10+RIdkU2HqucS6gMMV/G6w4LmHFvlDgV9ZGW/HMzHd458ERqC7pY71JOT12ka5DOhgUg=
X-Received: by 2002:aca:3556:: with SMTP id c83mr5554536oia.89.1556682852030;
 Tue, 30 Apr 2019 20:54:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190430125311.7267-1-fw@strlen.de>
In-Reply-To: <20190430125311.7267-1-fw@strlen.de>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Wed, 1 May 2019 12:54:01 +0900
Message-ID: <CAMArcTU4S0Sn3jzgYxZPohmV4oaWDqy-YFn5jpnH3H13V+oSfg@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix oops during rule dump
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 30 Apr 2019 at 21:52, Florian Westphal <fw@strlen.de> wrote:
>
> We can oops in nf_tables_fill_rule_info().
>
> Its not possible to fetch previous element in rcu-protected lists
> when deletions are not prevented somehow: list_del_rcu poisons
> the ->prev pointer value.
>
> Before rcu-conversion this was safe as dump operations did hold
> nfnetlink mutex.
>
> Pass previous rule as argument, obtained by keeping a pointer to
> the previous rule during traversal.
>

Hi Florian,
I have tested this patch and I think this patch works well.
I would like to share my test method.

SHELL#1
while :
do
    nft flush ruleset
    nft -f test.nft
done

SHELL#2
while :
do
    nft list ruleset -a
    iptables-nft -vnL
done

This test method could make panic.

[ 1887.092089] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[ 1887.100127] CPU: 0 PID: 1652 Comm: nft Not tainted 5.1.0-rc5+ #76
[ 1887.106982] Hardware name: To be filled by O.E.M. To be filled by
O.E.M./Aptio CRB, BIOS 5.6.5 07/08/2015
[ 1887.117769] RIP: 0010:nf_tables_fill_rule_info.isra.59+0x362/0x860
[nf_tables]
[ 1887.125892] Code: 8b 84 24 d8 00 00 00 4d 8b 65 08 48 83 c0 10 49
39 c4 74 5a 49 8d 7c 24 10 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48
c1 ea 03 <80> 3c 02 00 0f 85 9c 04 00 00 48 b8 ff ff ff ff ff 03 00 00
49 23
[ 1887.146996] RSP: 0018:ffff88810c0872a0 EFLAGS: 00010206
[ 1887.152878] RAX: dffffc0000000000 RBX: ffff88810ea0b1c0 RCX: 0000000000000000
[ 1887.160894] RDX: 1bd5a00000000042 RSI: ffff88810c0872f8 RDI: dead000000000210
[ 1887.168909] RBP: ffff8880b4b78000 R08: ffffed101696f008 R09: ffffed101696f008
[ 1887.176933] R10: 0000000000000002 R11: ffffed101696f007 R12: dead000000000200
[ 1887.184957] R13: ffff8880b8142688 R14: ffff8880b8142698 R15: ffff88810c0872f0
[ 1887.192973] FS:  00007fb475d8a740(0000) GS:ffff888116600000(0000)
knlGS:0000000000000000
[ 1887.202064] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1887.208527] CR2: 0000557d208c4088 CR3: 00000001102de000 CR4: 00000000001006f0
[ 1887.216548] Call Trace:
[ 1887.219344]  ? nft_expr_dump+0x4c0/0x4c0 [nf_tables]
[ 1887.224947]  ? debug_show_all_locks+0x2d0/0x2d0
[ 1887.230055]  ? rcu_read_lock_sched_held+0x114/0x130
[ 1887.235573]  __nf_tables_dump_rules+0x27d/0x620 [nf_tables]
[ 1887.241892]  nf_tables_dump_rules+0x4c4/0xc80 [nf_tables]
[ 1887.247967]  ? rcu_read_lock_sched_held+0x114/0x130
[ 1887.253466]  ? __kmalloc_node_track_caller+0x321/0x360
[ 1887.259285]  ? __nf_tables_dump_rules+0x620/0x620 [nf_tables]
[ 1887.265759]  ? __alloc_skb+0x314/0x500
[ 1887.269990]  ? sock_spd_release+0xf0/0xf0
[ 1887.274514]  ? check_flags.part.41+0x440/0x440
[ 1887.279532]  netlink_dump+0x476/0xea0
[ 1887.283669]  ? __netlink_sendskb+0xc0/0xc0
[ 1887.288283]  ? __netlink_dump_start+0x165/0x750
[ 1887.293408]  __netlink_dump_start+0x537/0x750
[ 1887.298345]  nft_netlink_dump_start_rcu.constprop.71+0x97/0x180 [nf_tables]
[ 1887.306205]  nf_tables_getrule+0x3b6/0x620 [nf_tables]
[ 1887.312019]  ? nf_tables_rule_notify+0x3e0/0x3e0 [nf_tables]
[ 1887.318407]  ? nf_tables_dump_obj_start+0x230/0x230 [nf_tables]
[ 1887.325086]  ? __nf_tables_dump_rules+0x620/0x620 [nf_tables]
[ 1887.331569]  ? nf_tables_dump_sets_done+0x40/0x40 [nf_tables]
[ 1887.338045]  ? __nla_parse+0x34/0x310
[ 1887.342198]  ? nf_tables_rule_notify+0x3e0/0x3e0 [nf_tables]
[ 1887.348576]  nfnetlink_rcv_msg+0x3f0/0xd0b [nfnetlink]
[ 1887.354366]  ? kernel_text_address+0x111/0x120
[ 1887.359391]  ? nfnetlink_bind+0x200/0x200 [nfnetlink]
[ 1887.365097]  ? sched_clock_cpu+0x18/0x170
[ 1887.369616]  ? __sys_sendto+0x263/0x300
[ 1887.373929]  ? sched_clock_cpu+0x18/0x170
[ 1887.378447]  ? do_syscall_64+0x9c/0x3e0
[ 1887.382779]  ? __lock_acquire+0xe7c/0x3bd0
[ 1887.387403]  ? check_flags.part.41+0x440/0x440
[ 1887.392416]  netlink_rcv_skb+0x112/0x330
[ 1887.396841]  ? nfnetlink_bind+0x200/0x200 [nfnetlink]
[ 1887.402538]  ? netlink_ack+0x940/0x940
[ 1887.406776]  ? ns_capable_common+0x5c/0xd0
[ 1887.411405]  nfnetlink_rcv+0x161/0x320 [nfnetlink]
[ 1887.416809]  ? nfnetlink_rcv_batch+0x1280/0x1280 [nfnetlink]
[ 1887.423200]  netlink_unicast+0x3ee/0x5a0

After this patch, I couldn't see this panic message.

Thanks!

> Fixes: d9adf22a291883 ("netfilter: nf_tables: use call_rcu in netlink dumps")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_tables_api.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index aa5e7b00a581..0969f9647927 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2261,13 +2261,13 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
>                                     u32 flags, int family,
>                                     const struct nft_table *table,
>                                     const struct nft_chain *chain,
> -                                   const struct nft_rule *rule)
> +                                   const struct nft_rule *rule,
> +                                   const struct nft_rule *prule)
>  {
>         struct nlmsghdr *nlh;
>         struct nfgenmsg *nfmsg;
>         const struct nft_expr *expr, *next;
>         struct nlattr *list;
> -       const struct nft_rule *prule;
>         u16 type = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
>
>         nlh = nlmsg_put(skb, portid, seq, type, sizeof(struct nfgenmsg), flags);
> @@ -2287,8 +2287,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
>                          NFTA_RULE_PAD))
>                 goto nla_put_failure;
>
> -       if ((event != NFT_MSG_DELRULE) && (rule->list.prev != &chain->rules)) {
> -               prule = list_prev_entry(rule, list);
> +       if (event != NFT_MSG_DELRULE && prule) {
>                 if (nla_put_be64(skb, NFTA_RULE_POSITION,
>                                  cpu_to_be64(prule->handle),
>                                  NFTA_RULE_PAD))
> @@ -2335,7 +2334,7 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
>
>         err = nf_tables_fill_rule_info(skb, ctx->net, ctx->portid, ctx->seq,
>                                        event, 0, ctx->family, ctx->table,
> -                                      ctx->chain, rule);
> +                                      ctx->chain, rule, NULL);
>         if (err < 0) {
>                 kfree_skb(skb);
>                 goto err;
> @@ -2360,12 +2359,13 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
>                                   const struct nft_chain *chain)
>  {
>         struct net *net = sock_net(skb->sk);
> +       const struct nft_rule *rule, *prule;
>         unsigned int s_idx = cb->args[0];
> -       const struct nft_rule *rule;
>
> +       prule = NULL;
>         list_for_each_entry_rcu(rule, &chain->rules, list) {
>                 if (!nft_is_active(net, rule))
> -                       goto cont;
> +                       goto cont_skip;
>                 if (*idx < s_idx)
>                         goto cont;
>                 if (*idx > s_idx) {
> @@ -2377,11 +2377,13 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
>                                         NFT_MSG_NEWRULE,
>                                         NLM_F_MULTI | NLM_F_APPEND,
>                                         table->family,
> -                                       table, chain, rule) < 0)
> +                                       table, chain, rule, prule) < 0)
>                         return 1;
>
>                 nl_dump_check_consistent(cb, nlmsg_hdr(skb));
>  cont:
> +               prule = rule;
> +cont_skip:
>                 (*idx)++;
>         }
>         return 0;
> @@ -2537,7 +2539,7 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
>
>         err = nf_tables_fill_rule_info(skb2, net, NETLINK_CB(skb).portid,
>                                        nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
> -                                      family, table, chain, rule);
> +                                      family, table, chain, rule, NULL);
>         if (err < 0)
>                 goto err;
>
> --
> 2.21.0
>
