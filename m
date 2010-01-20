From: Bernd Eckenfels <be-mail2009@lina.inka.de>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Wed, 20 Jan 2010 02:02:39 +0100
Message-ID: <20100120010239.GA19773@lina.inka.de>
References: <alpine.LSU.2.01.1001130039020.4567@obet.zrqbmnf.qr> <EDA0A4495861324DA2618B4C45DCB3EE5899B5@blrx3m08.blr.amer.dell.com> <20100113110425.GA5095@lina.inka.de> <4B4E0158.4050102@oracle.com> <20100113174610.GA10130@mdomsch-pws380.us.dell.com> <alpine.LSU.2.01.1001131908530.18981@obet.zrqbmnf.qr> <EDA0A4495861324DA2618B4C45DCB3EE5899F1@blrx3m08.blr.amer.dell.com> <4B54953D.5030005@cineca.it> <EDA0A4495861324DA2618B4C45DCB3EE589A31@blrx3m08.blr.amer.dell.com> <20100119143139.1dc18162@nehalam>
Reply-To: net-tools@lina.inka.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Stephen Hemminger <shemminger@linux-foundation.org>,
	Narendra_K@Dell.com, m.innocenti@cineca.it, jengelh@medozas.de,
	Matt_Domsch@Dell.com, john.haxby@oracle.com,
	netfilter-devel@vger.
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from quechua.inka.de ([193.197.184.2]:60136 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab0ATBCr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 20:02:47 -0500
Content-Disposition: inline
In-Reply-To: <20100119143139.1dc18162@nehalam>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 19, 2010 at 02:31:39PM -0800, Stephen Hemminger wrote:
> > Sure, but this would again introduce state. And that might not help in a
> > heterogeneous environment.
> 
> Hetrogeneous with what? Other OS's; sorry I don't care what Windows, Solaris,
> HP-UX or anything else uses as a rule. The point is to do the right thing.

I dont see "state" introduced:

a) you export the smb name of the interface to userspace
b) you use a (usersace) init script to use existing kernel api to rename the
interface (to it's  smbname or anything else you want)

Gruss
Bernd
