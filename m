From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables execution with sudo fails
Date: Mon, 6 Oct 2008 08:17:35 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810060816160.10698@fbirervta.pbzchgretzou.qr>
References: <548BC174642DC44AB25D749C28840FD308C72D7F@ZMY16EXM66.ds.mot.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Tanneeru Muralidhar Babu-A19589 <muralidharbabu@motorola.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57136 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbYJFMRg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:17:36 -0400
In-Reply-To: <548BC174642DC44AB25D749C28840FD308C72D7F@ZMY16EXM66.ds.mot.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-10-06 00:56, Tanneeru Muralidhar Babu-A19589 wrote:
> Hi,
> 
>While executing iptables command using sudo on my system (running MV
>2.6.10), I see following errors. Could someone please help me understand
>this error ?
> 
>sudo:        0 : uid 0 does not exist in the passwd file! ; TTY=unknown
>; PWD=unknown ; USER=root ; COMMAND=/sbin/iptables
> 
>Is this a problem with passwd file ? Under what circumstances do we see
>this error ?

This is a sudo problem, not iptables. I suggest you use the su
command instead.
