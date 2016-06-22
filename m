From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] iptables: extensions: libxt_MARK: Add translation for
 revision 1 to nft
Date: Wed, 22 Jun 2016 11:47:14 +0200
Message-ID: <CAOkSjBiKZR5=WcusV65Pq8qUOGaf3RhdKgkOpkRzb5z+DO8iXA@mail.gmail.com>
References: <1466539704-1666-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?Roberto_Garc=C3=ADa?= <rodanber@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34895 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbcFVJrf convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 05:47:35 -0400
Received: by mail-lf0-f67.google.com with SMTP id w130so12961106lfd.2
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 02:47:34 -0700 (PDT)
In-Reply-To: <1466539704-1666-1-git-send-email-rodanber@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21 June 2016 at 22:08,  <rodanber@gmail.com> wrote:
> From: Roberto Garc=C3=ADa <rodanber@gmail.com>
>
> Add translation for revision 1 of the MARK target to nft.
>
> Examples:
>
>   # iptables-translate -t mangle -A PREROUTING -j MARK --set-mark 0x6=
4
>   nft add rule ip mangle PREROUTING counter meta mark set 0x64
>
>   # iptables-translate -t mangle -A PREROUTING -j MARK --and-mark 0x6=
4
>   nft add rule ip mangle PREROUTING counter meta mark set mark and 0x=
64
>
>   # iptables-translate -t mangle -A PREROUTING -j MARK --or-mark 0x64
>   nft add rule ip mangle PREROUTING counter meta mark set mark or 0x6=
4
>
> Signed-off-by: Roberto Garc=C3=ADa <rodanber@gmail.com>
> ---
>  extensions/libxt_MARK.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>

Seems good to me.

Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
