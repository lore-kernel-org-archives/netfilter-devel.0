From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: ebtables extension 'http'
Date: Tue, 26 Jan 2010 14:29:37 +0800
Message-ID: <412e6f7f1001252229q6e8afde1r474939fadeea57ae@mail.gmail.com>
References: <8a87046f1001250546w1dec4136nc509510e8ac15eb8@mail.gmail.com>
	 <alpine.LSU.2.01.1001251453460.10705@obet.zrqbmnf.qr>
	 <8a87046f1001250632hd4220d1s9f44cad2c3b268a8@mail.gmail.com>
	 <alpine.LSU.2.01.1001251707500.20906@obet.zrqbmnf.qr>
	 <4B5DCBEA.5000501@trash.net>
	 <alpine.LSU.2.01.1001251753560.20906@obet.zrqbmnf.qr>
	 <8a87046f1001250945p2e666b32m7c2051e00454f8e4@mail.gmail.com>
	 <4B5DEAB0.6080401@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:49719 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab0AZG3j convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jan 2010 01:29:39 -0500
Received: by fxm20 with SMTP id 20so7429fxm.21
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2010 22:29:38 -0800 (PST)
In-Reply-To: <4B5DEAB0.6080401@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 26, 2010 at 3:02 AM, Pascal Hambourg
<pascal.mail@plouf.fr.eu.org> wrote:
> Hello,
>
> Felipe W Damasio a =C3=A9crit :
>>
>> 2010/1/25 Jan Engelhardt <jengelh@medozas.de>:
>>> The issue is that you would need to replay the tcp handshake.
>>>
>>> Case 1:
>>> - do TCP handshake
>>> - read out Host: header
>>> - if proxied
>>> =C2=A0- good
>>> - if not,
>>> =C2=A0- have to replay TCP handshake to next host (eww :-)
>>
>> =C2=A0 Would this be so bad? :-)
>
> Yes, quite, because it must be transparent to the client. However the
> new server may have a lower MSS and not support some TCP options such=
 as
> windows scaling, ECN, selective ACK, window scaling, timestamps... th=
at
> the previous one supported and which are transmitted only during the
> handshake, so the client would not know about.

how about learning this info from the next hop by sending a SYN packet
with all options set and the largest MSS. It sounds like TCP splicing
and SYN proxy. And I heard some one had implemented SYN proxy in
Linux, and xBSD also support SYN proxy. Is there any chance to
integrate SYN proxy and TCP splicing into Linux?

> Not to mention that of
> course it will use a different initial sequence number and it would h=
ave
> to be translated by the bridge in each packet.

NAT also need to take care of this, so we can reuse the code already
in the kernel maybe.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
