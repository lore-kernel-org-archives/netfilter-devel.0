Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AAB770E8
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Sep 2024 12:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726058477; cv=none; b=cRUV/zzHIf8lvhrgOc8S3A1lGJNdqleB67CVS7nDtg8MKSeSyKxnc/89c8sAh7gqtaQHhsPEswJhYU3rmz+OkdCWSt9nLxUw/Dw6RmIX2YdRzDcMcklpZqhtevwTKBOuWRiFWrrSyJhOH9puXjBXyIiysY13EOsE3o0hBCo2G7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726058477; c=relaxed/simple;
	bh=G0tfpoPLJK/lhxYKTzL8Jy6J1jKpjAmhqA97FvgEebQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c0irkLhk+d/ddsPOf082xiPjFHWO8wb4VQgUgsAKHDOqJayYoamo42l1kkduSKUEVzGg9KRJmtnuB9aGFppYCWOfNjchqk1bO+7lzuQyTvliUKSeuklWQSGBkpaBV09dB4C+HSPs/fubQtVOd9HzYvgQF1+qq3jsq/DL3eKQ28U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1soMem-0002K4-QU; Wed, 11 Sep 2024 14:41:12 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: py: fix up udp csum fixup output
Date: Wed, 11 Sep 2024 14:24:31 +0200
Message-ID: <20240911122435.8994-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Preceeding commit switched udp to use the inkernel csum parser, so tests
warn:

WARNING: line 7: 'add rule ip test-ip4 input iif "lo" udp checksum set 0':
'[ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 csum_flags 0x0 ]' mismatches
'[ payload write reg 1 => 2b @ transport header + 6 csum_type 0 csum_off 0 csum_flags 0x1 ]'

Fixes: f89abfb4068d ("proto: use NFT_PAYLOAD_L4CSUM_PSEUDOHDR flag to mangle UDP checksum")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/inet/udp.t.payload | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/py/inet/udp.t.payload b/tests/py/inet/udp.t.payload
index e6beda7f61fd..32f7f8c3f564 100644
--- a/tests/py/inet/udp.t.payload
+++ b/tests/py/inet/udp.t.payload
@@ -236,7 +236,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ immediate reg 1 0x00000000 ]
-  [ payload write reg 1 => 2b @ transport header + 6 csum_type 1 csum_off 6 csum_flags 0x0 ]
+  [ payload write reg 1 => 2b @ transport header + 6 csum_type 0 csum_off 0 csum_flags 0x1 ]
 
 # iif "lo" udp dport set 65535
 inet test-inet input
@@ -245,4 +245,4 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ immediate reg 1 0x0000ffff ]
-  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 6 csum_flags 0x0 ]
+  [ payload write reg 1 => 2b @ transport header + 2 csum_type 0 csum_off 0 csum_flags 0x1 ]
-- 
2.44.2

