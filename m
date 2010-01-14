From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Thu, 14 Jan 2010 09:44:40 +0100
Message-ID: <4B4ED978.9030700@trash.net>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com> <20100112194955.GA11752@mock.linuxdev.us.dell.com> <alpine.LSU.2.01.1001130039020.4567@obet.zrqbmnf.qr> <EDA0A4495861324DA2618B4C45DCB3EE5899B5@blrx3m08.blr.amer.dell.com> <20100113110425.GA5095@lina.inka.de> <4B4E0158.4050102@oracle.com> <20100113174610.GA10130@mdomsch-pws380.us.dell.com> <alpine.LSU.2.01.1001131908530.18981@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
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
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60459 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab0ANIon (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jan 2010 03:44:43 -0500
In-Reply-To: <alpine.LSU.2.01.1001131908530.18981@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-01-13 18:46, Domsch, Matt wrote:
>>> I am less than enthusiastic about the idea as well.  I've come across 
>>> numerous userspace scripts and whatnot that have enough trouble with the 
>>> default route not being through "eth0" let alone anything more 
>>> complex.   Aliases are going to cause a lot of problems for a lot of 
>>> people for little actual gain.
>> The "actual gain" is to provide a deterministic method of naming
>> network devices, in a stateless manner (e.g. w/o hard-coding MAC
>> addresses).  We don't have deterministic naming today.  It only gets
>> worse as we add more NIC ports.
>>
>> The kernel doesn't provide deterministic naming.
>>
>> Renaming from ethN to ethM is racy; often we wind up with devices named
>> 'eth0_rename'.
>>
>> Stephen noted (echoed in Bernd's comment) that the ethN namespace is
>> effectively an ABI (and certainly the 15-character IFNAMESZ is).
>> Userspace tools today expect ethN names.
> 
> Let's get things straight at least. Userspace does not expect eth#.
> You may get away with claiming feature-incompleteness if your program
> has no idea of tun#, sit# gre# and such, but there is also wlan#,
> tap#, and others that are a link/ether device. If a program relies on
> eth#, it is broken and should either be fixed or left dead in its
> corner.

I agree, this is simply broken. iptraf is one of these sad examples
which has been annoying me for years.
