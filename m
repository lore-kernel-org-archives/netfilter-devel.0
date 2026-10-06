Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8BA3DA7D7
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2026 23:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791327909; cv=none; b=e/1mYXv1HTuuICI2ROIqadW3uVBfISAztSoSEKqirCUVG4uQyRQYgQRFv0AE0EWUSKsbyHtp0/6sJyvjW7mQBke1AP5QgIwa8/iD7GGKoEZjhz8EQL/KsCSPolCBkEiktkwiO9nYCmol+i7Pugr0JVu8YatvSgcv771Fp2F46as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791327909; c=relaxed/simple;
	bh=29gWNjOnwR7AUboBoN2RLNeIo7aIHayvmWoHSBQkFdE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bqgCTJoXgttj0e68nVVkL50z3+LDOrwCMc5dZ9ZXiZwvkanedE9OF6OAJP0sGvN29jje7B4xBUDTzEHzanWdCfatU9iIZHuo6Z2WxqOxS2UiNUMh/mK6AFTffQC22z/L4sKHjIdi8qPFM/0Yq6d1hcCAeAaZwVA73f6pVFHrK0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C008D6059E; Wed, 07 Oct 2026 01:05:06 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] selftests: netfilter: fix return value in zone subtest
Date: Wed,  7 Oct 2026 01:04:59 +0200
Message-ID: <20261006230459.2139-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zone subtest prints FAIL, but did not set 'ret=1', so kselftest
framework reports success.

While at it, also fail when "nft -f" returns an error.

Noticed thanks to a (broken) local patch that should have caused this
selftest (resp. the kselftest framework) to report a failure.

Fixes: 33b8aad21ac1 ("selftests: netfilter: add a vrf+conntrack testcase")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Can also go via nf, I don't mind either way.

 .../selftests/net/netfilter/conntrack_vrf.sh  | 25 ++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_vrf.sh b/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
index 207b79932d91..2dbfabaadf4b 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
@@ -84,7 +84,7 @@ busywait $BUSYWAIT_TIMEOUT listener_ready "$ns1"
 # as decided by the first iteration of the ruleset.
 test_ct_zone_in()
 {
-ip netns exec "$ns0" nft -f - <<EOF
+if ! ip netns exec "$ns0" nft -f - <<EOF
 table testct {
 	chain rawpre {
 		type filter hook prerouting priority raw;
@@ -105,6 +105,12 @@ table testct {
 	}
 }
 EOF
+	then
+		echo "FAIL: cannot load testct nft ruleset"
+		ret=1
+		return
+	fi
+
 	ip netns exec "$ns1" ping -W 1 -c 1 -I veth0 "$IP0" > /dev/null
 
 	# should be in zone 1, not zone 2
@@ -113,6 +119,7 @@ EOF
 		echo "PASS: entry found in conntrack zone 1"
 	else
 		echo "FAIL: entry not found in conntrack zone 1"
+		ret=1
 		count=$(ip netns exec "$ns0" conntrack -L -s $IP1 -d $IP0 -p icmp --zone 2 2> /dev/null | wc -l)
 		if [ "$count" -eq 1 ]; then
 			echo "FAIL: entry found in zone 2 instead"
@@ -137,7 +144,7 @@ test_masquerade_vrf()
 
 	ip netns exec "$ns0" conntrack -F 2>/dev/null
 
-ip netns exec "$ns0" nft -f - <<EOF
+if ! ip netns exec "$ns0" nft -f - <<EOF
 flush ruleset
 table ip nat {
 	chain rawout {
@@ -158,6 +165,12 @@ table ip nat {
 	}
 }
 EOF
+	then
+		echo "FAIL: cannot load ip nat nft ruleset"
+		ret=1
+		return
+	fi
+
 	if ! ip netns exec "$ns0" ip vrf exec tvrf socat -u -4 STDIN TCP:"$IP1":55555 < /dev/null > /dev/null;then
 		echo "FAIL: connect failure with masquerade + sport rewrite on vrf device"
 		ret=1
@@ -184,7 +197,7 @@ EOF
 test_masquerade_veth()
 {
 	ip netns exec "$ns0" conntrack -F 2>/dev/null
-ip netns exec "$ns0" nft -f - <<EOF
+if ! ip netns exec "$ns0" nft -f - <<EOF
 flush ruleset
 table ip nat {
 	chain postrouting {
@@ -193,6 +206,12 @@ table ip nat {
 	}
 }
 EOF
+	then
+		echo "FAIL: cannot load ip nat postrouting ruleset"
+		ret=1
+		return
+	fi
+
 	if ! ip netns exec "$ns0" ip vrf exec tvrf socat -u -4 STDIN TCP:"$IP1":55555 < /dev/null > /dev/null;then
 		echo "FAIL: connect failure with masquerade + sport rewrite on veth device"
 		ret=1
-- 
2.55.0

