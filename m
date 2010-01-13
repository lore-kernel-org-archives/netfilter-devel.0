From: Bernd Eckenfels <be-mail2009@lina.inka.de>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Wed, 13 Jan 2010 19:11:10 +0100
Message-ID: <20100113181110.GA26997@lina.inka.de>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com> <20100112194955.GA11752@mock.linuxdev.us.dell.com> <alpine.LSU.2.01.1001130039020.4567@obet.zrqbmnf.qr> <EDA0A4495861324DA2618B4C45DCB3EE5899B5@blrx3m08.blr.amer.dell.com> <20100113110425.GA5095@lina.inka.de> <4B4E0158.4050102@oracle.com> <20100113174610.GA10130@mdomsch-pws380.us.dell.com>
Reply-To: net-tools@lina.inka.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: John Haxby <john.haxby@oracle.com>,
	"net-tools@lina.inka.de" <net-tools@lina.inka.de>,
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
To: "Domsch, Matt" <Matt_Domsch@Dell.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from quechua.inka.de ([193.197.184.2]:44950 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab0AMSLP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 13:11:15 -0500
Content-Disposition: inline
In-Reply-To: <20100113174610.GA10130@mdomsch-pws380.us.dell.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 13, 2010 at 11:46:10AM -0600, Domsch, Matt wrote:
> The "actual gain" is to provide a deterministic method of naming
> network devices, in a stateless manner (e.g. w/o hard-coding MAC
> addresses).  We don't have deterministic naming today.  It only gets
> worse as we add more NIC ports.

You can use ifrename or udev to rename an interface with kernel abi based on
your exported smb name (or other things like mac-based rules).

This can be done in the boot script and will be used to all tools.
Those tools requiring the ethX name are broken anyway and should be fixed.

Gruss
Bernd
