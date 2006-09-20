From: Horms <horms@verge.net.au>
Subject: Re: [patch 1/3] add type parameter to ip_route_me_harder
Date: Wed, 20 Sep 2006 23:17:34 +0900
Message-ID: <20060920141732.GA1286@verge.net.au>
References: <20060919024507.458115000@tabatha.lab.ultramonkey.org>
	<20060919025203.458282000@tabatha.lab.ultramonkey.org>
	<45111862.2000900@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ken Brownfield <krb@irridia.com>, Roberto Nibali <ratz@drugphish.ch>,
	netfilter-devel@lists.netfilter.org,
	Farid Sarwari <fsarwari@exchangesolutions.com>,
	Julian Anastasov <ja@ssi.bg>, David Black <dave@jamsoft.com>,
	Joseph Mack NA3T <jmack@wm7d.net>, David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <45111862.2000900@trash.net>
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

On Wed, Sep 20, 2006 at 12:30:58PM +0200, Patrick McHardy wrote:
> Horms wrote:
> > +/*
> > + * addr_type: 0 - determine automatically
> > + *            1 - local
> > + *            2 - non-local
> > + */
> > +
> >  /* route_me_harder function, used by iptable_nat, iptable_mangle + ip_queue */
> > -int ip_route_me_harder(struct sk_buff **pskb)
> > +int ip_route_me_harder(struct sk_buff **pskb, unsigned addr_type)
> 
> I liked the RTN_ types better .. is there a reason for not using
> them? Otherwise I'll just change it before applying.

Mainly because it seemed difficult to shoe-horn into the
reworking of ipt_REJECT's reverse_route(). In particular,
what value should be passed for non-local? auto and local 
are of course easy.

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/
