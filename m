From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: Re: [PATCH] info file for ROUTE target
Date: Thu, 9 Dec 2004 16:24:20 -0500
Message-ID: <20041209212420.GD591@ti64.telemetry-investments.com>
References: <1102603380.7528.98.camel@descartes.info.ucl.ac.be>
	<20041209195706.GA4121@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@lists.netfilter.org"
	<netfilter-devel@lists.netfilter.org>,
	Cedric de Launois <delaunois@info.ucl.ac.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20041209195706.GA4121@oknodo.bof.de>
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

On Thu, Dec 09, 2004 at 08:57:07PM +0100, Patrick Schaaf wrote:
> A propos overlooked (hi list at large :) - I made two postings on
> netfilter-devel recently, which were pure bugfixes for ROUTE,
> and nobody seemed to care. Any idea why that was so?
> 
> https://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017485.html
> https://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017514.html

W.r.t. the latter, ip6t_ROUTE.c doesn't build properly as a module, because it
invokes the inline function ndisc_get_neigh(), which in turn depends on the
symbol (un-exported) symbol nd_tbl:

include/net/ndisc.h:113:
static inline struct neighbour * ndisc_get_neigh(struct net_device *dev, struct in6_addr *addr)
{

        if (dev)
                return __neigh_lookup(&nd_tbl, addr, dev, 1);

        return NULL;
}

Presumably ip6t_ROUTE.c requires an out-of-line version of ndisc_get_neigh()
to be exported.

Regards,

	Bill Rugolsky
