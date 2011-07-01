From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_AUDIT additions
Date: Fri, 1 Jul 2011 10:12:12 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1107011005060.7813@frira.zrqbmnf.qr>
References: <4E0CFBF2.9000500@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, hch@infradead.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:43379 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab1GAIMN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:12:13 -0400
In-Reply-To: <4E0CFBF2.9000500@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-07-01 00:42, Mr Dash Four wrote:

>I would like to add 3 more pieces of information to the audit target to 
>be included in the audit logs:
>
>1. pid/uid -> auid + program path (auid and program path is retrievable 
>once the pid is known) - outgoing packets only, obviously;
>
>I know this information *should* be available as outgoing packets are 
>bound to sockets and those are created by a process, but I am 
>struggling to find a reliable source which I could use. I looked at 
>both ss and netstat sources, but the approach there is very different 
>as they both use/scan "/proc" to retrieve this information and I am not 
>sure this is the best way to approach things for the kernel code of the 
>audit target.

xt_owner did the same - it scanned the process table. According to 
Christoph Hellwig, this was declared as some gross abuse, and, IIRC, the 
reason was something like the tasklist lock was held "quite long" (which 
makes sense). However, xt_owner did not held the tasklist [write] lock, 
just entered a RCU read section. hch: Was this RCU section also too 
long?

xt_owner had the bonus that it only had to check whether the socket was 
owned by a particular user/group/pid/sid, which means it can stop 
looping the tasklist as soon as it found a match.

But with xt_AUDIT, you would have to traverse the entire list, because 
you would want to find all PIDs - since a socket may be shared between 
multiple threads/processes - which in itself may generate a huge list 
(=another problem) in the audit records.

Also, the PID owner may not be the socket owner for the same reason.
