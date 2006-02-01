From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: ctnetlink expect dumping bug
Date: Wed, 01 Feb 2006 03:14:24 +0100
Message-ID: <43E01980.6090506@eurodev.net>
References: <20060129180700.GA5490@rama.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060129180700.GA5490@rama.intranet.astaro.de>
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

Hi!

Harald Welte wrote:
> The issue is that for dumping the expect mask, we use regular tuple
> dumping functions.  Those regular dumping functions call proto_find_get
> and l3proto_find_get with protocol value 0xffff, which leads to an array
> overflow in those NPROTO sized arrays.
> 
> Rather than using the mask value, we'd need to pass the respective value
> from the expect tuple for dumping the expect mask.
> 
> From looking at the code, it seems the bug also exists in
> ip_conntrack_netlink, but I didn't really test it.

No problem, ip_conntrack doesn't have the l3num field.

> Pablo, would you please prepare a fix for this, and confirm it by having
> helpers create expectations inside the kernel while running 'conntrack
> -E' ?

I did, we're still discussing :). Anyway Patrick have workaround for
this but it still remains a bit tricky. Please have a look at:

expectation mask handling in nfctnetlink (Was Re: [PATCH] fix
nf_conntrack_netlink expectation dumping/event notification)

cheers,

-- 
Pablo
