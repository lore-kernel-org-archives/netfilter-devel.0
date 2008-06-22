From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: insmod: error inserting 'ipt_ipaddr.ko': -1 Unknown symbol in
 module
Date: Sun, 22 Jun 2008 10:50:42 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806221046350.15126@fbirervta.pbzchgretzou.qr>
References: <163429.97629.qm@web38503.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: isabela dinarsari <chebbyme@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48130 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbYFVIuo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Jun 2008 04:50:44 -0400
In-Reply-To: <163429.97629.qm@web38503.mail.mud.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2008-06-22 10:02, isabela dinarsari wrote:

>i need to insert module ipt_ipaddr match using insmod,
>but there's an error:
>
>ipt_ipaddr: Unknown symbol xt_register_match
>ipt_ipaddr: Unknown symbol xt_unregister_match
>
>could you explain to me how to solve this problem?
>thank you

insmod does not automatically load dependencies, only modprobe does.
But modprobe does not take a filename, which makes the situation a bit 
awkward. So what's left is that one loads the dependencies with 
modprobe before:

	modprobe x_tables
	modprobe xtables_compat
	insmod xt_ipaddr.ko

Note that ipt_ipaddr has been "replaced" by xt_ipaddr (you know ipaddr 
is just a test module anyway); the new doc is at 
http://jengelh.medozas.de/documents/Netfilter_Modules.pdf

