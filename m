From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Thu, 14 Jan 2010 10:35:17 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1001141034350.12836@obet.zrqbmnf.qr>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com> <20100112194955.GA11752@mock.linuxdev.us.dell.com> <alpine.LSU.2.01.1001130039020.4567@obet.zrqbmnf.qr> <EDA0A4495861324DA2618B4C45DCB3EE5899B5@blrx3m08.blr.amer.dell.com>
 <20100113110425.GA5095@lina.inka.de> <4B4E0158.4050102@oracle.com> <20100113174610.GA10130@mdomsch-pws380.us.dell.com> <alpine.LSU.2.01.1001131908530.18981@obet.zrqbmnf.qr> <4B4ED978.9030700@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Domsch, Matt" <Matt_Domsch@Dell.com>,
	John Haxby <john.haxby@oracle.com>,
	"net-tools@lina.inka.de" <net-tools@lina.inka.de>,
	Bernd Eckenfels <be-mail2010@lina.inka.de>,
	"K, Narendra" <Narendra_K@Dell.com>,
	"shemminger@linux-foundation.org" <shemminger@linux-foundation.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"jgarzik@users.sourceforge.net" <jgarzik@users.sourceforge.net>,
	"Rose, Charles" <Charles_Rose@Dell.com>,
	"Iyer, Shyam" <Shyam_Iyer@Dell.com>,
	"Hargrave, Jordan" <Jordan_Hargrave@Dell.com>,
	"Shandilya, Sandeep K" <Sandeep_K_Shandilya@Dell.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41712 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab0ANJfS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jan 2010 04:35:18 -0500
In-Reply-To: <4B4ED978.9030700@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-01-14 09:44, Patrick McHardy wrote:
>> 
>> Let's get things straight at least. Userspace does not expect eth#.
>> You may get away with claiming feature-incompleteness if your program
>> has no idea of tun#, sit# gre# and such, but there is also wlan#,
>> tap#, and others that are a link/ether device. If a program relies on
>> eth#, it is broken and should either be fixed or left dead in its
>> corner.
>
>I agree, this is simply broken. iptraf is one of these sad examples
>which has been annoying me for years.
>
Well, iptraf is only half-broken. Run it with the -u option,
and you get your interfaces.
