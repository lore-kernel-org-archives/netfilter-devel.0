From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH NF_CONNTRACK 2/4] change the random value on resizing
 hash
Date: Sun, 16 Oct 2005 05:18:18 +0900 (JST)
Message-ID: <200510152018.j9FKIItd021780@toshiba.co.jp>
References: <200510081109.j98B9gCX014619@toshiba.co.jp>
	<20051009174703.GC665@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Oct_16_05_18_18_2005_793)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051009174703.GC665@rama.customers.eurospot.com>
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

----Next_Part(Sun_Oct_16_05_18_18_2005_793)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Harald,

From: Harald Welte <laforge@netfilter.org>
Date: Sun, 9 Oct 2005 19:47:04 +0200

> > This synchronizes nf_conntrack with ip_conntrack and re-seeds the random
> > value for hashing when the hash size of conntrack is changed.
> 
> oh, I just 'rewrote' that patch, so it's already applied.

Please fix this typo.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Sun_Oct_16_05_18_18_2005_793)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-typo.patch"

[NETFILTER] fix typo in nf_conntrack

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 90345e5013ffc3541f0d0382d8f2e9d12e702e38
tree 42691c5345cae6249111e97c5ac1e7a61cbbc887
parent ef2b2389ff4d3a2bc6bec94074a239bb8fbb6468
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 16 Oct 2005 04:39:25 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 16 Oct 2005 04:39:25 +0900

 net/netfilter/nf_conntrack_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1467,7 +1467,7 @@ int set_hashsize(const char *val, struct
 	nf_conntrack_htable_size = hashsize;
 	nf_conntrack_vmalloc = vmalloced;
 	nf_conntrack_hash = hash;
-	ip_conntrack_hash_rnd = rnd;
+	nf_conntrack_hash_rnd = rnd;
 	write_unlock_bh(&nf_conntrack_lock);
 
 	free_conntrack_hash(old_hash, old_vmalloced, old_size);

----Next_Part(Sun_Oct_16_05_18_18_2005_793)----
