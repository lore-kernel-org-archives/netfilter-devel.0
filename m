From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/02]: Netfilter fixes for 2.6.21
Date: Thu, 22 Mar 2007 12:30:47 -0700 (PDT)
Message-ID: <20070322.123047.88487033.davem@davemloft.net>
References: <20070321052119.6534.84898.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070321052119.6534.84898.sendpatchset@localhost.localdomain>
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
Date: Wed, 21 Mar 2007 06:21:44 +0100 (MET)

> Hi Dave,
> 
> these two patches add a missing Kconfig dependency on NAT for nf_conntrack_netlink
> and fix a problem with ping -I to a destination without a route in combination with
> CONFIG_XFRM.
> 
> Please apply, thanks.

Applied, thanks a lot Patrick.
