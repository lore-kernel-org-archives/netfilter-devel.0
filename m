From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: how to use regex inside new netfilter extension modules?
Date: Wed, 3 Mar 2010 19:56:07 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003031954001.25372@obet.zrqbmnf.qr>
References: <63409.152.14.240.190.1267641716.squirrel@webmail.ncsu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Balaji Venkatamohan <bvenkat@ncsu.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46368 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab0CCS4J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:56:09 -0500
In-Reply-To: <63409.152.14.240.190.1267641716.squirrel@webmail.ncsu.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-03-03 19:41, Balaji Venkatamohan wrote:
>
>I need to use regular expressions inside the point of decision match
>function. I could not use 'regex.h ' or any other standard C library
>inside any of xt_*.c or xt_c*.h files. I could also see that none of the
>netfilter match extensions have them. I would also like to know why is it
>so?

Regular expressions are not the cheapest, both time and memory-wise:
you have to keep in mind NF runs in irq context. Furthermore, since 
you only see single packets rather than the connection stream, regexes 
prove to be far less useful.
