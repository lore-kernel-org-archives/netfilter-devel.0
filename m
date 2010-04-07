From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: use idr instead of list to speed up packet
	lookup by id
Date: Wed, 7 Apr 2010 22:07:47 +0800
Message-ID: <m2k412e6f7f1004070707sd456c5d1v567f9dca021397a2@mail.gmail.com>
References: <4BBBFE21.9070507@gmail.com> <4BBC711E.7050602@trash.net>
	<y2m412e6f7f1004070630v14118231g13847965d7d44a54@mail.gmail.com>
	<4BBC8B44.30208@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61866 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab0DGOPn convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:15:43 -0400
Received: by pwj9 with SMTP id 9so965196pwj.19
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Apr 2010 07:15:43 -0700 (PDT)
In-Reply-To: <4BBC8B44.30208@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 7, 2010 at 9:40 PM, Patrick McHardy <kaber@trash.net> wrote=
:
> Processing packets in order doesn't necessarily mean that there aren'=
t
> many packets queued. Its just that the current scheme is pretty much
> optimal for this case since the verdict will always refer to the firs=
t
> entry in the list.
>

How about keeping the old behavior by default, and replace the single
list with idr when an unorder vedict is received.



--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
