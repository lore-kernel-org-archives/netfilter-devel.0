From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/04]: Netfilter fixes
Date: Tue, 14 Nov 2006 19:49:42 -0800 (PST)
Message-ID: <20061114.194942.18309719.davem@davemloft.net>
References: <20061114070325.13023.10720.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20061114070325.13023.10720.sendpatchset@localhost.localdomain>
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
Date: Tue, 14 Nov 2006 08:03:26 +0100 (MET)

> following a few netfilter fixes for 2.6.19, fixing invalid use of skb_trim
> in netfilter userspace queueing, conflicting optname values for ip6tables
> revision support and another byteorder problem in nfnetlink_log.
> 
> Please apply, thanks.

All applied, thanks a lot Patrick.
