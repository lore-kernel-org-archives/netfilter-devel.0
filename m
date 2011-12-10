From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: Problem with Linux networking in 3.X kernels
Date: Sat, 10 Dec 2011 11:39:00 +0100
Message-ID: <877h24k8xn.fsf@tac.ki.iif.hu>
References: <CACD+8rMdSKLb85GX5RBRNv5L0KaYVaQYbYM184_wE5cyOo94Ng@mail.gmail.com>
	<alpine.LNX.2.01.1112041720180.30677@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Artur =?utf-8?Q?Fija=C5=82kowski?= <wiki.warx@gmail.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Bart De Schuymer <bdschuym@pandora.be>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tac.ki.iif.hu ([193.6.222.43]:48438 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab1LJKjG convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Dec 2011 05:39:06 -0500
In-Reply-To: <alpine.LNX.2.01.1112041720180.30677@frira.zrqbmnf.qr> (Jan
	Engelhardt's message of "Sun, 4 Dec 2011 17:20:52 +0100 (CET)")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> On Sunday 2011-12-04 15:09, Artur Fija=C5=82kowski wrote:
>
>> If ethernet device has vlans and is incorporated as bridge port it
>> completely drops incoming vlan packets.

Even under 2.6 kernels if eth0 is a bridge port, eth0.X won't receive
any packets as the bridge sucks up tagged packets as well.  Unless
forbidden by appropriate ebtables rules.
--=20
Regards,
=46eri.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
