From: Phil Oester <kernel@linuxace.com>
Subject: Re: xt_gateway 20070605 (kernel)
Date: Tue, 5 Jun 2007 15:24:20 -0700
Message-ID: <20070605222420.GA7144@linuxace.com>
References: <Pine.LNX.4.61.0706051317150.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706051317440.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0706051317440.20829@yvahk01.tjqt.qr>
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

On Tue, Jun 05, 2007 at 01:17:57PM +0200, Jan Engelhardt wrote:
> 
> Originally from Amin Azez <azez@ufomechanic.net>,
> http://lists.netfilter.org/pipermail/netfilter-devel/2007-June/027954.html
> 
> This adds a gateway match to iptables that lets you match against the
> routed ipv4 gateway, it's very useful for SNAT if you want to avoid
> replicating your routing in your SNAT table.

Just a suggestion...for a while I've been needing the ability to match
on the routing table (but not just the gateway).  Could we perhaps name
this match 'route' instead (similar to the ROUTE target)?

Some of the things I'd like to be able to do is match on the length
of a route.  For instance we use lots of 10.x.x.x/30 nets internally
and I'd like to be able to match on them.  I haven't quite gotten around
to figuring out how to do this given the route cache doesn't include
prefix length, but I do think it would be useful.  I could see how
it could be combined with this gateway match.

Thoughts?

Phil
