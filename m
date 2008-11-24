From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: ip_conntrack_ftp messages
Date: Mon, 24 Nov 2008 14:45:56 +1030
Message-ID: <200811241445.56544.rusty@rustcorp.com.au>
References: <31563483.01227485595724.JavaMail.shane@shane-laptop>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Shane Goulden <shane@matrixau.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:46982 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbYKXEQC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Nov 2008 23:16:02 -0500
In-Reply-To: <31563483.01227485595724.JavaMail.shane@shane-laptop>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 24 November 2008 10:43:19 Shane Goulden wrote:
> 2.6.18-92.1.10.el5xen
>
> FTP is working. Is there a way to easily silence the messages?

Not that I am aware of.  Perhaps that printk (still there in latest kernels) 
should be downgraded to a DEBUG?

		if (net_ratelimit())
			printk("conntrack_ftp: partial %s %u+%u\n",
			       search[dir][i].pattern,
			       ntohl(th->seq), datalen);

Cheers,
Rusty.

