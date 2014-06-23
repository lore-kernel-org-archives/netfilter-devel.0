From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH 0/4] expr: meta: Do not print unset values in xml
 and json
Date: Mon, 23 Jun 2014 11:11:06 +0200
Message-ID: <CAOkSjBghgORmMOHA1cCY9fWz8RPkdOG0vovGPA-RSaMCtA52mg@mail.gmail.com>
References: <1403368200-8860-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:60279 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbaFWJL2 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:11:28 -0400
Received: by mail-lb0-f170.google.com with SMTP id 10so4118049lbg.1
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 02:11:26 -0700 (PDT)
In-Reply-To: <1403368200-8860-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21 June 2014 18:29, Ana Rey <anarey@gmail.com> wrote:
> This patchset does tasks about does not print unset value in xml and =
json file
> and about refactoring code:
> * "expr: meta: Delete the last comma character in json text."
> * "expr: meta: Use nft_rule_expr_set_* in the xml parsing code"
>
> Ana Rey (4):
>   expr: meta: Use nft_rule_expr_set_* in the xml parsing code
>   expr: meta: Do not print unset values in xml file
>   expr: meta: Delete the last comma character in json text.
>   expr: meta: Do not print unset values in json file
>
>  src/expr/meta.c | 80 +++++++++++++++++++++++------------------------=
----------
>  1 file changed, 32 insertions(+), 48 deletions(-)
>

Hi Ana, series reviewed.

thanks.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
