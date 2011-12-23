From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Fri, 23 Dec 2011 22:54:47 +0800
Message-ID: <CABa6K_EX=L_4Fp=Cxt1-m521meoVLtEa5Enp5dO2zap+YU5goA@mail.gmail.com>
References: <1324647747-12646-1-git-send-email-pablo@netfilter.org> <1324647747-12646-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	jengelh@medozas.de, kadlec@blackhole.kfki.hu,
	eric.dumazet@gmail.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54204 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab1LWOzJ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Dec 2011 09:55:09 -0500
Received: by vbbfc26 with SMTP id fc26so7419950vbb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2011 06:55:08 -0800 (PST)
In-Reply-To: <1324647747-12646-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 23, 2011 at 9:42 PM,  <pablo@netfilter.org> wrote:
> +
> +static LIST_HEAD(nfnl_acct_list);

You suppose that there won't be many accounting instants. It isn't
scalable, as we have to iterate the list to find a special item. How
about a hash table?

> +
> +static int
> +nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> + =A0 =A0 =A0 struct nf_acct *cur, *last;
> +
> + =A0 =A0 =A0 if (cb->args[2])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 last =3D (struct nf_acct *)cb->args[1];
> + =A0 =A0 =A0 if (cb->args[1])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cb->args[1] =3D 0;
> +
> + =A0 =A0 =A0 rcu_read_lock();
> + =A0 =A0 =A0 list_for_each_entry(cur, &nfnl_acct_list, head) {

You should use the RCU variant here.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (last && cur !=3D last)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (nfnl_acct_fill_info(skb, NETLINK_CB=
(cb->skb).pid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cb->nlh->nlmsg_seq,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0NFNL_MSG_ACCT_NEW, cur) < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cb->args[1] =3D (unsign=
ed long)cur;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) =
=3D=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 NFNL_MSG_ACCT_GET_CTRZERO) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic64_set(&cur->pkts=
, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic64_set(&cur->byte=
s, 0);

The get and zero operations should be done in an atomic context,
otherwise counters added between them will be lost.


--=20
Regards,
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
