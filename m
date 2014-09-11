From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH nf-next 3/3 v2] netfilter: nf_tables: export rule-set
 generation ID
Date: Thu, 11 Sep 2014 17:46:57 +0200
Message-ID: <CAOkSjBhc65FVRK5CZSVuGnWz9sN0J1Ot9LOwGat_xKPuO83p_g@mail.gmail.com>
References: <1410448819-6694-1-git-send-email-pablo@netfilter.org> <1410448819-6694-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:48015 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312AbaIKPrU convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:47:20 -0400
Received: by mail-la0-f50.google.com with SMTP id ty20so8706141lab.9
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Sep 2014 08:47:18 -0700 (PDT)
In-Reply-To: <1410448819-6694-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11 September 2014 17:20, Pablo Neira Ayuso <pablo@netfilter.org> wro=
te:
> +
> +static int nf_tables_gen_notify(struct net *net, struct sk_buff *skb=
, int event)
> +{
> +       struct nlmsghdr *nlh =3D nlmsg_hdr(skb);
> +       struct sk_buff *skb2;
> +       int err;
> +
> +       if (nlmsg_report(nlh) &&
> +           !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
> +               return 0;
> +

The above logic is different from the other functions.

I don't know if that was deliberate.


> +       err =3D -ENOBUFS;
> +       skb2 =3D nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> +       if (skb2 =3D=3D NULL)
> +               goto err;
> +
> +       err =3D nf_tables_fill_gen_info(skb2, net, NETLINK_CB(skb).po=
rtid,
> +                                     nlh->nlmsg_seq);
> +       if (err < 0) {
> +               kfree_skb(skb2);
> +               goto err;
> +       }
> +
> +       err =3D nfnetlink_send(skb2, net, NETLINK_CB(skb).portid,
> +                            NFNLGRP_NFTABLES, nlmsg_report(nlh), GFP=
_KERNEL);
> +err:
> +       if (err < 0) {
> +               nfnetlink_set_err(net, NETLINK_CB(skb).portid, NFNLGR=
P_NFTABLES,
> +                                 err);
> +       }
> +       return err;
> +}
> +

All the xx_notify() functions looks very similar. Do you think it
worth to factorize the code?

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
