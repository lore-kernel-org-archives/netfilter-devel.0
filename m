From: <Jordan_Hargrave@Dell.com>
Subject: RE: [PROPOSAL]: Alias names for network interfaces
Date: Sat, 19 Dec 2009 18:12:46 -0600
Message-ID: <71C661ECA80E7B428057125B644033D0084A695637@AUSX7MCPS303.AMER.DELL.COM>
References: <EDA0A4495861324DA2618B4C45DCB3EE5898BB@blrx3m08.blr.amer.dell.com>
 <alpine.LSU.2.01.0912171506130.5925@obet.zrqbmnf.qr>
 <20091218020241.GA18168@lina.inka.de>
 <EDA0A4495861324DA2618B4C45DCB3EE5898C7@blrx3m08.blr.amer.dell.com>
 <alpine.LSU.2.01.0912181433230.5810@obet.zrqbmnf.qr>
 <20091218140828.GB16035@mdomsch-pws380.us.dell.com>
 <alpine.LSU.2.01.0912181513060.6400@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <Narendra_K@Dell.com>, <be-mail2009@lina.inka.de>,
	<net-tools@lina.inka.de>, <shemminger@osdl.org>,
	<netfilter-devel@vger.kernel.org>, <jgarzik@users.sourceforge.net>,
	<Charles_Rose@Dell.com>, <Sandeep_K_Shandilya@Dell.com>
To: <jengelh@medozas.de>, <Matt_Domsch@Dell.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ausxipps301.us.dell.com ([143.166.148.223]:13877 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbZLTAWl convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Dec 2009 19:22:41 -0500
In-Reply-To: <alpine.LSU.2.01.0912181513060.6400@obet.zrqbmnf.qr>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

One proposal we are looking at is a kernel change to add an extra attribute to the /sys/devices/pciXXX directories.  SMBIOS Type 9 and 41 contain mapping between slot number/device name and PCI BDF.  Creating an extra attribute called 'slotname' or 'smbiosname' would allow accessing the desired name by /sys/class/net/ethX/device/smbiosname


--jordan Hargrave
Dell Enterprise Linux Engineering

-----Original Message-----
From: Jan Engelhardt [mailto:jengelh@medozas.de] 
Sent: Friday, December 18, 2009 8:15 AM
To: Domsch, Matt
Cc: K, Narendra; be-mail2009@lina.inka.de; net-tools@lina.inka.de; shemminger@osdl.org; netfilter-devel@vger.kernel.org; jgarzik@users.sourceforge.net; Rose, Charles; Hargrave, Jordan; Shandilya, Sandeep K
Subject: Re: [PROPOSAL]: Alias names for network interfaces


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
