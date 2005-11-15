From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC PATCH] ctnetlink port to nf_conntrack take #1
Date: Tue, 15 Nov 2005 18:21:17 +0900 (JST)
Message-ID: <200511150921.jAF9LIRE011590@toshiba.co.jp>
References: <200511141622.jAEGMAXf015099@toshiba.co.jp>
	<20051114171015.GI4773@sunbeam.de.gnumonks.org>
	<4378E24C.7060307@eurodev.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
In-Reply-To: <4378E24C.7060307@eurodev.net>
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

From: Pablo Neira <pablo@eurodev.net>
Date: Mon, 14 Nov 2005 20:15:24 +0100

> Harald Welte wrote:
> > On Tue, Nov 15, 2005 at 01:22:09AM +0900, Yasuyuki KOZAKAI wrote:
> > 
> > 
> >>I think we can generalize layer 3 protocol handling more, by introducing
> >>nfattr_to_tuple/tuple_to_nfattr to l3proto modules like proto.
> > 
> > I agree.
> 
> Fine with it. I expect to send a new patch before the weekend.
> 
> >>And it would be great if {ip,nf}_conntrack_netlink.c can be unified.
> >>But currently I don't have good idea to do that in clear way, and without
> >>extensibility limitation of nf_conntrack_netlink. I'll think about this more.
> >>How do you think ?
> > 
> > I don't think it's really worth the effort.  we already have two
> > instances of connection tracking code.  
> > 
> > ip_conntrack will go sooner or later, so we should rather spend time on
> > important features such as userspace conntrack helpers and NAT for
> > nf_conntrack
> 
> Same feeling.

OK, let's go ahead.

-- Yasuyuki Kozakai
