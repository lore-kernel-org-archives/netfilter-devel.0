Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A541B2D2487;
	Wed, 10 Sep 2025 19:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757530997; cv=none; b=bw0HM649ANX5jSYiqS1CSlQKKwYkcrb3s6Zgcl4nn7hdRDHG3SvWktunyyj3gS3L0uU49kebAWhKPvMd1IzLPxqFlsMvxXmi6SbJCtQl0iyCK7ODOFn2r0p3isOpKWH0nv3/r0EOGXSwVJgY2aZgFRQ4TtfZ81kmGFZtAvv+QQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757530997; c=relaxed/simple;
	bh=n2GqUuAT44gsq2aUAeyZaYZyCY9N/hEHenq4xDPp9kE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nfj08lNzIF/0BAGO3QIktgLwu6Ila2CpC/yl96+d3vqQ54qckuhb8maBsACwoJeuPUT6FWXvMKB69JL78kz7UMPz4iCeGWZVIpqW4wDfOLvHuhBMMD211yaofBqHqn392CBNchYKimyhYG458BsqiepDz59mCbdZ8Fb6EVGYHKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B054360532; Wed, 10 Sep 2025 21:03:12 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 0/7] netfilter: updates for net
Date: Wed, 10 Sep 2025 21:03:01 +0200
Message-ID: <20250910190308.13356-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net*:

WARNING: This results in a conflict on net -> net-next merge.
Merge resolution walkthrough is at the end of this cover letter, see
MERGE WALKTHROUGH.

  Merge branch 'mptcp-misc-fixes-for-v6-17-rc6' (2025-09-09 18:39:55 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-09-10-v2

for you to fetch changes up to 37a9675e61a2a2a721a28043ffdf2c8ec81eba37:

  MAINTAINERS: add Phil as netfilter reviewer (2025-09-10 20:32:46 +0200)

First patch adds a lockdep annotation for a false-positive splat.
Last patch adds formal reviewer tag for Phil Sutter to MAINTAINERS.

Rest of the patches resolve spurious false negative results during set
lookups while another CPU is processing a transaction.

This has been broken at least since v4.18 when an unconditional
synchronize_rcu call was removed from the commit phase of nf_tables.

Quoting from Stefan Hanreichs original report:

 It seems like we've found an issue with atomicity when reloading
 nftables rulesets. Sometimes there is a small window where rules
 containing sets do not seem to apply to incoming traffic, due to the set
 apparently being empty for a short amount of time when flushing / adding
 elements.

Exanple ruleset:
table ip filter {
  set match {
    type ipv4_addr
    flags interval
    elements = { 0.0.0.0-192.168.2.19, 192.168.2.21-255.255.255.255 }
  }

  chain pre {
    type filter hook prerouting priority filter; policy accept;
    ip saddr @match accept
    counter comment "must never match"
  }
}

Reproducer transaction:
while true:
nft -f -<<EOF
 flush set ip filter match
 create element ip filter match { \
    0.0.0.0-192.168.2.19, 192.168.2.21-255.255.255.255 }
EOF
done

Then create traffic. to/from e.g. 192.168.2.1 to 192.168.3.10.
Once in a while the counter will increment even though the
'ip saddr @match' rule should have accepted the packet.

See individual patches for details.

Thanks to Stefan Hanreich for an initial description and reproducer for
this bug and to Pablo Neira Ayuso for reviewing earlier iterations of
the patchset.

Florian Westphal (7):
  netfilter: nft_set_bitmap: fix lockdep splat due to missing annotation
  netfilter: nft_set_pipapo: don't check genbit from packetpath lookups
  netfilter: nft_set_rbtree: continue traversal if element is inactive
  netfilter: nf_tables: place base_seq in struct net
  netfilter: nf_tables: make nft_set_do_lookup available unconditionally
  netfilter: nf_tables: restart set lookup on base_seq change
  MAINTAINERS: add Phil as netfilter reviewer

 MAINTAINERS                            |  1 +
 include/net/netfilter/nf_tables.h      |  1 -
 include/net/netfilter/nf_tables_core.h | 10 +---
 include/net/netns/nftables.h           |  1 +
 net/netfilter/nf_tables_api.c          | 66 +++++++++++++-------------
 net/netfilter/nft_lookup.c             | 46 ++++++++++++++++--
 net/netfilter/nft_set_bitmap.c         |  3 +-
 net/netfilter/nft_set_pipapo.c         | 20 +++++++-
 net/netfilter/nft_set_pipapo_avx2.c    |  4 +-
 net/netfilter/nft_set_rbtree.c         |  6 +--
 10 files changed, 103 insertions(+), 55 deletions(-)

MERGE WALKTHROUGH:

When merging this to net-next, you should see following:

CONFLICT (content): Merge conflict in net/netfilter/nft_set_pipapo.c
CONFLICT (content): Merge conflict in net/netfilter/nft_set_pipapo_avx2.c

Instructions for net/netfilter/nft_set_pipapo.c:

@@@ -562,7 -539,7 +578,11 @@@ nft_pipapo_lookup(const struct net *net
        const struct nft_pipapo_elem *e;
  
        m = rcu_dereference(priv->match);
++<<<<<<< HEAD
 +      e = pipapo_get_slow(m, (const u8 *)key, genmask, get_jiffies_64());
++=======
+       e = pipapo_get(m, (const u8 *)key, NFT_GENMASK_ANY, get_jiffies_64());
++>>>>>>> 352fd037254683c940630a6c5c8aa8c8ca38ae88
  
        return e ? &e->ext : NULL;
  }

Take the HEAD chunk, with 'genmask' replaced by NFT_GENMASK_ANY, i.e.:

e = pipapo_get_slow(m, (const u8 *)key, NFT_GENMASK_ANY, get_jiffies_64());

Instructions for net/netfilter/nft_set_pipapo_avx2.c:

++<<<<<<< HEAD
++=======
+       const struct nft_pipapo_match *m;
++>>>>>>> 352fd037254683c940630a6c5c8aa8c8ca38ae88

Take the HEAD chunk, i.e. delete 'const struct nft_pipapo_match *m;':
In -next, this is passed as function argument.

++<<<<<<< HEAD
 +              if (ret < 0) {
 +                      scratch->map_index = map_index;
 +                      kernel_fpu_end();
 +                      __local_unlock_nested_bh(&scratch->bh_lock);
 +                      return NULL;
++=======
+               if (ret < 0)
+                       goto out;
+ 
+               if (last) {
+                       const struct nft_set_ext *e = &f->mt[ret].e->ext;
+ 
+                       if (unlikely(nft_set_elem_expired(e)))
+                               goto next_match;
+ 
+                       ext = e;
+                       goto out;
++>>>>>>> 352fd037254683c940630a6c5c8aa8c8ca38ae88

Take the HEAD chunk and discard the other; including if (last) { branch.

Then, in nft_pipapo_avx2_lookup(), make this change:

@@ -1274,9 +1273,8 @@
 nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
                       const u32 *key)
 {
        struct nft_pipapo *priv = nft_set_priv(set);
-       u8 genmask = nft_genmask_cur(net);
        const struct nft_pipapo_match *m;
        const u8 *rp = (const u8 *)key;
        const struct nft_pipapo_elem *e;

@@ -1292,9 +1290,9 @@
        }

        m = rcu_dereference(priv->match);

-       e = pipapo_get_avx2(m, rp, genmask, get_jiffies_64());
+       e = pipapo_get_avx2(m, rp, NFT_GENMASK_ANY, get_jiffies_64());
        local_bh_enable();

        return e ? &e->ext : NULL;

After this change, you are done.
The expected diff vs the net-next main branch in these two files is:

--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -549,6 +549,23 @@ static struct nft_pipapo_elem *pipapo_get(const struct nft_pipapo_match *m,
  *
  * This function is called from the data path.  It will search for
  * an element matching the given key in the current active copy.
+ * Unlike other set types, this uses NFT_GENMASK_ANY instead of
+ * nft_genmask_cur().
[trimmed rest of comment]
  *
  * Return: ntables API extension pointer or NULL if no match.
  */
@@ -557,12 +574,11 @@ nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
                  const u32 *key)
 {
        struct nft_pipapo *priv = nft_set_priv(set);
-       u8 genmask = nft_genmask_cur(net);
        const struct nft_pipapo_match *m;
        const struct nft_pipapo_elem *e;

        m = rcu_dereference(priv->match);
-       e = pipapo_get_slow(m, (const u8 *)key, genmask, get_jiffies_64());
+       e = pipapo_get_slow(m, (const u8 *)key, NFT_GENMASK_ANY, get_jiffies_64());

        return e ? &e->ext : NULL;
 }

--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1275,7 +1275,6 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
                       const u32 *key)
 {
        struct nft_pipapo *priv = nft_set_priv(set);
-       u8 genmask = nft_genmask_cur(net);
        const struct nft_pipapo_match *m;
        const u8 *rp = (const u8 *)key;
        const struct nft_pipapo_elem *e;
@@ -1293,7 +1292,7 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,

        m = rcu_dereference(priv->match);

-       e = pipapo_get_avx2(m, rp, genmask, get_jiffies_64());
+       e = pipapo_get_avx2(m, rp, NFT_GENMASK_ANY, get_jiffies_64());
        local_bh_enable();

        return e ? &e->ext : NULL;
-- 
2.49.1
