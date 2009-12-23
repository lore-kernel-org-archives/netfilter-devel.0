From: <Narendra_K@Dell.com>
Subject: RE: [PROPOSAL]: Alias names for network interfaces
Date: Wed, 23 Dec 2009 22:41:12 +0530
Message-ID: <EDA0A4495861324DA2618B4C45DCB3EE5898E1@blrx3m08.blr.amer.dell.com>
References: <EDA0A4495861324DA2618B4C45DCB3EE5898BB@blrx3m08.blr.amer.dell.com><alpine.LSU.2.01.0912171506130.5925@obet.zrqbmnf.qr><20091218020241.GA18168@lina.inka.de><EDA0A4495861324DA2618B4C45DCB3EE5898C7@blrx3m08.blr.amer.dell.com><20091218093845.00d7e918@nehalam><EDA0A4495861324DA2618B4C45DCB3EE5898CC@blrx3m08.blr.amer.dell.com> <20091221093621.0470d637@nehalam>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Cc: <be-mail2009@lina.inka.de>, <jengelh@medozas.de>,
	<net-tools@lina.inka.de>, <netfilter-devel@vger.kernel.org>,
	<jgarzik@users.sourceforge.net>, <Matt_Domsch@Dell.com>,
	<Charles_Rose@Dell.com>, <Jordan_Hargrave@Dell.com>,
	<Sandeep_K_Shandilya@Dell.com>, <Shyam_Iyer@Dell.com>
To: <shemminger@linux-foundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ausxippc101.us.dell.com ([143.166.85.207]:31513 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbZLWRL3 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2009 12:11:29 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20091221093621.0470d637@nehalam>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> > > On Fri, 18 Dec 2009 18:49:15 +0530
> > > <Narendra_K@Dell.com> wrote:
> > >
> > > > The installer solution involved renaming the network interface
> names
> > > > from ethN to something else based on the naming convention that
> the
> > > user
> > > > specified. For example, if the user chose "smbios names" as the
> the
> > > > naming convention then all ethN would be renamed to
> Embedded_NIC_N.
> > > > ifconfig would show Embedded_NIC_N instead of ethN.
> > >
> > > Renaming away from ethN causes some applications like net-snmp to
> get
> > > confused,
> > > and others have special sorting rules based on existing model
(like
> > > quagga).
> > >
> > > I would argue that the "ethN" convention is part of existing
system
> > > ABI and should not get changed in a visible way to applications.
> >
> > Stephen,
> >
> > Thanks. What are your views on the current proposal we are making
> where
> > ethN names are not changed (or renamed) and libnetdevname would
> suggest
> > alias names for the ethN names ( and also alias to ethN names) in
> user
> > space. Applications like ip, ethtool etc can use these aliases, make
> > calls to libnetdevname and get the ethN name.
> >
> > Libnetdevname would read from sysfs the smbios names of the network
> > interface devices as Jordan mentioned
> > (/sys/class/net/ethX/device/smbiosname). Would this be acceptable ?
> 
> I have no need or use for them, but if it doesn't break other things
> then sure.

Jeff / netfilter-devel,

It would greatly help to know your views on this proposal.

With regards,
Narendra K
