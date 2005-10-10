From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] use 32bit counters for connection-based accounting
Date: Mon, 10 Oct 2005 10:59:35 +0200
Message-ID: <20051010085934.GF9644@oknodo.bof.de>
References: <20051007105451.GE4719@rama>
	<20051007.132619.129111295.davem@davemloft.net>
	<20051007220435.GJ4450@rama.customers.eurospot.com>
	<20051010051633.GE9644@oknodo.bof.de>
	<20051010083028.GB5091@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Patrick Schaaf <bof@bof.de>,
	"David S. Miller" <davem@davemloft.net>, kaber@trash.net,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20051010083028.GB5091@rama.customers.eurospot.com>
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

Hi Harald,

thanks for the extended rationale (not quoted, but appreciated).

I personally would have no problem with configuring this at compile time,
if neccessary. It was good to read that userlevel already gets typed
counters, so must cope.

I have one (ignorant) question left: when a certain byte counter
for some direction/flow overflows, is the packet counter forced
to overflow at the same time? Same question for when the packet
counter overflows - does the associated byte counter wrap, too?
(I intuit such would be desired behaviour. Wouldn't it?)

Re number-of-packets at 32 bit, I can only tell that in the
real world I know, the Radius protocol is sprouting extended
attributes to communicate the overflow (high 32 bit) part
of the per-connection (DSL-session etc) packet counters.
(The same two-attribute approach was used years ago for the
byte counters, but everybody was sure 32 bit packet counters
were good enough). Oh, the Radius practise does not include
any means to flag 'I overflowed, some time in the past'.

Hmm. Would it be hard to have each conntrack start out with
32 bit counters, plus an 'I overflowed' indicator? And some
additional memory (isn't there a nice 'ext *' interface now)
is used for the very rare conntracks which indeed need
64-bit counters?

best regards
  Patrick
