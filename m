From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 5/5] Remove randomness from IP selection
Date: Mon, 28 Jan 2008 20:43:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801282041510.1185@fbirervta.pbzchgretzou.qr>
References: <b9800b70801281127i63f70d1ay7e78ed1df7b1fae6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?ISO-8859-1?Q?Mart=EDn_Ferrari?= <martin.ferrari@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35437 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbYA1TnX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:43:23 -0500
In-Reply-To: <b9800b70801281127i63f70d1ay7e78ed1df7b1fae6@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 28 2008 17:27, Mart=C3=ADn Ferrari wrote:
>
>I have recently upgraded an old router running Debian Sarge (kernel
>2.6.8), which brought kernel 2.6.18. And after that, I nice feature of
>SNAT I've been using disappeared.
>
>Searching in google, I found the mentioned patch
>(http://lists.netfilter.org/pipermail/netfilter-devel/2004-November/01=
7472.html).
>Very old, I know, but I'd still like to recover that functionality
>(not necessarily randomness, round-robin is enough). I wonder if
>there's a way of doing that without modifying the code to use the
>source port as input to the hashing function, as I prefer to stick
>with unmodified kernels.
>
>Other question this raises is, what is the purpose of SAME if SNAT is
>using always the same source IP.

SAME was merged into the base NAT code AFAIR.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
