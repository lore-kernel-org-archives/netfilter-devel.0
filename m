From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH 0/5] queue: Do not print unset value
Date: Fri, 13 Jun 2014 12:51:20 +0200
Message-ID: <CAOkSjBjUnR6kjdFuWypJCe2igogmoUMfahvMHb5KxcE22wFu=Q@mail.gmail.com>
References: <1402651913-15065-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:60997 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaFMKvm convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:51:42 -0400
Received: by mail-la0-f41.google.com with SMTP id hz20so1359335lab.14
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2014 03:51:40 -0700 (PDT)
In-Reply-To: <1402651913-15065-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13 June 2014 11:31, Ana Rey <anarey@gmail.com> wrote:
> This patchset does tasks about does not print unset value in xml and =
json file
> and about refactoring code: "Add nft_rule_expr_queue_snprinf_* functi=
ons"
> and "Use nft_rule_expr_* in the xml".
>
> Also, It fixes some data type of variables.
>
> Ana Rey (5):
>   expr: queue: Add nft_rule_expr_queue_snprinf_* functions
>   expr: queue: Use nft_rule_expr_* in the xml
>   expr: queue: Do not print unset values in xml
>   expr: queue: Do not print unset values in json
>   expr: queue: Use the correct data type.
>
>  src/expr/queue.c | 161 ++++++++++++++++++++++++++++++++++-----------=
----------
>  1 file changed, 101 insertions(+), 60 deletions(-)
>

Hi Ana,

I've reviewed this series, and except the small thing in 1/5, they
seem OK to me.

thanks, regards.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
