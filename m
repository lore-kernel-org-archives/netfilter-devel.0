From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: New draft document on nat / traversal / hole punching (with
	Dan Kegel)
Date: Thu, 11 Nov 2004 15:23:17 +1100
Message-ID: <1100146997.9643.30.camel@localhost.localdomain>
References: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
	<1100024526.6496.10.camel@tux.rsn.bth.se>
	<1100043724.25963.19.camel@localhost.localdomain>
	<20041110162500.GA7485@sunbeam.de.gnumonks.org>
	<1100133056.9643.23.camel@localhost.localdomain>
	<20041110162627.30723691.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	gandalf@wlug.westbo.se, coreteam@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20041110162627.30723691.davem@davemloft.net>
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

On Wed, 2004-11-10 at 16:26 -0800, David S. Miller wrote:
> On Thu, 11 Nov 2004 11:30:56 +1100
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > Ew... Dave, please drop that patch as it was crap.
> > 
> > I merged two patches (a cleanup and the fix) and didn't re-test.
> > 
> > I'll fix, test and re-send.
> 
> Please send something relative, I just pushed your change
> to Linus.

Here it is.  Turns out it's a noop change.

Name: Cleanup find_appropriate_src() Fix
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

The fix to find_appropriate_src left a stupid test, which has no
effect but is incoherent at best.  It covers a corner case: if a
previous connection from this source was mapped onto a different IP
address (because it was explicitly told to), should the next one be
mapped that was as well, if no explicit rule says to remap the src IP?

eg. Admin says "NAT connections with DST 10.* to SRC 10.0.0.1", and a
machine sends out a UDP from SRC=a.b.c.d:p to 10.* (which gets
remapped to SRC=10.0.0.1:p), then sends from the same SRC=a.b.c.d:p to
a non-10.*, should we also map the second one to 10.0.0.1:p?

I think the answer is yes: unless the user explicitly tells us to map
into a particular range, we should follow the Kegel draft.

--- working-2.6.10-rc1-bk19-fix-source-matching/net/ipv4/netfilter/ip_nat_core.c.~1~	2004-11-11 12:17:30.000000000 +1100
+++ working-2.6.10-rc1-bk19-fix-source-matching/net/ipv4/netfilter/ip_nat_core.c	2004-11-11 12:27:16.000000000 +1100
@@ -128,16 +128,13 @@
 	unsigned int i;
 
 	for (i = 0; i < mr->rangesize; i++) {
-		/* If we are allowed to map IPs, then we must be in the
-		   range specified, otherwise we must be unchanged. */
+		/* If we are supposed to map IPs, then we must be in the
+		   range specified. */
 		if (mr->range[i].flags & IP_NAT_RANGE_MAP_IPS) {
 			if (ntohl(tuple->src.ip) < ntohl(mr->range[i].min_ip)
 			    || (ntohl(tuple->src.ip)
 				> ntohl(mr->range[i].max_ip)))
 				continue;
-		} else {
-			if (tuple->src.ip != tuple->src.ip)
-				continue;
 		}
 
 		if (!(mr->range[i].flags & IP_NAT_RANGE_PROTO_SPECIFIED)

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
