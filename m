From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: save the hash of the tuple in the original
 direction for latter use
Date: Tue, 17 Aug 2010 16:46:46 +0800
Message-ID: <AANLkTinuUuZSqEzfQAF422x2gYsVLzFQtXZKNLhgw+9g@mail.gmail.com>
References: <1282029386-2952-1-git-send-email-xiaosuo@gmail.com> <1282033817.2448.18.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47483 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab0HQIrI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:47:08 -0400
In-Reply-To: <1282033817.2448.18.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 17, 2010 at 4:30 PM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
>
> Three variables ?
>
> static atomic_t rnd __read_mostly;
>
> if (unlikely(!atomic_read(&rnd))) {
> =A0 =A0 =A0 =A0unsigned int val;
>
> =A0 =A0 =A0 =A0get_random_bytes(&val, sizeof(val));
> =A0 =A0 =A0 =A0if (!val)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0val =3D 1;
> =A0 =A0 =A0 =A0atomic_cmpxchg(&rnd, 0, val);
> }
>


Good idea. However, atomic_t is a volatile variable, and it prevent
ILP. I think maybe it hurts the likely case. cmpxchg() is an atomic
operations, so is the bellow code better?

 static unsigned long rnd __read_mostly;

 if (unlikely(!rnd)) {
        unsigned long val;

        get_random_bytes(&val, sizeof(val));
        if (!val)
                val =3D 1;
        cmpxchg(&rnd, 0, val);
 }

Thanks.

--=20
Regards,
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
