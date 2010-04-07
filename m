From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: use idr instead of list to speed up packet
 lookup by id
Date: Wed, 07 Apr 2010 14:25:36 +0200
Message-ID: <1270643136.2091.1013.camel@edumazet-laptop>
References: <4BBBFE21.9070507@gmail.com>  <4BBC711E.7050602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: xiaosuo@gmail.com, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63297 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab0DGMZn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:25:43 -0400
Received: by bwz1 with SMTP id 1so753502bwz.21
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Apr 2010 05:25:42 -0700 (PDT)
In-Reply-To: <4BBC711E.7050602@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 07 avril 2010 =C3=A0 13:48 +0200, Patrick McHardy a =C3=A9c=
rit :
> Changli Gao wrote:
> > use idr instead of list to speed up packet lookup by id.
> >=20
> > The current implementations of nfnetlink_queue, ip_queue and ip6_qu=
eue
> > are all use list to save the packets queued. If the verdicts aren't
> > received in order, the lookup for the corresponding packets isn't
> > efficient. As the ids is generated and maintained in kernel, we can=
 use
> > idr to speed up the lookup. The side effect of this patch is fixing=
 the
> > potential id overlap in nfnetlink_queue.
>=20
> I'm interested in how this affects performance for the vast majority
> of users, which process messages in order. A simple hash table looks
> like a better choice here since we know the maximum number of entries
> in advance and also could have the user specify the desired hash size=
=2E

Yes, a hash table would be good, but cost 8 bytes per slot.

Changli, did you tried RBL tree ? It might fit better both your needs
and Patrick concerns...


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
