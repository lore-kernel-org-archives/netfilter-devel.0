From: Daniel Hartmeier <daniel@benzedrine.cx>
Subject: Re: [PATCH] TCP window tracking patch backported from the 2.6 tree
Date: Thu, 30 Jun 2005 13:13:44 +0200
Message-ID: <20050630111344.GP26761@insomnia.benzedrine.cx>
References: <Pine.LNX.4.58.0506281201590.12765@blackhole.kfki.hu>
	<42C17443.60909@drugphish.ch>
	<Pine.LNX.4.58.0506290926400.14936@blackhole.kfki.hu>
	<42C26765.2060304@tac.ch>
	<Pine.LNX.4.58.0506291223440.14974@blackhole.kfki.hu>
	<20050629145545.GO26761@insomnia.benzedrine.cx>
	<Pine.LNX.4.58.0506300903350.16566@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0506300903350.16566@blackhole.kfki.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 30, 2005 at 09:48:19AM +0200, Jozsef Kadlecsik wrote:

> > advantages this has? We see no problems with SACK-enabled connections in
> > pf, and simply ignore selective ACK options.
> 
> I suspect you haven't received reports on such problems because pf does
> not log when it drops out of window segments. TCP is a robust protocol and
> sometimes, by resending packets, it can overcome the situation and the
> connection does not hang forever. However the window tracking patch for
> netfilter lived very long time in patch-o-matic as an experimental
> extension with logging out of window packets enabled. We received
> complains and sometimes the reporters could supply both the logs and full
> tcpdump recordings from the firewall which revealed the problem.

pf can log when it drops packets that mismatch the state entry's
sequence number windows ('BAD state' log entries, generated when pfctl
-xm, debug logging, is enabled, which is disabled by default).

I've analyzed a fair number of problem reports with both tcpdumps of
connections and such out-of-window logs, but I've never seen one where
SACK holes were part of the puzzle. In some cases, one peer would simply
violate the TCP RFC and send out-of-window segments. Maybe I just didn't
make the connection between seemingly invalid behaviour and SACK holes,
but out of at least two dozen analyzed incidents, none remained
unexplained so far.

I'd be interested in an example dump and log of a connection that
demonstrates this issue, especially if it shows that the hosts
didn't violate the RFCs. Comparing, in that example, the use of a
right-most SACK hole as edge vs. a (later) plain ACK could help
understand the implications.

I'm not saying netfilter's use of the SACK holes is potentially
incorrect, but it looks somewhat suspicious to me, and that's what I'd
look at more closely. If you still have one of those examples around,
I'd love to see it :)

Daniel
