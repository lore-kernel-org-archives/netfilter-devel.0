From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry
 finding.
Date: Tue, 13 Apr 2010 15:23:11 +0200
Message-ID: <1271164991.16881.346.camel@edumazet-laptop>
References: <4BBEA97A.5020303@gmail.com> <4BC442E5.8020001@trash.net>
	 <n2n412e6f7f1004130406xfeb33397m666d36a49ba46661@mail.gmail.com>
	 <1271162669.16881.301.camel@edumazet-laptop>
	 <r2q412e6f7f1004130609we90ce635u673ba882b8b50f50@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:61808 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab0DMNXU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:23:20 -0400
Received: by bwz19 with SMTP id 19so2065bwz.21
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Apr 2010 06:23:18 -0700 (PDT)
In-Reply-To: <r2q412e6f7f1004130609we90ce635u673ba882b8b50f50@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 13 avril 2010 =C3=A0 21:09 +0800, Changli Gao a =C3=A9crit :
> On Tue, Apr 13, 2010 at 8:44 PM, Eric Dumazet <eric.dumazet@gmail.com=
> wrote:
> >
> > Thats theory. And for sparse arrays, that pro might be true.
> > In your case, you prealloc all the array, using more ram than vmall=
oc...
> >
>=20
> I prealloc all the arrays, because all of them are needed later in an=
y way.
>=20

Yes, that is why vmalloc() is perfect for this case. No extra memory fo=
r
management, but one pointer for each page of memory.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
