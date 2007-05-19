From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 1/2]: nf_conntrack: fix use-after-free in helper
 destroy callback invocation
Date: Sat, 19 May 2007 14:24:38 -0700 (PDT)
Message-ID: <20070519.142438.75431615.davem@davemloft.net>
References: <464B374D.5000205@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <464B374D.5000205@trash.net>
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
Date: Wed, 16 May 2007 18:54:37 +0200

> These two patches fix an oops when unloading helper modules and
> a incorrect config ifdef.
> 
> Please apply, thanks.

Both applied, thanks a lot Patrick.
