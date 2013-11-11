From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: TOS target mask - leave alone the ECN bits
Date: Mon, 11 Nov 2013 08:31:24 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1311110640160.3837@nerf07.vanv.qr>
References: <1475190.7d3oHlGIdH@rofl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick Schaaf <netdev@bof.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:50781 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab3KKHb0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Nov 2013 02:31:26 -0500
In-Reply-To: <1475190.7d3oHlGIdH@rofl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2013-11-10 12:53, Patrick Schaaf wrote:
>
>I'm stumbling over a confusion, maybe just mine, regarding the use of =
the mask=20
>value of the TOS target in order to avoid messing with the ECN bits wi=
thin.=20
>
>	-j TOS --set-tos 0x0c/0xfc
>
>which should result in A) leaving ECN alone and B) set the DSCP bits t=
o=20
>000011, the first "reserved for local use" value.

RFCs have the bit order reversed in their diagrams, which is=E2=80=A6
unusual, but at least properly documented. It spells out: "bits 6 and
7 in the IPv4 TOS octet are designed as the ECN field". The keeper
mask is therefore 0xc0, and the equivalent clearing mask is 0x3f
(not 0xfc).


In the user interface, clearing masks are a must-have for bit
manipulation[1] targets, do not fall under "bit manipulation"), and
keeper masks are a must-have for bit tests. This is because they are
easiest to use for each case.
Lemma: Look at some C code. You will find

	void paint(animal *a) {
		if (a->type & HORSE) {
			a->type &=3D ~HORSE;
			a->type |=3D ZEBRA;
		}
	}

rather than

	if (foo & ~(DONKEY | HORSE | ZEBRA | MULE | ZULE | ZORSE)) {
		foo &=3D DONKEY | HORSE | ZEBRA | MULE | ZULE | ZORSE;
		foo |=3D ZEBRA;
	}

for the same reason.

[1] While many targets do some bit manipulation on the packet,
the UI does not expose it as such. For example, NAT uses IP
addresses rather than raw bits.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
