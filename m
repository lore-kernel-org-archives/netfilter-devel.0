From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 11:26:39 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805151125570.16151@fbirervta.pbzchgretzou.qr>
References: <200805151421.23862.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47805 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144AbYEOJ0k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 05:26:40 -0400
In-Reply-To: <200805151421.23862.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-05-15 11:21, Anton wrote:

>Regarding the performance of the lookup of the iptables 
>rules for match inside the kernel, is there any plans to 
>improve the behaviour or no plans in this area yet?
>
>For example on the transit gateway I have ~500 rules which 
>mark the packet, according to the client source IP - with 
>unique mark per client IP - so I have 500 unique marks 
>there, and so cannot use IPSET, and only IPTABLES - but 
>it's known that iptables insert/lookup is very slow on huge 
>rulesets (atleat with iptables 1.3.x) and slowness 
>progresses approximatelly exponentially on growth of rules 
>number.
>
>Do I miss anything?

You missed IPMARK from Xtables-addons which does the marking
in O(1) instead of O(n).
