From: <Narendra_K@Dell.com>
Subject: RE: [PROPOSAL]: Alias names for network interfaces
Date: Wed, 13 Jan 2010 22:30:27 +0530
Message-ID: <EDA0A4495861324DA2618B4C45DCB3EE5899C5@blrx3m08.blr.amer.dell.com>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com><20100112194955.GA11752@mock.linuxdev.us.dell.com><4B4DC997.20306@trash.net><alpine.LSU.2.01.1001131439330.31436@obet.zrqbmnf.qr> <20100113082711.2dee7415@nehalam>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Cc: <kaber@trash.net>, <be-mail2009@lina.inka.de>,
	<net-tools@lina.inka.de>, <netfilter-devel@vger.kernel.org>,
	<jgarzik@users.sourceforge.net>, <Charles_Rose@Dell.com>,
	<Matt_Domsch@Dell.com>, <Shyam_Iyer@Dell.com>,
	<Jordan_Hargrave@Dell.com>, <Sandeep_K_Shandilya@Dell.com>
To: <shemminger@linux-foundation.org>, <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ausxipps301.us.dell.com ([143.166.148.223]:62435 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab0AMRJw convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:09:52 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20100113082711.2dee7415@nehalam>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> -----Original Message-----
> From: Stephen Hemminger [mailto:shemminger@linux-foundation.org]
> Sent: Wednesday, January 13, 2010 9:57 PM
> To: Jan Engelhardt
> Cc: Patrick McHardy; K, Narendra; be-mail2009@lina.inka.de; net-
> tools@lina.inka.de; netfilter-devel@vger.kernel.org;
> jgarzik@users.sourceforge.net; Rose, Charles; Domsch, Matt; Iyer,
> Shyam; Hargrave, Jordan; Shandilya, Sandeep K
> Subject: Re: [PROPOSAL]: Alias names for network interfaces
> 
> On Wed, 13 Jan 2010 14:43:26 +0100 (CET)
> Jan Engelhardt <jengelh@medozas.de> wrote:
> 
> >
> > On Wednesday 2010-01-13 14:24, Patrick McHardy wrote:
> > >>
> > >> The proposal is to enhance iptables (and other tools which might
> fail if
> > >> integrated port 1 does not get named as eth0) to support
something
> like
> > >[...]
> > >> +	strcpy(vianame, kernel_name);
> > >> +	int vialen = strlen(kernel_name);
> > >>  	if ((vialen == 0) || (vialen == 1 && vianame[0] == '+'))
> > >>  		memset(mask, 0, IFNAMSIZ);
> > >>  	else if (vianame[vialen - 1] == '+') {
> > >>
> > >>
> > >> where kernel_name is the ethN name that will be returned by a
> library
> > >> like libnetdevname which will map the user supplied
> "Embedded_NIC_1"
> > >> name to the corresponding ethN name, thus bringing in determinism
> while
> > >> referring to the network interfaces.
> > >>
> > >> Netfilter-devel, would this be acceptable ?
> > >
> > >What I don't like very much is that you can't decide whether to
> > >map the interface names back in order to display a rule the same
> > >way it was specified. Anyone looking at the output will have to
> > >know the alias mapping, which seems to defeat the purpose of
> > >this patch.
> >
> > By definition, the mapping from aliases to real names is not
> > bijective, thus not always unambiguously reversible. That also means
> > there will be problems if either side of a mapping disappears - say,
> > across a reboot - you are in for some local DoS. That of course also
> > holds for regular network interface names, but only if you do not
use
> > udev to give them a persistent name.
> 
> Is there a tool to do:
>    netdevtoalias eth0
> and
>    netdevfromalias Embedded_NIC_1

Stephen,

Yes, the tool is part of the solution. The proposal involves three parts
- (more details here
http://linux.dell.com/wiki/index.php/Oss/libnetdevname#Proposal_2: )

1. Library

The library would provide the following functionality.

    * Alias to kernel name
    * Given a kernel name, provide a list of aliases
    * Tell us which alias is descriptive for a given kernel name, which
in this case will be Embedded_NIC_N

2.Command line tool which can be used in scripting

    * Given an alias, fetch the kernel name of the device
    * For a given kernel name, fetch the list of aliases
    * Tell us which alias is descriptive

3.Kernel

	* The smbios strings would need to be exported to the kernel, so
that tools and the library need not have root permissions to read the
smbios strings.

Patrick,

If I understand your point correctly, you are saying that if a rule is
specified in the command line as below

iptables -A INPUT -i Embedded_NIC_1 -j ACCEPT, then if the rule is saved
by iptables-save the rule would look like 

iptables -A INPUT -i ethN -j ACCEPT and there is no way to know what the
corresponding Embedded_NIC_1 name is. 

If this is correct, then I agree. I suppose that this concern can be
addressed in one of these ways, if I am not missing
something - 

a) The command line tool I mentioned above (point 2)would tell us the
ethN -> Embedded_NIC_N mapping
b) Or the iptables-save needs to be enhanced to save Embedded_NIC_N
format instead of ethN by making a call to
libnetdevname to get that mapping ( ethN -> Embedded_NIC_1).

With regards,
Narendra K

