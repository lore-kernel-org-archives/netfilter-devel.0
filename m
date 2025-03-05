Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CA415746E
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 15:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741187219; cv=none; b=Oj6ySilblM+AExLcBUekOx9RsjMovps2McTA1JclqVoAFd0WxWtjbDeO4WR+s+HAYeRpXxqh3z4txtFQBHpxkStaGNvZCmPxO2GneJAGiBDajKU8Xa4aw3dCuWN/ilV3QDMs8YTlBzsb/UXcNdGqsQeO4EUOQgOLwodqPKMOFRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741187219; c=relaxed/simple;
	bh=MzzjJGLqVQ3QwPRM74iB+H5LkBJ3Id8/KBPkKbKmUqI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CdiL5wnozTwXKpS7jD/g8R1vB0U/TQbmrjLAtO4oWQJJoMQRxUYknChjBE6TlfApIF2eKqVlrKn5KNs97Dy5xHgTCUi6+lj9MRP6HsTb06MHG6voRshPXZsfDf6dmMy4vHSzcqhySn0+AtRS/yDPi6UPxP4VhRWTFQbXS9+zmLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tpqKf-0008UJ-6r; Wed, 05 Mar 2025 16:06:49 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] segtree: fix string data initialisation
Date: Wed,  5 Mar 2025 16:01:48 +0100
Message-ID: <20250305150154.19494-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This uses the wrong length.  This must re-use the length of the datatype,
not the string length.

The added test cases will fail without the fix due to erroneous
overlap detection, which in itself is due to incorrect sorting of
the elements.

Example error:
 netlink: Error: interval overlaps with an existing one
 add element inet testifsets simple_wild {  "2-1" } failed.
 table inet testifsets {
      ...       elements = { "1-1", "abcdef*", "othername", "ppp0" }

... but clearly "2-1" doesn't overlap with any existing members.
The false detection is because of the "acvdef*" wildcard getting sorted
at the beginning of the list which is because its erronously initialised
as a 64bit number instead of 128 bits (16 bytes / IFNAMSIZ).

Fixes: 5e393ea1fc0a ("segtree: add string "range" reversal support")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/segtree.c                                |  2 +-
 tests/shell/testcases/sets/sets_with_ifnames | 62 ++++++++++++++++++++
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index 2e32a3291979..11cf27c55dcb 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -471,7 +471,7 @@ static struct expr *interval_to_string(struct expr *low, struct expr *i, const m
 
 	expr = constant_expr_alloc(&low->location, low->dtype,
 				   BYTEORDER_HOST_ENDIAN,
-				   (str_len + 1) * BITS_PER_BYTE, data);
+				   len * BITS_PER_BYTE, data);
 
 	return __expr_to_set_elem(low, expr);
 }
diff --git a/tests/shell/testcases/sets/sets_with_ifnames b/tests/shell/testcases/sets/sets_with_ifnames
index a4bc5072938e..c65499b76bc5 100755
--- a/tests/shell/testcases/sets/sets_with_ifnames
+++ b/tests/shell/testcases/sets/sets_with_ifnames
@@ -105,10 +105,67 @@ check_matching_icmp_ppp()
 	fi
 }
 
+check_add_del_ifnames()
+{
+	local what="$1"
+	local setname="$2"
+	local prefix="$3"
+	local data="$4"
+	local i=0
+
+	for i in $(seq 1 5);do
+		local cmd="element inet testifsets $setname { "
+		local to_batch=16
+
+		for j in $(seq 1 $to_batch);do
+			local name=$(printf '"%x-%d"' $i $j)
+
+			[ -n "$prefix" ] && cmd="$cmd $prefix . "
+
+			cmd="$cmd $name"
+
+			[ -n "$data" ] && cmd="$cmd : $data"
+
+			if [ $j -lt $to_batch ] ; then
+				cmd="$cmd, "
+			fi
+		done
+
+		cmd="$cmd }"
+
+		if ! $NFT "$what" "$cmd"; then
+			echo "$what $cmd failed."
+			$NFT list set inet testifsets $setname
+			exit 1
+		fi
+
+		if ! ip netns exec "$ns1" $NFT "$what" "$cmd"; then
+			echo "$ns1 $what $cmd failed."
+			ip netns exec "$ns1" $NFT list set inet testifsets $setname
+			exit 1
+		fi
+	done
+}
+
+check_add_ifnames()
+{
+	check_add_del_ifnames "add" "$1" "$2" "$3"
+}
+
+check_del_ifnames()
+{
+	check_add_del_ifnames "delete" "$1" "$2" "$3"
+}
+
 ip netns add "$ns1" || exit 111
 ip netns add "$ns2" || exit 111
 ip netns exec "$ns1" $NFT -f "$dumpfile" || exit 3
 
+check_add_ifnames "simple" "" ""
+check_add_ifnames "simple_wild" "" ""
+check_add_ifnames "concat" "10.1.2.2" ""
+check_add_ifnames "map_wild" "" "drop"
+
 for n in abcdef0 abcdef1 othername;do
 	check_elem simple $n
 done
@@ -150,3 +207,8 @@ ip -net "$ns2" addr add 10.1.2.2/24 dev veth0
 ip -net "$ns2" addr add 10.2.2.2/24 dev veth1
 
 check_matching_icmp_ppp
+
+check_del_ifnames "simple" "" ""
+check_del_ifnames "simple_wild" "" ""
+check_del_ifnames "concat" "10.1.2.2" ""
+check_del_ifnames "map_wild" "" "drop"
-- 
2.48.1

