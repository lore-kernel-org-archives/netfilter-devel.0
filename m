From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5/5] NETFILTER: fix ctnetlink endian problem
Date: Sun, 09 Oct 2005 21:36:28 -0700 (PDT)
Message-ID: <20051009.213628.10832642.davem@davemloft.net>
References: <20051009221648.GE6493@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051009221648.GE6493@rama.customers.eurospot.com>
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
Date: Mon, 10 Oct 2005 00:16:48 +0200

> [NETFILTER] conntrack_netlink: Fix endian issue with status from userspace
> 
> When we send "status" from userspace, we forget to convert the endianness.
> This patch adds the reqired conversion.  Thanks to Pablo Neira for
> discovering this.
> 
> Signed-off-by: Harald Welte <laforge@netfilter.org>

Applied, thanks.
