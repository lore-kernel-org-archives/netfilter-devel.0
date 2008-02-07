From: Justin McCann <jneilm@yahoo.com>
Subject: Re: Get UID from netlink/conntrack
Date: Wed, 6 Feb 2008 19:28:41 -0800 (PST)
Message-ID: <734077.89514.qm@web30406.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web30406.mail.mud.yahoo.com ([68.142.200.109]:44788 "HELO
	web30406.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759088AbYBGD2m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Feb 2008 22:28:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

----- Original Message ----
> From: Jan Engelhardt <jengelh@computergmbh.de>
> >I'm attempting to make an auto-updating tcpdump filter, so
> >unprivileged users could tcpdump their own connections without
> >compromising privacy.
> 
> In that case, using ->f_uid should work for all (locally-generated)
> outgoing traffic. It is the best you can get right now.

I see that where /proc/net/tcp gets populated in net/ipv4/tcp_ipv4.c, the inode and uid use sock_i_uid() and sock_i_ino() for connections in TCP_SEQ_STATE_{LISTENING,ESTABLISHED}. Is there a reason to use ->f_uid instead?

That should get both incoming and outgoing, no? Or is the uid/inode not set up for outgoing connections in the SYN_SENT state? My question here is-- is there any chance I'd be notified of active-open/locally-initiated connections before the outgoing SYN packet gets sent?

> About input, a test would be needed (examining things) because I
> suspect that ssh sessions can be wrongly attributed to root when
> there's a normal user sitting behind it.

Right-- but although I'd like to see those connections as well, I'll take what I can get without too many changes. Clearly a problem for other applications.

> PID matching is not possible. Or rather, if it was, you'd spend a
> ridiculous amount of time scanning all processes' fd tables on every
> packet.

I was thinking the same thing, but the kernel has to actually queue up the data to socket. It would be nice if the sk_peercred actually got populated once the socket was created, but only for AF_UNIX. But then again, you can actually pass sockets between processes, so who owns it then? The PID isn't so important, just a nice-to-have.

Also, I only care to update the bpf filter when the connections change (which is exactly why conntrack is almost perfect for it), so I think/hope there shouldn't be any particular per-packet overhead. 

> And that's just the kernel side. How you wire that up in netlink
> is another story.

Yeah, about that....

    Justin


      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
