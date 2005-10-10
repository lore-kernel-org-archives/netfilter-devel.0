From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/5] NETFILTER: Add missing PPTP dependency
Date: Sun, 09 Oct 2005 21:33:56 -0700 (PDT)
Message-ID: <20051009.213356.58897417.davem@davemloft.net>
References: <20051009221316.GB6493@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051009221316.GB6493@rama.customers.eurospot.com>
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
Date: Mon, 10 Oct 2005 00:13:16 +0200

> [NETFILTER] ipt_ULOG: Mark ipt_ULOG as OBSOLETE
> 
> Similar to nfnetlink_queue and ip_queue, we mark ipt_ULOG as obsolete.
> This should have been part of the original nfnetlink_log merge, but
> I somehow missed it.
> 
> Signed-off-by: Harald Welte <laforge@netfilter.org>

Applied, thanks.
