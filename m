From: Patrick Schaaf <bof@bof.de>
Subject: Re: PATCH: extra conntrack stats
Date: Mon, 28 Apr 2003 08:13:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030428061323.GA9256@oknodo.bof.de>
References: <200304192142.h3JLg1S03466@fokkensr.vertis.nl> <20030427124835.GA990@sunbeam.de.gnumonks.org> <200304271523.h3RFNZk05880@fokkensr.vertis.nl> <20030427204218.GT990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
  Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
  netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030427204218.GT990@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Apr 27, 2003 at 10:42:18PM +0200, Harald Welte wrote:
> On Sun, Apr 27, 2003 at 05:23:30PM +0200, Rolf Fokkens wrote:
> > On Sunday 27 April 2003 02:48 pm, Harald Welte wrote:
> > > This is inacceptable, the only way to implement this is via per-cpu
> > > counters that are added at the time you read them out (like the iptables
> > > per-cpu local counters)
> > 
> > Oh boy! It's even worse! Even without this patch we have a concurrency 
> > problem: the timout! It's updated frequently I guess, and it's also
> > protected by the same lock: ip_conntrack_lock!

Let's look at things non-polemically, please.

The first add_timer() you allude to, happens in __ip_conntrack_confirm().
Indeed, we take a WRITE_LOCK there. But, we do this not to protect
the add_timer(), but to protect the conntrack list insertion happening
there. Of course, we need a WRITE_LOCK for list insertion [*]. But, note
that this only happens for unconfirmed conntracks, i.e. about once per
individual connection, for the first packet of the connection.
Otherwise, __ip_conntrack_confirm() returns _before_ doing the WRITE_LOCK.

The more general issue with timers, is the regular update on further
packets. This happens in ip_ct_refresh(). Indeed, it happens under
conntrack WRITE_LOCK. It's probably this place that you remembered.

IF a new WRITE_LOCK reason appears, e.g. for the counter update
discussed here, I would strongly advise to do it in ip_ct_refresh(),
i.e. use the already taken WRITE_LOCK, don't take it twice. If you
take it twice in a row, chances are you just doubled the ping pong
frequncy under load, i.e. halved the packets-per-second worst case.

> > Should a lock per contrack entry be considered? This increases the 
> > concurrency for different connections anyhow.

That would help in that place. However, we'd still do a del_timer/add_timer,
and the kernel timer implementation will again do some locking.

Harald remembered:

> Oh yes, sorry.  This issue never was fixed, although I seem to remember
> some patches implementing a solution where the timeout was not updated
> for every packet.

Correct. I implemented (and lightly tested) such a solution last year,
here's the pointer to the archives:

http://lists.netfilter.org/pipermail/netfilter-devel/2002-August/008859.html

Note that it does NOT get rid of the WRITE_LOCK, because this solution
needs to store the new timeout target in conntrack, after calculating
it - which would be racy without the lock.

So, Rolf's suggestion of a per-conntrack lock would indeed help here
to further reduce pingpong.

As far as I remember, ip_ct_refresh() was the only WRITE_LOCK we
take per-packet, at least at the conntrack layer.

To recapitulate, for the packet/byte counter patch, one should
either use per-cpu counters, or put the counter update into
ip_ct_refresh(), somehow.

best regards
  Patrick
