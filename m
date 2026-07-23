Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9B7439F8B
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2026 10:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802933; cv=none; b=elr/UxXip7Fh72xqtTb7QDrsl7OzE96pbL9CsHUaFep4KHCQFouFNfAoej2N01kFHOTrMyKE4YMMfkoWX6UzePNHl+ibaWrdAmUXX0YQhIOWaV15ZgW2IdX7bviGN+861HjkrvhgGEoNEK2LkDZRUujRuwnZAuC39vuzyZHPYNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802933; c=relaxed/simple;
	bh=S9OmasRYd5xskDx4kAa/AUU2lZ39/55FOKW3/0cEDs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leirEnoPu7QFf4qDNRfe/xFucBGBj2ZVS7IC7m+YqAEZQgqNcAN1/VhyyxtTK4vzO/o9B2tjcNARlQiiRiFUUUePS4p8EKn8fPgiiKzkW7WyX8Je7uFPFyLVdrW1+kpX74THy+FEgKy06ZSmJg3oDK22+zeOW113dq4pNC60HeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 742B460EA5; Thu, 23 Jul 2026 12:35:27 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: kadlec@netfilter.org
Cc: <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 3/5] tests: prefer diff -u to cmp
Date: Thu, 23 Jul 2026 12:35:02 +0200
Message-ID: <20260723103504.3175-4-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723103504.3175-1-fw@strlen.de>
References: <20260723103504.3175-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Irrelevant when things are working as expected, but is beneficial when they
are not: diff -u is much easier to decipher than: "differ, byte x line y"

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/iphash.t  | 8 ++++----
 tests/restore.t | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tests/iphash.t b/tests/iphash.t
index c7c0b081e34a..e4386bbf6f52 100644
--- a/tests/iphash.t
+++ b/tests/iphash.t
@@ -33,13 +33,13 @@
 # IP: Restore values so that rehashing is triggered, old format
 0 ipset -R < iphash.t.restore.old
 # IP: Check that all values are restored
-0 (grep add iphash.t.restore | sort > "$IPSET_TMP/.foo.1") && (ipset -S test | grep add | sort > "$IPSET_TMP/.foo.2") && cmp "$IPSET_TMP/"{.foo.1,.foo.2}
+0 (grep add iphash.t.restore | sort > "$IPSET_TMP/.foo.1") && (ipset -S test | grep add | sort > "$IPSET_TMP/.foo.2") && diff -u "$IPSET_TMP/"{.foo.1,.foo.2}
 # IP: Delete test set
 0 ipset -X test
 # IP: Restore values so that rehashing is triggered
 0 ipset -R < iphash.t.restore
 # IP: Check that all values are restored
-0 (grep add iphash.t.restore | sort > "$IPSET_TMP/.foo.1") && (ipset -S test | grep add | sort > "$IPSET_TMP/.foo.2") && cmp "$IPSET_TMP/"{.foo.1,.foo.2}
+0 (grep add iphash.t.restore | sort > "$IPSET_TMP/.foo.1") && (ipset -S test | grep add | sort > "$IPSET_TMP/.foo.2") && diff -u "$IPSET_TMP/"{.foo.1,.foo.2}
 # IP: Flush test set
 0 ipset -F test
 # IP: Delete test set
@@ -55,7 +55,7 @@
 # IP: Save sets
 0 ipset -s -f "$IPSET_TMP/.foo0" save && ./ignore.sh "$IPSET_TMP/.foo0"
 # IP: Compare sorted save and restore
-0 cmp "$IPSET_TMP/.foo" iphash.t.restore.sorted
+0 diff -u "$IPSET_TMP/.foo" iphash.t.restore.sorted
 # IP: Delete test set
 0 ipset x test
 # IP: Delete test2 set
@@ -65,7 +65,7 @@
 # IP: Save the restored set
 0 (ipset save test | sort > "$IPSET_TMP/.foo.1") && ./ignore.sh "$IPSET_TMP/.foo.1"
 # IP: Compare save and restore
-0 (sort iphash.t.large > "$IPSET_TMP/.foo.2") && (cmp "$IPSET_TMP/.foo" "$IPSET_TMP/.foo.2")
+0 (sort iphash.t.large > "$IPSET_TMP/.foo.2") && (diff -u "$IPSET_TMP/.foo" "$IPSET_TMP/.foo.2")
 # IP: Delete all elements, one by one
 0 ipset list test | sed '1,/Members/d' | xargs -n1 ipset del test
 # IP: Delete test set
diff --git a/tests/restore.t b/tests/restore.t
index 02da4465af94..dddd72481784 100644
--- a/tests/restore.t
+++ b/tests/restore.t
@@ -1,7 +1,7 @@
 # Check multi-set restore
 0 ipset restore < restore.t.multi
 # Save sets and compare
-0 ipset save > "$IPSET_TMP/.foo" && diff restore.t.multi.saved "$IPSET_TMP/.foo"
+0 ipset save > "$IPSET_TMP/.foo" && diff -u restore.t.multi.saved "$IPSET_TMP/.foo"
 # Delete all sets
 0 ipset x
 # Check auto-increasing maximal number of sets
-- 
2.54.0

