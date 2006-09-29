From: Venkat Yekkirala <vyekkirala@TrustedCS.com>
Subject: RE: [patch 3/3] Replace reverse_route() with a call to ip_route_m
	e_harder()
Date: Fri, 29 Sep 2006 15:26:32 -0400
Message-ID: <36282A1733C57546BE392885C0618592015CF34D@chaos.tcs.tcs-sec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-15"
Cc: vyekkirala@TrustedCS.com, Ken Brownfield <krb@irridia.com>,
	Roberto Nibali <ratz@drugphish.ch>, netfilter-devel@lists.netfilter.org,
	Farid Sarwari <fsarwari@exchangesolutions.com>,
	Julian Anastasov <ja@ssi.bg>, David Black <dave@jamsoft.com>,
	Joseph Mack NA3T <jmack@wm7d.net>, David Miller <davem@davemloft.net>
To: Patrick McHardy <kaber@trash.net>, Horms <horms@verge.net.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

> With this patch we loose the security_skb_classify_flow call.
> I think it is also needed in ip_route_me_harder, if so your
> patch seems fine (but I get large rejects with the current
> tree, so I'm going to redo it).
> 
> Venkat, is it correct to place a security_skb_classify_flow
> call in ip_route_me_harder (which also handles currently
> unlabeled protocols)?

This isn't necessary since the xfrm_decode_session invocation
from within ip_route_me_harder does take care of classifying
the flow.
