From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 05/08]: Lower *tables printk severity
Date: Sat, 14 Jul 2007 20:46:41 -0700 (PDT)
Message-ID: <20070714.204641.18290232.davem@davemloft.net>
References: <20070714151150.9829.47674.sendpatchset@localhost.localdomain>
	<20070714151156.9829.4970.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070714151156.9829.4970.sendpatchset@localhost.localdomain>
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
Date: Sat, 14 Jul 2007 17:12:40 +0200 (MEST)

> [NETFILTER]: Lower *tables printk severity
> 
> Lower ip6tables, arptables and ebtables printk severity similar to
> Dan Aloni's patch for iptables.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.

There are probably other missing KERN_* cases scattered
around the rest of netfilter.
