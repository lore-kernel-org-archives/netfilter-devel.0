From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: New logging module
Date: Sat, 13 Sep 2003 09:54:02 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309130941170.25469-100000@filer.marasystems.com>
References: <20030912203907.GC4398@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030912203907.GC4398@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 12 Sep 2003, Harald Welte wrote:

> this would be something new.  Does this have to be event-based from the
> kernel?  Why can't you just periodically dump the whole table via GET
> requests from userspace?

Not sure. It depends on what is worst.. the overhead of event handling in
the kernel or the overhead of dumping all rules even those who does not
need to be logged as their start/stop was logged recently. But it sure
should be possible to use a conditional GET only returning open
long-running sessions.

> > 3. End of session
> 
> again covered by patrick's event code.  If you send the whole conntrack
> for every event (start/stop of session), the counters would be included.

Indeed.

> Please make sure that struct ip_conntrack is layed out in a way that all
> writeable parts (timer, counters) are packed together in the same
> cacheline. this way we don't get cache ping-pong for the whole
> structure.

Right.. this should be a problem for the tcp window tracking code as well, 
the difference being that the counters are not normally needed other than 
when producing the logs (unless a match using these counters are also 
done).

Regards
Henrik
