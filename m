From: Willy Tarreau <willy@w.ods.org>
Subject: Re: NAT for IPv6
Date: Sun, 23 Nov 2003 09:23:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031123082321.GA23141@alpha.home.local>
References: <Pine.LNX.4.44.0311221301120.20371-100000@filer.marasystems.com> <Pine.LNX.4.58.0311230900510.31603@mercury.sdinet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Henrik Nordstrom <hno@marasystems.com>,
   Don Cohen <don-nfil@isis.cs3-inc.com>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sven-Haegar Koch <haegar@sdinet.de>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0311230900510.31603@mercury.sdinet.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Nov 23, 2003 at 09:05:51AM +0100, Sven-Haegar Koch wrote:
> >       -  /128 when it is absolutely known that one and only one device
> >          is connecting.
> 
> "This is a single user home dsl, you may only connect one computer and no
> router - if you want something more, there is our business/professional
> contract, with only 3 times the price" :/ - absolutely normal with most
> cheap enduser-dsl.
> currently there is no problem with this and nat, even if it's not
> officially allowed, it is not enforced - but what then with v6?
> 
> I don't see the big dsl-players to change that anytime soon.

Then change your provider. Mine already offers me a /48 for free with even
the lowest home user contract. If a provider wants to enforce a /128, then
he may also try to detect multiple hosts by analysing TCP sequence numbers.
Right now, providers are clearly aware that many of their customers have
more than one host (father gives the old P3 to the son and buys a new P4),
and they often have no problem with that. What they don't want, is you to
provide access to your neighbour for free. But with all the bandwidth-hungry
people over there, it becomes less common that it once was. Would you share
your SSH entry point with a neighbour interested in P2P ?

Cheers,
Willy
