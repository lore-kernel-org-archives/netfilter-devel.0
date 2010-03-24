From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: debugging kernel during packet drops
Date: Wed, 24 Mar 2010 18:04:49 +0100
Message-ID: <1269450289.3213.66.camel@edumazet-laptop>
References: <4BA74950.6000305@infopact.nl> <4BA7A5D8.5080101@trash.net>
	 <4BA8DAC5.6050002@infopact.nl> <1269364893.2983.296.camel@edumazet-laptop>
	 <4BAA2DC5.7000409@infopact.nl> <1269447674.3213.64.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1003241727080.29135@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jorrit Kronjee <j.kronjee@infopact.nl>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51487 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab0CXRFG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:05:06 -0400
Received: by bwz1 with SMTP id 1so117608bwz.21
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Mar 2010 10:05:04 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1003241727080.29135@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 24 mars 2010 =C3=A0 17:28 +0100, Jan Engelhardt a =C3=A9cri=
t :
> On Wednesday 2010-03-24 17:21, Eric Dumazet wrote:
> >dsthash_find() takes a lot of cpu, its a sign your hash table params
> >might be suboptimal.
> >
> >Please send us "iptables -nvL"=20
>=20
> Consider using "iptables-save" instead, because -nvL is just
> an abridged tabular display.

Yes you are right, but as I was also interested by rules and numbers
(packets/bytes) of matches, please Jorrit post :

iptables-save
iptables -nvL

Thanks


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
