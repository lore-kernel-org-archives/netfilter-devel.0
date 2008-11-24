From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: ip_conntrack_ftp messages
Date: Tue, 25 Nov 2008 03:44:46 +1030
Message-ID: <200811250344.46392.rusty@rustcorp.com.au>
References: <31563483.01227485595724.JavaMail.shane@shane-laptop> <200811241445.56544.rusty@rustcorp.com.au> <492A9DD9.1090307@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Shane Goulden <shane@matrixau.net>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:41542 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbYKXRO7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2008 12:14:59 -0500
In-Reply-To: <492A9DD9.1090307@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 24 November 2008 22:58:09 Patrick McHardy wrote:
> Rusty Russell wrote:
> > 		if (net_ratelimit())
> > 			printk("conntrack_ftp: partial %s %u+%u\n",
> > 			       search[dir][i].pattern,
> > 			       ntohl(th->seq), datalen);
>
> Its strange that FTP is apparently working since we drop those packets.
> I'm not sure about downgrading that message, its there to inform the
> user of an exceptional action (dropping of packets within conntrack).

Actually, we drop the packets *so* it will work.  The idea is that they'll 
coalesce and send the whole packet next time.

If not, well, they don't get any more packes through, but without connection 
tracking the other connections wouldn't work anyway (if the conntrack is being 
used for NAT or filtering).

IIRC wu-ftpd used to trigger this (multiple write syscalls for the ip address 
and nagle sometimes hit in the middle; go figure).

Cheers,
Rusty.
