From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/5] NETFILTER ctnetlink: add one nesting level for TCP
Date: Sun, 09 Oct 2005 21:47:56 -0700 (PDT)
Message-ID: <20051009.214756.102990378.davem@davemloft.net>
References: <20051007222456.GN4450@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051007222456.GN4450@rama.customers.eurospot.com>
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

From: Harald Welte <laforge@netfilter.org>
Date: Sat, 8 Oct 2005 00:24:56 +0200

> [NETFILTER] ctnetlink: add one nesting level for TCP state
> 
> To keep consistency, the TCP private protocol information is nested
> attributes under CTA_PROTOINFO_TCP. This way the sequence of attributes to
> access the TCP state information looks like here below:
> 
> CTA_PROTOINFO
> CTA_PROTOINFO_TCP
> CTA_PROTOINFO_TCP_STATE
> 
> instead of:
> 
> CTA_PROTOINFO
> CTA_PROTOINFO_TCP_STATE
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Harald Welte <laforge@netfilter.org>

Applied for 2.6.14, thanks.
