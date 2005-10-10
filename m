From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/5] NETFILTER: Add missing PPTP dependency
Date: Sun, 09 Oct 2005 21:33:15 -0700 (PDT)
Message-ID: <20051009.213315.37691147.davem@davemloft.net>
References: <20051009221205.GA6493@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051009221205.GA6493@rama.customers.eurospot.com>
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
Date: Mon, 10 Oct 2005 00:12:05 +0200

> [NETFILTER] PPTP helper: Add missing Kconfig dependency
> 
> PPTP should not be selectable without conntrack enabled
> 
> Signed-off-by: Harald Welte <laforge@netfilter.org>

Applied, thanks.
