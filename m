From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables-1.4.5 REPLACE rule problem
Date: Sun, 15 Nov 2009 16:05:40 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911151601220.24638@obet.zrqbmnf.qr>
References: <4AFE777C.8090106@net.wpww>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Werner Pawlitschko <werner.pawlitschko@arcor.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48474 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbZKOPFg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Nov 2009 10:05:36 -0500
In-Reply-To: <4AFE777C.8090106@net.wpww>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2009-11-14 10:25, Werner Pawlitschko wrote:

> iptables -A OUPUT -j LOG -d 10.11.12.13
> then iptables-save shows
> -A OUPUT -d 10.11.12.13/32 -j LOG
> that's ok.
> Then doing:
> iptables -R OUTPUT 1 -j LOG -d 10.11.12.13
> then iptables-save shows
> -A OUTPUT -d 10.11.12.13/0 -j LOG
> Looks bad. As you see the mask is set to zero for all bits.

It turns out -R always put /0 in there. A bug of course, that I fixed 
now. Patch at git://dev.medozas.de/iptables for the wary, otherwise 
will be submitted in my semiregular pushes.

thanks,
Jan
