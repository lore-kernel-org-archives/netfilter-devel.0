From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] ctnetlink events drop benchmark
Date: Wed, 14 Jun 2006 15:55:29 +0200
Message-ID: <44901551.8080400@trash.net>
References: <448ED2DD.30100@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <448ED2DD.30100@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Hi,
> 
> Finally, I've got some results in my test enviroment about the ctnetlink
> event drop issue. The machine used as firewall is a PIII 866 256 Mbytes
> RAM, two NIC realtek 8139 100Mbits running debian unstable with linux
> kernel 2.6.16.
> 
> I have run the same test with three different socket queue sizes:
> 107.520 (default)
> 215.040 (x2)
> 430.080 (x4)
> 
> I used netperf to create the connections with a shell script that loops
> calling netperf -H ip -l 3 &.
> 
> To get the number of events dropped I've used the following:
> 
> $ conntrackd & (run as daemon)
> $ conntrackd -s (request statistics)
> 
> Results are available in:
> 
> http://people.netfilter.org/pablo/ctnetlink/events.eps

Does "events" mean events/s?

> Currently nlmsg_seq is not set in ctnetlink events, if we set it, we can
> do some kind of sequence tracking on netlink. If an event gets lost, we
> can request a resync with the conntrack via dump_conntrack.

nlmsg_seq should only (but in that case it really should) be set for
responses to queries, so userspace can associate responses with queries.
Drops are reported as -ENOBUFS socket errors to all multicast listeners.

> Another choice could be relax conntrackd states transitions, currently
> the valid transition sequence is: NEW -> UPDATE -> DESTROY, if an UPDATE
> event is received but no NEW was seen previously, then the event is
> ignored. Maybe this is too tight, but since I'm validating the whole
> thing I prefer remaining "tight" at the moment.

I guess this could be made configurable, but I think for testing
purposes its better to be stricter so it doesn't shadow real
problems.
