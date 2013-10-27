From: Phil Oester <kernel@linuxace.com>
Subject: Re: conntrack, idle TCP connection and keep-alives
Date: Sun, 27 Oct 2013 08:34:09 -0700
Message-ID: <20131027153408.GA20634@home>
References: <526C22B8.5030102@torlan.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: WGH <wgh@torlan.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56158 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab3J0PeM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 11:34:12 -0400
Received: by mail-pa0-f46.google.com with SMTP id rd3so5725583pab.5
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Oct 2013 08:34:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <526C22B8.5030102@torlan.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 27, 2013 at 12:14:48AM +0400, WGH wrote:
> It seems that, when masquerading, conntrack silently drops idle
> connection after nf_conntrack_tcp_timeout_established seconds. This's
> pretty terrible, as application inside the network, if it never sends
> anything, will never know that connection was dropped.

If this is a problem for you, then increase nf_conntrack_tcp_timeout_established
to an insanely high value.  You do realize, of course, that the conntrack
table has a finite number of entries.
 
> RFC 5382 gives us a solution to this:
> > A NAT can check if an endpoint for a session has crashed by sending a
> > TCP keep-alive packet and receiving a TCP RST packet in response.
> 
> However, it I couldn't find such feature in netfilter. It would be
> pretty nice to have.

Keepalives should be done in the application, not in the firewall.

Phil
