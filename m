From: Simon Kirby <sim@netnation.com>
Subject: Re: REJECT using invalid data
Date: Fri, 10 Dec 2004 05:10:50 -0800
Message-ID: <20041210131050.GB9398@netnation.com>
References: <Pine.LNX.4.53.0412072347080.2736@bizon.gios.gov.pl>
	<41B642A1.9030807@eurodev.net>
	<20041208005216.GA7958@netnation.com>
	<Pine.LNX.4.53.0412101310210.1288@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <ole@ans.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.53.0412101310210.1288@bizon.gios.gov.pl>
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

On Fri, Dec 10, 2004 at 01:29:30PM +0100, Krzysztof Oledzki wrote:

> > I don't think it's a good idea to try to filter all TCP flags in REJECT
> > unless we're trying to avoid rejecting rejects and we don't already do
> > that for some reason (eep), for the same reason that unclean was removed
> > (ECN and other new functionality could break).  I would think that all
> > that is needed is a check for the RST bit.
> >
> > At the same time, it would be nice to have a match (or at least some
> > functionality) resulting in the ability to drop corrupted packets
> > ("corrupted" as in with the checksum) that would otherwise be accepted.
> >
> > Hmm.  Maybe this should be done at a different level?  It should
> > basically not match "-p tcp" in the rule "iptables -p tcp -j REJECT".
> > Doing it at "-p tcp" time would also correct "iptables -p tcp --dport 80
> > -j ACCEPT", which would otherwise also be affected by the same problem
> > (the TCP port could be corrupted).
> 
> No. We simply can't do that. Please consider such config:
> iptables -A INPUT -p tcp -j ACCEPT
> iptables -A INPUT -j REJECT

Yes, what's the problem?

If the TCP checksum is fine, "-p tcp" will match and it will accept the
packet.  If it is corrupted, "-p tcp" will not match and the ACCEPT rule
will not match.  The REJECT rule will then DROP the packet.  There is
nothing wrong with this.

The only difference here is the use of "-p tcp" alone to literally match
the protocol in the IP header (under the IP checksum) versus the use of
"-p tcp" to enable inspection of the TCP header.

For example, if this rule were to match a packet with a bad TCP checksum,
it would be broken (because the port could be corrupted):

	iptables -A INPUT -p tcp --dport 80 -j ACCEPT

On the other hand, it would not be broken to match in this case:

	iptables -A INPUT -p tcp -j ACCEPT

...which may be what you are getting at.  Fixing this requires a syntax
or design change, most likely.

> I thing we really need somethig like "-m malformed" so we can do tricks
> like: iptables -A FORWARD -m malformed -j DROP (to drop malformed packets)
> or: iptables -A FORWARD -m malformed -j ACCEPT (to stop further processing such packets)

Sure, adding the a corrupted test is useful for things such as logging,
etc.  However, requiring the firewall user to check for corruption
explicitly before any "-p tcp --tcp-blah" rules is just going to make
the iptables learning curve even higher, and 99% of us are going to miss
it.  Simply, I think it's broken.

So, how does the code structure of iptables work in this case?  Can the
checksum be added in a single place such that "-p tcp" alone will match
but any of --dport, --sport, --syn, --tcp-flags, --tcp-option, --mss,
multiport, etc?

Simon-
