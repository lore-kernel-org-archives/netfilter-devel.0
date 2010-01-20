From: <Narendra_K@Dell.com>
Subject: RE: [PROPOSAL]: Alias names for network interfaces
Date: Wed, 20 Jan 2010 22:12:25 +0530
Message-ID: <EDA0A4495861324DA2618B4C45DCB3EE589A4C@blrx3m08.blr.amer.dell.com>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com><20100112194955.GA11752@mock.linuxdev.us.dell.com><alpine.LSU.2.01.1001130039020.4567@obet.zrqbmnf.qr><EDA0A4495861324DA2618B4C45DCB3EE5899B5@blrx3m08.blr.amer.dell.com><20100113110425.GA5095@lina.inka.de><4B4E0158.4050102@oracle.com><20100113174610.GA10130@mdomsch-pws380.us.dell.com><alpine.LSU.2.01.1001131908530.18981@obet.zrqbmnf.qr><EDA0A4495861324DA2618B4C45DCB3EE5899F1@blrx3m08.blr.amer.dell.com><4B54953D.5030005@cineca.it><EDA0A4495861324DA2618B4C45DCB3EE589A31@blrx3m08.blr.amer.dell.com> <20100119143139.1dc18162@nehalam>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Cc: <m.innocenti@cineca.it>, <jengelh@medozas.de>,
	<Matt_Domsch@Dell.com>, <john.haxby@oracle.com>,
	<net-tools@lina.inka.de>, <be-mail2010@lina.inka.de>,
	<netfilter-devel@vger.kernel.org>, <jgarzik@users.sourceforge.net>,
	<Charles_Rose@Dell.com>, <Shyam_Iyer@Dell.com>,
	<Jordan_Hargrave@Dell.com>, <Sandeep_K_Shandilya@Dell.com>
To: <shemminger@linux-foundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:20663 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab0ATQnI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2010 11:43:08 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20100119143139.1dc18162@nehalam>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> -----Original Message-----
> From: Stephen Hemminger [mailto:shemminger@linux-foundation.org]
> Sent: Wednesday, January 20, 2010 4:02 AM
> To: K, Narendra
> Cc: m.innocenti@cineca.it; jengelh@medozas.de; Domsch, Matt;
> john.haxby@oracle.com; net-tools@lina.inka.de; be-
> mail2010@lina.inka.de; netfilter-devel@vger.kernel.org;
> jgarzik@users.sourceforge.net; Rose, Charles; Iyer, Shyam; Hargrave,
> Jordan; Shandilya, Sandeep K
> Subject: Re: [PROPOSAL]: Alias names for network interfaces
> 
> On Tue, 19 Jan 2010 23:02:19 +0530
> <Narendra_K@Dell.com> wrote:
> 
> > Sure, but this would again introduce state. And that might not help
> in a
> > heterogeneous environment.
> 
> Hetrogeneous with what? Other OS's; sorry I don't care what Windows,
> Solaris,
> HP-UX or anything else uses as a rule. The point is to do the right
> thing.

Sorry for not being clear. Heterogeneous with different hardware (like
Dell, HP etc, I was not referring to OSes, ) and a udev rule like 
SUBSYSTEM=="net", SUBSYSTEMS=="pci", KERNELS=="0000:04:00.0",
NAME="eth0"
will not help as 0000:04:00.0 (or any other bus,device,function) might
not be a network device 
in all the systems or it might not exist. A single OS image which has to
be installed on multiple systems would
have to be more generic than that.

With regards,
Narendra K
