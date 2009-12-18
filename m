From: "Domsch, Matt" <Matt_Domsch@Dell.com>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Fri, 18 Dec 2009 08:02:34 -0600
Message-ID: <20091218140233.GA16035@mdomsch-pws380.us.dell.com>
References: <EDA0A4495861324DA2618B4C45DCB3EE5898BB@blrx3m08.blr.amer.dell.com>
 <alpine.LSU.2.01.0912171506130.5925@obet.zrqbmnf.qr>
 <20091218020241.GA18168@lina.inka.de>
 <EDA0A4495861324DA2618B4C45DCB3EE5898C7@blrx3m08.blr.amer.dell.com>
 <alpine.LSU.2.01.0912181433230.5810@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "K, Narendra" <Narendra_K@Dell.com>,
	"be-mail2009@lina.inka.de" <be-mail2009@lina.inka.de>,
	"net-tools@lina.inka.de" <net-tools@lina.inka.de>,
	"shemminger@osdl.org" <shemminger@osdl.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"jgarzik@users.sourceforge.net" <jgarzik@users.sourceforge.net>,
	"Rose, Charles" <Charles_Rose@Dell.com>,
	"Hargrave, Jordan" <Jordan_Hargrave@Dell.com>,
	"Shandilya, Sandeep K" <Sandeep_K_Shandilya@Dell.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:45299 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbZLROCh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:02:37 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.0912181433230.5810@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 18, 2009 at 07:42:22AM -0600, Jan Engelhardt wrote:
> What is wrong with just renaming the actual interface? In fact you
> could use udev itself for just that.

a) The disk image then becomes 'stateful' with respect to MAC
addresses for NICs.  It breaks the scenario of hardware maintenance
whereby you remove the disks from one server, plug them into an
identical server, and power it back on.  Or replacing a NIC.  Or
booting the same image on multiple systems.

b) I'd really like to be able to use the platform-defined name
(e.g. Embedded_NIC_1) early in the installers, long before udev would
have set up 70-persistent-net.rules, for doing network-based installs.
The syslinux IPAPPEND 2 option is quite helpful I'll admit, but that
only sets up a deterministic mapping for one of the N NICs in a system
(N>=4 commonplace on all our servers).

c) it requires the user to make a choice as to what they want that
one-and-only name to be, either at install time (which the anaconda
team rejected), or later (meaning it's not really the one-and-only
name).

> Mapping MACs to interface names is a sort of determinism -- it
> remains the same over time.

Only so long as you don't replace any hardware components.

With the method we're proposing, the image remains stateless with respect to MAC addresses.

Thanks,
Matt

-- 
Matt Domsch
Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
