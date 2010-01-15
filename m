From: <Narendra_K@Dell.com>
Subject: RE: [PROPOSAL]: Alias names for network interfaces
Date: Sat, 16 Jan 2010 00:44:41 +0530
Message-ID: <EDA0A4495861324DA2618B4C45DCB3EE5899F1@blrx3m08.blr.amer.dell.com>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com> <20100112194955.GA11752@mock.linuxdev.us.dell.com> <alpine.LSU.2.01.1001130039020.4567@obet.zrqbmnf.qr> <EDA0A4495861324DA2618B4C45DCB3EE5899B5@blrx3m08.blr.amer.dell.com> <20100113110425.GA5095@lina.inka.de> <4B4E0158.4050102@oracle.com> <20100113174610.GA10130@mdomsch-pws380.us.dell.com> <alpine.LSU.2.01.1001131908530.18981@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Cc: <john.haxby@oracle.com>, <net-tools@lina.inka.de>,
	<be-mail2010@lina.inka.de>, <shemminger@linux-foundation.org>,
	<netfilter-devel@vger.kernel.org>, <jgarzik@users.sourceforge.net>,
	<Charles_Rose@Dell.com>, <Shyam_Iyer@Dell.com>,
	<Jordan_Hargrave@Dell.com>, <Sandeep_K_Shandilya@Dell.com>
To: <jengelh@medozas.de>, <Matt_Domsch@Dell.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:8327 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab0AOTOv convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jan 2010 14:14:51 -0500
Content-class: urn:content-classes:message
In-Reply-To: <alpine.LSU.2.01.1001131908530.18981@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> -----Original Message-----
> From: Jan Engelhardt [mailto:jengelh@medozas.de]
> Sent: Wednesday, January 13, 2010 11:52 PM
> To: Domsch, Matt
> Cc: John Haxby; net-tools@lina.inka.de; Bernd Eckenfels; K, Narendra;
> shemminger@linux-foundation.org; netfilter-devel@vger.kernel.org;
> jgarzik@users.sourceforge.net; Rose, Charles; Iyer, Shyam; Hargrave,
> Jordan; Shandilya, Sandeep K
> Subject: Re: [PROPOSAL]: Alias names for network interfaces
> 
> 
> On Wednesday 2010-01-13 18:46, Domsch, Matt wrote:
> >>
> >> I am less than enthusiastic about the idea as well.  I've come
> across
> >> numerous userspace scripts and whatnot that have enough trouble
with
> the
> >> default route not being through "eth0" let alone anything more
> >> complex.   Aliases are going to cause a lot of problems for a lot
of
> >> people for little actual gain.
> >
> >The "actual gain" is to provide a deterministic method of naming
> >network devices, in a stateless manner (e.g. w/o hard-coding MAC
> >addresses).  We don't have deterministic naming today.  It only gets
> >worse as we add more NIC ports.
> >
> >The kernel doesn't provide deterministic naming.
> >
> >Renaming from ethN to ethM is racy; often we wind up with devices
> named
> >'eth0_rename'.
> >
> >Stephen noted (echoed in Bernd's comment) that the ethN namespace is
> >effectively an ABI (and certainly the 15-character IFNAMESZ is).
> >Userspace tools today expect ethN names.
> 
> Let's get things straight at least. Userspace does not expect eth#.
> You may get away with claiming feature-incompleteness if your program
> has no idea of tun#, sit# gre# and such, but there is also wlan#,
> tap#, and others that are a link/ether device. If a program relies on
> eth#, it is broken and should either be fixed or left dead in its
> corner.
> 

I am aware of many data center scenarios where lot of systems(large
numbers) are already pre-wired where Integrated Port 1 is connected to 
public network and Integrated Port 2 is connected to private network.
With the existing OS image, Integrated Port 1 is eth0 and Integrated
Port 2 is eth1. So everything is working as expected. Now there is a
need to upgrade to a new OS image and with this image Integrated Port 1
gets named eth1
and Integrated Port 2 gets eth0. Scripts (for example firewall) are
written for a scenario of Integrated Port 1 (eth0) is public 
network and Integrated Port 2 (eth1) as private network. 

Also, in case of large scale image based deployment scenarios embedding
HWADDR in config files or udev rules is not an option. Though HWADDR
helps in 
ensuring persistency in naming, it doesn't help in achieving expected
naming. 

I might be missing something, but I think this is the real issue. So by
referring to interfaces by their BIOS given name Embedded_NIC_1 will
always refer to the right interface irrespective of whether it is eth0
or eth1. I think which of the tools need to be modified and which need
to be left out of this can be debated.

With regards,
Narendra K
