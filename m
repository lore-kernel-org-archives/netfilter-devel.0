From: Josh Samuelson <josamue1@wsc.edu>
Subject: Re: [PATCH 1/2] flow match
Date: Wed, 29 Jun 2005 21:53:29 -0500
Message-ID: <20050630025329.GA27106@wsc.edu>
References: <20050628234912.GB23662@wsc.edu> <42C2F409.4040509@eurodev.net>
	<42C34524.1010304@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42C34524.1010304@trash.net>
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

On Thu, Jun 30, 2005 at 03:04:36AM +0200, Patrick McHardy wrote:
> Pablo Neira wrote:
> > This stuff clearly supersedes `connlimit' that is a bit raw and very
> > "limited".
> > 
> > @Patrick: Do you agree to add this to pom-ng?
> 
> There's lots of weird stuff in there, so basically, I don't care much.
> It looks nice and clean, but quite complex for something I don't even
> know what it is useful for. Josh, do you have any practical examples
> where it is useful?
> 
> Regards
> Patrick

Hi Patrick,

Yes, we have been using it as a metric for acceptable use on our
dorm network.  When a machine exceeds some threshold for our rule
base, we use my TIMER target to add the machine's MAC address to
a table.  If a machine's MAC address is found in the TIMER table,
it will be marked.  All established connections for the machine
are unaffected.  However, the new connections coming from the
machine are denied, unless they are destined for port 80, which
we DNAT to an internal web server with instructions (acceptable use
policy) and utilities for checking if the machine has a virus or
spyware.  Once the timer runs out, things are back to normal for
the machine.  If the machine continues to pound the network and therefore
break our acceptable use policy, the TIMER just gets refreshed from
the flow match.  So yes, by itself, it just gives you the ability to
match against the number of new or established connections per source
or destination IP address.  Oh yeah, also subnets, but I haven't
tested that functionality much yet in a real world situation.
We've had good results with this setup.

Another use would be where you have a box that mainly does routing
with another that mainly does firewalling.  As rogue scanning packets
flow through the router, they will be dropped by the next hop firewall.
With the flow module, these dropped packets will appear to be
new connections to the router.  Once the new count goes beyond a
reasonable level, the source IP address is added to a TIMER target.
If the router matches source IP addresses against that TIMER target,
drop them at the router.  This will allow for automated thwarting of service
scanning, lasting however long the TIMER table is configured for.
I haven't tried this yet but it seems plausible.

I'm not trying to plug the TIMER target/match, it just makes
the flow and other matches more useful in certain transient situations. :)

I would love to answer any questions you may have to the "weird stuff"
I've got in there.  :)  Please be patient for responses though because
tomorrow morning I'm off on a big hiking trip and will be well away
from my email.

Cheers,
Josh
