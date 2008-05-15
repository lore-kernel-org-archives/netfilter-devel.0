From: Anton <anton.vazir@gmail.com>
Subject: Re: NFLOG - missing packets?
Date: Thu, 15 May 2008 10:42:10 +0500
Message-ID: <200805151042.11110.anton.vazir@gmail.com>
References: <200805101657.45111.anton.vazir@gmail.com> <482B2626.8080902@netfilter.org> <482B272B.3040906@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:57166 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbYEOFmL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 01:42:11 -0400
In-Reply-To: <482B272B.3040906@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 14 May 2008 22:53, Patrick McHardy wrote:
> > plain text logging facility and then convert it to a
> > database *offline* if you really need advanced queries.
>
> Yeah, but what we can do is check whether the message
> was successfully transmitted in the kernel and drop
> the packet in case it wasn't. That should catch 99.9%
> of all error cases since a slow databse effectively
> only causes the process to read less often from the
> netlink socket.

What we did, is trying to transport a message over network 
to another host, for further analysis - OPRINT and LOGEMU 
targets were used. Even with no further DB interaction 
(just plain dumping to a file) - causes loosing of 50% of 
packets with hacked OPRINT - regardles if it's done while 
connecting to localhost (same pc) or another host. 
PC's are P4-3Ghz.

host 1(NFLOG -> ULOG -> OPRINT_OVER_NETWORK) -> host 2
(LOG_RECEIVER)

and just plain native LOGEMU looses arround 1% of packets on 
100mbit transfers.

If there a way for checking is the message were transmitted, 
how to do that?

>
> I still have a very old and unfinished patch for this
> somewhere ...
