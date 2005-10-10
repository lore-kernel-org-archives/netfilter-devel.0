From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4/5] NETFILTER: remove bogus structure member
Date: Sun, 09 Oct 2005 21:35:56 -0700 (PDT)
Message-ID: <20051009.213556.78791538.davem@davemloft.net>
References: <20051009221546.GD6493@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051009221546.GD6493@rama.customers.eurospot.com>
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
Date: Mon, 10 Oct 2005 00:15:46 +0200

> [NETFILTER] nat: remove bogus structure member
> 
> When 'rustynat' was merged in 2.6.12, the use of the "helper" pointer of
> struct ipt_nat_info was obsoleted, but the pointer not removed from the
> struct.
> 
> This patch removes the pointer, thereby yet again shrinking struct
> ip_conntrack.
> 
> Discovered-by: Rusty Russell <rusty@netfilter.org>
> Signed-off-by: Harald Welte <laforge@netfilter.org>

Applied, thanks.
