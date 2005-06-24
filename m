From: Patrick Schaaf <bof@bof.de>
Subject: Re: New target to control a fake network interface
Date: Fri, 24 Jun 2005 18:13:03 +0200
Message-ID: <20050624161303.GA9571@oknodo.bof.de>
References: <1119319953.4109.59.camel@envy>
	<8C06C084907746238C329ABC@[10.0.0.14]>
	<1119586321.8230.80.camel@envy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Corey Giovanella <coreygiovanella@challenge-engineering.com>
Content-Disposition: inline
In-Reply-To: <1119586321.8230.80.camel@envy>
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

On Fri, Jun 24, 2005 at 04:12:01AM +0000, Corey Giovanella wrote:
> > You're echoing iptables packet counts into a fake interface to make it 
> > available to an existing graphical monitor application. The app has a 
> > plugin system, so wouldn't it be better to write an iptables plugin for it? 
> 
> Yes, you are quite possibly right.  If my only concern was gkreallm a
> plugging would probably have been better.  One reason I did it this way
> was to do some kernel level programing, and to play around with
> iptables.  Also, this seems like a much more general solution that could
> be used for other things and in other apps if someone wanted to.  for
> example, it works with ifconfig.

If that idea is so wonderful, wouldn't it be wonderful to be able
to get at context switch counts, CPU usage, and all other kinds of
things representable by some counters, through a suitable fiddled-in
fake network interface?

What would be useful, is a packet/byte count aggregator infrastructure
where iptables rules can tell when to count into which bucket(s),
and where userlevel can efficiently read one or all buckets.

Having that readable through /proc/net/dev and all other interfaces
which show network devices, however, strikes me as bad abuse of
well-known stuff meant for different purposes (than accounting in
a fancy new way).

Just my opinion, of course.

best regards
  Patrick
