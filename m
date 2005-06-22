From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2.6] ipt_CLUSTERIP: fix ARP mangling
Date: Wed, 22 Jun 2005 12:43:41 -0700 (PDT)
Message-ID: <20050622.124341.95064256.davem@davemloft.net>
References: <20050622122902.GI4551@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050622122902.GI4551@obroa-skai.de.gnumonks.org>
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
Date: Wed, 22 Jun 2005 14:29:02 +0200

> Hi Dave, please apply!
> 
> The patch below adds mangling of ARP requests (in addition to replies),
> since ARP caches are made from snooping both requests and replies.
> 
> Signed-off-by: Harald Welte <laforge@netfilter.org>

1) Please use my correct email address, davem@davemloft.net

2) Patch does not apply, because of the patches that went into
   2.6.x yesterday from Patrick McHardy which removed all the
   lockhelp stuff.

Please prepare your patches against current upstream, use GIT if
possible.  This is especially important during times like this where
there are lots of networking patches going in every day to Linus's
tree.  Every patch that doesn't apply cleanly makes lots of extra
work for me.

Thanks.
