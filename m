From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Wed, 14 Jul 2004 05:37:51 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407140528420.12284-100000@filer.marasystems.com>
References: <40F48AE6.9090302@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Stephen Frost <sfrost@snowman.net>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <40F48AE6.9090302@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 14 Jul 2004, Patrick McHardy wrote:

> Maybe we should add new policy checks to protect conntrack from these
> packets. If they are invalid it shouldn't change state.

This general problem of conntrack when applying policies on packets
flows.. Spoofed packets arriving from an untrusted source will disrupt
conntrack states unless filtering is applied before conntrack.

In normal traffic this can be solved by using the raw table to enforce the
anti-spoof policy by dropping illegal traffic flows before seen by
conntrack.  I suppose something similar could be done with ipsec traffic?

It would obviously be very nice for conntrack if the ipsec policy checks
could be applied in prerouting before conntrack, but I am not sure how
feasible this is.. It is not exacly a natural point for ipsec to apply 
policy checks in prerouting..

Regards
Henrik
