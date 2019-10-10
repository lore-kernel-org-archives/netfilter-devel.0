Return-Path: <SRS0=6wcg=YD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8962BC4360C
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Oct 2019 17:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65D1120659
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Oct 2019 17:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfJJRVx convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 13:21:53 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:59278 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726710AbfJJRVw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 13:21:52 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E4AB3140071;
        Thu, 10 Oct 2019 17:21:47 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 10 Oct
 2019 10:21:44 -0700
Subject: Re: [PATCH nf-next] netfilter: add and use nf_hook_slow_list()
To:     Florian Westphal <fw@strlen.de>, <netfilter-devel@vger.kernel.org>
References: <20191009143046.11070-1-fw@strlen.de>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <d4294ffa-db43-f9ad-2f7f-b33c0f241101@solarflare.com>
Date:   Thu, 10 Oct 2019 18:21:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191009143046.11070-1-fw@strlen.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24966.005
X-TM-AS-Result: No-11.317700-4.000000-10
X-TMASE-MatchedRID: UuaOI1zLN1iHYS4ybQtcOsmB4bNJoA6M69aS+7/zbj+qvcIF1TcLYBHl
        lBgYgqA10oF+/GyyeYr74Fi75cj4LdxjBp1dvHZ99u1rQ4BgXPLpVMb1xnESMgaYevV4zG3ZQBz
        oPKhLasiPqQJ9fQR1zqGSYVuf3ysxGtKIZJULgZ7HmyDJSEsI2y9Xl/s/QdUMLpmXl9ViEPDv6F
        j2Xtj47LUOkZ4Qyp5AfLzCtO+RY4SdnO9WT4MKG1tTO+xodboGAp+UH372RZW8YDH/UBNnmxOvq
        WE4CGBUfzMeXZEdHQP/U0YizU52S9SnuEf3mhWI+ACG5oWJ7tLnpmIrKZRxTq11zJyN4wn3Xlcq
        8zP3SsqTp0GGIv4oE5soi2XrUn/Jsuf7RWbvUtyrusVRy4an8cK21zBg2KlfFAQvQYa7pIOAcWP
        tWpFIMhq51YIsDTSYCMD0YDHwp3s590r83Xtd5A==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--11.317700-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24966.005
X-MDID: 1570728108-iP1DJRyt1h7Z
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 09/10/2019 15:30, Florian Westphal wrote:
> At this time, NF_HOOK_LIST() macro will iterate the list and then call
> nf_hook() for each skb.
>
> This makes it so the entire list is passed into the netfilter core.
> The advantage is that we only need to fetch the rule blob once per list
> instead of per-skb.  If no rules are present, the list operations
> can be elided entirely.
>
> NF_HOOK_LIST only supports ipv4 and ipv6, but those are the only
> callers.
>
> Cc: Edward Cree <ecree@solarflare.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
LGTM (but see below).
Acked-by: Edward Cree <ecree@solarflare.com>
>  include/linux/netfilter.h | 41 +++++++++++++++++++++++++++++----------
>  net/netfilter/core.c      | 20 +++++++++++++++++++
>  2 files changed, 51 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
> index 77ebb61faf48..eb312e7ca36e 100644
> --- a/include/linux/netfilter.h
> +++ b/include/linux/netfilter.h
> @@ -199,6 +199,8 @@ extern struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
>  int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
>                const struct nf_hook_entries *e, unsigned int i);
>
> +void nf_hook_slow_list(struct list_head *head, struct nf_hook_state *state,
> +                    const struct nf_hook_entries *e);
>  /**
>   *   nf_hook - call a netfilter hook
>   *
> @@ -311,17 +313,36 @@ NF_HOOK_LIST(uint8_t pf, unsigned int hook, struct net *net, struct sock *sk,
>            struct list_head *head, struct net_device *in, struct net_device *out,
>            int (*okfn)(struct net *, struct sock *, struct sk_buff *))
>  {
> -     struct sk_buff *skb, *next;
> -     struct list_head sublist;
> -
> -     INIT_LIST_HEAD(&sublist);
> -     list_for_each_entry_safe(skb, next, head, list) {
> -             list_del(&skb->list);
> -             if (nf_hook(pf, hook, net, sk, skb, in, out, okfn) == 1)
> -                     list_add_tail(&skb->list, &sublist);
> +     struct nf_hook_entries *hook_head = NULL;
> +
> +#ifdef CONFIG_JUMP_LABEL
> +     if (__builtin_constant_p(pf) &&
> +         __builtin_constant_p(hook) &&
> +         !static_key_false(&nf_hooks_needed[pf][hook]))
> +             return;
> +#endif
> +
> +     rcu_read_lock();
> +     switch (pf) {
> +     case NFPROTO_IPV4:
> +             hook_head = rcu_dereference(net->nf.hooks_ipv4[hook]);
> +             break;
> +     case NFPROTO_IPV6:
> +             hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
> +             break;
> +     default:
> +             WARN_ON_ONCE(1);
> +             break;
>       }
> -     /* Put passed packets back on main list */
> -     list_splice(&sublist, head);
> +
> +     if (hook_head) {
> +             struct nf_hook_state state;
> +
> +             nf_hook_state_init(&state, hook, pf, in, out, sk, net, okfn);
> +
> +             nf_hook_slow_list(head, &state, hook_head);
> +     }
> +     rcu_read_unlock();
>  }
>
>  /* Call setsockopt() */
> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> index 5d5bdf450091..306587b07a4f 100644
> --- a/net/netfilter/core.c
> +++ b/net/netfilter/core.c
> @@ -536,6 +536,26 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
>  }
>  EXPORT_SYMBOL(nf_hook_slow);
>
> +void nf_hook_slow_list(struct list_head *head, struct nf_hook_state *state,
> +                    const struct nf_hook_entries *e)
> +{
> +     struct sk_buff *skb, *next;
> +     struct list_head sublist;
> +     int ret;
> +
> +     INIT_LIST_HEAD(&sublist);
> +
> +     list_for_each_entry_safe(skb, next, head, list) {
> +             list_del(&skb->list);
I know this was just copied from the existing code, but I've been getting
 a lot more paranoid lately about skbs escaping with non-NULL ->next
 pointers, since several bugs of that kind have turned up elsewhere.
So should this maybe be skb_list_del_init()?

-Ed
> +             ret = nf_hook_slow(skb, state, e, 0);
> +             if (ret == 1)
> +                     list_add_tail(&skb->list, &sublist);
> +     }
> +     /* Put passed packets back on main list */
> +     list_splice(&sublist, head);
> +}
> +EXPORT_SYMBOL(nf_hook_slow_list);
> +
>  /* This needs to be compiled in any case to avoid dependencies between the
>   * nfnetlink_queue code and nf_conntrack.
>   */

The information contained in this message is confidential and is intended for the addressee(s) only. If you have received this message in error, please notify the sender immediately and delete the message. Unless you are an addressee (or authorized to receive for an addressee), you may not use, copy or disclose to anyone this message or any information contained in this message. The unauthorized use, disclosure, copying or alteration of this message is strictly prohibited.
