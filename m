From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrackd] allowing DisableExternalCache in alarm mode
Date: Thu, 1 Oct 2015 20:26:32 +0200
Message-ID: <20151001182632.GA4525@salvia>
References: <CAOkSjBh2KtYcSEQ7=h_h+R9CE53pwGtBAiQ_OZF0aTX0fhY0fw@mail.gmail.com>
 <20150828164912.GD3436@salvia>
 <CAOkSjBhxLk2beq70jZCTKtO8K09UcSj5jNh2H-9wvCzSL0XxeA@mail.gmail.com>
 <20150901164421.GA3320@salvia>
 <CAOkSjBhUEJESS=_Z2oui9FFNG7RM+ZRfJpFY2WWYWbVjN3LfOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56248 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbbJASTk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Oct 2015 14:19:40 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhUEJESS=_Z2oui9FFNG7RM+ZRfJpFY2WWYWbVjN3LfOw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 25, 2015 at 01:38:38PM +0200, Arturo Borrero Gonzalez wrote:
> On 1 September 2015 at 18:44, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Aug 31, 2015 at 09:55:23AM +0200, Arturo Borrero Gonzalez wrote:
> >> On 28 August 2015 at 18:49, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >> >
> >> > Are these FTP data flows? I'm asking this because the master
> >> > connection (control flow) may be missing in the conntrack table, thus
> >> > the ENOENT error.
> >>
> >> Makes sense.
> >>
> >> Would you consider accepting the patch?
> >
> > I think you can fix the problem that you're noticing by extending
> > timer_add().
> >
> > Note that the general idea behind the alarm approach is to insert a
> > timer with a random time wait in unit from 0..M seconds.
> >
> > A quick workaround to address this is that master conntracks are
> > placed in the time range from 0..N/2, then you place non-master
> > conntrack entries in the range from N/2+1 to M. Then, unless there is
> > packet loss, most likely the expected conntrack will find the master
> > one.
> >
> > It should be just a few more extra lines away from this oneliner.
> 
> I keep thinking about this, and I have a few questions:
> 
> timer_add() seems to manage timers for both internal and external caches.

Only for external:

struct sync_mode sync_alarm = {
        .internal_cache_flags   = NO_FEATURES,
        .external_cache_flags   = TIMER,
        ...

> Is it okay to include the workaround you mentioned for *both* internal
> and external caches?

You only have to make it from the internal cache, the relevant timer
bits are in the cache_alarm_extra code, more specifically the
cache_alarm_add(), cache_alarm_update() and refresher() functions.
These functions tell when to send the sync message to the backup
firewall.

> This is what I've understood: the master conntrack in the internal
> cache of the sending node is vanishing before the non-master
> conntrack, and then the non-master conntrack is being synced again to
> the receiving node without the associated master conntrack. Is this
> assumption true?

The problem is that the non-master conntrack gets to the back before
the master conntrack. With the workaround above, you can make sure the
master always comes in first place (unless there is sync message loss,
in that case the assumption above is no longer true).

Another a bit more complex solution, but nicer, would be to look up in
the internal cache for the master in case the IPS_EXPECTED status bit
is set, then queue from alarm_enqueue() the master conntrack object
before the expected conntrack. With this procedure, the master and the
expected conntrack will be transmited in the same sync message, coming
the master in first place as the backup firewall needs (the order
matters).

> Other possibility is that both master and non-master conntracks are
> sycned, but then the receiving node fails to somehow inject to the
> kernel in the required order.

Not sure what you mean, both master and non-master (expected)
conntracks are sync'ed, the problem is that the timer value is random,
so one may get scheduled to be sent via the refresher() before
another.

Cheers,
Pablo
