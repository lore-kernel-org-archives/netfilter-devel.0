From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/03]: Netfilter fixes
Date: Tue, 30 Jan 2007 14:25:49 -0800 (PST)
Message-ID: <20070130.142549.126764949.davem@davemloft.net>
References: <20070130181625.25041.95438.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070130181625.25041.95438.sendpatchset@localhost.localdomain>
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
Date: Tue, 30 Jan 2007 19:16:27 +0100 (MET)

> Hi Dave,
> 
> following are a few more netfilter fixes for 2.6.20, fixing a division
> by zero in the connbytes match (I will pass this one on to -stable as
> well) and two problems with the SIP conntrack helper.
> 
> Please apply, thanks.

I sucked these all in, please push that one to -stable, thanks.
