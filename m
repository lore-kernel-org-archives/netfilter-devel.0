From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 0/7]: Netfilter update
Date: Tue, 21 Jun 2005 14:04:00 -0700 (PDT)
Message-ID: <20050621.140400.111206313.davem@davemloft.net>
References: <42B74B60.3050402@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <42B74B60.3050402@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 21 Jun 2005 01:04:00 +0200

> here are my pending netfilter patches. The ipt_recent cleanup and
> a couple of new things will follow soon.
> 
>     [NETFILTER]: Kill lockhelp.h
>     [NETFILTER]: Kill nf_debug
>     [NETFILTER]: Restore netfilter assumptions in IPv6 multicast
>     [NETFILTER]: expectation timeouts are compulsory
>     [NETFILTER]: Missing owner-field initialization in ip6table_raw
>     [NETFILTER]: Avoid unncessary checksum validation in UDP connection
> tracking
>     [NETFILTER]: Check TCP checksum in ipt_REJECT

All applied, thanks a lot Patrick.
