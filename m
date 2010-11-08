From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: RFC: netfilter: cache dst_entry in conntrack
Date: Mon, 08 Nov 2010 08:23:57 +0100
Message-ID: <1289201037.2478.360.camel@edumazet-laptop>
References: <AANLkTimVY870t+ugopoabpe3+QCDC9RFh0nCtgPmJLq8@mail.gmail.com>
	 <4CD79A79.3030103@trash.net> <4CD79B12.9060502@trash.net>
	 <AANLkTimdoYvCZhm-EqbVk2gBH-WR+yVXpnZyjqFbT-RF@mail.gmail.com>
	 <1289199090.2478.326.camel@edumazet-laptop>  <4CD7A0A0.5010905@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Changli Gao <xiaosuo@gmail.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34192 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab0KHHYC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Nov 2010 02:24:02 -0500
Received: by wyb36 with SMTP id 36so3161064wyb.19
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Nov 2010 23:24:01 -0800 (PST)
In-Reply-To: <4CD7A0A0.5010905@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 08 novembre 2010 =C3=A0 08:02 +0100, Patrick McHardy a =C3=A9c=
rit :

> I think the main idea is to make double use of the existing conntrack
> lookup. The most interesting part about this idea in my opinion is
> that it should make multipath setups very easy since you don't have
> to manually deal with expiring routing cache entries anymore. However
> this clearly is a big change to the existing behaviour of the routing
> cache and needs a lot more thought, which I will perform after having
> some coffee :)

I see, but short lived conntracks are going to hurt the dst refcount.

(No coffee yet here ;) )



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
