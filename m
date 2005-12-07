From: Herve Eychenne <rv@wallfire.org>
Subject: Re: (D)NAT with IPv6 (was "nf_conntrack & NAT")
Date: Wed, 7 Dec 2005 13:02:23 +0100
Message-ID: <20051207120222.GX5617@eychenne.org>
References: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>
	<200511231225.jANCPmYd015427@toshiba.co.jp>
	<20051123132044.GZ3249@eychenne.org>
	<20051123132419.GJ24091@fi.muni.cz>
	<20051206154320.GG4038@rama.exocore.com>
	<20051206173135.GQ5617@eychenne.org>
	<20051207070517.GA4361@rama.exocore.com>
Reply-To: rv@wallfire.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20051207070517.GA4361@rama.exocore.com>
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

On Wed, Dec 07, 2005 at 12:35:17PM +0530, Harald Welte wrote:

> On Tue, Dec 06, 2005 at 06:31:35PM +0100, Herve Eychenne wrote:
> > > for stuff like redirecting traffic, all you really need is stateless
> > > rewriting of the destination address.  If people want that, the entire
> > > implementation fits in a single ip6tables target.  no relation to
> > > nf_conntrack at all.
> > 
> > Stateless?  And what if you want the response (of the packets which have
> > been redirected) to come back with their initial address, as if they
> > had not been redirected? (if the client shouldn't know that, if this
> > should be transparent to him)

> then you need a static snat target that does this for all reply packets.

Ok, let's say that some packets originally destined to host A are
redirected to host B (dst addr changed).
Of course, regular packets coming from B should not have their
src addr systematically changed to A...
So how do you know that some packets coming back from host B are part of
a connection that was originally destined to host A (their src addr
should be changed to A again for transparency) without storing state?

> > This is also known as DNAT, for which the state has be stored, right?

> you don't really need state unless you want to do stuff like dynamically
> changing port numbers, etc.

Or dst addresses, yes.  And that's what is needed here.

> > So, in one word: if we definitely need DNAT with IPv4 today, why
> > wouldn't we need DNAT with IPv6?

> stateful IPv6 NAT only over my dead body.  Do you know that NAT is the
> single most destructive way that ever happened to todays internet?  That
> it is the number one reason why VoIP doesn't really take off as much as
> it could?  The number one reason for various non-deterministic breakage
> all over the place? 

I know all of this.

> I've participated in the IETF BEHAVE group discussions, and there was
> concensus that any BEHAVE compliant NAT must not do NAT for ipv6.

I understand that core network developpers have been bitten more than once
by NAT issues, and that they've become so allergic to it that the
evocation of this simple word can make them cry at night.

But even if massive use of NAT should definitely be considered
harmful and should not be encouraged, some uses of NAT/PAT can still be
considered legitimate even with IPv6 as some specific technical needs are
still there.
Like a french expression says, I just think we should not throw the baby
with the (unclean) water of his bath.

Anyway, until IPv6 is widely used elsewhere than in Asia, there is no
real hurry for retarded occidentals like us. ;-)

> > > also, IPVS doesn't need any ip_conntrack/iptable_nat today,
> > 
> > I don't know IPVS implementation, but maybe the IPVS-NAT method could
> > theorically share some code with the current NAT code... (they both
> > seem to handle the same kind of state table, even if at least the hashing
> > algorithm could probably be different, I guess)

> *sigh*.  IPVS doesn't use ip_conntrack,

I was only saying that maybe it could have, from a technical point of
view (I always praise code factorization).  I was not particularly
encouraging it here though.

> so they won't be using nf_conntrack. Also, it's their project and their decision.

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
