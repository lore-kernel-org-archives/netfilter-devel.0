From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Get UID from netlink/conntrack
Date: Thu, 7 Feb 2008 03:14:40 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802070308020.23855@fbirervta.pbzchgretzou.qr>
References: <886927.30648.qm@web30401.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Justin McCann <jneilm@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50346 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758735AbYBGCOl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Feb 2008 21:14:41 -0500
In-Reply-To: <886927.30648.qm@web30401.mail.mud.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Feb 6 2008 18:04, Justin McCann wrote:
>>>
>>>I'd like to use libnetfilter_conntrack to track connections per
>>>UID and/or by PID, ...
>> 
>> You are facing the same issues as xt_socket (currently, and
>> unfortunately, still named xt_owner) - in that sockets do not
>> necessarily have an owner, much less exactly one associated PID.
>
>That doesn't surprise me too much, given how e.g. sshd handles
>connections (sockets are uid 0).

- sshd created the socket as root (dunno why it did that as root :-)
- so skb->sk->sk_socket->file->f_uid is root, no matter
  if it called setuid(2) or not.
- binds to port 22 (requires root)
- accept(2), privilege separation and all that

(I notice an interesting upcoming problem for input-path owner
processing as projected with tproxy's help.)

>Is this mainly a setuid issue, or
>is there something else interesting going on behind the scenes?
>
>I'm attempting to make an auto-updating tcpdump filter, so
>unprivileged users could tcpdump their own connections without
>compromising privacy.

In that case, using ->f_uid should work for all (locally-generated)
outgoing traffic. It is the best you can get right now.

About input, a test would be needed (examining things) because I
suspect that ssh sessions can be wrongly attributed to root when
there's a normal user sitting behind it.

PID matching is not possible. Or rather, if it was, you'd spend a
ridiculous amount of time scanning all processes' fd tables on every
packet.

And that's just the kernel side. How you wire that up in netlink
is another story.
