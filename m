From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [ANNOUNCE] Release of nf-HiPAC 0.9.0
Date: Wed, 09 Nov 2005 22:35:52 +0000
Message-ID: <1131575752.3423.33.camel@localhost.localdomain>
References: <200509260441.42483.mbellion@hipac.org>
	<433AA30E.7060709@ufomechanic.net>
	<1128252040.3388.15.camel@localhost.localdomain>
	<200510021430.21697.mbellion@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org,
	Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Michael Bellion <mbellion@hipac.org>
In-Reply-To: <200510021430.21697.mbellion@hipac.org>
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

Op zo, 02-10-2005 te 14:30 +0200, schreef Michael Bellion:
> > Also, is it not possible to make a B+ tree with the standard iptables? I
> > don't see why it shouldn't be possible. The jump to a new chain can be
> > seen as going deeper into the B+ tree. So it should be possible to
> > construct an iptables table structure that looks very similar to the B+
> > tree of nf-hipac, for some given rule set. I guess this will be somewhat
> > slower than nf-hipac, but I'd like to see the performance difference...
> 
> Sorry, but you seem to confuse some things.
> nf-HiPAC is not based on B+trees or any other kind of B-trees. 

So the algorithm of nf-hipac was changed in view of the one you were
using in 2003? I remembered from your talk then that you used B+trees
and this is confirmed by the slides you've finally put online.

cheers,
Bart
