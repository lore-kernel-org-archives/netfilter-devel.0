From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: CAN you give me a piece of sample code to implement this
 iptablescommand? thanks
Date: Mon, 12 May 2008 18:47:22 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805121846130.25441@fbirervta.pbzchgretzou.qr>
References: <200805112243513753221@fiberhome.com.cn> <200805112347000787949@fiberhome.com.cn> <48286949.5000503@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: cyx <cyx@fiberhome.com.cn>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53627 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbYELQrY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 12:47:24 -0400
In-Reply-To: <48286949.5000503@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-05-12 17:59, Patrick McHardy wrote:
> cyx wrote:
>> So there is no APIs we can use to manipulate the kernel's iptables, except
>> invoking the "iptables" command from shell? so wired, it should be have some
>> APIs to do the same as the "iptables" does.          
>
> Unfortunately not, at least not for C. There is a perl-API,
> but I forgot its name.

Why does everything need a C API? head, tail, grep, sort, are all shell
utilities without a C API yet they are used in an API-like fashion
by the user:

	ls | grep foo | sort -r | tail -n 1

so I do not see anything wrong -- especially now that Henrik presented
his patches -- to do the same with iptables. And it is not really
hard to use pipe() from C.
