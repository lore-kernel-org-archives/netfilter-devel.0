From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] use 32bit counters for connection-based accounting
Date: Mon, 10 Oct 2005 07:16:33 +0200
Message-ID: <20051010051633.GE9644@oknodo.bof.de>
References: <20051007105451.GE4719@rama>
	<20051007.132619.129111295.davem@davemloft.net>
	<20051007220435.GJ4450@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>, kaber@trash.net,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20051007220435.GJ4450@rama.customers.eurospot.com>
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

> > > [NETFILTER] Use only 32bit counters for CONNTRACK_ACCT
[...]
Dave:
> > I would like to actually suggest you keep the 64-bit counters.

For what it's worth, I second this suggestion. With 64-bit counters
in kernel/conntrack proper, as-yet-uninvented new matches and targets
can do fancy things to practically all real world data streams,
whatever fancy things they want to invent - the base is there.
When somebody gets an idea of a useful new match or target that
would need 64-bit per-conntrack counters, and he sees that he'll
have to implement kernel->user->kernel roundabout communication
just to get at the full counters, the idea will DIE IMMEDIATELY.

BTW, how wide are the regular iptables per-rule byte/packet counters?
Do we still have the 64-byte-per-each-and-every-rule wasted (and
always touched / brought in cache) for input/output network interface
name/mask, even when no network interface matching is done at all?

best regards
  Partick
