Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E888225A37;
	Thu, 17 Apr 2025 10:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744885745; cv=none; b=c6fSMZzx8Wpeenl9xkv3vFkqd2qkYUmMwuVG1ICtRZyopBsr9CenKKiv5gxMCGbT7Cve92pSeM+ZBokabYPezM017GtqbaMNFdnGLKAldd9foyvOnftGCjYq9lKlXjjCMZkwqN4SYnzYhq4CiCG7sAXH0MvMk+t7A5X9Z6l9jJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744885745; c=relaxed/simple;
	bh=uT/fRq6/1trlsr76gjZJ36sBmgvi8gbfTNKW74h8VJs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e9+Nga/Fy95E77VsarNnm4d8yuAMMMpVO47WfCSbUrIsR0FIXD0YC1vXi1jABV61uF4Fa3h8t5qkFNPCocrYDlz3npzxx6SEEJATIXYltf0tXwKReag5h2k4dueWPplfblADuhIDHMT/Tq7DeTf6W8SEViD6S9QcuKkDKDc4dvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bU8Kf/7T; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Rfy7fC9h; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bU8Kf/7T";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Rfy7fC9h"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8EEBA60A1D; Thu, 17 Apr 2025 12:28:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744885735;
	bh=4Zff9CbpB0jsb4kb75On8YckIzTrsURKLrAplUD462k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bU8Kf/7TM7Hu3pKzuHmPwWmvrAW7Wa0C6b33DwrPFdFaPj8HvYblYI7PkKCOlqCHC
	 2K8Q+XoNGWFyYKK2k9uphKyA/Ou9H9ZrtFp5NNpDqMxN9BbHUqGll+timke9FOkDFr
	 NV4znCPA6Ug7ZkeRblBJSh5uRt/qHsfeTQuISyNRDVcUkeHPxxBRDTTQK9pZIZe//u
	 rARlng9Fz1bfM0NB7KE1xJ3R6TyliVoJopXt7ekX+3Udglsj5Ns4zxogrUFkgZvLdp
	 r2mBJXcd4l2Wz4hpyrufvr1OwlEiOsrgBqReyMok1fqby1//a2prIE5oELKrvW+QN4
	 NOsl3SqkipZ1Q==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9D93B60A19;
	Thu, 17 Apr 2025 12:28:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744885733;
	bh=4Zff9CbpB0jsb4kb75On8YckIzTrsURKLrAplUD462k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rfy7fC9h6eEX8aEN+pKKX7wViDTdOF6esCHaMh+ZHIhpi+ydoY7hjfgs4wSyciAj9
	 GCxxc0DzFEHwgnpkiDA8me6VSvtSIMEetKQKj9fVb/UEAA62/Oom1Zn417+dYBo3vH
	 bjgSgBlr5P/0OCnHivGhsUzJ2gtxj/3iqQ1haLnTgAcLvoGGxg9p+FbhXTQgLMXS5p
	 rTHouu9ShGV05SxfP9gwIFvDuKNyPHXNOJ9NHEqQaEqg+9T+mSzSePGC5R4v0OCjBI
	 3hTB6ta3T+uOubfqWdw9l4qu8thDYn6DlSNlkbHF/A0zw45tmGrUNbJiikRXoPwvWx
	 8XXAKCfzkMYNQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 1/1] netfilter: conntrack: fix erronous removal of offload bit
Date: Thu, 17 Apr 2025 12:28:47 +0200
Message-Id: <20250417102847.16640-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250417102847.16640-1-pablo@netfilter.org>
References: <20250417102847.16640-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

The blamed commit exposes a possible issue with flow_offload_teardown():
We might remove the offload bit of a conntrack entry that has been
offloaded again.

1. conntrack entry c1 is offloaded via flow f1 (f1->ct == c1).
2. f1 times out and is pushed back to slowpath, c1 offload bit is
   removed.  Due to bug, f1 is not unlinked from rhashtable right away.
3. a new packet arrives for the flow and re-offload is triggered, i.e.
   f2->ct == c1.  This is because lookup in flowtable skip entries with
   teardown bit set.
4. Next flowtable gc cycle finds f1 again
5. flow_offload_teardown() is called again for f1 and c1 offload bit is
   removed again, even though we have f2 referencing the same entry.

This is harmless, but clearly not correct.
Fix the bug that exposes this: set 'teardown = true' to have the gc
callback unlink the flowtable entry from the table right away instead of
the unintentional defer to the next round.

Also prevent flow_offload_teardown() from fixing up the ct state more than
once: We could also be called from the data path or a notifier, not only
from the flowtable gc callback.

NF_FLOW_TEARDOWN can never be unset, so we can use it as synchronization
point: if we observe did not see a 0 -> 1 transition, then another CPU
is already doing the ct state fixups for us.

Fixes: 03428ca5cee9 ("netfilter: conntrack: rework offload nf_conn timeout extension logic")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9d8361526f82..9441ac3d8c1a 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -383,8 +383,8 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 void flow_offload_teardown(struct flow_offload *flow)
 {
 	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
-	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
-	flow_offload_fixup_ct(flow);
+	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
+		flow_offload_fixup_ct(flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
@@ -558,10 +558,12 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
-	    nf_flow_custom_gc(flow_table, flow))
+	    nf_flow_custom_gc(flow_table, flow)) {
 		flow_offload_teardown(flow);
-	else if (!teardown)
+		teardown = true;
+	} else if (!teardown) {
 		nf_flow_table_extend_ct_timeout(flow->ct);
+	}
 
 	if (teardown) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
-- 
2.30.2

