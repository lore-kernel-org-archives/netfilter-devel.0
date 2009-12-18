From: "Domsch, Matt" <Matt_Domsch@Dell.com>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Fri, 18 Dec 2009 08:08:29 -0600
Message-ID: <20091218140828.GB16035@mdomsch-pws380.us.dell.com>
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
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:60321 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbZLROIa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:08:30 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.0912181433230.5810@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 18, 2009 at 07:42:22AM -0600, Jan Engelhardt wrote:
> >I suppose the ifrename would rename network interfaces from ethN to ethN
> >and that would cause issues.
> 
> What issues?

historically, udev would wind up with NICs named:

eth0
eth0_rename
eth2
eth2_rename

instead of eth[0-4].  The renames running in parallel would conflict.
I'm told that DavidZ fixed this a recent udev, but I haven't
confirmed this is the case.

Regardless, this begs the question of how to name newly added NICs.
Today's method involves a human fixing up 70-persistent-net.rules to
match what they want it to be.  I hate that, when the platform itself
can provide a perfectly good answer.

-- 
Matt Domsch
Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
