From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/04]: Netfilter fixes
Date: Mon, 27 Nov 2006 10:27:07 -0800 (PST)
Message-ID: <20061127.102707.18302022.davem@davemloft.net>
References: <20061127182053.17688.57354.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20061127182053.17688.57354.sendpatchset@localhost.localdomain>
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
Date: Mon, 27 Nov 2006 19:20:53 +0100 (MET)

> following are a few small netfilter fixes for 2.6.19, fixing multiple
> refcount leaks and a nf_conntrack helper assignment race which can
> lead to use-after-free.
> 
> Please apply, thanks.

Applied, thanks a lot Patrick.
