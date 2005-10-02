From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [ANNOUNCE] Release of nf-HiPAC 0.9.0
Date: Sun, 02 Oct 2005 11:20:40 +0000
Message-ID: <1128252040.3388.15.camel@localhost.localdomain>
References: <200509260441.42483.mbellion@hipac.org>
	<433AA30E.7060709@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Michael Bellion <mbellion@hipac.org>, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <433AA30E.7060709@ufomechanic.net>
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

Op wo, 28-09-2005 te 15:05 +0100, schreef Amin Azez:
> This auto-factorization of rules seems cool.
> 
> > Dynamic rule sets:
> > nf-HiPAC offers fast dynamic rules et updates without stalling packet
> >classification in contrast to iptables which yields bad update performance
> > along with stalled packet processing during updates.
> 
> Does it also remove the "upload rules in bulk" issue of iptables and
> make use of links lists (or trees) to upload small changes singly? I
> recall someone released a re-write a while ago that took care of this,
> but this seems to do rule-factoring too to reduce the number of check
> operations.
> 
> Speaking under fear of blasphemy I'm wondering what stops this becoming
> iptables proper? (ipv4 anyway)?  OK, it would want linking to
> nf_conntrack instead of ip_conntrack and a v6 version doing type stuff,
> but it seems the biz.

http://www.hipac.org/documentation/user_guide.html states some
incompatibilities with iptables.

What's always resisted me from looking to it closely is that there is no
documentation about the implementation. I'm especially interested in how
the code deals with matches. The reason why counters aren't supported
interests me too, I can't see why adding 1 to a 64-bit integer would
result in a noticeable performance drop.
Also, is it not possible to make a B+ tree with the standard iptables? I
don't see why it shouldn't be possible. The jump to a new chain can be
seen as going deeper into the B+ tree. So it should be possible to
construct an iptables table structure that looks very similar to the B+
tree of nf-hipac, for some given rule set. I guess this will be somewhat
slower than nf-hipac, but I'd like to see the performance difference...

cheers,
Bart
