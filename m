From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/5] NETFILTER nfnetlink: Explicitly mark nested nfattr's
Date: Sun, 09 Oct 2005 21:35:18 -0700 (PDT)
Message-ID: <20051009.213518.12525821.davem@davemloft.net>
References: <20051009221503.GC6493@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051009221503.GC6493@rama.customers.eurospot.com>
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
Date: Mon, 10 Oct 2005 00:15:03 +0200

> [NETFILTER] nfnetlink: use highest bit of nfa_type to indicate nested TLV
> 
> As Henrik Nordstrom pointed out, all our efforts with "split endian" (i.e.
> host byte order tags, net byte order values) are useless, unless a parser
> can determine whether an attribute is nested or not.
> 
> This patch steals the highest bit of nfattr.nfa_type to indicate whether
> the data payload contains a nested nfattr (1) or not (0).
> 
> This will break userspace compatibility, but luckily no kernel with
> nfnetlink was released so far.
> 
> Signed-off-by: Harald Welte <laforge@netfilter.org>

Applied, thanks.
