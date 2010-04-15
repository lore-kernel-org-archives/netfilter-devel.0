From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry
 finding.
Date: Thu, 15 Apr 2010 10:23:10 +0200
Message-ID: <1271319790.16881.2188.camel@edumazet-laptop>
References: <4BBEA97A.5020303@gmail.com> <4BC442E5.8020001@trash.net>
	 <n2n412e6f7f1004130406xfeb33397m666d36a49ba46661@mail.gmail.com>
	 <1271162669.16881.301.camel@edumazet-laptop>
	 <r2q412e6f7f1004130609we90ce635u673ba882b8b50f50@mail.gmail.com>
	 <1271164991.16881.346.camel@edumazet-laptop> <4BC470B3.4030007@trash.net>
	 <h2n412e6f7f1004142353uac023edfqc59d076c0d8a1784@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:57926 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab0DOIXS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 04:23:18 -0400
Received: by bwz25 with SMTP id 25so1171944bwz.28
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Apr 2010 01:23:16 -0700 (PDT)
In-Reply-To: <h2n412e6f7f1004142353uac023edfqc59d076c0d8a1784@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 15 avril 2010 =C3=A0 14:53 +0800, Changli Gao a =C3=A9crit :
> On Tue, Apr 13, 2010 at 9:25 PM, Patrick McHardy <kaber@trash.net> wr=
ote:
> >> Yes, that is why vmalloc() is perfect for this case. No extra memo=
ry for
> >> management, but one pointer for each page of memory.
> >
> > I agree, if it works for conntrack, it certainly also works for
> > nfnetlink_queue.
> >
>=20
> I need to allocate memory in atomic section, so vmalloc() can't be us=
ed. :(
>=20
> does double check mechanism works?
>=20

Allocate memory to setup a hash table in atomic section ?

Changli you can forget this right now, this is not serious.

We are not going to use this thing because your requirements are crazy.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
