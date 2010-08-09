From: Jon E <je_nfd@hotmail.com>
Subject: RE: Help! Stuck while porting table code from older to recent kernel
Date: Mon, 9 Aug 2010 14:42:55 -0400
Message-ID: <SNT135-w32147432DE5D4464E054BCF3940@phx.gbl>
References: <SNT135-w26664576B07E441CEE789BF3940@phx.gbl>,<alpine.LSU.2.01.1008091955560.21619@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from snt0-omc1-s35.snt0.hotmail.com ([65.55.90.46]:28206 "EHLO
	snt0-omc1-s35.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754199Ab0HISm4 convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Aug 2010 14:42:56 -0400
In-Reply-To: <alpine.LSU.2.01.1008091955560.21619@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



> >So, my primary question is, how can I add a new table under the current
> >framework?
>
> You will have to forfeit the netns integration and use &init_net.

Is there a code example of table creation using this that you can direct me to?

> xt_register_table is for exclusive internal use of {ip,ip6,etc}_register_table.

Thank you, I will not use it.  I was just under the impression that, if one of the goals was/is to remove ip_xxx references, that one should favour the new functions over the old.  I gather I misunderstood the purpose of the consolidation efforts? 		 	   		  