Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704B2277035
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2026 11:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768218707; cv=none; b=tSqP94xNiUWUIxZkcoqa1ndkPCtx7+pV/hAa2bQ280PmaxTY00lpoD75xyamHI5GASpNxCBf1beyNDsXTAGOglqzLmSyqgwpU6z4ak+hUDcPnEU4tm+Y6T+IghwQV/MfBdCoATsovWKN13o6x23m4BiSJbJNQVFTqS8plA5Fp9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768218707; c=relaxed/simple;
	bh=f7eQ4nE4Vo8aQ5L9iR3nVlD9KnjGaJGNDOtqJFWCt+w=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Smn3EElauHgjeoG5gLol3+ahdF3Ej6cuX15u3K0CvnybX+hksh8aMdFp2XSx82BQvF95UV7WGyTLxt+83jOz969kntA/aKdDcYoL0RTqxWU0Up5vVKQj/pPTSqzA97aKB7E/7A6d+qPYv79J9t6fwDHXiCJa1mFFbin8Yd8nLcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=P+Nmg83d; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="P+Nmg83d"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BC2DE600B5
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2026 12:42:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1768218140;
	bh=YzRAOixg7VwKKojR/LAR7tO6gj0uB1t0DTeiUu/B+rE=;
	h=From:To:Subject:Date:From;
	b=P+Nmg83doFOjQt0R4srFAW+2czESjk7qSfDz8eFv4ydwRZgPpuMaup6BfBAu5DYFT
	 148u3eI0jWMDiBRtyH+ak43k9jUSgZIIs++MvPMy5+HfH0dpvDtkjWr9TBK302MORz
	 E3mOVElSSuA04k05sEkvj3pD1i4d9NWVucDjDG9kyNCQv38N9HkVgaRjjTip7PXrsG
	 WjMQhqDjKIbs6vgbRiwUOrpwDYj0NnCVA6E4bFBhTptCL9qt4cRm1Xa5w2pdVIZri9
	 WTxi5WnCnwEzzbp9LvMP8eO2aU2HZ4vdAbkthnBMgmQvcNa9UMhX0I6muxEAAArivj
	 s6/2x1bMeD3Bw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] tests: shell: cover for large interval sets with create command
Date: Mon, 12 Jan 2026 12:42:15 +0100
Message-ID: <20260112114216.305723-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 91dc281a82ea ("src: rework singleton interval transformation to
reduce memory consumption") duplicates singleton interval elements when
the netlink message gets full, this results in spurious EEXIST errors
when creating many elements in a set.

This patch extends the existing test to cover for this bug.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../maps/0004interval_map_create_once_0       | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tests/shell/testcases/maps/0004interval_map_create_once_0 b/tests/shell/testcases/maps/0004interval_map_create_once_0
index 7d3825596c49..965da2d0663a 100755
--- a/tests/shell/testcases/maps/0004interval_map_create_once_0
+++ b/tests/shell/testcases/maps/0004interval_map_create_once_0
@@ -41,6 +41,29 @@ generate_test() {
 	echo -e "$elements"
 }
 
+echo "add table x
+add map x y { type ipv4_addr : ipv4_addr; flags interval; }
+create element x y $(generate_add)" > $tmpfile
+
+set -e
+$NFT -f $tmpfile
+
+EXPECTED="table ip x {
+	map y {
+		type ipv4_addr : ipv4_addr
+		flags interval
+		elements = { "$(generate_test)" }
+	}
+}"
+GET=$($NFT list ruleset)
+if [ "$EXPECTED" != "$GET" ] ; then
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
+
+$NFT flush ruleset
+
+# now try with add element command
 echo "add table x
 add map x y { type ipv4_addr : ipv4_addr; flags interval; }
 add element x y $(generate_add)" > $tmpfile
-- 
2.47.3

