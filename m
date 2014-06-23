From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH 0/3] expr: immediate: Do not print unset values
 in xml and json
Date: Mon, 23 Jun 2014 11:02:53 +0200
Message-ID: <CAOkSjBgVWOrHNAKxVDR0juXbJDDjLip54SFK4-6AYcga6VH9xw@mail.gmail.com>
References: <1403366023-6385-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:53599 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaFWJDP convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:03:15 -0400
Received: by mail-lb0-f181.google.com with SMTP id p9so3992402lbv.40
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 02:03:13 -0700 (PDT)
In-Reply-To: <1403366023-6385-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21 June 2014 17:53, Ana Rey <anarey@gmail.com> wrote:
> This patchset does tasks about does not print unset value in xml and =
json file
> and about refactoring code:
> * "expr: immediate: Use nft_rule_expr_set_* in the xml parsing code"
>
> Ana Rey (3):
>   expr: immediate: Use nft_rule_expr_set_* in the xml parsing code
>   expr: immediate: Do not print unset values in json file
>   expr: immediate: Do not print unset values in xml file
>
>  src/expr/immediate.c | 95 +++++++++++++++++++++++++-----------------=
----------
>  1 file changed, 46 insertions(+), 49 deletions(-)

Hi Ana, I reviewed the series and seems fine to me.

regards.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
