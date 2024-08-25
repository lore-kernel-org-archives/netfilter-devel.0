Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22DB5762DF
	for <netfilter-devel@vger.kernel.org>; Sun, 25 Aug 2024 22:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724626041; cv=none; b=nDG+v+m2Em+ewYc+WP3SxCvvBctAdNFz/G+SNDVEW7U7kWACAAugN+qCkUzF6Qntiscbm/T/aOvE46Xe5vh/aYoAZ+jtoJKvBzD6RhUqIN78JzneU/LOBoLMKdqHNV6AvxKGz8rLSGS48tvh8wgSMMwxj3+1krqXQNXRC3x9HcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724626041; c=relaxed/simple;
	bh=Y1GvYmmoShUdM9Yh61QaSqGdgXhfsMKygB0GtrcSsv8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kIL8N5kRKevJkA/KqhQpp1IiX07Kcslw8tLjFJcoN3gm3v5rDdkbeUNKxWukIE1w8LNHD+I+Td1wZp4+gyMSrKbsM42B64xgsy5jX4hhFvSKsdh0BQ/vMj44pXxLxO6ok/49BQQgVKyprwrWW/wCUQPHMxFgDDF4TkhLjiM+bgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 4/5] tests: shell: cover anonymous set with reset command
Date: Mon, 26 Aug 2024 00:47:06 +0200
Message-Id: <20240825224707.3687-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240825224707.3687-1-pablo@netfilter.org>
References: <20240825224707.3687-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend existing test to reset counters for rules with anonymous set.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1763
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testcases/rule_management/0011reset_0     | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tests/shell/testcases/rule_management/0011reset_0 b/tests/shell/testcases/rule_management/0011reset_0
index 3fede56fb7d8..2004b17d5822 100755
--- a/tests/shell/testcases/rule_management/0011reset_0
+++ b/tests/shell/testcases/rule_management/0011reset_0
@@ -4,6 +4,27 @@
 
 set -e
 
+echo "loading ruleset with anonymous set"
+$NFT -f - <<EOF
+table t {
+        chain dns-nat-pre {
+                type nat hook prerouting priority filter; policy accept;
+                meta l4proto { tcp, udp } th dport 53 ip saddr 10.24.0.0/24 ip daddr != 10.25.0.1 counter packets 1000 bytes 1000 dnat to 10.25.0.1
+        }
+}
+EOF
+
+echo "resetting ruleset with anonymous set"
+$NFT reset rules
+EXPECT='table ip t {
+	chain dns-nat-pre {
+		type nat hook prerouting priority filter; policy accept;
+		meta l4proto { tcp, udp } th dport 53 ip saddr 10.24.0.0/24 ip daddr != 10.25.0.1 counter packets 0 bytes 0 dnat to 10.25.0.1
+	}
+}'
+$DIFF -u <(echo "$EXPECT") <($NFT list ruleset)
+$NFT flush ruleset
+
 echo "loading ruleset"
 $NFT -f - <<EOF
 table ip t {
-- 
2.30.2

