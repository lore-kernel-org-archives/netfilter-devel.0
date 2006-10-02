From: Horms <horms@verge.net.au>
Subject: Re: [patch 2/3] Honour source routing for LVS-NAT
Date: Mon, 2 Oct 2006 10:57:38 +0900
Message-ID: <20061002015737.GG2180@verge.net.au>
References: <20060921092241.441882000@tabatha.lab.ultramonkey.org>
	<20060921093021.418727000@tabatha.lab.ultramonkey.org>
	<451D21D4.10503@trash.net>
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
In-Reply-To: <451D21D4.10503@trash.net>
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

On Fri, Sep 29, 2006 at 03:38:28PM +0200, Patrick McHardy wrote:
> Horms wrote:
> > For policy routing, packets originating from this machine itself may be
> > routed differently to packets passing through. We want this packet to be
> > routed as if it came from this machine itself. So re-compute the routing
> > information using ip_route_me_harder().
> 
> Thanks, I've applied the first two patches.

Thanks. To which tree did you apply them?

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/
