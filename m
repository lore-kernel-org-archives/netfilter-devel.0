From: "David S. Miller" <davem@davemloft.net>
Subject: Re: MASQUERADE + DHCP problem
Date: Sun, 11 Sep 2005 20:07:26 -0700 (PDT)
Message-ID: <20050911.200726.41147288.davem@davemloft.net>
References: <43244826.5020405@trash.net>
	<1126481675.9832.3.camel@localhost.localdomain>
	<4324C462.9040804@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, rusty@rustcorp.com.au,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <4324C462.9040804@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 12 Sep 2005 01:57:22 +0200

> Rusty Russell wrote:
> > If IP src is 0.0.0.0, let it through untouched.  Those packets are
> > presumably not supposed to be masqueraded, so it's the Right Think
> > AFAICT.
> > 
> > Will that fix DHCP?
> 
> Absolutely. Since these packets never get routed, the only possibility
> when they can occur is when a local raw socket with IP_HDRINCL chooses
> a source address of 0. In that case it definitely seems right to leave
> the packet alone.

That's a really great idea Rusty.

Patrick, I think this needs to go into -stable as well,
once you have a patch ready, right?
