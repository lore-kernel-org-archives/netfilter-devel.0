From: Marek Kierdelewicz <marek@koba.pl>
Subject: Re: Fwd: iptables-1.4.1-1.4.2 change "Warn about use of DROP in nat
 table" (fwd)
Date: Tue, 13 Jan 2009 13:22:30 +0100
Message-ID: <20090113132230.3aa55c40@catlap>
References: <alpine.LSU.2.00.0901131030410.7823@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from psyche.piasta.pl ([83.175.144.5]:37805 "EHLO psyche.piasta.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbZAMMly convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:41:54 -0500
In-Reply-To: <alpine.LSU.2.00.0901131030410.7823@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

>If you are _that_ concerned about CPU usage (and I remember there
>being an analysis of Netfilter's speed compared to other solutions; a
>document somewhere on people.netfilter.org), you would have done it
>in the mangle table, not in nat, short of saying that that is
>probably not the purpose of mangle either.
>There were once thoughts to combine some tables because of the
>redundancy, but the thought timed out :)

Thanks for informative and prompt response Jan.

Regards,
--=20
Marek Kierdelewicz
Kierownik Dzia=C5=82u System=C3=B3w Sieciowych, KoBa
Manager of Network Systems Department, KoBa
tel. (85) 7406466; fax. (85) 7406467
e-mail: admin@koba.pl
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
