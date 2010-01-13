From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Wed, 13 Jan 2010 08:27:11 -0800
Message-ID: <20100113082711.2dee7415@nehalam>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com>
	<20100112194955.GA11752@mock.linuxdev.us.dell.com>
	<4B4DC997.20306@trash.net>
	<alpine.LSU.2.01.1001131439330.31436@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Narendra K <Narendra_K@dell.com>, be-mail2009@lina.inka.de,
	net-tools@lina.inka.de, netfilter-devel@vger.kernel.org,
	jgarzik@users.sourceforge.net, charles_rose@dell.com,
	matt_domsch@dell.com, shyam_iyer@dell.com,
	jordan_hargrave@dell.com, sandeep_k_shandilya@dell.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949Ab0AMQ2W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:28:22 -0500
In-Reply-To: <alpine.LSU.2.01.1001131439330.31436@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 13 Jan 2010 14:43:26 +0100 (CET)
Jan Engelhardt <jengelh@medozas.de> wrote:

> 
> On Wednesday 2010-01-13 14:24, Patrick McHardy wrote:
> >> 
> >> The proposal is to enhance iptables (and other tools which might fail if
> >> integrated port 1 does not get named as eth0) to support something like
> >[...]
> >> +	strcpy(vianame, kernel_name);
> >> +	int vialen = strlen(kernel_name);
> >>  	if ((vialen == 0) || (vialen == 1 && vianame[0] == '+'))
> >>  		memset(mask, 0, IFNAMSIZ);
> >>  	else if (vianame[vialen - 1] == '+') {
> >> 
> >> 
> >> where kernel_name is the ethN name that will be returned by a library
> >> like libnetdevname which will map the user supplied "Embedded_NIC_1"
> >> name to the corresponding ethN name, thus bringing in determinism while
> >> referring to the network interfaces.
> >> 
> >> Netfilter-devel, would this be acceptable ?
> >
> >What I don't like very much is that you can't decide whether to
> >map the interface names back in order to display a rule the same
> >way it was specified. Anyone looking at the output will have to
> >know the alias mapping, which seems to defeat the purpose of
> >this patch.
> 
> By definition, the mapping from aliases to real names is not
> bijective, thus not always unambiguously reversible. That also means
> there will be problems if either side of a mapping disappears - say,
> across a reboot - you are in for some local DoS. That of course also
> holds for regular network interface names, but only if you do not use
> udev to give them a persistent name.

Is there a tool to do:
   netdevtoalias eth0
and
   netdevfromalias Embedded_NIC_1



-- 
