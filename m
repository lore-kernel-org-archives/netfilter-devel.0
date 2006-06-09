From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 2.6.18 1/3]: recent match: fix "sleeping function
 called from invalid context"
Date: Fri, 09 Jun 2006 12:19:09 -0700 (PDT)
Message-ID: <20060609.121909.55725285.davem@davemloft.net>
References: <4487CDBD.2070400@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <4487CDBD.2070400@trash.net>
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
Date: Thu, 08 Jun 2006 09:11:57 +0200

> These three patches against net-2.6.18 fix two bugs in my recent
> match rewrite and a minor thinko in the hashlimit match.
> 
> Please apply.

All 3 patches applied, thanks a lot.
