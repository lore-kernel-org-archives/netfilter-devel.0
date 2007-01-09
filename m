From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/04]: Netfilter fixes
Date: Tue, 09 Jan 2007 14:35:04 -0800 (PST)
Message-ID: <20070109.143504.130236764.davem@davemloft.net>
References: <20070109162952.6229.79602.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20070109162952.6229.79602.sendpatchset@localhost.localdomain>
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
Date: Tue,  9 Jan 2007 17:29:52 +0100 (MET)

> Hi Dave,
> 
> following are a few more netfilter fixes for 2.6.20, fixing a
> nf_conntrack_ipv6 crash when dealing with fragments, hanging
> connections when loading the nf_nat module, an incorrect value
> for a TCP connection tracking flag and compilation of arp_tables
> userspace. I'll also pass on the relevant ones to -stable.
> 
> Please apply, thanks.

It all looks good, applied, thanks Patrick.
