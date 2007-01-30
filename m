From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 03/03]: SIP conntrack: fix out of bounds memory
 access
Date: Tue, 30 Jan 2007 14:25:38 -0800 (PST)
Message-ID: <20070130.142538.106265759.davem@davemloft.net>
References: <20070130181625.25041.95438.sendpatchset@localhost.localdomain>
	<20070130181630.25041.87766.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070130181630.25041.87766.sendpatchset@localhost.localdomain>
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
Date: Tue, 30 Jan 2007 19:16:31 +0100 (MET)

> [NETFILTER]: SIP conntrack: fix out of bounds memory access
> 
> When checking for an @-sign in skp_epaddr_len, make sure not to
> run over the packet boundaries.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
