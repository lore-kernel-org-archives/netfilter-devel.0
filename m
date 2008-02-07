From: Justin McCann <jneilm@yahoo.com>
Subject: Re: Get UID from netlink/conntrack
Date: Wed, 6 Feb 2008 18:04:48 -0800 (PST)
Message-ID: <886927.30648.qm@web30401.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web30401.mail.mud.yahoo.com ([68.142.200.104]:48300 "HELO
	web30401.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757557AbYBGCEw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Feb 2008 21:04:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

----- Original Message ----
> From: Jan Engelhardt <jengelh@computergmbh.de>
> >I'd like to use libnetfilter_conntrack to track connections per UID
> >and/or by PID, ...
> 
> You are facing the same issues as xt_socket (currently, and
> unfortunately, still named xt_owner) - in that sockets do not
> necessarily have an owner, much less exactly one associated PID.

That doesn't surprise me too much, given how e.g. sshd handles connections (sockets are uid 0). Is this mainly a setuid issue, or is there something else interesting going on behind the scenes?

I'm attempting to make an auto-updating tcpdump filter, so unprivileged users could tcpdump their own connections without compromising privacy. For those purposes having the largest possible subset of connections 'owned/initiated' by a given user will do-- better something than nothing. In the cases where there isn't a known PID/UID, 0 would suffice (maybe -1 for PID since it appears to be a signed int). There are probably other applications this wouldn't work too well for, e.g. using the firewall to prevent any new connections by a user. But there are probably better ways to do that. 

It doesn't look like nfnetlink_log does any special handling in case the real uid isn't known. Is distinguishing between 'unknown/not set' and 0 important enough to handle specially (e.g. with a separate flag)?

BTW, I see that in 2.6.23, net/netfilter/nfnetlink_log.c:505 just grabs the uid directly out of the skb->.... Should that use sock_i_uid(skb) instead? That chain of macros/functions uses vfs_inode instead of sk_socket->file->f_uid, FWIW.

   Justin


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 

