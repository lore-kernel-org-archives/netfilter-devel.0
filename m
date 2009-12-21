From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Mon, 21 Dec 2009 09:36:21 -0800
Message-ID: <20091221093621.0470d637@nehalam>
References: <EDA0A4495861324DA2618B4C45DCB3EE5898BB@blrx3m08.blr.amer.dell.com>
	<alpine.LSU.2.01.0912171506130.5925@obet.zrqbmnf.qr>
	<20091218020241.GA18168@lina.inka.de>
	<EDA0A4495861324DA2618B4C45DCB3EE5898C7@blrx3m08.blr.amer.dell.com>
	<20091218093845.00d7e918@nehalam>
	<EDA0A4495861324DA2618B4C45DCB3EE5898CC@blrx3m08.blr.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <be-mail2009@lina.inka.de>, <jengelh@medozas.de>,
	<net-tools@lina.inka.de>, <netfilter-devel@vger.kernel.org>,
	<jgarzik@users.sourceforge.net>, <Matt_Domsch@Dell.com>,
	<Charles_Rose@Dell.com>, <Jordan_Hargrave@Dell.com>,
	<Sandeep_K_Shandilya@Dell.com>, <Shyam_Iyer@Dell.com>
To: <Narendra_K@Dell.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134AbZLURhU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Dec 2009 12:37:20 -0500
In-Reply-To: <EDA0A4495861324DA2618B4C45DCB3EE5898CC@blrx3m08.blr.amer.dell.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 21 Dec 2009 22:58:09 +0530
<Narendra_K@Dell.com> wrote:

> > On Fri, 18 Dec 2009 18:49:15 +0530
> > <Narendra_K@Dell.com> wrote:
> > 
> > > The installer solution involved renaming the network interface names
> > > from ethN to something else based on the naming convention that the
> > user
> > > specified. For example, if the user chose "smbios names" as the the
> > > naming convention then all ethN would be renamed to Embedded_NIC_N.
> > > ifconfig would show Embedded_NIC_N instead of ethN.
> > 
> > Renaming away from ethN causes some applications like net-snmp to get
> > confused,
> > and others have special sorting rules based on existing model (like
> > quagga).
> > 
> > I would argue that the "ethN" convention is part of existing system
> > ABI and should not get changed in a visible way to applications.
> 
> Stephen,
> 
> Thanks. What are your views on the current proposal we are making where
> ethN names are not changed (or renamed) and libnetdevname would suggest
> alias names for the ethN names ( and also alias to ethN names) in user
> space. Applications like ip, ethtool etc can use these aliases, make
> calls to libnetdevname and get the ethN name. 
> 
> Libnetdevname would read from sysfs the smbios names of the network
> interface devices as Jordan mentioned
> (/sys/class/net/ethX/device/smbiosname). Would this be acceptable ?

I have no need or use for them, but if it doesn't break other things
then sure.
