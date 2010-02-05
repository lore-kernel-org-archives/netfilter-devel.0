From: Jan Engelhardt <jengelh@medozas.de>
Subject: RE: kernel panic with ip_conntrack with kernel 2.6.16.13
Date: Fri, 5 Feb 2010 14:08:08 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002051358300.23211@obet.zrqbmnf.qr>
References: <001301caa5ca$2b50e8a0$81f2b9e0$@com> <alpine.LSU.2.01.1002051323130.7363@obet.zrqbmnf.qr> <005901caa661$81650400$842f0c00$@com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: 'Netfilter Developer Mailing List'
	<netfilter-devel@vger.kernel.org>
To: Nishit Shah <nishit@elitecore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38095 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094Ab0BENIJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:08:09 -0500
In-Reply-To: <005901caa661$81650400$842f0c00$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-02-05 13:48, Nishit Shah wrote:

>Thanks Jan,
>	
>	Besides kernel upgrade, is there a way ? as hardware is running in
>production 2.6.16 environment. :(
>	Any information regarding understanding the kernel panic or fix is
>really appreciated. 

You had a NULL dereference, and 00000079 is an approximation as to 
what struct member was accessed, together with the stack trace showing 
destroy_conntrack+0xc6 (=near the start of said function) one can go and 
look if really interested.
If your distro does not ship updates for the kernel anymore, I would be 
worried. And I would be, given that 2.6.16.13 is not even the most 
recent in the .16 series IIRC.
