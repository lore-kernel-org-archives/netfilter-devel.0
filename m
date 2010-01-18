From: Marco Innocenti <m.innocenti@cineca.it>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Mon, 18 Jan 2010 18:07:21 +0100 (MET)
Message-ID: <4B54953D.5030005@cineca.it>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com> <20100112194955.GA11752@mock.linuxdev.us.dell.com> <alpine.LSU.2.01.1001130039020.4567@obet.zrqbmnf.qr> <EDA0A4495861324DA2618B4C45DCB3EE5899B5@blrx3m08.blr.amer.dell.com> <20100113110425.GA5095@lina.inka.de> <4B4E0158.4050102@oracle.com> <20100113174610.GA10130@mdomsch-pws380.us.dell.com> <alpine.LSU.2.01.1001131908530.18981@obet.zrqbmnf.qr> <EDA0A4495861324DA2618B4C45DCB3EE5899F1@blrx3m08.blr.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, Matt_Domsch@Dell.com, john.haxby@oracle.com,
	net-tools@lina.inka.de, be-mail2010@lina.inka.de,
	shemminger@linux-foundation.org, netfilter-devel@vger.kernel.org,
	jgarzik@users.sourceforge.net, Charles_Rose@Dell.com,
	Shyam_Iyer@Dell.com, Jordan_Hargrave@Dell.com,
	Sandeep_K_Shandilya@Dell.com
To: Narendra_K@Dell.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from avas-cineca-2.cineca.com ([130.186.81.105]:21091 "EHLO
	avas-cineca-2.cineca.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab0ARRRH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:17:07 -0500
In-Reply-To: <EDA0A4495861324DA2618B4C45DCB3EE5899F1@blrx3m08.blr.amer.dell.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Narendra_K@Dell.com wrote:
> Also, in case of large scale image based deployment scenarios embedding
> HWADDR in config files or udev rules is not an option. Though HWADDR
> helps in 
> ensuring persistency in naming, it doesn't help in achieving expected
> naming.

HWADDR is not the only way to use udev to name a network interface. You 
can do something like:

SUBSYSTEM=="net", SUBSYSTEMS=="pci", KERNELS=="0000:04:00.0", NAME="eth0"
SUBSYSTEM=="net", SUBSYSTEMS=="pci", KERNELS=="0000:06:00.0", NAME="eth1"


> 
-- 
**********************************************************************
Marco Innocenti              Dipartimento Sistemi E Tecnologie
CINECA                       phone:+39 0516171553 / fax:+39 0516132198
Via Magnanelli 6/3           e-mail: innocenti@cineca.it
40033 Casalecchio di Reno    Bologna (Italia)
**********************************************************************
