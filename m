From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 09/12]: Fix IP_NF_CONNTRACK_NETLINK dependency
Date: Thu, 06 Apr 2006 14:17:38 -0700 (PDT)
Message-ID: <20060406.141738.92396272.davem@davemloft.net>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
	<20060406100505.17409.24939.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20060406100505.17409.24939.sendpatchset@localhost.localdomain>
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
Date: Thu,  6 Apr 2006 12:05:05 +0200 (MEST)

> [NETFILTER]: Fix IP_NF_CONNTRACK_NETLINK dependency
> 
> When NAT is built as a module, ip_conntrack_netlink can not be linked
> statically.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks.
