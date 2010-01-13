From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Wed, 13 Jan 2010 09:54:03 -0800
Message-ID: <20100113095403.47cdde4d@nehalam>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com>
	<20100112194955.GA11752@mock.linuxdev.us.dell.com>
	<alpine.LSU.2.01.1001130039020.4567@obet.zrqbmnf.qr>
	<EDA0A4495861324DA2618B4C45DCB3EE5899B5@blrx3m08.blr.amer.dell.com>
	<20100113110425.GA5095@lina.inka.de>
	<4B4E0158.4050102@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: net-tools@lina.inka.de, Bernd Eckenfels <be-mail2010@lina.inka.de>,
	Narendra_K@Dell.com, jengelh@medozas.de,
	netfilter-devel@vger.kernel.org, jgarzik@users.sourceforge.net,
	Charles_Rose@Dell.com, Matt_Domsch@Dell.com, Shyam_Iyer@Dell.com,
	Jordan_Hargrave@Dell.com, Sandeep_K_Shandilya@Dell.com
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755314Ab0AMRyl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:54:41 -0500
In-Reply-To: <4B4E0158.4050102@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 13 Jan 2010 17:22:32 +0000
John Haxby <john.haxby@oracle.com> wrote:

> On 13/01/10 11:04, Bernd Eckenfels wrote:
> > Hello,
> >
> > On Wed, Jan 13, 2010 at 12:17:16PM +0530, Narendra_K@Dell.com wrote:
> >    
> >> The implementation is for char device node solution we proposed earlier.
> >> It would be extended to handle the current proposal if it is acceptable.
> >>      
> > For the record: I still dont like the idea to add another namespace (besides
> > interface index number and kernel names (possibly renamed)) to network
> > devices (especially in usermode), however if nobody else objects I will keep
> > quiet and accept the patches.
> >    
> 
> I am less than enthusiastic about the idea as well.  I've come across 
> numerous userspace scripts and whatnot that have enough trouble with the 
> default route not being through "eth0" let alone anything more 
> complex.   Aliases are going to cause a lot of problems for a lot of 
> people for little actual gain.

I am worried about the user space change version as well.
Especially since many of the network tools (snmp, quagga, ...) have
to be cross-platform and this is not likely to get a warm reception from
BSD and Solaris users.
