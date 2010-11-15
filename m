From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [arptables] rfc: add classify target
Date: Mon, 15 Nov 2010 20:31:44 +0100
Message-ID: <4CE18AA0.20204@pandora.be>
References: <20101107152636.56f62235@caresse>	<alpine.LNX.2.01.1011071616150.21289@obet.zrqbmnf.qr>	<4CD959D6.1090705@trash.net>	<20101109161047.GB25549@sd-11162.dedibox.fr>	<4CD98746.4050100@pandora.be>	<20101109211834.4da8e412@caresse>	<alpine.LNX.2.01.1011092121210.10710@obet.zrqbmnf.qr>	<20101109215126.502a155e@caresse>	<4CDBC7B1.2020101@trash.net>	<20101111124505.345643a3@caresse>	<4CDCF1A7.2050402@trash.net>	<20101113162934.768e4a3c@caresse>	<4CE001F2.8020600@pandora.be> <20101115133248.5815e9c1@caresse>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Frederic Leroy <fredo@starox.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:35663 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980Ab0KOTbr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:31:47 -0500
In-Reply-To: <20101115133248.5815e9c1@caresse>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Applied,

Thanks Frederic.

Bart

On 15-11-10 13:32, Frederic Leroy wrote:
> Le Sun, 14 Nov 2010 16:36:18 +0100,
> Bart De Schuymer<bdschuym@pandora.be>  a =E9crit :
>
>> Apart from my comments below, the userspace patch looks ok:
>> - I would line up the help and man page entries between arptables an=
d
>> iptables so noone gets confused. Also, the man page entry refers to
>> set-class-mac.
>> - In final_check() you should make sure that the priority has been s=
et
>> (similar to what's done in libxt_CLASSIFY.c).
> Here it is, largely borrowed from iptables.
>
> Cheers,
>


--=20
Bart De Schuymer
www.artinalgorithms.be

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
