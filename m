From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] nfnetlink_queue: use hash table to speed up entry
 lookup
Date: Wed, 21 Apr 2010 21:04:24 +0200
Message-ID: <1271876664.7895.3117.camel@edumazet-laptop>
References: <1271773896-28246-1-git-send-email-xiaosuo@gmail.com>
	 <4BCDC0F4.5070904@trash.net>
	 <i2t412e6f7f1004201704ubf9a7018oaf385e0831382a12@mail.gmail.com>
	 <4BCEF100.10006@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:65515 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab0DUTEd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Apr 2010 15:04:33 -0400
Received: by bwz1 with SMTP id 1so10542995bwz.2
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Apr 2010 12:04:31 -0700 (PDT)
In-Reply-To: <4BCEF100.10006@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 21 avril 2010 =C3=A0 14:35 +0200, Patrick McHardy a =C3=A9c=
rit :

> > I also think there are too much tricks in my code above, but Eric
> > concerns the performance of modulo.
>=20
> Alternatively we could round the hash size to the next power of
> two to avoid this.

Sure, and my comments were about flex_array() abuse of divides ;)


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
