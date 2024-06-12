Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7DA1D54B
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2024 13:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718197468; cv=none; b=TrgwnOk1WaKWCktRyH1wP+oEqkpyPxGWkME6o4w3lsJIGJ/MXJ9mHNSwHlYYimFii8nbDQtbebmostDZhPBlNdV6y+NXnW5MUdVzcSwKoDbLVVbR3ID9i+BW4m8terEvtcqUxXLCpkdFuUxpVhAudC785ckxYDqXxUsgv5Kfxj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718197468; c=relaxed/simple;
	bh=639AtpBBgaynNIO2gtHMArIC+kuIq9b+geP7wxUkJIo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Osm8Fj8SYai9CVbIx3HRAn1nFnsoXfN1RspcgPkrAYMTGfoHgldEBo/+urb1o08Aqo67F3yM0WEBvRBm5qOY1iPi5OCAzuXi1vv8th//wjueE1lRgPloQar8UAwiQ77REskJt+UMYQWrePznAYWJZ79RCf2wYB/igK6oKjRiV0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=AVijy/Gq; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="AVijy/Gq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rNV9nQmHbknlDRP71yuS30BfVO+4EJSVXrC3lRb48wY=; b=AVijy/GqjhGHzxgYQ82gxn4JZq
	QB+bjXUcbBPl0CLYClt70pwT+zStY0ZPjAsMIUaNAC6pPPJ5Ao4rzw9mHIr8nxz1M/jwz3RkUMDDY
	wcr6cxPpvRJ+XN5HrBGP9gsCzgM2FIc/b7jC2FzQZm4Ab4YQgtwLtTfAS6+LrPXIzsAzrooS0haB5
	da0UaLlabecWYVCIuxODQpn60pDqPDKkzpahnmTq51TGgjgOoz24xRnoB05OmzrCJMJt6lGVTA+HG
	860BK4IgyvXH7qszpdDcaEL90vHjQzASjHRNDKzMZXG/DGYTruFoYJTz7ZvdfPqQWEVYe5azcbw6J
	FZpnx0KQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sHNHm-000000006cY-0asA
	for netfilter-devel@vger.kernel.org;
	Wed, 12 Jun 2024 14:41:06 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: libxt_sctp: Add an extra assert()
Date: Wed, 12 Jun 2024 14:41:08 +0200
Message-ID: <20240612124109.19837-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The code is sane, but this keeps popping up in static code analyzers.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_sctp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 6e2b2745dcbd5..e8312f0c8abe9 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -7,6 +7,7 @@
  * libipt_ecn.c borrowed heavily from libipt_dscp.c
  *
  */
+#include <assert.h>
 #include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
@@ -354,6 +355,7 @@ print_chunk_flags(uint32_t chunknum, uint8_t chunk_flags, uint8_t chunk_flags_ma
 
 	for (i = 7; i >= 0; i--) {
 		if (chunk_flags_mask & (1 << i)) {
+			assert(chunknum < ARRAY_SIZE(sctp_chunk_names));
 			if (chunk_flags & (1 << i)) {
 				printf("%c", sctp_chunk_names[chunknum].valid_flags[7-i]);
 			} else {
-- 
2.43.0

