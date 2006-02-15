From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 05/05]: nf_conntrack: Fix TCP/UDP HW checksum
 handling for IPv6 packet
Date: Wed, 15 Feb 2006 15:25:35 -0800 (PST)
Message-ID: <20060215.152535.27079613.davem@davemloft.net>
References: <20060215230026.25078.33875.sendpatchset@localhost.localdomain>
	<20060215230033.25078.39539.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20060215230033.25078.39539.sendpatchset@localhost.localdomain>
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
Date: Thu, 16 Feb 2006 00:00:33 +0100 (MET)

> [NETFILTER]: nf_conntrack: Fix TCP/UDP HW checksum handling for IPv6 packet
> 
> If skb->ip_summed is CHECKSUM_HW here, skb->csum includes checksum
> of actual IPv6 header and extension headers. Then such excess
> checksum must be subtruct when nf_conntrack calculates TCP/UDP checksum
> with pseudo IPv6 header. Spotted by Ben Skeggs.
> 
> Signeded-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> Signeded-off-by: Patrick McHardy <kaber@trash.net>

Goot catch.

Applied, thanks.
