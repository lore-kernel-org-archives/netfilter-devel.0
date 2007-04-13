From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/06]: Netfilter update
Date: Thu, 12 Apr 2007 22:17:36 -0700 (PDT)
Message-ID: <20070412.221736.25921681.davem@davemloft.net>
References: <20070413025923.29875.68909.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070413025923.29875.68909.sendpatchset@localhost.localdomain>
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
Date: Fri, 13 Apr 2007 05:00:08 +0200 (MEST)

> Hi Dave,
> 
> following are a few netfilter patches for 2.6.22, adding support for filtering
> encapsulated PPPoE and gratuitous ARP packets in bridge netfilter, compat
> support for ipt_ULOG (as mentioned in the other thread, 32 bit userspace can
> already deal with log messages sent by a 64 bit kernel, but the kernel
> currently does not support adding new rules from a 32 bit iptables binary),
> some misc netfilter logging cleanup and support for using HW checksumming
> for forwarded packets mangled by NAT helpers.
> 
> Please apply, thanks.

All looks good, applied, thanks Patrick.
