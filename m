From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/5] NETFILTER ctnetlink: ICMP ID is not mandatory
Date: Sun, 09 Oct 2005 21:39:47 -0700 (PDT)
Message-ID: <20051009.213947.93823173.davem@davemloft.net>
References: <20051007222157.GM4450@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051007222157.GM4450@rama.customers.eurospot.com>
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
Date: Sat, 8 Oct 2005 00:21:57 +0200

> [NETFILTER] ctnetlink: ICMP ID is not mandatory
> 
> The ID is only required by ICMP type 8 (echo), so it's not
> mandatory for all sort of ICMP connections. This patch makes
> mandatory only the type and the code for ICMP netlink messages.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Harald Welte <laforge@netfilter.org>

Applied for 2.6.14, thanks.
