From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Make nfct_catch return control to original thread
Date: Thu, 1 Mar 2012 00:26:02 +0100
Message-ID: <20120229232602.GA3817@1984>
References: <CA+DcbdcTggNHJS3rCbnVNHejU5Zdb3+fukK_03qB+Y30K7XhxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Jeremy/starcraft.man" <starcraft.man@ubuntu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54585 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378Ab2B2X0L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:26:11 -0500
Content-Disposition: inline
In-Reply-To: <CA+DcbdcTggNHJS3rCbnVNHejU5Zdb3+fukK_03qB+Y30K7XhxA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 29, 2012 at 09:38:00AM -0500, Jeremy/starcraft.man wrote:
> Hi,
> 
> I'm a developer currently working at a company using libnetfilter, I
> came in late in development of the product and the code is pretty much
> complete. Due to debugging checks recently enabled, they want to be
> able to unblock and gracefully stop all threads before terminating the
> process. The problem then is that the thread which invokes nfct_catch
> never returns and blocks the thread from cleanly terminating.
>
> pthread_cancel is not an option since we develop on android and that
> platform doesn't stopping threads that way.
> 
> I'm not that familiar with netfilter and am still reading up, from
> what I've read it doesn't seem like I can. Please correct me if I'm
> wrong, but the events that trigger the registered handlers are all
> tied to interfaces being new/updated/down and thus I can't just use a
> handler that returns NFNL_CB_STOP when it next gets an event (at least
> not unless I trigger an event artificially say after setting a boolean
> flag in the registered handler to force it to stop). Is there any sort
> of signal mechanism I'm missing that could be used to force a return
> from the loop of nfnl_catch?

You can set the non-blocking socket via nfct_fd(...) and setsockopt.

Then, check if nfct_catch returns -1 and errno == EAGAIN.
