From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Multiple IPs on iptables/ip6tables command line
Date: Wed, 29 Apr 2009 22:53:50 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904292251480.9772@fbirervta.pbzchgretzou.qr>
References: <49DE2F54.1040703@zeus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Michael Granzow <mgranzow@zeus.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39098 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbZD2Uxv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:53:51 -0400
In-Reply-To: <49DE2F54.1040703@zeus.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-04-09 19:24, Michael Granzow wrote:
>It seems iptables (and ip6tables) can only process one IP address at a
>time which makes blocking many IP addresses a rather slow process.

Use iptables-restore ;-)

>commit 377b05e967bc0623364089f2d57018ab2604ea95
>Author: Michael Granzow <mgranzow@zeus.com>
>Date:   Thu Apr 9 16:38:09 2009 +0100
>
>    Allow multiple IPs on the command-line for iptables/ip6tables.
>    
>    With this patch, you can process more than one IP address with a single
>    invocation of iptables, for instance:
>    
>     # ip6tables -A INPUT -s 2001:db8::a,2001:db8::b,2001:db8::c -j DROP
>     # ip6tables -I INPUT -s 2001:db8::d,2001:db8::e -j DROP
>     # ip6tables -D INPUT -s 2001:db8::a,2001:db8::d -j DROP

I cleaned this patch now and queued it.

You may re-inspect or test it, grabbable from:
	git://dev.medozas.de/iptables  master  (commit 91c9e31)
