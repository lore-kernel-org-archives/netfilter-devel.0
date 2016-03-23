From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH nft] src: store parser location for handle and position IDs
Date: Wed, 23 Mar 2016 17:02:43 +0100
Message-ID: <CAOkSjBj9Y4siLUzzqVU+=mYs4D-iwYbAiWc8wjLtjLhvktn0mg@mail.gmail.com>
References: <1458748265-6100-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35671 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756AbcCWQDF convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Mar 2016 12:03:05 -0400
Received: by mail-wm0-f67.google.com with SMTP id r129so70761wmr.2
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2016 09:03:04 -0700 (PDT)
In-Reply-To: <1458748265-6100-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23 March 2016 at 16:51, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
> Store the parser location structure for handle and position IDs so we
> can use this information from the evaluation step, to provide better
> error reporting.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/rule.h            | 26 ++++++++++++++++++++++++--
>  src/netlink.c             | 14 +++++++-------
>  src/netlink_delinearize.c |  4 ++--
>  src/parser_bison.y        | 19 ++++++++++++++-----
>  src/rule.c                |  6 +++---
>  5 files changed, 50 insertions(+), 19 deletions(-)
>

Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

I can't refresh my patchset until next week, I will be travelling.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
