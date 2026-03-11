Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F292F4A14
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 19:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773258069; cv=none; b=WlJccjju+o42xCvtjuOd+J76f5+Xevx3oZBu7K8BYHnAtz25/czar3dEpf4mHzN6PD1OKRS6RjV3qKog+8wdff1T25qcsv6cwx5umhcAkrPJ3Px9fl8kxmZJ7owrhsDjBF8bwleDYTVm6IAqo+jWOv4Yf0z5U1MY61WLbb9tZuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773258069; c=relaxed/simple;
	bh=nGCtSjx5BZXVnn4sLF8VdTPba6yPu93FrnZ3IRcHH20=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SHZYg00B5VEE0vtnhePov+cv7aTW0197H9wCDc0ClQJkB9URTLFAA3cU2dqzA7nCEuwYPSHr0hdByjZRNsz/eAY47vFaxqdM0rGo6tFZHBQVSsK68uyKqSfaqgnIIc6u3h5Xchis83krGz0i8zDC9tfkGY7BJW30znRtGMac7yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=A7CSxlgd; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="A7CSxlgd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bU4Hi92BDkIAuuoglXVS3H12SQ0g+BGA8hj7bgVkTiE=; b=A7CSxlgdwU70VoW2b7dh3oK/XF
	tOcjtvVpsb4//PXr31sLm2od/CDzO3KeohkojsPGMzfW5wNzF4B/4EDCeRyNNSTRzJzTMbEwbaLw8
	SqpdcSbNhSJSktcjXIh4PvuewyrUlAHr7EuaQkJg/17vSQ6FXBqmOg7n4o30Q+wDgZiPYInYuW7q3
	pOUOnwDDQ5lcfdQIOsJddnfBrLOfak7U0aFLJPHNy5sohM8Fo7ulykHMV+dMmtnbfu9wbxzoXRvI7
	anjfBWeB2ULefit3yEbYFElqKw9/DNUvxAE+GxWqD3C1ZjopEWO2hOTRMBkVuASR2u0FRnP4dSAB/
	HG75biag==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w0PQX-000000007ks-3ViV;
	Wed, 11 Mar 2026 20:41:05 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nft PATCH] cache: Fix for multiple commands in a single batch
Date: Wed, 11 Mar 2026 20:33:57 +0100
Message-ID: <20260311194100.21983-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A command line like 'nft list table t1 \; list table t2' would return an
error for non-existent table t1: The filter setup for the second command
limited cache population to table t2, so t1 was not found in cache.

Try to sort this by passing a temporary filter object to evaluate_cache
routines and merging its content to the original object. The logic goes
like this:

- The first command is easy, just copy filter->list values.
- Folllowing commands may only remove filters, not add ones. Therefore
  only unset filter values, if either the current command does not set a
  filter (i.e., "needs all data") or filters for a different object (in
  the case above, drop table filter for t1 instead of changing it to
  t2).
- If the family value varies between commands, unset all filters. The
  kernel can't dump e.g. all tables named "t" in all families, so a
  command like 'list table ip t ; list table ip6 t' breaks the algorihm.
- Treat NFT_CACHE_TERSE flag like a filter (which it is), i.e. allow
  later commands to unset it ("needs set elements") but not set it.

Fixes: 3f1d3912c3a6b ("cache: filter out tables that are not requested")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This patch is a mess and probably pretty fragile, too. I at least
encountered way more "special" cases while testing it than anticipated.

A proper fix would be to perform cache population for each command
individually and thus support per-command filters - basically
refactoring the cache population step in nft_evaluate().

What do you think? Go for a proper solution or not? Apply this one "for
now" or not?
---
 src/cache.c                                   | 47 +++++++++-
 .../testcases/listing/cache_filter_merge      | 88 +++++++++++++++++++
 2 files changed, 132 insertions(+), 3 deletions(-)
 create mode 100755 tests/shell/testcases/listing/cache_filter_merge

diff --git a/src/cache.c b/src/cache.c
index 88a83b7406a6b..f6fff4d6d5fae 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -483,13 +483,15 @@ static void reset_filter(struct nft_cache_filter *filter)
 }
 
 int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
-		       struct list_head *msgs, struct nft_cache_filter *filter,
+		       struct list_head *msgs, struct nft_cache_filter *all_filter,
 		       unsigned int *pflags)
 {
 	unsigned int flags, batch_flags = NFT_CACHE_EMPTY;
+	struct nft_cache_filter _filter, *filter = &_filter;
+	bool first_cmd = true;
 	struct cmd *cmd;
 
-	assert(filter);
+	assert(all_filter);
 
 	list_for_each_entry(cmd, cmds, list) {
 		if (nft_handle_validate(cmd, msgs) < 0)
@@ -536,7 +538,46 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 		default:
 			break;
 		}
-		batch_flags |= flags;
+
+		if (first_cmd) {
+			batch_flags = flags;
+			all_filter->list = filter->list;
+			first_cmd = false;
+		} else {
+			/* do not let later commands set TERSE if not set */
+			batch_flags |= flags & ~NFT_CACHE_TERSE;
+			/* unset TERSE if later commands need it off */
+			if (!(flags & NFT_CACHE_TERSE))
+				batch_flags &= ~NFT_CACHE_TERSE;
+			if (all_filter->list.family != filter->list.family) {
+				/* no filtering possible if family value varies */
+				memset(&all_filter->list, 0,
+				       sizeof(all_filter->list));
+				all_filter->list.family = 0;
+			}
+			if (!all_filter->list.table ||
+			    !filter->list.table ||
+			    strcmp(all_filter->list.table, filter->list.table))
+				all_filter->list.table = NULL;
+			if (!all_filter->list.chain ||
+			    !filter->list.chain ||
+			    strcmp(all_filter->list.chain, filter->list.chain))
+				all_filter->list.chain = NULL;
+			if (!all_filter->list.obj ||
+			    !filter->list.obj ||
+			    strcmp(all_filter->list.obj, filter->list.obj))
+				all_filter->list.obj = NULL;
+			if (!all_filter->list.set ||
+			    !filter->list.set ||
+			    strcmp(all_filter->list.set, filter->list.set))
+				all_filter->list.set = NULL;
+			if (!all_filter->list.ft ||
+			    !filter->list.ft ||
+			    strcmp(all_filter->list.ft, filter->list.ft))
+				all_filter->list.ft = NULL;
+			if (all_filter->list.obj_type != filter->list.obj_type)
+				all_filter->list.obj_type = 0;
+		}
 	}
 	*pflags = batch_flags;
 
diff --git a/tests/shell/testcases/listing/cache_filter_merge b/tests/shell/testcases/listing/cache_filter_merge
new file mode 100755
index 0000000000000..82132d8e5dbbd
--- /dev/null
+++ b/tests/shell/testcases/listing/cache_filter_merge
@@ -0,0 +1,88 @@
+#!/bin/bash
+
+set -e
+
+$NFT -f - <<EOF
+table ip t {
+	flowtable ft {
+		hook ingress priority 0
+	}
+	set s {
+		type inet_service
+		elements = { 80, 443 }
+	}
+	counter cnt {
+		packets 13 bytes 23
+	}
+	quota qt {
+	}
+	chain c {
+		tcp dport 22 accept
+	}
+}
+table ip6 t {
+	flowtable ft {
+		hook ingress priority 0
+	}
+	set s {
+		type inet_service
+		elements = { 80, 443 }
+	}
+	counter cnt {
+		packets 13 bytes 23
+	}
+	quota qt {
+	}
+	chain c {
+		tcp dport 22 accept
+	}
+}
+EOF
+
+commands=(
+	"list ruleset"
+	"list ruleset ip"
+	"list ruleset ip6"
+	"list tables"
+	"list tables ip"
+	"list tables ip6"
+)
+for obj in flowtables sets counters quotas; do
+	commands+=("list $obj")
+	for fam in ip ip6; do
+		commands+=(
+			"list $obj $fam"
+			"list $obj $fam t"
+		)
+	done
+done
+# FIXME: 'list chains <fam> <table>' unsupported
+commands+=("list chains")
+for fam in ip ip6; do
+	commands+=(
+		"list chains $fam"
+	)
+done
+for fam in ip ip6; do
+	commands+=(
+		"list table $fam t"
+		"list flowtable $fam t ft"
+		"list set $fam t s"
+		"list counter $fam t cnt"
+		"list quota $fam t qt"
+		"list chain $fam t c"
+	)
+done
+
+declare -a outputs
+for cmd in "${commands[@]}"; do
+	outputs+=("$($NFT "$cmd")")
+done
+
+for ((i = 0; i < ${#commands[*]} - 1; i++)); do
+	for ((j = $i + 1; j < ${#commands[*]}; j++)); do
+		diff -u --label expect --label "${commands[$i]}; ${commands[$j]}" \
+			<(echo "${outputs[$i]}"; echo "${outputs[$j]}") \
+			<($NFT "${commands[$i]}; ${commands[$j]}")
+	done
+done
-- 
2.51.0

