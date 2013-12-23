From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH] build: properly handle --without-{xml,json}-parsing
Date: Mon, 23 Dec 2013 14:53:16 +0100
Message-ID: <CAOkSjBgo8ijmNy71xeAe+z3C1xyHoTfC54K+XiwRVZbqzb5XZA@mail.gmail.com>
References: <1387790097-9314-1-git-send-email-dwfreed@mtu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Douglas Freed <dwfreed@mtu.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:60814 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab3LWNxh convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Dec 2013 08:53:37 -0500
Received: by mail-la0-f53.google.com with SMTP id mc6so2240448lab.26
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Dec 2013 05:53:36 -0800 (PST)
In-Reply-To: <1387790097-9314-1-git-send-email-dwfreed@mtu.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23 December 2013 10:14, Douglas Freed <dwfreed@mtu.edu> wrote:
> This patch fixes how --without-{xml,json}-parsing (and subsequently
> --with-{xml,json}-parsing=3Dno) is handled.  Prior to this,
> --without-{xml,json}-parsing actually resulted in libnftables being
> built with that parsing enabled.
>
> Signed-off-by: Douglas Freed <dwfreed@mtu.edu>
> ---
>  configure.ac | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Hi,

I've tested your patch, and seems fine to me.

Thanks.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
