From: "Domsch, Matt" <Matt_Domsch@Dell.com>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Wed, 13 Jan 2010 11:46:10 -0600
Message-ID: <20100113174610.GA10130@mdomsch-pws380.us.dell.com>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com>
 <20100112194955.GA11752@mock.linuxdev.us.dell.com>
 <alpine.LSU.2.01.1001130039020.4567@obet.zrqbmnf.qr>
 <EDA0A4495861324DA2618B4C45DCB3EE5899B5@blrx3m08.blr.amer.dell.com>
 <20100113110425.GA5095@lina.inka.de>
 <4B4E0158.4050102@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "net-tools@lina.inka.de" <net-tools@lina.inka.de>,
	Bernd Eckenfels <be-mail2010@lina.inka.de>,
	"K, Narendra" <Narendra_K@Dell.com>,
	"jengelh@medozas.de" <jengelh@medozas.de>,
	"shemminger@linux-foundation.org" <shemminger@linux-foundation.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"jgarzik@users.sourceforge.net" <jgarzik@users.sourceforge.net>,
	"Rose, Charles" <Charles_Rose@Dell.com>,
	"Iyer, Shyam" <Shyam_Iyer@Dell.com>,
	"Hargrave, Jordan" <Jordan_Hargrave@Dell.com>,
	"Shandilya, Sandeep K" <Sandeep_K_Shandilya@Dell.com>
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ausxippc101.us.dell.com ([143.166.85.207]:9109 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab0AMRqN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:46:13 -0500
Content-Disposition: inline
In-Reply-To: <4B4E0158.4050102@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 13, 2010 at 11:22:32AM -0600, John Haxby wrote:
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

The "actual gain" is to provide a deterministic method of naming
network devices, in a stateless manner (e.g. w/o hard-coding MAC
addresses).  We don't have deterministic naming today.  It only gets
worse as we add more NIC ports.

The kernel doesn't provide deterministic naming.

Renaming from ethN to ethM is racy; often we wind up with devices named
'eth0_rename'.

Stephen noted (echoed in Bernd's comment) that the ethN namespace is
effectively an ABI (and certainly the 15-character IFNAMESZ is).
Userspace tools today expect ethN names.

So:
a) we can't rely on ethN being meaningful from boot.
b) we can't rename ethN to ethM without racing
c) we can't rename ethN to anything else

what choice do we have left?  Aliases in some form or another, that
can be meaningful.

Changing the kernel to handle aliasing has been rejected.  So we're
trying to do it entirely in userspace.

We're trying to be the least intrusive to applications as we can be,
but we'll need a small change to a lot of apps (as noted earlier in
this thread as an example).  We're open to how best do to that.  If
this proposal isn't acceptable, please advise including methods that
would be acceptable.

Thanks,
Matt


-- 
Matt Domsch
Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
