From: Horms <horms@verge.net.au>
Subject: Re: [patch 1/3] add type parameter to ip_route_me_harder
Date: Thu, 21 Sep 2006 18:21:11 +0900
Message-ID: <20060921092109.GH17391@verge.net.au>
References: <20060919024507.458115000@tabatha.lab.ultramonkey.org>
	<20060919025203.458282000@tabatha.lab.ultramonkey.org>
	<45111862.2000900@trash.net> <20060920141732.GA1286@verge.net.au>
	<45116213.8010300@trash.net>
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
In-Reply-To: <45116213.8010300@trash.net>
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

On Wed, Sep 20, 2006 at 05:45:23PM +0200, Patrick McHardy wrote:
> Horms wrote:
> > On Wed, Sep 20, 2006 at 12:30:58PM +0200, Patrick McHardy wrote:
> > 
> >>I liked the RTN_ types better .. is there a reason for not using
> >>them? Otherwise I'll just change it before applying.
> > 
> > 
> > Mainly because it seemed difficult to shoe-horn into the
> > reworking of ipt_REJECT's reverse_route(). In particular,
> > what value should be passed for non-local? auto and local 
> > are of course easy.
> 
> Just explicitly using ip_route_output on the LOCAL_IN/LOCAL_OUT
> hooks (and for the bridging case) should be fine for ipt_REJECT.
> A local source address can not occur in FORWARD, so ip_route_input
> will be chosen through inet_addr_type. So how about:
> 
> RTN_LOCAL: route as locally originating packet
> RTN_UNSPEC: use inet_addr_type to find out
> 
> I think thats also what you did in your first patch.

No problem, I'll resend with the original RTN_LOCAL/RTN_UNSPEC approach.

The main thing that I was trying to avoid was having ipt_REJECT cause a
call to inet_addr_type() in the FORWARD case, though I'm not sure if
performance is a concern or not. If it is, we could always pass some
value other than RTN_LOCAL or RTN_UNSPEC, for instance RTN_UNSPEC, as
its just used as a key to the if statement in ip_route_me_harder(). I
was shying away from that approach as it somewhat overloads the meaning
of RTN_*.

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/
