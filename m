From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/5] NETFILTER ctnetlink: use ENOMEM instead of -1
Date: Sun, 09 Oct 2005 21:39:05 -0700 (PDT)
Message-ID: <20051009.213905.47127482.davem@davemloft.net>
References: <20051007221948.GL4450@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@gnumonks.org
In-Reply-To: <20051007221948.GL4450@rama.customers.eurospot.com>
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

From: Harald Welte <laforge@gnumonks.org>
Date: Sat, 8 Oct 2005 00:19:48 +0200

> [NETFILTER] ctnetlink: use ENOMEM instead of -1 (-ENOPERM)
> 
> Fix the return value of NFA_PUT on fail. Now it returns -ENOMEM
> instead of -1 (-ENOPERM) since NFA_PUT only fails if there's no
> enough space in the netlink message for the new attribute that
> will be added. Thanks to Patrick McHardy for spotting this.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Harald Welte <laforge@netfilter.org>

Applied for 2.6.14, thanks.
