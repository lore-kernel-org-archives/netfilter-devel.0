From: <Narendra_K@Dell.com>
Subject: RE: [PROPOSAL]: Alias names for network interfaces
Date: Tue, 19 Jan 2010 23:02:19 +0530
Message-ID: <EDA0A4495861324DA2618B4C45DCB3EE589A31@blrx3m08.blr.amer.dell.com>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com> <20100112194955.GA11752@mock.linuxdev.us.dell.com> <alpine.LSU.2.01.1001130039020.4567@obet.zrqbmnf.qr> <EDA0A4495861324DA2618B4C45DCB3EE5899B5@blrx3m08.blr.amer.dell.com> <20100113110425.GA5095@lina.inka.de> <4B4E0158.4050102@oracle.com> <20100113174610.GA10130@mdomsch-pws380.us.dell.com> <alpine.LSU.2.01.1001131908530.18981@obet.zrqbmnf.qr> <EDA0A4495861324DA2618B4C45DCB3EE5899F1@blrx3m08.blr.amer.dell.com> <4B54953D.5030005@cineca.it>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Cc: <jengelh@medozas.de>, <Matt_Domsch@Dell.com>,
	<john.haxby@oracle.com>, <net-tools@lina.inka.de>,
	<be-mail2010@lina.inka.de>, <shemminger@linux-foundation.org>,
	<netfilter-devel@vger.kernel.org>, <jgarzik@users.sourceforge.net>,
	<Charles_Rose@Dell.com>, <Shyam_Iyer@Dell.com>,
	<Jordan_Hargrave@Dell.com>, <Sandeep_K_Shandilya@Dell.com>
To: <m.innocenti@cineca.it>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:51557 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab0ASRcb convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:32:31 -0500
Content-class: urn:content-classes:message
In-Reply-To: <4B54953D.5030005@cineca.it>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: Marco Innocenti [mailto:m.innocenti@cineca.it]
> Sent: Monday, January 18, 2010 10:37 PM
> To: K, Narendra
> Cc: jengelh@medozas.de; Domsch, Matt; john.haxby@oracle.com; net-
> tools@lina.inka.de; be-mail2010@lina.inka.de; shemminger@linux-
> foundation.org; netfilter-devel@vger.kernel.org;
> jgarzik@users.sourceforge.net; Rose, Charles; Iyer, Shyam; Hargrave,
> Jordan; Shandilya, Sandeep K
> Subject: Re: [PROPOSAL]: Alias names for network interfaces
> 
> Narendra_K@Dell.com wrote:
> > Also, in case of large scale image based deployment scenarios
> embedding
> > HWADDR in config files or udev rules is not an option. Though HWADDR
> > helps in
> > ensuring persistency in naming, it doesn't help in achieving
expected
> > naming.
> 
> HWADDR is not the only way to use udev to name a network interface.
You
> can do something like:
> 
> SUBSYSTEM=="net", SUBSYSTEMS=="pci", KERNELS=="0000:04:00.0",
> NAME="eth0"
> SUBSYSTEM=="net", SUBSYSTEMS=="pci", KERNELS=="0000:06:00.0",
> NAME="eth1"

Sure, but this would again introduce state. And that might not help in a
heterogeneous environment.

With regards,
Narendra K
