From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 3/3] NFQUEUE: add --queue-cpu-fanout parameter
Date: Tue, 2 Apr 2013 13:26:32 +0200
Message-ID: <20130402112632.GA9386@localhost>
References: <20130323200402.209591997@eitzenberger.org>
 <20130323200608.668651644@eitzenberger.org>
 <20130401232947.GA12381@localhost>
 <20130402103539.GF8327@imap.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41551 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab3DBL0i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:26:38 -0400
Content-Disposition: inline
In-Reply-To: <20130402103539.GF8327@imap.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Holger,

On Tue, Apr 02, 2013 at 12:35:39PM +0200, Holger Eitzenberger wrote:
> Hi Pablo,
> 
> > I think we have to add O_QUEUE_CPU_FANOUT here to make sure both
> > queue-balance and queue-cpu-fanout are not used both incorrectly
> > together. That also needs some code a new .x6_fcheck function to
> > validate this.
> 
> it is currently that --queue-cpu-fanout *requires* --queue-balance, as
> the CPU fanout works on top of the balanced queues.
> 
> Or possibly I miss your point.

Forget it, your patch was just fine, sorry.

> > Could you also send me the corresponding manpage update for this?
> 
> Sorry for lacking that.
> 
> I've respinned the 3/3 patch to include the man page update as well.

Thanks!

I have pushed this to the -next branch of iptables. Will merge by when
3.10-rc1 is released.
