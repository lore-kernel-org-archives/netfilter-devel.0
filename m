From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the netfilter-next tree
Date: Thu, 18 Aug 2016 11:56:57 +1000
Message-ID: <20160818115657.56eb079f@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi all,

After merging the netfilter-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: "nf_conntrack_htable_size" [net/netfilter/nf_conntrack_netlink.ko] undefined!
ERROR: "nf_conntrack_htable_size" [net/ipv4/netfilter/nf_conntrack_ipv4.ko] undefined!

Caused by commit

  adf0516845bc ("netfilter: remove ip_conntrack* sysctl compat code")

or maybe

  92e47ba8839b ("netfilter: conntrack: simplify the code by using nf_conntrack_get_ht")

I have used the netfilter-next tree from next-20160817 for today.

-- 
Cheers,
Stephen Rothwell
