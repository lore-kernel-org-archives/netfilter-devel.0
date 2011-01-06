From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: new netfilter target - DNETMAP
Date: Fri, 7 Jan 2011 00:25:58 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101070008590.19521@obet.zrqbmnf.qr>
References: <20110107000259.775ba310@kuguar>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Marek Kierdelewicz <marek@piasta.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46333 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab1AFXZ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:25:59 -0500
In-Reply-To: <20110107000259.775ba310@kuguar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-01-07 00:02, Marek Kierdelewicz wrote:

>Hi,
>
>The DNETMAP target allows dynamic two-way 1:1 mapping of IPv4 subnets.
>Single rule can map private subnet to shorter public subnet creating
>and maintaining unambigeous private-public ip bindings. Second rule can
>be used to map new flows to private subnet according to maintained
>bindings. Target allows efficient public IPv4 space usage and
>unambigeous NAT at the same time.
>
>DNETMAP is available as patched xtables-addons-1.31 package and as a
>patch for xtables-addons-1.31 package.
>
>http://cat.piasta.pl/dnetmap/

Have you considered updating the NETMAP target inside the linux
kernel instead?

Your idea looks interesting in that I could envision it superseding
DNAT, SNAT and NETMAP altogether.


>Polite request to Jan Engelhardt for inclusion of the target into
>xtables-addons.

It would be nice if you could

 * resolve the inconsistencies in indentation. Specifically, use tabs to 
indent statements. If in doubt, use scripts/Lindent 
and scripts/checkpatch.pl from linux.

 * wrap lines at 80 cols in xt_DNETMAP.man 


Things I have noticed while spending a quick look:

The manpage mentions "If host 192.168.0.10 generates some traffic, it 
gets bound to first free IP in subnet - 20.0.0.0.". However,
20.0.0.0 can be a network address and thus lead to problems.
Is there a way for the user to specify that the range to use
should be 20.0.0.1-20.255.255.254 rather than 20.0.0.0-20.255.255.255?
