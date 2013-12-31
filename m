From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH 1/2] src: rename the parameter tag to
 node_name in jansson function
Date: Tue, 31 Dec 2013 19:59:57 +0100
Message-ID: <CAOkSjBiBzxqMb6+__d1Ye4m29DUcDdahr6iio5mBk+U4Aaiq4w@mail.gmail.com>
References: <20131231112747.11095.53072.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Alvaro Neira <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:64716 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab3LaTAT convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Dec 2013 14:00:19 -0500
Received: by mail-la0-f43.google.com with SMTP id n7so6371262lam.16
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Dec 2013 11:00:18 -0800 (PST)
In-Reply-To: <20131231112747.11095.53072.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31 December 2013 12:27, Alvaro Neira <alvaroneay@gmail.com> wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>
> I have changed this parameter for having consistence with the xml hel=
per
> function
>
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  src/internal.h |   18 ++++++++++--------
>  src/jansson.c  |   34 ++++++++++++++++++----------------
>  2 files changed, 28 insertions(+), 24 deletions(-)

This patch seems OK to me :-)
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
