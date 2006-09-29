From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 2/3] Honour source routing for LVS-NAT
Date: Fri, 29 Sep 2006 15:38:28 +0200
Message-ID: <451D21D4.10503@trash.net>
References: <20060921092241.441882000@tabatha.lab.ultramonkey.org>
	<20060921093021.418727000@tabatha.lab.ultramonkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Ken Brownfield <krb@irridia.com>, Roberto Nibali <ratz@drugphish.ch>,
	netfilter-devel@lists.netfilter.org,
	Farid Sarwari <fsarwari@exchangesolutions.com>,
	Julian Anastasov <ja@ssi.bg>, David Black <dave@jamsoft.com>,
	Joseph Mack NA3T <jmack@wm7d.net>, David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Horms <horms@verge.net.au>
In-Reply-To: <20060921093021.418727000@tabatha.lab.ultramonkey.org>
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

Horms wrote:
> For policy routing, packets originating from this machine itself may be
> routed differently to packets passing through. We want this packet to be
> routed as if it came from this machine itself. So re-compute the routing
> information using ip_route_me_harder().

Thanks, I've applied the first two patches.
