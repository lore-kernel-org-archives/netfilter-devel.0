From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: ip_conntrack performance issues
Date: 18 Jan 2003 15:15:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1042899318.16799.38.camel@tux.rsn.bth.se>
References: <200301180113.04460.alchemyx@uznam.net.pl>
	 <1042857018.16805.19.camel@tux.rsn.bth.se>
	 <20030118072556.GB12401@oknodo.bof.de>
	 <20030118074306.GC12401@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Micha Margula <alchemyx@uznam.net.pl>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030118074306.GC12401@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2003-01-18 at 08:43, Patrick Schaaf wrote:
> > The real problem with the interface, is not the runtime, but the
> > inaccuracy. Does ctnetlink help with that?
> 
> Too early in the morning... The question should be "does ctnetlink
> help to provide an accurate O(N) scan over all connections, neither
> returning a connection twice during one scan, nor ommitting any
> connection that was alive between the start of the scan, and the
> current scan time point".
> 
> For the O(1) oident _lookup_ case, all this is irrelevant, and an
> interface like /proc/net/ip_conntrack is inefficient IN PRINCIPLE.
> It is clear that the query functionality of ctnetlink solves this.

In the case of a scan of all connections ctnetlink will give you a
correct list since it holds a readlock on ip_conntrack_lock the entire
time. This of course isn't very good... but it does give you a correct
list unlike /proc/net/ip_conntrack which starts over for every 4kB and
start generating the list from the beginning until it has produced the
next 4kB that the user wanted and then it starts over again. And it
drops the lock after each 4kB sent to userspace.

ctnetlink has a few other nice features aswell, you can drop/create
connections and/or expectations. I don't know how far along these things
have come but I do remember that the delete connections feature works.

These features will probably be the base for the next generation of
conntrack/nat helpers that will run in userspace.

I will probably start looking at other performanceproblems with
ip_conntrack soonish, I'll probably start trying to get UP running a bit
faster and then start attacking SMP (rusty's rework of the locking looks
nice but RCU would be even nicer...)

I'll dig out the patch you made a while ago regarding the lists and
timers.... well time for breakfast now.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat you with experience.
