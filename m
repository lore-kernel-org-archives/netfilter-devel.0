From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Automatically load modules in iptables-save
Date: Thu, 19 Mar 2009 14:55:54 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903191452550.27642@fbirervta.pbzchgretzou.qr>
References: <20090316171014.GG31952@ralph.linux2go.dk> <20090319125532.GC20472@ralph.linux2go.dk> <49C24332.2020107@trash.net> <20090319135006.GD20472@ralph.linux2go.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Soren Hansen <soren@ubuntu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47014 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZCSNz4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:55:56 -0400
In-Reply-To: <20090319135006.GD20472@ralph.linux2go.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-03-19 14:50, Soren Hansen wrote:
>On Thu, Mar 19, 2009 at 02:05:54PM +0100, Patrick McHardy wrote:
>>>> If the iptables modules are not loaded when iptables-save is run,
>>>> iptables-save will fail, because it can't open the relevant files in
>>>> /proc.  This patch makes iptables-save attempt to load the modules,
>>>> and then retries.
>
>Right. I thought about just silently bailing out, but decided to go this
>route instead. Explanation follows.
>
>$ sudo iptables-save
>iptables-save v1.4.1.1: Unable to open /proc/net/ip_tables_names: No such file or directory
>$ echo $?
>1
>
>I decided to try to load the modules instead of just silently returning,

IMHO, it should not fail, not even silently, but return success.
If x_tables.ko is not loaded, there cannot be any tables active
anyway, and thus would be equal to a loaded x_tables.ko with
no table modules (iptable_filter, etc.) loaded.

>so that if iptables-save succeeds, you can reasonably expect
>iptables-restore to work as well.

`echo '' | iptables-restore` does work. One more reason to
make iptables-save not outputting anything returning 0.
