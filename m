From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: TCP-packet with PUSH flag with wrong payload data in LOCAL_OUT
 hook.
Date: Wed, 21 Jan 2009 20:05:04 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901212004260.21029@fbirervta.pbzchgretzou.qr>
References: <49776300.1060708@lissi.ru> <alpine.LSU.2.00.0901211950220.20352@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35123 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbZAUTFG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 14:05:06 -0500
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 468101CBD2986
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Jan 2009 20:05:04 +0100 (CET)
In-Reply-To: <alpine.LSU.2.00.0901211950220.20352@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



>  kent@lissi.ru
>    SMTP error from remote mail server after end of data:
>    host 194.84.136.194 [194.84.136.194]: 550 5.7.1 Message rejected.

Should - have - known.





>On Wednesday 2009-01-21 19:01, =D0=9A=D0=BE=D0=B1=D1=8B=D0=BB=D1=8F=D0=
=BD=D1=81=D0=BA=D0=B8=D0=B9 =D0=92=D0=BB=D0=B0=D0=B4=D0=B8=D0=BC=D0=B8=D1=
=80 wrote:
>>
>>I see in my module 3 handshake packets - they all normal.
>>Then I see first packet with payload - it is TCP-packet with PSH and =
ACK
>>flags and it is not normal at all.
>>In this packet in tcp-data area I MUST see such string:
>>"GET / HTTP/1.1..."
>>or in HEX
>>"4745 5420 2f20 4854 5450 2f31 2e31 ..."
>>BUT I see such data in it:
>>"0200 0100 0100 0000 0100 0000 0000 ....".
>
>Could be TCP options. Payload could be begin in a later packet maybe.
>Or somewhere in your code you have a wrong pointer.
>I don't read glass spheres so...[...]
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
