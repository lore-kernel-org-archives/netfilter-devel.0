Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058FF1DED5A
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 11:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730201392; cv=none; b=AianZ04TIclCWoc7tHpAAHyb7CyFKBItNb0RoU5kVv0HgLJ3EcHtBXGoMnrAiiABMTNfCRCunXjfqG6+NIYjqXoBipM6trAA/W421rJb5bI6iFi8ppmTPuE4XyP8VDpV/GTUTk07Py3clmsOmqXjXYLHf8deiREU17t4N9GsKw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730201392; c=relaxed/simple;
	bh=pKsAV2ZC+8Pp+ERKhMt23qrI1Fcqwrg1fBclJdL5qcc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=i/PZmXg3gCxd9lfM/1gW+9VZ/5ZuWqjDcc1hdlhQYW/4voUZZfT1s3npElbf0NUqyJr9CSIr+Q5sRtEpien/sJ21HhLErso/OjJBrd1bn6mAd0T2Anzehb2RJ/P3HqQbBHtZGZGGeQAhBo6mTEiuVO02eLdFXQci1jGoeoYgaVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=koYErdIy; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="koYErdIy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=f5BWkhB3vSi/fYYZI5Lu3kMXSVztIajAMINjNPv1A38=; b=koYErdIyVDYrHgVShwEioV5ilQ
	P1dhCgOp42B/HyIZctZ3qkSDBxqbtM5a6X/5i/AGaCHOj31NXtWVUOvABmltNZOn2+d2kGqN3z8tF
	Mt/JdkzarsXZsqLxK1VOyFxRtlSPWYbB5c6vsUS8MCKRve1U1yYKpikTOXnZTGvChi0+gFIkFstID
	U58HHlCqHADT5YtLRCMTGfy3zIhbFlIODHMEKJX9x1X5KgQDpHl/b/O4K2kgUuZoaxkC/7Yd6aTmq
	BMFlbcEeNEvpITgJmvwlkR1SjSCxItZHLw7FJ9bvQhIoJ9pbVtYtfqmkK8YxnafCW2q02K4F2uYAP
	mG0ZsyFQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t5kPt-000000006aP-2yDt
	for netfilter-devel@vger.kernel.org;
	Tue, 29 Oct 2024 12:29:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] tests: shell: Fix for 'make distcheck'
Date: Tue, 29 Oct 2024 12:29:38 +0100
Message-ID: <20241029112938.19873-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The target performs a "VPATH build", so built binaries are not put into
the same directory tree as the test script itself. For lack of a better
way to detect this, assume $PWD in this situation remains being the
build tree's TLD and check if binaries are present in there.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/tests/shell/run-tests.sh | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/iptables/tests/shell/run-tests.sh b/iptables/tests/shell/run-tests.sh
index 1125690583b46..2ad259c21644c 100755
--- a/iptables/tests/shell/run-tests.sh
+++ b/iptables/tests/shell/run-tests.sh
@@ -87,6 +87,17 @@ if [ "$HOST" != "y" ]; then
 	XTABLES_LEGACY_MULTI="$(dirname $0)/../../xtables-legacy-multi"
 
 	export XTABLES_LIBDIR=${TESTDIR}/../../../extensions
+
+	# maybe this is 'make distcheck' calling us from a build tree
+	if [ ! -e "$XTABLES_NFT_MULTI" -a \
+	     ! -e "$XTABLES_LEGACY_MULTI" -a \
+	     -e "./iptables/xtables-nft-multi" -a \
+	     -e "./iptables/xtables-legacy-multi" ]; then
+		msg_warn "Running in separate build-tree, using binaries from $PWD/iptables"
+		XTABLES_NFT_MULTI="$PWD/iptables/xtables-nft-multi"
+		XTABLES_LEGACY_MULTI="$PWD/iptables/xtables-legacy-multi"
+		export XTABLES_LIBDIR="$PWD/extensions"
+	fi
 else
 	XTABLES_NFT_MULTI="xtables-nft-multi"
 	XTABLES_LEGACY_MULTI="xtables-legacy-multi"
-- 
2.47.0

