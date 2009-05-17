From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: port based routing for local generated connections
Date: Sun, 17 May 2009 09:21:50 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905170920130.20778@fbirervta.pbzchgretzou.qr>
References: <a14f8c120905161628i6b129e87m17f6db647115315c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Jan_Rathousk=C3=BD?= <jan.rathousky@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60847 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZEQHVv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 May 2009 03:21:51 -0400
In-Reply-To: <a14f8c120905161628i6b129e87m17f6db647115315c@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2009-05-17 01:28, Jan Rathousk=C3=BD wrote:

>Hi everybody,
>I'm looking for something that allows me routing based on destination
>ports (for two OpenVPN tunnels).
>First I found nice howto [1] but there is one problem =E2=80=93 it wor=
ks only
>with LAN traffic and I want it for one computer with two ISPs. Because
>router decision is done before writing marks for local generated
>packets.

It also applies to local traffic. The packet will be re-evaluated by=20
routing if it changed its mark in the OUTPUT chain.

>I was told that "iptables -j ROUTE" is what I'm looking for.

Nope, that is obsoleted by iproute2.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
