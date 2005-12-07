From: Herve Eychenne <rv@wallfire.org>
Subject: Re: (D)NAT with IPv6 (was "nf_conntrack & NAT")
Date: Wed, 7 Dec 2005 15:54:38 +0100
Message-ID: <20051207145438.GA5617@eychenne.org>
References: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>
	<200511231225.jANCPmYd015427@toshiba.co.jp>
	<20051123132044.GZ3249@eychenne.org>
	<20051123132419.GJ24091@fi.muni.cz>
	<20051206154320.GG4038@rama.exocore.com>
	<20051206173135.GQ5617@eychenne.org>
	<Pine.LNX.4.58.0512071201460.17863@blackhole.kfki.hu>
Reply-To: rv@wallfire.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Harald Welte <laforge@netfilter.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0512071201460.17863@blackhole.kfki.hu>
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

On Wed, Dec 07, 2005 at 12:22:22PM +0100, Jozsef Kadlecsik wrote:

> On Tue, 6 Dec 2005, Herve Eychenne wrote:

> > On Tue, Dec 06, 2005 at 09:13:21PM +0530, Harald Welte wrote:
> >
> > > for stuff like redirecting traffic, all you really need is stateless
> > > rewriting of the destination address.  If people want that, the entire
> > > implementation fits in a single ip6tables target.  no relation to
> > > nf_conntrack at all.
> >
> > Stateless?  And what if you want the response (of the packets which have
> > been redirected) to come back with their initial address, as if they
> > had not been redirected? (if the client shouldn't know that, if this
> > should be transparent to him)
> > This is also known as DNAT, for which the state has be stored, right?
> >
> > So, in one word: if we definitely need DNAT with IPv4 today, why
> > wouldn't we need DNAT with IPv6?

> IPv6 is not just IPv4 with a larger address space. Definitely there is no
> need for DNAT in order to make a server with private address available.
> But I can imagine for example to replace the "need" for DNAT with anycast
> in IPv6 for load balancing.

I don't want to use DNAT for load balancing.  I want to use DNAT (and
I'm using it just now with IPv4) to redirect traffic destined to a
certain IP/port to another IP (private or not) in the most transparent
way. There are plenty of scenari where I'm willing to do that.



For those who need practical examples (others can stop here) that I'm
regularly facing myself, here it is.

Then MX of domain points on host A, and I want to redirect SMTP traffic
to host B (also in my network) in the most atomic way.
DNS propagation can be slow (caching), and user proxying is too slow
(and not transparent).
If there are miraculous mecanisms in IPv6 which enable to achieve that
redirection as atomically and quickly that DNAT, please let me know.

And that's only one example.
Another? Ok... ;-)

Lets say I have a DNS entry that points to a certain IP address. But
I have a problem (configuration, whatever) with http server on this host,
and I want the web traffic destined to this IP on port 80/tcp (but not
other services!) to be handled by a given server (IP2), which already
handles several virtualhosts.
So I use:  -d IP1 -p tcp --dport 80 -j DNAT --to IP2:80

And on top of that, imagine that it is not convenient (configuration
issues, server not powerful enough, restrictive SSL certificate, whatever)
to handle https traffic in this host (IP2) as well...
So I would redirect https traffice on server 3 (IP3) instead:
-d IP1 -p tcp --dport 443 -j DNAT --to IP3:443

Once everything is OK, I can probably change DNS entries accordingly and
certainly get rid of some DNAT rules... (even if I don't see well how I
could transparently handle HTTP traffic on one server, and HTTPS on
another, anyway...)
But the DNAT rule are definitely useful in the meantime, unless I'm
showed something that would achieve exactly the same in a more IPv6 way...

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
