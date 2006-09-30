From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 3/3] Replace reverse_route() with a call to ip_route_m
 e_harder()
Date: Sat, 30 Sep 2006 18:23:08 +0200
Message-ID: <451E99EC.1050001@trash.net>
References: <36282A1733C57546BE392885C0618592015CF34D@chaos.tcs.tcs-sec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Ken Brownfield <krb@irridia.com>, Roberto Nibali <ratz@drugphish.ch>,
	netfilter-devel@lists.netfilter.org,
	Farid Sarwari <fsarwari@exchangesolutions.com>,
	David Black <dave@jamsoft.com>, Julian Anastasov <ja@ssi.bg>,
	Horms <horms@verge.net.au>, Joseph Mack NA3T <jmack@wm7d.net>,
	David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Venkat Yekkirala <vyekkirala@TrustedCS.com>
In-Reply-To: <36282A1733C57546BE392885C0618592015CF34D@chaos.tcs.tcs-sec.com>
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

Venkat Yekkirala wrote:
>>Venkat, is it correct to place a security_skb_classify_flow
>>call in ip_route_me_harder (which also handles currently
>>unlabeled protocols)?
> 
> 
> This isn't necessary since the xfrm_decode_session invocation
> from within ip_route_me_harder does take care of classifying
> the flow.

Thanks, I missed the call in xfrm_decode_session because I
only looked in xfrm4_policy.c.

Simon, I fixed up the patch slightly and applied it, thanks.
