From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 01/03]: xt_connbytes: fix division by zero
Date: Tue, 30 Jan 2007 14:24:37 -0800 (PST)
Message-ID: <20070130.142437.45515562.davem@davemloft.net>
References: <20070130181625.25041.95438.sendpatchset@localhost.localdomain>
	<20070130181627.25041.43611.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070130181627.25041.43611.sendpatchset@localhost.localdomain>
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
Date: Tue, 30 Jan 2007 19:16:28 +0100 (MET)

> [NETFILTER]: xt_connbytes: fix division by zero
> 
> When the packet counter of a connection is zero a division by zero
> occurs in div64_64(). Fix that by using zero as average value, which
> is correct as long as the packet counter didn't overflow, at which
> point we have lost anyway.
> 
> Additionally we're probably going to go back to 64 bit counters
> in 2.6.21.
> 
> Based on patch from Jonas Berlin <xkr47@outerspace.dyndns.org>,
> with suggestions from KOVACS Krisztian <hidden@balabit.hu>.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
