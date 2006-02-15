From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 04/05]: nf_conntrack: attach conntrack to locally
 generated ICMPv6 error
Date: Wed, 15 Feb 2006 15:24:27 -0800 (PST)
Message-ID: <20060215.152427.133308755.davem@davemloft.net>
References: <20060215230026.25078.33875.sendpatchset@localhost.localdomain>
	<20060215230032.25078.64555.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20060215230032.25078.64555.sendpatchset@localhost.localdomain>
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
Date: Thu, 16 Feb 2006 00:00:32 +0100 (MET)

> [NETFILTER]: nf_conntrack: attach conntrack to locally generated ICMPv6 error
> 
> Locally generated ICMPv6 errors should be associated with the conntrack
> of the original packet. Since the conntrack entry may not be in the hash
> tables (for the first packet), it must be manually attached.
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks.
