From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] use 32bit counters for connection-based accounting
Date: Mon, 10 Oct 2005 18:38:45 +0200
Message-ID: <20051010163844.GG9644@oknodo.bof.de>
References: <20051007105451.GE4719@rama>
	<20051007.132619.129111295.davem@davemloft.net>
	<20051007220435.GJ4450@rama.customers.eurospot.com>
	<20051010051633.GE9644@oknodo.bof.de>
	<20051010083028.GB5091@rama.customers.eurospot.com>
	<20051010085934.GF9644@oknodo.bof.de>
	<20051010094717.GA5347@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Patrick Schaaf <bof@bof.de>,
	"David S. Miller" <davem@davemloft.net>, kaber@trash.net,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20051010094717.GA5347@rama.customers.eurospot.com>
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

> > I have one (ignorant) question left: when a certain byte counter
> > for some direction/flow overflows, is the packet counter forced
> > to overflow at the same time? Same question for when the packet
> > counter overflows - does the associated byte counter wrap, too?
> > (I intuit such would be desired behaviour. Wouldn't it?)
> 
> no, the counters will overflow independently - and we have no indication
> that such an event occurred.

Could this be discussed a bit? My rationale is that sometimes
all I'm interested in, is a quick evaluation of average packet
sizes. With synchronized byte and packet counters, this is
one divide away. When synchronization cannot be assumed, several
samples MUST be taken, and differences calculated. Damn.

> Radius is, however, used for doing accounting on "per line" basis, that
> is per dialup/dsl session.  Yes, i see, in the case of PPTP/L2TP all
> packets within such a session are likely to end up in one conntrack...

L2TP conntracking itself would be an exellent example of very long
living flows: it even has multiple (think possibly a hundred)
individual end user tunnel sessions all running between the
same L3/L4 association. BTW, average packet size is a nice
fuzzy indicator for upstream/downstream direction :)

all the best
  Patrick
