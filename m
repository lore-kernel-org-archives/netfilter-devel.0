From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH nf 1/2] netfilter: nfnetlink: avoid recurrent netns
 lookups in call_batch
Date: Thu, 10 Dec 2015 09:38:43 +0100
Message-ID: <CAOkSjBhY-oUHeY3b78RgQ=cvozH8NEzcbfODGtfs=UeDXBotgg@mail.gmail.com>
References: <1449663164-1606-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36152 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbbLJIjE convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Dec 2015 03:39:04 -0500
Received: by mail-wm0-f53.google.com with SMTP id w144so13552339wmw.1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2015 00:39:03 -0800 (PST)
In-Reply-To: <1449663164-1606-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 9 December 2015 at 13:12, Pablo Neira Ayuso <pablo@netfilter.org> wr=
ote:
> Pass the net pointer to the call_batch callback functions so we can s=
kip
> recurrent lookups.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> I would really appreciate to get a Tested-by: tag from you on this.
>
>  include/linux/netfilter/nfnetlink.h |  2 +-
>  net/netfilter/nf_tables_api.c       | 96 +++++++++++++++++----------=
----------
>  net/netfilter/nfnetlink.c           |  2 +-
>  3 files changed, 47 insertions(+), 53 deletions(-)
>

thanks, the problem seems to be fixed now.

Tested-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
