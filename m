From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 3/8] [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign
 a non-clashing value
Date: Wed, 9 Apr 2008 15:59:26 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804091552430.4411@fbirervta.pbzchgretzou.qr>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <2a75525ff0d60f2e71df2c9c3d040d3a76451713.1207668694.git.jengelh@computergmbh.de> <47FCBC24.4020209@trash.net> <alpine.LNX.1.10.0804091508480.4411@fbirervta.pbzchgretzou.qr>
 <47FCC0D2.7060306@trash.net> <alpine.LNX.1.10.0804091514550.4411@fbirervta.pbzchgretzou.qr> <47FCC2F4.4030901@trash.net> <alpine.LNX.1.10.0804091533010.4411@fbirervta.pbzchgretzou.qr> <47FCC7B0.6080205@trash.net> <alpine.LNX.1.10.0804091545570.4411@fbirervta.pbzchgretzou.qr>
 <47FCC9CC.4070307@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45863 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYDIN71 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:59:27 -0400
In-Reply-To: <47FCC9CC.4070307@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-09 15:51, Patrick McHardy wrote:
>
>> So since that just came to my mind, how about using the
>> somewhat odd one NFPROTO_TOTAL?
>
> How about just using MAX the way a maximum is defined?
>

MAX is just ambiguous.

 - the maximum /number/ [i.e.=C2=A0counting things] of something or
 - the maximum [array index] /value/

and apparently noone encoded the intent of MAX into their
constant's name when writing it.


Make a public vote on lkml if you dare, or I will >>:-]
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
