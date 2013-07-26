From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH] log: fix qthreshold data type
Date: Fri, 26 Jul 2013 12:01:59 +0200
Message-ID: <CAOkSjBgRp1nNcfHb1W7jo76tv3f81yBwSY5KF03Ns4oUv5yc1Q@mail.gmail.com>
References: <20130725095941.22630.18584.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:41619 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3GZKCU convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:02:20 -0400
Received: by mail-lb0-f170.google.com with SMTP id u10so2368486lbi.1
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2013 03:02:19 -0700 (PDT)
In-Reply-To: <20130725095941.22630.18584.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25 July 2013 11:59, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> As stated in include/net/netfilter/nf_log.h, qthreshold is uint16_t i=
nstead of uint32_t.
>
> This patch fixes it.
>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com=
>
> ---
v2: still u32 in kernel.

>  src/expr/log.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
>

I forgot to note this as v2.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
