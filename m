From: Simon Kirby <sim@netnation.com>
Subject: Re: REJECT using invalid data
Date: Tue, 7 Dec 2004 09:28:23 -0800
Message-ID: <20041207172823.GA31513@netnation.com>
References: <20041207010130.GC4757@netnation.com>
	<41B58EE3.5050709@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <41B58EE3.5050709@eurodev.net>
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

On Tue, Dec 07, 2004 at 12:07:15PM +0100, Pablo Neira wrote:

> not really, my ruleset drops it, actually another rule here is 
> previously logging it.
> 
> -A INPUT -m state --state INVALID -j DROP

That's all fine and dandy, except that we can't use state tracking in our
configuration because of asymmetric routing (which is required due to
BGP).  This is fairly common, and not an incorrect setup.

> > REJECT can be set to reject with a
> >tcp-reset or some ICMP response at this point.  If so, it will actually
> >use the possibly-incorrect information from the bad TCP packet and send a
> >rejection packet.  As far as I can tell, this is a bug.
> 
> yes, that's a bug, but in your ruleset, people should log/drop/let 

No!  It is not a bug in our ruleset, it is a bug in REJECT.

It is incorrect to reply to packet layers that have bad checksums.
REJECT in this case must DROP, because anything else would be broken.

Simon-
