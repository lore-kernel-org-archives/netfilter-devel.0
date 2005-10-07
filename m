From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] use 32bit counters for connection-based accounting
Date: Fri, 07 Oct 2005 13:26:19 -0700 (PDT)
Message-ID: <20051007.132619.129111295.davem@davemloft.net>
References: <20051007105451.GE4719@rama>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051007105451.GE4719@rama>
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
Date: Fri, 7 Oct 2005 12:54:51 +0200

> I know this is too late for 2.6.14, so do you want me to hold back such
> patches or do you already have a 2.6.15 queue?
> 
> [NETFILTER] Use only 32bit counters for CONNTRACK_ACCT
> 
> Initially we used 64bit counters for conntrack-based accounting, since we
> had no event mechanism to tell userspace that our counters are about to
> overflow.  With nfnetlink_conntrack, we now have such a event mechanism and
> thus can save 16bytes per connection.
> 
> Signed-off-by: Harald Welte <laforge@netfilter.org>

I would like to actually suggest you keep the 64-bit counters.

Is there a truly strong reason to shrink them to be 32-bits?
