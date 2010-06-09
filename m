From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next-2.6] netfilter: queue: rwlock to spinlock
 conversion
Date: Wed, 09 Jun 2010 16:00:53 +0200
Message-ID: <1276092053.2442.142.camel@edumazet-laptop>
References: <1276002860.2486.22.camel@edumazet-laptop>
	 <4C0F9BCD.2040605@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57361 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab0FIOA5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jun 2010 10:00:57 -0400
Received: by fxm8 with SMTP id 8so3598838fxm.19
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Jun 2010 07:00:55 -0700 (PDT)
In-Reply-To: <4C0F9BCD.2040605@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 09 juin 2010 =C3=A0 15:49 +0200, Patrick McHardy a =C3=A9cr=
it :
> Eric Dumazet wrote:
> > Converts queue_lock rwlock to a spinlock.
> >
> > (readlocked part can be changed by reads of integer values)
> >
> > One atomic operation instead of four per ipq_enqueue_packet() call.
>=20
> Looks fine to me, applied, thanks Eric.
>=20
> Just wondering since ip_queue is actually obsoleted, do you intend to
> change ip6_queue and nfnetlink_queue in a similar fashion?
>=20

Indeed, I started these yesterday but had to pause them, probably befor=
e
tomorrow, if no urgent stuff raise before ;)



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
