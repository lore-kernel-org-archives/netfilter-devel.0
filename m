Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0266730C359
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 12:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773319741; cv=none; b=JHJois60sBDMpiPfBsteErB6gbxeok+am8vmtL0/4QJEebSI81f/SOxDCWE7enaGmjyeklRdjV6p9gHR4HoaRkg5tSsQ8TGw8TYhgx5B6I1/5LNZ6kB0cv/2SWTo09FtGrye57AcJsIGpxMXO+JZ6X3jQLdwJVBB585watFx5EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773319741; c=relaxed/simple;
	bh=yMg35xkTXGqlv0tIWfCTvKH3CJraFyU0g/c44q0k66Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnRbQE6Fg6b5qDbtktnTKQhuD/eoAGm71UOWSZvpf3a+SaH53/pfBHbIh+6G8+5sSteUKtmGygbViAYdO+M4mgav8eMq/Mf1MnjPvC7FqBKoakLlYXPVr4HRVpxGdPZUK7f4QIRyptXvpbutFZM2QhM/Gbn03nKOz9sqGfZ92HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XZIreaCf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XZIreaCf"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D09C160567
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 13:48:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773319732;
	bh=yYQsv6eKTQajv0O+O5OZSEYUko/mMhcLLlOjC1dzauI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XZIreaCfpmQrgTO/eQcoX9xTqlsbI8QLbkW9uYbdMbNs6zZpmo5lVpzSM+uz6fsk+
	 ELG2g4Ky+F32K2YGSGZhwCyb1G609q6XfHFrY9kM8bq/Lzf0qp4Cz/d+frB3Bq/tRN
	 OCk4AKJ55fIAnpLXsa0HalufhTlrp33RBWiAx3agW0PLJLt/DFpMpjURgtCrcD+Q/M
	 Zw2XoIkdZ/KNzllMGJm8J9vhJZMLFI6dw8Kris5qdOFjWT7RsdV3o4IrH7o3/7fUQo
	 0nFXVMpAnW0/xiTUXq2FXsJc9QhIszny8rJCCdP1Bqfpp91ozyQ6bcsH9fyEX4K30n
	 Ju/NyQ4ibzYgA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/2] netfilter: xt_CT: drop pending enqueued packets on template removal
Date: Thu, 12 Mar 2026 13:48:48 +0100
Message-ID: <20260312124848.3532943-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260312124848.3532943-1-pablo@netfilter.org>
References: <20260312124848.3532943-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Templates refer to objects that can go away while packets are sitting in
nfqueue refer to:

- helper, this can be an issue on module removal.
- timeout policy, nfnetlink_cttimeout might remove it.

The use of templates with zone and event cache filter are safe, since
this just copies values.

Flush these enqueued packets in case the template rule gets removed.

Fixes: 24de58f46516 ("netfilter: xt_CT: allow to attach timeout policy + glue code")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I don't remember what email reported this.

Compile-tested only.

 net/netfilter/xt_CT.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 3ba94c34297c..498f5871c84a 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -16,6 +16,7 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_zones.h>
+#include "nf_internals.h"
 
 static inline int xt_ct_target(struct sk_buff *skb, struct nf_conn *ct)
 {
@@ -283,6 +284,9 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
 	struct nf_conn_help *help;
 
 	if (ct) {
+		if (info->helper[0] || info->timeout[0])
+			nf_queue_nf_hook_drop(par->net);
+
 		help = nfct_help(ct);
 		xt_ct_put_helper(help);
 
-- 
2.47.3

