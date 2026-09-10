Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E783128B6;
	Thu, 10 Sep 2026 00:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789000742; cv=none; b=KAwb5FeYP36twHtokFpSgmQeQsREw6t7wQNvMmH14BXiKw6FOuePe6Dor2AkZQ+UlV+IC7AgTJr6j/jJAnbCGncbuFaXzrPzbnVnzacaXwTkT74ERztXY2pqylobqJR48OU5irt6ohFcX+gmtamFOrHud2ll0blNMZBPs/e4gWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789000742; c=relaxed/simple;
	bh=MPOLRi1v1RgERTL4UNzEiKtF1A3h0doVVeKx2ZF7kgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaCCQcTP7s8y8lYc3fjcEfqOjHWfClusQENb94u4hvJwnX+JsoPDBiP7K0Ga+83Dm9Rb1YsZWiU+HZHmemCQStx65nJHSpsbkqs1EHaxygsV2u/zcLN8bTeTxQ29r6RQrhzlsIv/u9vblmi7p8VHRkLYRF+BlNtVYabbpABNTg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MmJTbwtt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MmJTbwtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4140D1F0089A;
	Thu, 10 Sep 2026 00:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789000741;
	bh=BjCh3h/bIG3klQVY1szsDy+8FPDqAo0zXHtBtldez04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MmJTbwttgxhECDUVPSgQDR817NQMolZJyGHgOuHjVwkKzfna5t2+qE6Ovg7euctNq
	 AVfIVrdxt2DlVY3NeJlQFheMPWRa3nf0UFaQnFTPAqiI5l1C2rzrsvpHIRqbPVAvlz
	 RFugdueVKdxqdLKfx33LGh+vks43hv2AO69jIgly7EH/iM4JlvDIQ5ukiTx74yYTTN
	 jcktvoNVl0xKh0wYBVTXtOCQXL9GzT3101ekr1qm+hT2c1vX8tfMED103AiCSoHWpl
	 LZVtT1OphKasdWOJZUcosJQrbnwRrck3GIdgGEQGO8ItqIzYXFm/xqvU3fWGD034EB
	 EwSEsiYtJxo1w==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	donald.hunter@gmail.com,
	ast@fiberby.net,
	i.maximets@ovn.org,
	one-d-wide@protonmail.com,
	fw@strlen.de,
	pablo@netfilter.org,
	netfilter-devel@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 6/7] netlink: specs: conntrack: fix the per-CPU stats reply
Date: Wed,  9 Sep 2026 17:38:50 -0700
Message-ID: <20260910003852.2184031-7-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910003852.2184031-1-kuba@kernel.org>
References: <20260910003852.2184031-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ctnetlink_ct_stat_cpu_fill_info() emits CTA_STATS_INVALID but
does not emit CTA_STATS_SEARCHED. Update the attr list, and
remove the false annotation of invalid as obsolete.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/conntrack.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/specs/conntrack.yaml b/Documentation/netlink/specs/conntrack.yaml
index ec90d3d05841..9ba93370275d 100644
--- a/Documentation/netlink/specs/conntrack.yaml
+++ b/Documentation/netlink/specs/conntrack.yaml
@@ -530,7 +530,7 @@ doc: >-
         name: invalid
         type: u32
         byte-order: big-endian
-        doc: obsolete
+        doc: packets which could not be tracked
       -
         name: ignore
         type: u32
@@ -661,8 +661,8 @@ doc: >-
         reply:
           value: 0x104
           attributes:
-            - searched
             - found
+            - invalid
             - insert
             - insert-failed
             - drop
-- 
2.55.0

