From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] iptables: extensions: libxt_MARK: Fix translation of
 --set-xmark option
Date: Wed, 22 Jun 2016 11:49:03 +0200
Message-ID: <CAOkSjBjNL5i20ExhjWJnjt6w4cDnFzhReetjb9iCHQJmDQm=Aw@mail.gmail.com>
References: <1466543023-15740-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?Roberto_Garc=C3=ADa?= <rodanber@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34052 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbcFVKEZ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 06:04:25 -0400
Received: by mail-lf0-f65.google.com with SMTP id l184so13074242lfl.1
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 03:04:19 -0700 (PDT)
In-Reply-To: <1466543023-15740-1-git-send-email-rodanber@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21 June 2016 at 23:03,  <rodanber@gmail.com> wrote:
> From: Roberto Garc=C3=ADa <rodanber@gmail.com>
>
> Fix translation of MARK target's --set-xmark option.
>
> Before:
>
>  # iptables-translate -t mangle -A PREROUTING -j MARK --set-xmark 0x6=
4/0xaf
>   nft add rule ip mangle PREROUTING counter meta mark set mark xor 0x=
64 and 0xaf
>
> After:
>
>   # iptables-translate -t mangle -A PREROUTING -j MARK --set-xmark 0x=
64/0xaf
>   nft add rule ip mangle PREROUTING counter meta mark set mark xor 0x=
64 and \
>   0xffffff50
>
> Signed-off-by: Roberto Garc=C3=ADa <rodanber@gmail.com>
> ---
>  extensions/libxt_MARK.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Seems good to me :-)

Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
