From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: use idr instead of list to speed up packet
	lookup by id
Date: Wed, 7 Apr 2010 22:33:56 +0800
Message-ID: <y2u412e6f7f1004070733i3635487bh81cfac3e6a64474f@mail.gmail.com>
References: <4BBBFE21.9070507@gmail.com> <4BBC711E.7050602@trash.net>
	<y2m412e6f7f1004070630v14118231g13847965d7d44a54@mail.gmail.com>
	<4BBC8B44.30208@trash.net> <m2k412e6f7f1004070707sd456c5d1v567f9dca021397a2@mail.gmail.com>
	<4BBC93CA.4000207@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:37961 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0DGOeR convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:34:17 -0400
Received: by pzk42 with SMTP id 42so517731pzk.4
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Apr 2010 07:34:17 -0700 (PDT)
In-Reply-To: <4BBC93CA.4000207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 7, 2010 at 10:16 PM, Patrick McHardy <kaber@trash.net> wrot=
e:
>
> You only know that during runtime, so this will get more complicated
> than necessary. Why not simply use a hash table with a size specified
> by userspace in the queue creation command? =C2=A0The default behavio=
ur
> would be a size of 1, which is equivalent to the currently used singl=
e
> list.
>

We'd better not expose too many internal implementation details to
userspace. If we do so, we can't change its implementation easily
later. And letting user choose the size of hash table is much like the
orginal epoll(2) design, there will be security consern, such as too
much memory usage.



--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
