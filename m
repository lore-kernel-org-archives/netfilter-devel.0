Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E861C1740
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2024 19:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727812133; cv=none; b=p/RSZbAsRp3jbJoqPtWtqxAL8e/sZnrltNUir5UD6Ew3K9HX3MZY553EhHGFKihhOcEE5ueZ3yQmL/a5XzXM6AXOelfsdjXJZNjqEywFa8U2K2T0GE5i+y7aXbxgHF/GvKj/PWGDiPptr0GdYfWmkczyWrDu1rBWKUfFMkry7YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727812133; c=relaxed/simple;
	bh=iFrWnBdvbOZcQMeX16xTXEixTniZkUC0QBIollIKoGg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=bDCAvtOMnP+iv1gNtmmbErCGgqBIDDc8NCz4CMTeh5md08ajitOP54Xu5Cmf+aSOWW38wwYovW8QStNfSYJhNjz5jQezUsLNT4k5KiVZso5PqHCS6m3t/NZvxij3aJNJxI0FRpiBtjYy0qrPEGZlksOQCszs2O77S5pyB3iG1SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aCIIaDp5; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aCIIaDp5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mQasNn4CImzWIbsDno/Jik716jkl4yTDln3lTHyXLRY=; b=aCIIaDp5w2ZHgfHBlnIcK1jFo6
	BqirS0QnJI94XZ3Lhds4/OkmmBVU5/0CN5b8ZrZu2Ts9lyCZiehzhP+8JkeQ9hxaSloSqb4awiMrR
	qBLtSaMF6pLLTByeAcueQz2d+0KpG3c9DAkxUGTkEV+Dhu0vXwjVoLqFc1nWurMMWscvemg3RX0NJ
	hHtZl0Oo0/8txmksbadIkTq70mqQSuONl3Kc5zNL/FnbhGxXQkAKLAwdG2acduuL20wOJJppA1291
	FNA9KDwKt7Cm9KNbkU7nMT4uQR84FggwBeTjfoDEgExDTOjnB962Sfv5ZDCA43XfG0LTQOtTe86Lb
	h5Kq8esw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1svirY-0000000046e-184v
	for netfilter-devel@vger.kernel.org;
	Tue, 01 Oct 2024 21:48:48 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] tests: shell: Adjust for recent changes in libnftnl
Date: Tue,  1 Oct 2024 21:48:44 +0200
Message-ID: <20241001194844.17817-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

libnftnl commit a96d5a338f24e ("rule: Don't append a newline when
printing a rule") affected nft (and iptables-nft) debug output in that
no extra newline is appended to rule bytecode output anymore. Tolerate
this in the sole test case it breaks by ignoring changes to blank lines.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0 b/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0
index 34802cc26aad4..bfceed4976f18 100755
--- a/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0
+++ b/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0
@@ -343,4 +343,4 @@ filter() {
 	awk '/^table /{exit} /^(  \[|$)/{print}'
 }
 
-diff -u -Z <(filter <<< "$EXPECT") <(nft --debug=netlink list ruleset | filter)
+diff -u -Z -B <(filter <<< "$EXPECT") <(nft --debug=netlink list ruleset | filter)
-- 
2.43.0

