From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: Regarding libxt_multiport translation in nft
Date: Wed, 9 Mar 2016 11:06:05 +0100
Message-ID: <CAOkSjBimhamOTLjrQghozFRdj=FvRMO=nkGG0ADui7fw5-7KQQ@mail.gmail.com>
References: <20160307212141.GA10594@sonyv> <20160308105346.GB4008@salvia> <56DFCB53.8090601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: FaTe <gokuvsvegita@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34975 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbcCIKGb convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2016 05:06:31 -0500
Received: by mail-wm0-f46.google.com with SMTP id l68so170260201wml.0
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Mar 2016 02:06:31 -0800 (PST)
In-Reply-To: <56DFCB53.8090601@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 9 March 2016 at 08:05, FaTe <gokuvsvegita@gmail.com> wrote:
> Hello Pablo,
>
> I would require some guidance regarding the libxt_multiport translati=
on in nft.
>
> If the translation is over ip4 family :
> $ iptables-translate -A INPUT -p tcp -m multiport --ports 3:4  -j ACC=
EPT
> nft add rule ip filter INPUT ip protocol tcp dport { 3-4 } tcp sport =
{ 3-4 } counter accept
>                              ^^^^^^^^^^^
>                              this causes problem.
> Similarly for ipv6 :
> $ ip6tables-translate -A input -p tcp -m multiport --dports 1024:2048=
,2049:3333 -j ACCEPT
> nft add rule ip6 filter input meta l4proto tcp dport { 1024-2048,2049=
-3333 } counter accept
>                               ^^^^^^^^^^^^
>                               this is causing problem.
>
> both the strings "ip protocol" and "meta l4proto" is not introduced b=
y libxt_multiport.
> And in the absence of both , the command works.
>
> For example ,
> $ nft add rule ip filter INPUT tcp dport { 3-4 } tcp sport { 3-4 } co=
unter accept
>
> $ nft add rule ip6 filter input tcp dport { 1024-2048,2049-3333 } cou=
nter accept
>
> Any comment regarding this behaviour ?

They are different statements, rules should be something like:
 * meta l4proto tcp tcp dport XX
 * ip protocol tcp tcp dport XX

However, the two statements are redundants... the second implies the fi=
rst.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
