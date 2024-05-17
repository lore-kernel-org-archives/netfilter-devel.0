Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7A1524A5
	for <netfilter-devel@vger.kernel.org>; Fri, 17 May 2024 13:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715952308; cv=none; b=aN1Xf92+jiz/lTpuuc/YC0dRVh/QZDuq7E56qbO+ROESqTT/WqcV5AbeP+ABKT2WjR42XunV7l/SGpxcB3XrcucAdKEjxhgkKryZMLsGCtTlouUcJd2lswGWLz5Cv7XVaET1bFko9auU/GC2ctn1fcRybxx6j9oxkgDxGeDumOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715952308; c=relaxed/simple;
	bh=639AtpBBgaynNIO2gtHMArIC+kuIq9b+geP7wxUkJIo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=n2Ajc1rX7am73EK2YB9olkGRMPPkTS/Ogh9lceOfatTJVDea/DzrRCmJoEqz2wqI2G2gJVuufX4cRPqGwrv2ZEljJi8I1MuBnXz/0T+rVGOyfX3N7LpolOyXb+O/wWH/RuTB9hDOMCPpNUvFl0c5db3DuOuUTt0mpQi3y9GlC20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=i6cwjwHo; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="i6cwjwHo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rNV9nQmHbknlDRP71yuS30BfVO+4EJSVXrC3lRb48wY=; b=i6cwjwHo8WnGBl2N4xZGzdk84b
	KXeglpRiTvN3xuvHHof8r4SRaKBTx5UU4z/9vixquoTO6vSrr5aqqzGUqifFSKW6igiAN4Oej48TF
	OoA32uYYTuIVUbpj/sV826IDGq2YGe4OsIiMsLDiekRCPT7IBtZQCBfmJFfap2Sj2Ji6RpgOhBVIt
	HJbg20h7nK3Juoor/MamOBstaiajQyQjc2saFYC0doRKb3qH28O+PXeZrL0KLslq/yaK4SUnpNrzh
	Dcsz9kg0jb9LKxRlvJCRYUMBRphmijfFyr+Xu0qDlQ41c5WMhasEUOUxU8jwmGpJlaKzla/vkiUjo
	yHInZrbA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s7xa5-000000001pg-2pB7
	for netfilter-devel@vger.kernel.org;
	Fri, 17 May 2024 15:25:05 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: libxt_sctp: Add an extra assert()
Date: Fri, 17 May 2024 15:25:06 +0200
Message-ID: <20240517132506.29679-1-phil@nwl.cc>
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

