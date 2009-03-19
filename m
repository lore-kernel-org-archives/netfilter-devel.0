From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Automatically load modules in iptables-save
Date: Thu, 19 Mar 2009 15:31:25 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903191530310.31487@fbirervta.pbzchgretzou.qr>
References: <20090316171014.GG31952@ralph.linux2go.dk> <20090319125532.GC20472@ralph.linux2go.dk> <49C24332.2020107@trash.net> <20090319135006.GD20472@ralph.linux2go.dk> <alpine.LSU.2.00.0903191452550.27642@fbirervta.pbzchgretzou.qr>
 <20090319142935.GE20472@ralph.linux2go.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Soren Hansen <soren@ubuntu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35207 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZCSOb2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 10:31:28 -0400
In-Reply-To: <20090319142935.GE20472@ralph.linux2go.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-03-19 15:29, Soren Hansen wrote:
>
>How about the case where someone calls "iptables-save -t foo"? Should
>that just return an empty string and exit(0), should it attempt module
>load to see if that's even a valid table or something entirely
>different?

It should load x_tables.ko and the table... I have a suspicion
some unknown users might expect to see "*foo" when using -t.
