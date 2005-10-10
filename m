From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] don't use __be16 in files used by userspace
Date: Sun, 09 Oct 2005 21:47:11 -0700 (PDT)
Message-ID: <20051009.214711.108291006.davem@davemloft.net>
References: <20051007103105.GF4719@rama>
	<20051007.132456.19624093.davem@davemloft.net>
	<20051007221500.GK4450@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051007221500.GK4450@rama.customers.eurospot.com>
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
Date: Sat, 8 Oct 2005 00:15:00 +0200

> [NETFILTER] Add missing include to ip_conntrack_tuple.h
> 
> Without this #include, __be16 is not defined and userspace programs
> will break.
> 
> Signed-off-by: Harald Welte <laforge@netfilter.org>

Now that looks a lot better, applied.

Thanks!
