From: Herve Eychenne <rv@wallfire.org>
Subject: Re: nf_conntrack & NAT
Date: Tue, 6 Dec 2005 18:31:35 +0100
Message-ID: <20051206173135.GQ5617@eychenne.org>
References: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>
	<200511231225.jANCPmYd015427@toshiba.co.jp>
	<20051123132044.GZ3249@eychenne.org>
	<20051123132419.GJ24091@fi.muni.cz>
	<20051206154320.GG4038@rama.exocore.com>
Reply-To: rv@wallfire.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Jan Kasprzak <kas@fi.muni.cz>,
	netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <20051206154320.GG4038@rama.exocore.com>
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

On Tue, Dec 06, 2005 at 09:13:21PM +0530, Harald Welte wrote:

> On Wed, Nov 23, 2005 at 02:24:19PM +0100, Jan Kasprzak wrote:

> > : > > support for IPv6?

> > : > Never ever. You can learn why people don't want to do it from many sources.
> > : > For example, You can use many addresses in IPv6 world. And I don't want people
> > : > get troubles due to NAT traversal issues in IPv6 world.

> > : And what if you want your firewall to transparently redirect some traffic
> > : to another host, for example?

> > 	... or IPVS-based clusters. NAT functionality is definitely
> > wanted (even though full NAT in the IPv6 world is evil :-).

> guys, we have to differentiate here.

> I often stated "nf_conntrack based ipv6 nat only over my dead body".
> This refers to something similar to the current IPv4 NAT code as a
> stateful, fully symmetric, port overloading NAPT attached to the
> connection tracking code.

> for stuff like redirecting traffic, all you really need is stateless
> rewriting of the destination address.  If people want that, the entire
> implementation fits in a single ip6tables target.  no relation to
> nf_conntrack at all.

Stateless?  And what if you want the response (of the packets which have
been redirected) to come back with their initial address, as if they
had not been redirected? (if the client shouldn't know that, if this
should be transparent to him)
This is also known as DNAT, for which the state has be stored, right?

So, in one word: if we definitely need DNAT with IPv4 today, why
wouldn't we need DNAT with IPv6?

> also, IPVS doesn't need any ip_conntrack/iptable_nat today,

I don't know IPVS implementation, but maybe the IPVS-NAT method could
theorically share some code with the current NAT code... (they both
seem to handle the same kind of state table, even if at least the hashing
algorithm could probably be different, I guess)

> why would it need that for ipv6?

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
