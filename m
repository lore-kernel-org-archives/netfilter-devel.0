From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER]: zap get_cpu()/put_cpu() calls from ip_tables
Date: Sun, 27 Nov 2005 20:44:25 -0800 (PST)
Message-ID: <20051127.204425.74332165.davem@davemloft.net>
References: <4388FAA2.5010708@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <4388FAA2.5010708@trash.net>
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
Date: Sun, 27 Nov 2005 01:15:30 +0100

> This patch fixes the problems with the iptables NUMA optimization.
> It applies to the net-2.6.16 tree.

Applied, thanks everyone.
