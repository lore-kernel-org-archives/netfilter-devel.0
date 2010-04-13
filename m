From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry
	finding.
Date: Tue, 13 Apr 2010 21:09:51 +0800
Message-ID: <r2q412e6f7f1004130609we90ce635u673ba882b8b50f50@mail.gmail.com>
References: <4BBEA97A.5020303@gmail.com> <4BC442E5.8020001@trash.net>
	<n2n412e6f7f1004130406xfeb33397m666d36a49ba46661@mail.gmail.com>
	<1271162669.16881.301.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35480 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab0DMNKL convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:10:11 -0400
Received: by pwj9 with SMTP id 9so5254827pwj.19
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Apr 2010 06:10:11 -0700 (PDT)
In-Reply-To: <1271162669.16881.301.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 13, 2010 at 8:44 PM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
>
> Thats theory. And for sparse arrays, that pro might be true.
> In your case, you prealloc all the array, using more ram than vmalloc=
=2E..
>

I prealloc all the arrays, because all of them are needed later in any =
way.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
