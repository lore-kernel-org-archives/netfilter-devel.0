From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT, not doing route_me_harder?
Date: Wed, 26 Jun 2002 12:04:23 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206261204.23831.hno@marasystems.com>
References: <20020626084136.GA25908@balabit.hu> <200206261113.16886.hno@marasystems.com> <20020626095557.GB4140@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <20020626095557.GB4140@balabit.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Balazs Scheidler wrote:

> But what happens when you initiate a connection on the host running
> netfilter, thus you have no PREROUTING chain?

You have the OUTPUT chain.

> If I'm doing SNAT in POSTROUTING, the routing decision is not redone, thus
> it leaves with the specified source address, but on the wrong interface.

See my previous reply.

> I think I now understand, have my packets marked in local OUTPUT, route
> based on that mark, and SNAT based on the marks. Is this the way you
> suggested? Hmm.. this sounds reasonable on the programmer's perspective,
> but is difficult to maintain from the user's: it needs two rules.

Yes, it requires three custom rules rather than two (there is also the routing 
policy rule)

Having NAT reroute all packets due to source nat transformations would be a 
significant performance impact only to support the corner cases where it is 
handy..

Regards
Henrik
