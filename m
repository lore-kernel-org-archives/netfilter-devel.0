From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: TCP-packet with PUSH flag with wrong payload data in LOCAL_OUT
 hook.
Date: Wed, 21 Jan 2009 19:52:12 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901211950220.20352@fbirervta.pbzchgretzou.qr>
References: <49776300.1060708@lissi.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?0JrQvtCx0YvQu9GP0L3RgdC60LjQuSDQktC70LDQtNC40LzQuNGA?=
	<kent@lissi.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50535 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZAUSwP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 13:52:15 -0500
In-Reply-To: <49776300.1060708@lissi.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-01-21 19:01, =D0=9A=D0=BE=D0=B1=D1=8B=D0=BB=D1=8F=D0=BD=
=D1=81=D0=BA=D0=B8=D0=B9 =D0=92=D0=BB=D0=B0=D0=B4=D0=B8=D0=BC=D0=B8=D1=80=
 wrote:
>
>I see in my module 3 handshake packets - they all normal.
>Then I see first packet with payload - it is TCP-packet with PSH and A=
CK
>flags and it is not normal at all.

It could be something in your code (which seem to be absent here).

>In this packet in tcp-data area I MUST see such string:
>"GET / HTTP/1.1..."
>or in HEX
>"4745 5420 2f20 4854 5450 2f31 2e31 ..."
>BUT I see such data in it:
>"0200 0100 0100 0000 0100 0000 0000 ....".

Could be TCP options. Payload could be begin in a later packet maybe.
Or somewhere in your code you have a wrong pointer.
I don't read glass spheres so...
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
