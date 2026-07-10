Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1D6395AF2;
	Fri, 10 Jul 2026 14:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783694282; cv=none; b=WFHKFuCxHiffIsNwUJFMtELtdkpXGSXJ/Xt4+lNbGN7WXo91PZiSatVNPwSfAVdqPOJNwgTjkagOznU4seGBz35+hksYUeK66KWgI0cKIP/uNvvsaiQqCjaVcm6ipJbPqNna+umFv3MovnlTUzUeB4mACOxfvAKfF9iEW76iGeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783694282; c=relaxed/simple;
	bh=ho6b7UqYZeTzSjEoLdR9pW2HnXH+Fkv44alSVEd03ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHCWxLvvpCh7aGFa5M241HvOp/swjwE7IXgM88QVmsiSPRkFzwtD0CRLnIuCPLMD5Og5tLajon3GTMZ6SfBVb7wuBqKfcu5/k1Po4oUyzA0nxv0/9/L7nsntVq4vSqr1ZsBFVX5JCA/GngOGaspe2dXgRk2mYzt6Xm9jqsR/ITc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D625160503; Fri, 10 Jul 2026 16:37:59 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 4/9] netfilter: nf_conncount: fix zone comparison in tuple dedup
Date: Fri, 10 Jul 2026 16:37:28 +0200
Message-ID: <20260710143733.29741-5-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710143733.29741-1-fw@strlen.de>
References: <20260710143733.29741-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

The "already exists" dedup logic in __nf_conncount_add() decides
whether a connection has already been counted and can be skipped instead
of incrementing the connlimit count.  It compares the conntrack zone of a
list entry with the zone of the connection being added using
nf_ct_zone_id() and nf_ct_zone_equal(), passing conn->zone.dir or
zone->dir as the direction argument.

Those helpers take enum ip_conntrack_dir values: IP_CT_DIR_ORIGINAL is 0
and IP_CT_DIR_REPLY is 1.  However, zone->dir is a u8 bitmask:
NF_CT_ZONE_DIR_ORIG is 1, NF_CT_ZONE_DIR_REPL is 2 and
NF_CT_DEFAULT_ZONE_DIR is 3.  Passing that bitmask as the enum direction
shifts the meaning of every non-zero value.  An ORIG-only zone passes 1
and is tested as REPLY, while REPL-only and default zones pass 2 or 3 and
test bits beyond the valid direction range.  In those cases
nf_ct_zone_id() can fall back to NF_CT_DEFAULT_ZONE_ID instead of using
the real zone id, so different zones can be treated as equal and dedup
collapses to tuple equality alone.

nf_conncount stores and compares the original-direction tuple for a
connection.  If an skb already has an attached conntrack entry,
get_ct_or_tuple_from_skb() explicitly copies
ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, regardless of the packet's
ctinfo.  Therefore the zone comparison in the tuple dedup path must use
IP_CT_DIR_ORIGINAL as well; the zone direction bitmask describes where a
zone id applies, not which direction this conncount tuple represents.

Fix the two dedup comparisons by passing IP_CT_DIR_ORIGINAL directly.
Do not special-case NF_CT_DEFAULT_ZONE_DIR and do not compare raw zone
ids: using the existing helpers with IP_CT_DIR_ORIGINAL preserves the
direction-aware NF_CT_DEFAULT_ZONE_ID fallback.  A default bidirectional
zone contains the ORIG bit, so it naturally returns the real zone id;
reply-only zones continue to fall back for original-direction tuple
comparisons.

Fixes: 21ba8847f857 ("netfilter: nf_conncount: Fix garbage collection with zones")
Fixes: b36e4523d4d5 ("netfilter: nf_conncount: fix garbage collection confirm race")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conncount.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 91582069f6d2..e9ea6d9466e7 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -211,8 +211,8 @@ static int __nf_conncount_add(struct net *net,
 			/* Not found, but might be about to be confirmed */
 			if (PTR_ERR(found) == -EAGAIN) {
 				if (nf_ct_tuple_equal(&conn->tuple, &tuple) &&
-				    nf_ct_zone_id(&conn->zone, conn->zone.dir) ==
-				    nf_ct_zone_id(zone, zone->dir))
+				    nf_ct_zone_id(&conn->zone, IP_CT_DIR_ORIGINAL) ==
+				    nf_ct_zone_id(zone, IP_CT_DIR_ORIGINAL))
 					goto out_put; /* already exists */
 			} else {
 				collect++;
@@ -223,7 +223,7 @@ static int __nf_conncount_add(struct net *net,
 		found_ct = nf_ct_tuplehash_to_ctrack(found);
 
 		if (nf_ct_tuple_equal(&conn->tuple, &tuple) &&
-		    nf_ct_zone_equal(found_ct, zone, zone->dir)) {
+		    nf_ct_zone_equal(found_ct, zone, IP_CT_DIR_ORIGINAL)) {
 			/*
 			 * We should not see tuples twice unless someone hooks
 			 * this into a table without "-p tcp --syn".
-- 
2.54.0

