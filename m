From: David Miller <davem@davemloft.net>
Subject: Re: linux-next: Tree for Dec 28 (nfnetlink)
Date: Wed, 28 Dec 2011 15:33:04 -0500 (EST)
Message-ID: <20111228.153304.1267926241298522965.davem@davemloft.net>
References: <20111228201806.d6de27fa2dbd9e3a3b7a2603@canb.auug.org.au>
	<4EFB87CC.6020105@xenotime.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: rdunlap@xenotime.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <4EFB87CC.6020105@xenotime.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Wed, 28 Dec 2011 13:19:08 -0800

> On 12/28/2011 01:18 AM, Stephen Rothwell wrote:
>> Hi all,
>> 
>> I got bored :-(  I also hate tree wide, flag day changes :-(
>> 
>> Changes since 20111222:
> 
> 
> 
> warning: (NETFILTER_XT_MATCH_NFACCT) selects NETFILTER_NETLINK_ACCT which has unmet direct dependencies (NET && INET && NETFILTER && NETFILTER_ADVANCED)
> 
> and then
> 
> ERROR: "nfnetlink_subsys_unregister" [net/netfilter/nfnetlink_acct.ko] undefined!
> ERROR: "nfnetlink_subsys_register" [net/netfilter/nfnetlink_acct.ko] undefined!
> 
> 
> Full randconfig file is attached.

Pablo please fix this, thanks.
