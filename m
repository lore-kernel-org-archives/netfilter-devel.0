From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: ebtables extension 'http'
Date: Mon, 25 Jan 2010 20:02:08 +0100
Message-ID: <4B5DEAB0.6080401@plouf.fr.eu.org>
References: <8a87046f1001250546w1dec4136nc509510e8ac15eb8@mail.gmail.com>	 <alpine.LSU.2.01.1001251453460.10705@obet.zrqbmnf.qr>	 <8a87046f1001250632hd4220d1s9f44cad2c3b268a8@mail.gmail.com>	 <alpine.LSU.2.01.1001251707500.20906@obet.zrqbmnf.qr>	 <4B5DCBEA.5000501@trash.net>	 <alpine.LSU.2.01.1001251753560.20906@obet.zrqbmnf.qr> <8a87046f1001250945p2e666b32m7c2051e00454f8e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:54816 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab0AYTCL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 14:02:11 -0500
Received: from localhost (localhost [127.0.0.1])
	by poutre.nerim.net (Postfix) with ESMTP id E63F639DE6B
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2010 20:02:06 +0100 (CET)
Received: from poutre.nerim.net ([127.0.0.1])
	by localhost (poutre.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4-dcfxD31g0y for <netfilter-devel@vger.kernel.org>;
	Mon, 25 Jan 2010 20:02:06 +0100 (CET)
Received: from [192.168.0.246] (plouf.fr.eu.org [213.41.173.35])
	by poutre.nerim.net (Postfix) with ESMTP id CC3AD39DC36
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2010 20:02:05 +0100 (CET)
In-Reply-To: <8a87046f1001250945p2e666b32m7c2051e00454f8e4@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

=46elipe W Damasio a =E9crit :
>=20
> 2010/1/25 Jan Engelhardt <jengelh@medozas.de>:
>> The issue is that you would need to replay the tcp handshake.
>>
>> Case 1:
>> - do TCP handshake
>> - read out Host: header
>> - if proxied
>>  - good
>> - if not,
>>  - have to replay TCP handshake to next host (eww :-)
>=20
>   Would this be so bad? :-)

Yes, quite, because it must be transparent to the client. However the
new server may have a lower MSS and not support some TCP options such a=
s
windows scaling, ECN, selective ACK, window scaling, timestamps... that
the previous one supported and which are transmitted only during the
handshake, so the client would not know about. Not to mention that of
course it will use a different initial sequence number and it would hav=
e
to be translated by the bridge in each packet.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
