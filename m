From: Sven-Haegar Koch <haegar@sdinet.de>
Subject: Re: NAT for IPv6
Date: Sun, 23 Nov 2003 09:05:51 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0311230900510.31603@mercury.sdinet.de>
References: <Pine.LNX.4.44.0311221301120.20371-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Don Cohen <don-nfil@isis.cs3-inc.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0311221301120.20371-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 22 Nov 2003, Henrik Nordstrom wrote:

> On Fri, 21 Nov 2003, Don Cohen wrote:
>
> > I also don't see that IPV6 reduces my need for NAT.
> > For instance, my ISP will probably still give me only one IP address
> > that I'll want to share with my home network.
>
> Not if they follow the recommendations on IPv6 address assignment.
>
> [RFC3177]
> 3. Address Delegation Recommendations
[snip]
>       -  /128 when it is absolutely known that one and only one device
>          is connecting.

"This is a single user home dsl, you may only connect one computer and no
router - if you want something more, there is our business/professional
contract, with only 3 times the price" :/ - absolutely normal with most
cheap enduser-dsl.
currently there is no problem with this and nat, even if it's not
officially allowed, it is not enforced - but what then with v6?

I don't see the big dsl-players to change that anytime soon.

c'ya
sven

-- 

The Internet treats censorship as a routing problem, and routes around it.
(John Gilmore on http://www.cygnus.com/~gnu/)
