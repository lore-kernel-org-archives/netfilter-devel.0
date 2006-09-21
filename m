From: Horms <horms@verge.net.au>
Subject: [patch 0/3] Add addr_type to ip_route_me_harder()
Date: Thu, 21 Sep 2006 18:22:41 +0900
Message-ID: <20060921092241.441882000@tabatha.lab.ultramonkey.org>
References: <20060921092109.GH17391@verge.net.au>
Cc: Ken Brownfield <krb@irridia.com>, Roberto Nibali <ratz@drugphish.ch>,
	Farid Sarwari <fsarwari@exchangesolutions.com>,
	Patrick McHardy <kaber@trash.net>, Julian Anastasov <ja@ssi.bg>,
	David Black <dave@jamsoft.com>, Joseph Mack NA3T <jmack@wm7d.net>,
	David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20060921092109.GH17391@verge.net.au>
To: netfilter-devel@lists.netfilter.org
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

Hi,

this is the latest incarntation of patches to

1. Allow the address type to be passed to ip_route_me_harder(),
   which allows it to be called from locations where this is know,
   but calling ip_route_me_harder() was previously too expensive.

2. Make use of ip_route_me_harder() to honour source routing in IPVS

3. Remove ipt_REJECT's reverse_route(), which is largely a
   duplication of ip_route_me_harder().

IMHO, the first 2 patches are in reasonable shape, but 3rd needs review.

As requested by Patrick McHardy, these patches use the original approach of
using RTN_LOCAL/RTN_UNSPEC as the new argiment to ip_route_me_harder.

This patchest replaces a similar one sent on Tue, 19 Sep 2006 11:45:07 +0900.
Lead Message-Id: <20060919024507.458115000@tabatha.lab.ultramonkey.org>

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/
