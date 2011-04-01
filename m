From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 05/17] v4: rename init_extensions() to
 init_extensions4()
Date: Fri, 1 Apr 2011 12:15:22 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104011214570.10168@obet.zrqbmnf.qr>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com> <1301632053-3694-5-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54647 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab1DAKPX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 06:15:23 -0400
In-Reply-To: <1301632053-3694-5-git-send-email-zenczykowski@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-04-01 06:27, Maciej =C5=BBenczykowski wrote:
>diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
>index b96bd11..84688d3 100644
>--- a/extensions/GNUmakefile.in
>+++ b/extensions/GNUmakefile.in
>@@ -127,8 +127,8 @@ initext4.c: .initext4.dd
> 	for i in ${initext_func}; do \
> 		echo "extern void lib$${i}_init(void);" >>$@; \
> 	done; \
>-	echo "void init_extensions(void);" >>$@; \
>-	echo "void init_extensions(void)" >>$@; \
>+	echo "void init_extensions4(void);" >>$@; \
>+	echo "void init_extensions4(void)" >>$@; \
> 	echo "{" >>$@; \
> 	for i in ${initext_func}; do \
> 		echo  " ""lib$${i}_init();" >>$@; \

And the reason for these renames is...?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
