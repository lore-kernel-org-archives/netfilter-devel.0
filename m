From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: bug : nft_redirect port byteorder issue
Date: Fri, 12 Dec 2014 11:49:13 +0100
Message-ID: <CAOkSjBj3uY8f==Xwc1GirAgj7-QdtViOxVMFhfPKxUFnJX9dVA@mail.gmail.com>
References: <54885B08.1010700@c-s.fr> <20141210182244.GA5622@salvia> <548AC07D.6080703@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	GUITTON Alex <alex.guitton@c-s.fr>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: leroy christophe <christophe.leroy@c-s.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:33107 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934334AbaLLKtf convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:49:35 -0500
Received: by mail-la0-f49.google.com with SMTP id hs14so5660569lab.8
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Dec 2014 02:49:33 -0800 (PST)
In-Reply-To: <548AC07D.6080703@c-s.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 December 2014 at 11:16, leroy christophe <christophe.leroy@c-s.fr=
> wrote:
> Hi,
>
> table ip nat {
>         chain prerouting {
>                  type nat hook prerouting priority 0;
>                  tcp dport 222 redirect :22
>         }
>         chain postrouting {
>                  type nat hook postrouting priority 0;
>         }
> }
>
> With the above rules, data[priv->sreg_proto_min].data[0] has value 0x=
160000
> instead of 0x16 on powerpc (Big Endian byte order)
>
> Due to this, mr.range[0].min.all gets assigned value 0 instead of 22.
>
> Below patch fixes it, but it is maybe not the proper way to fix it, s=
o I let
> it up to you.
>
> Christophe
>
> diff --git a/net/ipv4/netfilter/nft_redir_ipv4.c
> b/net/ipv4/netfilter/nft_redir_ipv4.c
> index 643c596..554bb32 100644
> --- a/net/ipv4/netfilter/nft_redir_ipv4.c
> +++ b/net/ipv4/netfilter/nft_redir_ipv4.c
> @@ -28,9 +28,9 @@ static void nft_redir_ipv4_eval(const struct nft_ex=
pr
> *expr,
>         memset(&mr, 0, sizeof(mr));
>         if (priv->sreg_proto_min) {
>                 mr.range[0].min.all =3D (__force __be16)
> -                                       data[priv->sreg_proto_min].da=
ta[0];
> +
> *(__be16*)&data[priv->sreg_proto_min].data[0];
>                 mr.range[0].max.all =3D (__force __be16)
> -                                       data[priv->sreg_proto_max].da=
ta[0];
> +
> *(__be16*)&data[priv->sreg_proto_max].data[0];
>                 mr.range[0].flags |=3D NF_NAT_RANGE_PROTO_SPECIFIED;
>         }
>

With nft_nat and nft_redir_ipv6, the three code are almost the same:

http://git.kernel.org/cgit/linux/kernel/git/pablo/nf-next.git/tree/net/=
netfilter/nft_nat.c
http://git.kernel.org/cgit/linux/kernel/git/pablo/nf-next.git/tree/net/=
ipv6/netfilter/nft_redir_ipv6.c

Since it seems the same issue may appear, would you like to patch all o=
f them?

regards.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
