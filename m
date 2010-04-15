From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Named/numbered queues in the kernel?
Date: Thu, 15 Apr 2010 21:09:43 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004152109001.825@obet.zrqbmnf.qr>
References: <201004151302.40872.morgon.j.kanter@dartmouth.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "Morgon J. Kanter" <morgon.j.kanter@dartmouth.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40438 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab0DOTJo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 15:09:44 -0400
In-Reply-To: <201004151302.40872.morgon.j.kanter@dartmouth.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-04-15 19:02, Morgon J. Kanter wrote:

>I was poking around the libnetfilter_queue code in an attempt to 
>understand it, and was looking at the queue numbers. It looks like 
>these numbers are only part of an individual application, and are not 
>system-wide. Is there already a way to have system-wide numbers for 
>queues, or is that something that I'll have to implement myself?

Queue numbers are per system.

>For example, when using iptables I can do a "-j QUEUE". It would be 
>cool if instead I could do a "-j QUEUE <name or number>", and then have 
>an individual application only listen to its own queue instead of the 

See -j NFQUEUE --queue-num...

>entire system's worth of queued packets. Is there general interest in 
>this functionality beyond my own?
