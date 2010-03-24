From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: debugging kernel during packet drops
Date: Wed, 24 Mar 2010 18:25:10 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003241824200.25215@obet.zrqbmnf.qr>
References: <4BA74950.6000305@infopact.nl> <4BA7A5D8.5080101@trash.net>  <4BA8DAC5.6050002@infopact.nl> <1269364893.2983.296.camel@edumazet-laptop>  <4BAA2DC5.7000409@infopact.nl> <1269447674.3213.64.camel@edumazet-laptop>  <alpine.LSU.2.01.1003241727080.29135@obet.zrqbmnf.qr>
 <1269450289.3213.66.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jorrit Kronjee <j.kronjee@infopact.nl>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54655 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab0CXRZL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:25:11 -0400
In-Reply-To: <1269450289.3213.66.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-03-24 18:04, Eric Dumazet wrote:

>Le mercredi 24 mars 2010 =C3=A0 17:28 +0100, Jan Engelhardt a =C3=A9cr=
it :
>> On Wednesday 2010-03-24 17:21, Eric Dumazet wrote:
>> >dsthash_find() takes a lot of cpu, its a sign your hash table param=
s
>> >might be suboptimal.
>> >
>> >Please send us "iptables -nvL"=20
>>=20
>> Consider using "iptables-save" instead, because -nvL is just
>> an abridged tabular display.
>
>Yes you are right, but as I was also interested by rules and numbers
>(packets/bytes) of matches, please Jorrit post :
>
>iptables-save
>iptables -nvL

The numbers you get with iptables-save -c.
There really is not anything that save does not output, after all, it's=
=20
meant to store the exact state.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
