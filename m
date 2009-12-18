From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Fri, 18 Dec 2009 15:15:12 +0100 (CET)
Message-ID: <alpine.LSU.2.01.0912181513060.6400@obet.zrqbmnf.qr>
References: <EDA0A4495861324DA2618B4C45DCB3EE5898BB@blrx3m08.blr.amer.dell.com> <alpine.LSU.2.01.0912171506130.5925@obet.zrqbmnf.qr> <20091218020241.GA18168@lina.inka.de> <EDA0A4495861324DA2618B4C45DCB3EE5898C7@blrx3m08.blr.amer.dell.com>
 <alpine.LSU.2.01.0912181433230.5810@obet.zrqbmnf.qr> <20091218140828.GB16035@mdomsch-pws380.us.dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "K, Narendra" <Narendra_K@Dell.com>,
	"be-mail2009@lina.inka.de" <be-mail2009@lina.inka.de>,
	"net-tools@lina.inka.de" <net-tools@lina.inka.de>,
	"shemminger@osdl.org" <shemminger@osdl.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"jgarzik@users.sourceforge.net" <jgarzik@users.sourceforge.net>,
	"Rose, Charles" <Charles_Rose@Dell.com>,
	"Hargrave, Jordan" <Jordan_Hargrave@Dell.com>,
	"Shandilya, Sandeep K" <Sandeep_K_Shandilya@Dell.com>
To: "Domsch, Matt" <Matt_Domsch@Dell.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40904 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbZLROPO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:15:14 -0500
In-Reply-To: <20091218140828.GB16035@mdomsch-pws380.us.dell.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-12-18 15:08, Domsch, Matt wrote:
>On Fri, Dec 18, 2009 at 07:42:22AM -0600, Jan Engelhardt wrote:
>> >I suppose the ifrename would rename network interfaces from ethN to ethN
>> >and that would cause issues.
>> 
>> What issues?
>
>historically, udev would wind up with NICs named:
>
>eth0
>eth0_rename
>eth2
>eth2_rename
>
>instead of eth[0-4].  The renames running in parallel would conflict.
>I'm told that DavidZ fixed this a recent udev, but I haven't
>confirmed this is the case.
>
>Regardless, this begs the question of how to name newly added NICs.
>Today's method involves a human fixing up 70-persistent-net.rules to
>match what they want it to be.  I hate that, when the platform itself
>can provide a perfectly good answer.

Of course. If the user chose to want SMBIOS names by default,
why not.

Except when the BIOS manufacturer left the SMBIOS info blank again.
