From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH 0/4] expr: cmp: Do not print unset values in xml
 and json
Date: Fri, 20 Jun 2014 09:05:58 +0200
Message-ID: <CAOkSjBisvk2=W6MTXDBbkkgB0kTEykiAr+LGF3rwabeO0pT+yA@mail.gmail.com>
References: <1403199264-14271-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:35622 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaFTHGT convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:06:19 -0400
Received: by mail-la0-f51.google.com with SMTP id mc6so2114204lab.10
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jun 2014 00:06:18 -0700 (PDT)
In-Reply-To: <1403199264-14271-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19 June 2014 19:34, Ana Rey <anarey@gmail.com> wrote:
> This patchset does tasks about does not print unset value in xml and =
json file
> and about refactoring code:
>  * expr: cmp: Get a nft_rule_expr type in nft_rule_expr_cmp_snprintf_=
* functions
>  * expr: cmp: Use nft_rule_expr_set_* in the xml parsing code
>
>
> Ana Rey (4):
>   expr: cmp: Get a nft_rule_expr type in nft_rule_expr_cmp_snprintf_*
>     functions
>   expr: cmp: Use nft_rule_expr_set_* in the xml parsing code
>   expr: cmp: Do not print unset values in xml file
>   expr: cmp: Do not print unset values in json file
>
>  src/expr/cmp.c | 112 ++++++++++++++++++++++++++++-------------------=
----------
>  1 file changed, 55 insertions(+), 57 deletions(-)
>

Hi Ana,

I reviewed this patch-set and is good to me.

thanks, regards.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
