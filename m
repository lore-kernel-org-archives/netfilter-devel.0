From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 2/8]: Add NetBIOS name service helper
Date: Tue, 06 Sep 2005 20:02:32 -0700 (PDT)
Message-ID: <20050906.200232.87922168.davem@davemloft.net>
References: <m2slwh617b.fsf@cerbere.dyndns.info>
	<20050906.195649.54560179.davem@davemloft.net>
	<431E5800.9080406@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, sbellabes@mandriva.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <431E5800.9080406@trash.net>
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
Date: Wed, 07 Sep 2005 05:01:20 +0200

> Actually it was deliberate, I don't see a reason why the packet
> should be dropped, its best effort. Besides that the patch
> creates a reference leak, we always need to call
> ip_conntrack_expect_put. Please revert the patch. Thanks.

Ok, will do.
