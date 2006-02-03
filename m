From: "David S. Miller" <davem@davemloft.net>
Subject: Re: 2.6.16-rc1-mm3 XFRM+NAT issue
Date: Thu, 02 Feb 2006 17:16:37 -0800 (PST)
Message-ID: <20060202.171637.09393987.davem@davemloft.net>
References: <43DD3E3D.5070201@trash.net>
	<1138573848.28464.1.camel@leto.intern.saout.de>
	<43DD48CC.9070709@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, herbert@gondor.apana.org.au
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <43DD48CC.9070709@trash.net>
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
Date: Sun, 29 Jan 2006 23:59:24 +0100

> Found it, the packet doesn't have its dst_entry released after DNAT in
> PRE_ROUTING because of an incorrect check and is delivered locally.
> This patch should fix it.

Patrick, want me to apply this?

I need a changelog and signed-off-by line if so.

Thanks.
