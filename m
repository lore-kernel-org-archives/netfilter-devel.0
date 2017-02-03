From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the rcu tree with the netfilter-next
 tree
Date: Fri, 3 Feb 2017 13:08:02 +1100
Message-ID: <20170203130802.55dbd6e6@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi all,

Today's linux-next merge of the rcu tree got a conflict in:

  net/netfilter/nf_conntrack_core.c

between commit:

  a9e419dc7be6 ("netfilter: merge ctinfo into nfct pointer storage area")

from the netfilter-next tree and commit:

  55f619e5c322 ("mm: Rename SLAB_DESTROY_BY_RCU to SLAB_TYPESAFE_BY_RCU")

from the rcu tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

-- 
Cheers,
Stephen Rothwell

diff --cc net/netfilter/nf_conntrack_core.c
index 071b97fcbefb,13b7e5159660..000000000000
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@@ -1876,9 -1862,8 +1876,9 @@@ int nf_conntrack_init_start(void
  	nf_conntrack_max = max_factor * nf_conntrack_htable_size;
  
  	nf_conntrack_cachep = kmem_cache_create("nf_conntrack",
 -						sizeof(struct nf_conn), 0,
 +						sizeof(struct nf_conn),
 +						NFCT_INFOMASK + 1,
- 						SLAB_DESTROY_BY_RCU | SLAB_HWCACHE_ALIGN, NULL);
+ 						SLAB_TYPESAFE_BY_RCU | SLAB_HWCACHE_ALIGN, NULL);
  	if (!nf_conntrack_cachep)
  		goto err_cachep;
  
