From: Horms <horms@verge.net.au>
Subject: Re: [patch 3/3] Replace reverse_route() with a call to ip_route_m
	e_harder()
Date: Sun, 1 Oct 2006 11:42:01 +0900
Message-ID: <20061001024201.GB4975@verge.net.au>
References: <36282A1733C57546BE392885C0618592015CF34D@chaos.tcs.tcs-sec.com>
	<451E99EC.1050001@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Ken Brownfield <krb@irridia.com>,
	Roberto Nibali <ratz@drugphish.ch>,
	Venkat Yekkirala <vyekkirala@TrustedCS.com>,
	Farid Sarwari <fsarwari@exchangesolutions.com>,
	Julian Anastasov <ja@ssi.bg>, David Black <dave@jamsoft.com>,
	Joseph Mack NA3T <jmack@wm7d.net>, David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <451E99EC.1050001@trash.net>
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

On Sat, Sep 30, 2006 at 06:23:08PM +0200, Patrick McHardy wrote:
> Venkat Yekkirala wrote:
> >>Venkat, is it correct to place a security_skb_classify_flow
> >>call in ip_route_me_harder (which also handles currently
> >>unlabeled protocols)?
> > 
> > 
> > This isn't necessary since the xfrm_decode_session invocation
> > from within ip_route_me_harder does take care of classifying
> > the flow.
> 
> Thanks, I missed the call in xfrm_decode_session because I
> only looked in xfrm4_policy.c.
> 
> Simon, I fixed up the patch slightly and applied it, thanks.

Thanks, I really was a bit unsure about this patch.

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/
