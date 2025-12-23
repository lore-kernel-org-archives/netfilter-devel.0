Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E4A350D58;
	Tue, 23 Dec 2025 10:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766484322; cv=none; b=OnxVEptcMSFqxlNovTb58oLJNStSLoVKeVgq6ME6Vvn8am2t610sAefMv+3KF2b5NaBbeVhJf24cRPfiVVcwWtfy1NVYXH663eMwQsrZI/iyRlIhOxYq4PlhnJ5wjMRUXk7jcibhbB6Y4MFphi73tJo31WkbqpoixTN8jGQ2xco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766484322; c=relaxed/simple;
	bh=ZC3lK8Ir+YU2yV9VH4rrxpOsk7hVKGxbKcBXjjOgC8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcMt3cW0U+RfA32iJNXFSEJd4ebETyJ6nQxX7R8LVellS8bm/nbZIY5+RE/NgxyCt+dErMhYZrAt33ewY5s6KFZJnpB8raZAVjnOLdD9uwm74fH40LrRuO05IoUkS8nNUbhChW8kIKK/uCWgDB82xcZZaV3d81CE5bjLIu3zrEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QfxSmWa4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfxSmWa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981DCC19421;
	Tue, 23 Dec 2025 10:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766484321;
	bh=ZC3lK8Ir+YU2yV9VH4rrxpOsk7hVKGxbKcBXjjOgC8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QfxSmWa43F6rgrmO3SJZbZl1dyKCkEXYrYneH5aaAGj/5tkFMFYd6nfF0KMkIhvX8
	 9SWEbkjx5PPTgG1Wa1t4KDNu5i1i0lUD+SQU5vZGGCYv2+F20jYe9N3sTLUcA81BOs
	 XfaW5OhVgKYKsuOn+VbD1F2xB+wTMsRt1bkrnE5wFtJIIyw8lyovsn5ffEegy3Bk4l
	 lUErzd1Rm0SgsvWtSJGc2xfkQEyK7w0KWo0AdM2ntftkgVzR+sSo14SPc+tyeUt6SK
	 E2yD0m38YXBpfIUdqeGJVGjMw1jIEml7DU+BRt8ylogHqecbPz3Nzj2mQn5nGA+0BW
	 eqp3rt7/7+iCw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH AUTOSEL 6.18-6.6] netfilter: nf_tables: avoid chain re-validation if possible
Date: Tue, 23 Dec 2025 05:05:06 -0500
Message-ID: <20251223100518.2383364-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251223100518.2383364-1-sashal@kernel.org>
References: <20251223100518.2383364-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.2
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 8e1a1bc4f5a42747c08130b8242ebebd1210b32f ]

Hamza Mahfooz reports cpu soft lock-ups in
nft_chain_validate():

 watchdog: BUG: soft lockup - CPU#1 stuck for 27s! [iptables-nft-re:37547]
[..]
 RIP: 0010:nft_chain_validate+0xcb/0x110 [nf_tables]
[..]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_immediate_validate+0x36/0x50 [nf_tables]
  nft_chain_validate+0xc9/0x110 [nf_tables]
  nft_table_validate+0x6b/0xb0 [nf_tables]
  nf_tables_validate+0x8b/0xa0 [nf_tables]
  nf_tables_commit+0x1df/0x1eb0 [nf_tables]
[..]

Currently nf_tables will traverse the entire table (chain graph), starting
from the entry points (base chains), exploring all possible paths
(chain jumps).  But there are cases where we could avoid revalidation.

Consider:
1  input -> j2 -> j3
2  input -> j2 -> j3
3  input -> j1 -> j2 -> j3

Then the second rule does not need to revalidate j2, and, by extension j3,
because this was already checked during validation of the first rule.
We need to validate it only for rule 3.

This is needed because chain loop detection also ensures we do not exceed
the jump stack: Just because we know that j2 is cycle free, its last jump
might now exceed the allowed stack size.  We also need to update all
reachable chains with the new largest observed call depth.

Care has to be taken to revalidate even if the chain depth won't be an
issue: chain validation also ensures that expressions are not called from
invalid base chains.  For example, the masquerade expression can only be
called from NAT postrouting base chains.

Therefore we also need to keep record of the base chain context (type,
hooknum) and revalidate if the chain becomes reachable from a different
hook location.

Reported-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Closes: https://lore.kernel.org/netfilter-devel/20251118221735.GA5477@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net/
Tested-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit Analysis: netfilter: nf_tables: avoid chain re-validation if
possible

### 1. COMMIT MESSAGE ANALYSIS

**Bug Indicators:**
- Reports CPU soft lock-ups in `nft_chain_validate()` - a serious
  denial-of-service condition
- Stack trace shows recursive validation causing 27+ second lockups
- Has `Reported-by:` and `Tested-by:` tags from Hamza Mahfooz
  (Microsoft)
- Has `Closes:` link to lore.kernel.org bug report

The commit explains that chain validation currently traverses the entire
table graph, causing exponential complexity when chains are reachable
through multiple paths. This is a clear performance/DoS bug, not a
feature addition.

### 2. CODE CHANGE ANALYSIS

**Changes to nf_tables.h:**
- Adds new `struct nft_chain_validate_state` with hook_mask and depth
  tracking
- Adds `vstate` field to `struct nft_chain` for validation state caching
- Changes `nft_chain_validate()` signature to allow chain modification

**Changes to nf_tables_api.c:**
- `nft_chain_vstate_valid()`: New function checking if chain is already
  validated for current context
- `nft_chain_vstate_update()`: Updates chain's validation state after
  successful validation
- `nft_chain_validate()`: Added early-exit when chain already validated,
  added depth/base-chain checks
- `nft_table_validate()`: Added cleanup loop to clear vstate after
  validation completes

**The technical fix:** Implements memoization to avoid redundant chain
validation. If a chain has already been validated at the current call
depth and hook context, skip re-validation.

### 3. CLASSIFICATION

This is a **bug fix** for a denial-of-service condition. While it adds
new structures for state tracking, the purpose is purely to fix the
exponential validation complexity causing soft lockups.

### 4. SCOPE AND RISK ASSESSMENT

**Size:** ~60 lines added across 2 files
**Complexity:** Moderate - adds memoization logic with proper cleanup

**Risks:**
- Changes validation logic which is security-critical
- If memoization is incorrect, could theoretically allow invalid chains
  or block valid ones
- New field in `struct nft_chain`

**Mitigations:**
- Well-structured with defensive checks (`WARN_ON_ONCE`, `BUILD_BUG_ON`)
- Cleanup loop at end of `nft_table_validate()` ensures no stale state
- vstate only used during control plane commit phase
- Trusted author (Florian Westphal, netfilter maintainer)

### 5. USER IMPACT

**Severity: HIGH**
- CPU soft lockups make the system unresponsive for 27+ seconds
- Triggered by iptables-nft/nftables operations with complex rulesets
- Affects any user managing firewalls with multiple jump paths between
  chains
- Could potentially be exploited for DoS if unprivileged users can
  modify rules

### 6. STABILITY INDICATORS

- `Reported-by:` and `Tested-by:` from the same reporter confirms the
  fix works
- Author is a well-known netfilter maintainer
- Clear technical explanation in commit message
- The fix targets existing core netfilter code that exists in stable
  trees

### 7. DEPENDENCY CHECK

Looking at the code, this doesn't appear to depend on other recent
commits. It uses existing macros and structures (`nft_is_base_chain`,
`nft_base_chain`, etc.) that should exist in stable kernels.

### DECISION ANALYSIS

**Pro-backport:**
1. Fixes real user-reported DoS (CPU soft lockup for 27+ seconds)
2. Tested by reporter, confirmed to resolve the issue
3. Authored by trusted netfilter maintainer
4. Netfilter is critical infrastructure - firewall lockups are serious
5. The bug affects real-world complex rulesets

**Against-backport:**
1. Larger than typical stable patches (~60 lines)
2. Adds new data structure and field
3. Touches security-critical validation path
4. Some complexity in the memoization logic

### CONCLUSION

Despite being larger than a typical stable fix, this commit addresses a
**severe denial-of-service condition** (soft lockups) in critical
firewall infrastructure. The 27+ second lockups render systems unusable
and this has real user impact. The fix is well-designed with proper
cleanup, tested by the reporter, and authored by a trusted netfilter
maintainer. The stable kernel rules explicitly allow fixes for "serious
crash, deadlock" issues - soft lockups fall into this category.

The benefit (fixing DoS) significantly outweighs the risk, and the code
quality/testing gives confidence in the fix's correctness.

**YES**

 include/net/netfilter/nf_tables.h | 34 +++++++++++----
 net/netfilter/nf_tables_api.c     | 69 +++++++++++++++++++++++++++++--
 2 files changed, 91 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index fab7dc73f738..0e266c2d0e7f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1091,6 +1091,29 @@ struct nft_rule_blob {
 		__attribute__((aligned(__alignof__(struct nft_rule_dp))));
 };
 
+enum nft_chain_types {
+	NFT_CHAIN_T_DEFAULT = 0,
+	NFT_CHAIN_T_ROUTE,
+	NFT_CHAIN_T_NAT,
+	NFT_CHAIN_T_MAX
+};
+
+/**
+ *	struct nft_chain_validate_state - validation state
+ *
+ *	If a chain is encountered again during table validation it is
+ *	possible to avoid revalidation provided the calling context is
+ *	compatible.  This structure stores relevant calling context of
+ *	previous validations.
+ *
+ *	@hook_mask: the hook numbers and locations the chain is linked to
+ *	@depth: the deepest call chain level the chain is linked to
+ */
+struct nft_chain_validate_state {
+	u8			hook_mask[NFT_CHAIN_T_MAX];
+	u8			depth;
+};
+
 /**
  *	struct nft_chain - nf_tables chain
  *
@@ -1109,6 +1132,7 @@ struct nft_rule_blob {
  *	@udlen: user data length
  *	@udata: user data in the chain
  *	@blob_next: rule blob pointer to the next in the chain
+ *	@vstate: validation state
  */
 struct nft_chain {
 	struct nft_rule_blob		__rcu *blob_gen_0;
@@ -1128,9 +1152,10 @@ struct nft_chain {
 
 	/* Only used during control plane commit phase: */
 	struct nft_rule_blob		*blob_next;
+	struct nft_chain_validate_state vstate;
 };
 
-int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain);
+int nft_chain_validate(const struct nft_ctx *ctx, struct nft_chain *chain);
 int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 			 const struct nft_set_iter *iter,
 			 struct nft_elem_priv *elem_priv);
@@ -1138,13 +1163,6 @@ int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
 int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 
-enum nft_chain_types {
-	NFT_CHAIN_T_DEFAULT = 0,
-	NFT_CHAIN_T_ROUTE,
-	NFT_CHAIN_T_NAT,
-	NFT_CHAIN_T_MAX
-};
-
 /**
  * 	struct nft_chain_type - nf_tables chain type info
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eed434e0a970..7fbfa1e5d27c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -123,6 +123,29 @@ static void nft_validate_state_update(struct nft_table *table, u8 new_validate_s
 
 	table->validate_state = new_validate_state;
 }
+
+static bool nft_chain_vstate_valid(const struct nft_ctx *ctx,
+				   const struct nft_chain *chain)
+{
+	const struct nft_base_chain *base_chain;
+	enum nft_chain_types type;
+	u8 hooknum;
+
+	if (WARN_ON_ONCE(!nft_is_base_chain(ctx->chain)))
+		return false;
+
+	base_chain = nft_base_chain(ctx->chain);
+	hooknum = base_chain->ops.hooknum;
+	type = base_chain->type->type;
+
+	/* chain is already validated for this call depth */
+	if (chain->vstate.depth >= ctx->level &&
+	    chain->vstate.hook_mask[type] & BIT(hooknum))
+		return true;
+
+	return false;
+}
+
 static void nf_tables_trans_destroy_work(struct work_struct *w);
 
 static void nft_trans_gc_work(struct work_struct *work);
@@ -4079,6 +4102,29 @@ static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *r
 	nf_tables_rule_destroy(ctx, rule);
 }
 
+static void nft_chain_vstate_update(const struct nft_ctx *ctx, struct nft_chain *chain)
+{
+	const struct nft_base_chain *base_chain;
+	enum nft_chain_types type;
+	u8 hooknum;
+
+	/* ctx->chain must hold the calling base chain. */
+	if (WARN_ON_ONCE(!nft_is_base_chain(ctx->chain))) {
+		memset(&chain->vstate, 0, sizeof(chain->vstate));
+		return;
+	}
+
+	base_chain = nft_base_chain(ctx->chain);
+	hooknum = base_chain->ops.hooknum;
+	type = base_chain->type->type;
+
+	BUILD_BUG_ON(BIT(NF_INET_NUMHOOKS) > U8_MAX);
+
+	chain->vstate.hook_mask[type] |= BIT(hooknum);
+	if (chain->vstate.depth < ctx->level)
+		chain->vstate.depth = ctx->level;
+}
+
 /** nft_chain_validate - loop detection and hook validation
  *
  * @ctx: context containing call depth and base chain
@@ -4088,15 +4134,25 @@ static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *r
  * and set lookups until either the jump limit is hit or all reachable
  * chains have been validated.
  */
-int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
+int nft_chain_validate(const struct nft_ctx *ctx, struct nft_chain *chain)
 {
 	struct nft_expr *expr, *last;
 	struct nft_rule *rule;
 	int err;
 
+	BUILD_BUG_ON(NFT_JUMP_STACK_SIZE > 255);
 	if (ctx->level == NFT_JUMP_STACK_SIZE)
 		return -EMLINK;
 
+	if (ctx->level > 0) {
+		/* jumps to base chains are not allowed. */
+		if (nft_is_base_chain(chain))
+			return -ELOOP;
+
+		if (nft_chain_vstate_valid(ctx, chain))
+			return 0;
+	}
+
 	list_for_each_entry(rule, &chain->rules, list) {
 		if (fatal_signal_pending(current))
 			return -EINTR;
@@ -4117,6 +4173,7 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 		}
 	}
 
+	nft_chain_vstate_update(ctx, chain);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nft_chain_validate);
@@ -4128,7 +4185,7 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 		.net	= net,
 		.family	= table->family,
 	};
-	int err;
+	int err = 0;
 
 	list_for_each_entry(chain, &table->chains, list) {
 		if (!nft_is_base_chain(chain))
@@ -4137,12 +4194,16 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 		ctx.chain = chain;
 		err = nft_chain_validate(&ctx, chain);
 		if (err < 0)
-			return err;
+			goto err;
 
 		cond_resched();
 	}
 
-	return 0;
+err:
+	list_for_each_entry(chain, &table->chains, list)
+		memset(&chain->vstate, 0, sizeof(chain->vstate));
+
+	return err;
 }
 
 int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
-- 
2.51.0

