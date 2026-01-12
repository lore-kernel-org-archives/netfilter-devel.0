Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBA12E0916;
	Mon, 12 Jan 2026 14:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229943; cv=none; b=aI6JeiqsmiIGGoVsC4qFQwkAZfGWcs8jXXFym35NqlsTbGbhtubm9LY9tbHN2j2V152x74eCPGLXYF++1CJUrj+d3CU4iim0Wq6Gf3rBELkxO2yvL6cUTjy/2PrbOqbYctZZX+vy+/GSKuc8CviYWsUnWoyPk15ueuExGCFNGFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229943; c=relaxed/simple;
	bh=opg4tncLaI6otjgqlDIEK5fsztRbZKQsPuoibXoWSsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dVG+pejZwmm0JiJ7J3QvQ+Y6PNapVUWxWWfwngUkGrdFkD1KvEtZKhdrTIBcpYStmPQb0ABKrGeP/SJUAYdETGi9uE1ajYp0hjiXPtOspqXr0mK+o+B2+FS2nAK+HfHw6QbVqqz1WqNfpSmsWtYnd/jzu2ryN/AmC59RgUBbkQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=smWTvNFc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="smWTvNFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B139C2BC86;
	Mon, 12 Jan 2026 14:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768229943;
	bh=opg4tncLaI6otjgqlDIEK5fsztRbZKQsPuoibXoWSsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smWTvNFcuBYIv/R5nX8oy4ig5e0vHxiu+qhkeb2N8iD2XbBfh/lqXmNWqn6De9sBK
	 YFj8KRiyf6XCEqZp4hj18O8b/juoqPQDmylBMoT9No2jzRngCei7BaxT1/Z/AHeQHc
	 wQid2g25IoZt0EbD1ZbtKJPO2xPhSkbsm4fsWYiBXcdkx4lhWyFlkTI0i8QYBq0ABl
	 r6NNhaZn56XE7rbpo4XA9FfQlApdanvk+1P/NrJMug8y79zgSAfw+YYfI+WyJabR49
	 vKXGA3n1AXyCXP+9Rz7yPta5bYPcojF7C5Gr+rY6TrlCoBO3moUpD1ytiHjbXz86st
	 yd763xFWNq3NA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Gomez <da.gomez@samsung.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH AUTOSEL 6.18-5.15] netfilter: replace -EEXIST with -EBUSY
Date: Mon, 12 Jan 2026 09:58:14 -0500
Message-ID: <20260112145840.724774-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112145840.724774-1-sashal@kernel.org>
References: <20260112145840.724774-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Gomez <da.gomez@samsung.com>

[ Upstream commit 2bafeb8d2f380c3a81d98bd7b78b854b564f9cd4 ]

The -EEXIST error code is reserved by the module loading infrastructure
to indicate that a module is already loaded. When a module's init
function returns -EEXIST, userspace tools like kmod interpret this as
"module already loaded" and treat the operation as successful, returning
0 to the user even though the module initialization actually failed.

Replace -EEXIST with -EBUSY to ensure correct error reporting in the module
initialization path.

Affected modules:
  * ebtable_broute ebtable_filter ebtable_nat arptable_filter
  * ip6table_filter ip6table_mangle ip6table_nat ip6table_raw
  * ip6table_security iptable_filter iptable_mangle iptable_nat
  * iptable_raw iptable_security

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit Analysis: netfilter: replace -EEXIST with -EBUSY

### 1. COMMIT MESSAGE ANALYSIS

The commit explains a subtle but important bug in error reporting:
- When module initialization returns `-EEXIST`, the kernel module
  loading infrastructure (kmod) interprets this as "module already
  loaded"
- kmod then returns **success (0)** to userspace, even though the module
  initialization actually **failed**
- This creates a silent failure condition where users believe operations
  succeeded when they didn't

Keywords: "error reporting", "failed" - this is a bug fix, not a
feature.

### 2. CODE CHANGE ANALYSIS

The changes are trivial and identical across three files:

**net/bridge/netfilter/ebtables.c** (`ebt_register_template()`):
```c
- return -EEXIST;
+                       return -EBUSY;
```

**net/netfilter/nf_log.c** (`nf_log_register()`):
```c
- ret = -EEXIST;
+                       ret = -EBUSY;
```

**net/netfilter/x_tables.c** (`xt_register_template()`):
```c
- int ret = -EEXIST, af = table->af;
+       int ret = -EBUSY, af = table->af;
```

All three functions are registration routines called during module
initialization for netfilter tables. When a duplicate name/type is
detected, they were returning `-EEXIST`, which gets misinterpreted by
kmod.

### 3. CLASSIFICATION

**Bug fix**: Corrects error code semantics. No new functionality, no
behavior change beyond proper error reporting.

The `-EBUSY` error code is semantically appropriate ("resource is
busy/in use") and is not intercepted specially by the module loading
infrastructure.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: ~6 actual code changes
- **Files affected**: 3 files in netfilter subsystem
- **Complexity**: Trivial - only changing error code constants
- **Risk**: Extremely low - no logic changes at all

The only conceivable concern would be if userspace depended on
`-EEXIST`, but:
1. These are internal kernel registration functions
2. The duplicate condition should never occur in normal operation (note
   the `WARN_ON_ONCE`)
3. The current behavior is **wrong** - it reports success on failure

### 5. USER IMPACT

**High impact bug**:
- Affects all netfilter/iptables users when module initialization fails
- Security implications: Users may believe their firewall tables loaded
  successfully when they didn't
- Affected modules include: `iptable_filter`, `iptable_nat`,
  `ip6table_filter`, `ebtable_filter`, etc. - core firewall components

This is exactly the kind of silent failure that can cause security
issues in production.

### 6. STABILITY INDICATORS

- Signed-off-by: Florian Westphal (netfilter maintainer) - indicates
  proper review
- The fix is self-evidently correct
- Clear problem description in commit message

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- The affected code (netfilter table registration) exists in all stable
  kernel trees
- These are long-standing, mature functions

### Summary

| Criterion | Assessment |
|-----------|------------|
| Fixes real bug? | ✅ Yes - silent failure condition |
| Obviously correct? | ✅ Yes - trivial error code change |
| Small and contained? | ✅ Yes - 6 lines across 3 files |
| Security relevant? | ✅ Yes - firewall may silently fail to load |
| Risk of regression? | ✅ Minimal - no logic changes |
| Dependencies? | ✅ None - self-contained |

This commit fixes incorrect error semantics that cause userspace tools
to report success when module initialization fails. The fix is trivial
(changing error codes), affects widely-used firewall code, has potential
security implications (users may not know their firewall failed), and
carries virtually zero regression risk. It meets all stable kernel
criteria.

**YES**

 net/bridge/netfilter/ebtables.c | 2 +-
 net/netfilter/nf_log.c          | 4 ++--
 net/netfilter/x_tables.c        | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 5697e3949a365..a04fc17575289 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1299,7 +1299,7 @@ int ebt_register_template(const struct ebt_table *t, int (*table_init)(struct ne
 	list_for_each_entry(tmpl, &template_tables, list) {
 		if (WARN_ON_ONCE(strcmp(t->name, tmpl->name) == 0)) {
 			mutex_unlock(&ebt_mutex);
-			return -EEXIST;
+			return -EBUSY;
 		}
 	}
 
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 74cef8bf554c5..62cf6a30875e3 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -89,7 +89,7 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 	if (pf == NFPROTO_UNSPEC) {
 		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
 			if (rcu_access_pointer(loggers[i][logger->type])) {
-				ret = -EEXIST;
+				ret = -EBUSY;
 				goto unlock;
 			}
 		}
@@ -97,7 +97,7 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 			rcu_assign_pointer(loggers[i][logger->type], logger);
 	} else {
 		if (rcu_access_pointer(loggers[pf][logger->type])) {
-			ret = -EEXIST;
+			ret = -EBUSY;
 			goto unlock;
 		}
 		rcu_assign_pointer(loggers[pf][logger->type], logger);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 90b7630421c44..48105ea3df152 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1764,7 +1764,7 @@ EXPORT_SYMBOL_GPL(xt_hook_ops_alloc);
 int xt_register_template(const struct xt_table *table,
 			 int (*table_init)(struct net *net))
 {
-	int ret = -EEXIST, af = table->af;
+	int ret = -EBUSY, af = table->af;
 	struct xt_template *t;
 
 	mutex_lock(&xt[af].mutex);
-- 
2.51.0

