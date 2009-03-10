From: Nir Tzachar <nir.tzachar@gmail.com>
Subject: Re: [PATCH]: Fix ipt_REJECT problem with nf_bridge
Date: Tue, 10 Mar 2009 07:29:55 +0200
Message-ID: <9b2db90b0903092229l1a02e8abtaf3e94a3a5ed641e@mail.gmail.com>
References: <9b2db90b0902260048j514b6ab0w63038bd11ab3f8f6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jengelh@medozas.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:57064 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZCJF36 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:29:58 -0400
Received: by ewy25 with SMTP id 25so1110769ewy.37
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Mar 2009 22:29:55 -0700 (PDT)
In-Reply-To: <9b2db90b0902260048j514b6ab0w63038bd11ab3f8f6@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good Morning.

I am resending this patch, as I got no feedback the previous time.

Cheers.

On Thu, Feb 26, 2009 at 10:48 AM, Nir Tzachar <nir.tzachar@gmail.com> w=
rote:
> Hello.
>
> There is a problem with the current version of ipt_REJECT when
> operating on a bridge interface.
> To be more exact, an RST is never sent to connections over the bridge=
,
> as the ip_route_me_harder function always fail.
>
> The problem arises from the following code
> (net/ipv4/netfilter/ipt_REJECT.c line 221:)
>
> =A0 =A0 =A0 =A0if (hook !=3D NF_INET_FORWARD
> #ifdef CONFIG_BRIDGE_NETFILTER
> =A0 =A0 =A0 =A0 =A0 =A0|| (nskb->nf_bridge && nskb->nf_bridge->mask &=
 BRNF_BRIDGED)
> #endif
> =A0 =A0 =A0 =A0 =A0 )
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0addr_type =3D RTN_LOCAL;
>
> but, as nskb was newly allocated just a few line back, the
> oldskb->nf_bridge was never copied, so nskb->nf_bridge is always NULL=
=2E
> The following patch corrects the problem. Please review and apply.
>
> Cheers, Nir.
>
>
> Signed-off-by: Nir Tzachar <nir.tzachar@gmail.com>
> Tested-by: Elad Kertis <elad.kertis@gmail.com>
>
> --- linux-2.6.28.7.old/net/ipv4/netfilter/ipt_REJECT.c =A02009-02-26
> 10:28:51.000000000 +0200
> +++ linux-2.6.28.7/net/ipv4/netfilter/ipt_REJECT.c =A0 =A0 =A02009-02=
-26
> 10:31:26.000000000 +0200
> @@ -98,6 +98,12 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 niph->saddr, niph->daddr,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 csum_partial(tcph,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct tcphdr), 0));
> +#ifdef CONFIG_BRIDGE_NETFILTER
> + =A0 =A0 =A0 if (oldskb->nf_bridge){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 nf_bridge_get(oldskb->nf_bridge);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 nskb->nf_bridge =3D oldskb->nf_bridge;
> + =A0 =A0 =A0 }
> +#endif
>
> =A0 =A0 =A0 =A0addr_type =3D RTN_UNSPEC;
> =A0 =A0 =A0 =A0if (hook !=3D NF_INET_FORWARD
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
