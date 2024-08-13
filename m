Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE641DDF4
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2024 19:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723577780; cv=none; b=Q9ZXun3BLhrT6SWE6yp4vlqfP60EphapspFVb7gLG2+r6NwfIoi+UTBdjV0h9ldqy2iqycB+Asxo72thFEZtG6qLyE2Zae4ILUWl1T2/bd9XDwOodM76Nl2IW6H1Q+bjZMY5O+i2oC/RiPrKPMhe/9ZbBsWNLIWDnxmL7E2rgQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723577780; c=relaxed/simple;
	bh=4+fc9bwjrrW4geqdwAZm/yMb/x1+JcXbQ43GeeXjYxY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JfxQ4sxVAqrS0cvhCH4Dr5JdgR/5VMQCwMt24+VAaaYKRhy4NOWo0b6ORG5l1QsmY6UnLyFegV+/P61YWDIHdgD1WiA1fP40wTbnOm0OC0JzrdXa+HimVitK4thlp1K96HteBcbPJTWMfR/X3reBch8Ek9QDTHKGbhZJy43htAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fq85BPmg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fq85BPmg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=O6bSyFsjonrH4muFiiOUV1ticHLSNp/e6yj6YcNxiz4=; b=fq85BPmgfn309PibOR0x90LJEz
	jmogjCfLOZ63+QN0VIo7HpwvtJD/YWVqhH1D3qs7QR7reenuGBX5sygsBEMKkstBSqjTrI3aPMq6R
	axMr15VIdJba2bke9cr3fVlM3sel4pD0ii55mAbobWLj7W4Ifgnxp7gJn/rf41yMXRRtmy9NmVHez
	Hdgo6IJCU7hYMsQhYNY/y28e6VKpKH1tB8Y75Zh5XzANPB5+dIPsnMCw7wYhEyaNSKOsGi9DeKhtH
	IrNG11Z+jhRRFoc8JNn5tiGTPQm94oiw4XIwHGZHM1hAFcZhiNFKHuG0dsHkbFjN1e4MSJlkrQNFm
	3I+wzIoQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sdxJX-000000005ts-21dB;
	Tue, 13 Aug 2024 21:36:15 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: shell: Extend table persist flag test a bit
Date: Tue, 13 Aug 2024 21:36:11 +0200
Message-ID: <20240813193611.14529-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Using a co-process, assert owner flag is effective.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/owner/0002-persist      | 42 +++++++++++++++++++
 .../owner/dumps/0002-persist.json-nft         |  8 ----
 .../testcases/owner/dumps/0002-persist.nft    |  3 --
 3 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/tests/shell/testcases/owner/0002-persist b/tests/shell/testcases/owner/0002-persist
index cf4b8f1327ec1..98a8eb1368bc1 100755
--- a/tests/shell/testcases/owner/0002-persist
+++ b/tests/shell/testcases/owner/0002-persist
@@ -33,4 +33,46 @@ EOF
 	die "retake ownership failed"
 }
 
+EXPECT="table ip t {
+	flags persist
+}"
+diff -u <(echo "$EXPECT") <($NFT list ruleset) || {
+	die "unexpected ruleset before coproc setup"
+}
+
+coproc $NFT -i
+sleep 1
+
+cat >&"${COPROC[1]}" <<EOF
+add table ip t { flags owner, persist; }
+EOF
+
+EXPECT="table ip t { # progname nft
+	flags owner,persist
+}"
+diff -u <(echo "$EXPECT") <($NFT list ruleset) || {
+	die "unexpected ruleset after coproc setup"
+}
+
+$NFT flush ruleset
+$NFT list ruleset | grep -q 'table ip t' || {
+	die "flushed owned table"
+}
+
+$NFT add table 'ip t { flags owner, persist; }' && {
+	die "stole owned table"
+}
+
+cat >&"${COPROC[1]}" <<EOF
+delete table ip t
+EOF
+
+[[ -z $($NFT list ruleset) ]] || {
+	die "owner should be able to delete the table"
+}
+
+eval "exec ${COPROC[1]}>&-"
+wait $COPROC_PID
+
+
 exit 0
diff --git a/tests/shell/testcases/owner/dumps/0002-persist.json-nft b/tests/shell/testcases/owner/dumps/0002-persist.json-nft
index f0c336a86e52f..546cc5977db61 100644
--- a/tests/shell/testcases/owner/dumps/0002-persist.json-nft
+++ b/tests/shell/testcases/owner/dumps/0002-persist.json-nft
@@ -6,14 +6,6 @@
         "release_name": "RELEASE_NAME",
         "json_schema_version": 1
       }
-    },
-    {
-      "table": {
-        "family": "ip",
-        "name": "t",
-        "handle": 0,
-        "flags": "persist"
-      }
     }
   ]
 }
diff --git a/tests/shell/testcases/owner/dumps/0002-persist.nft b/tests/shell/testcases/owner/dumps/0002-persist.nft
index b47027d35a30c..e69de29bb2d1d 100644
--- a/tests/shell/testcases/owner/dumps/0002-persist.nft
+++ b/tests/shell/testcases/owner/dumps/0002-persist.nft
@@ -1,3 +0,0 @@
-table ip t {
-	flags persist
-}
-- 
2.43.0

