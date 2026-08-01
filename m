Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA7A36A375
	for <netfilter-devel@vger.kernel.org>; Sat,  1 Aug 2026 07:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785569275; cv=none; b=d+QkKg64YmrhtwVEqrK71VvAVYvrEjo6/Ie1boh3kKg0cQlHaN8Yzd1Vs9Ka1k9ZhsbKUq5GmL9pioplZtWuAOwmoZNmTD6SsaFvRh73ZYScpnJ6JO+OpFxAvCnDJzfAZCMqNqQKiHJv+71lBIvzG3iS5p8psZ0k0Nu5O0a+Ung=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785569275; c=relaxed/simple;
	bh=uAjwjrqf/HHQ7RfHy1Puelw0qU8HeCnJ3t+U2ACHGqc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dCo/p+Nitj0gQOjlFOIbNIRj2dOibY3kUY/X5RhVc83F9yq9iupW1YW+CWvVxnulemEpxS+mJFaF1BLUCXeEBcu+92uo+hYmzvewsKhJqWHZKPA2ZVjsc00k2+cwMs5nG9bJJwMU+MnZmVsz5JonkZlz4TqpH7k6tQ5uHQt318I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=phTTW8dv; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="phTTW8dv"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38511175ad3so1255997a91.2
        for <netfilter-devel@vger.kernel.org>; Sat, 01 Aug 2026 00:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785569273; x=1786174073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=krzdgZddwDx26VO3XhPhfYU9VAEbNCjfYfa1jxi9UaE=;
        b=phTTW8dvXB2Gn3WQw70UxQkh/lHyxLWAan7xc8BfP9+ZWgLV3iymx7NwUrRJFXSrFq
         pH3XjojMtGO4L6bRsKtkKFyr9yP+pAl/bWZ5GOaWq1gqmtu4240Z289pmQ3qn5uxQDMy
         Y+TJsCsC42+hGirQIWFpVwGwcc3e4DNI28x7UctRKl0GjFBbSRvyQLkcW1m/F30Qp4JN
         ipJVbflCz4Agm2n5fhCX98Pdi2aKNKLWj1BGtXEEwOFTlhqpwJxbUbclzYsTcUnt9u71
         78mqtKK1+1YB8Sx/IICKaQbb49CBX9oqMyagOdXZ6vOjZFxUL+lfS/XOED/u6DmhtYJg
         /uXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785569273; x=1786174073;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=krzdgZddwDx26VO3XhPhfYU9VAEbNCjfYfa1jxi9UaE=;
        b=KXHy2wNbSJUIFXTWKHC+TSt/OVM4iDfaKHq1iOZPhEjMXH/CR5n7U2xQPyhxFyZ2gb
         tuD9BWFlRlaSyv3SUwqib5KgwkSCHvZE2AqP/rZvv9+JvM0szqqX/ZQRsvtpnHoVCbmz
         i0frP6AyKrdylx0vFMUN49f/vbYJ7g++IDBWbqne59Wzv2cN8/i90aBrSkBtHr/hGv0z
         vDQLzZy/7e5WWyuEKIRglnp1edasjhWv0n/XnSC/QYAIFXAl7uSqeGIU50m1siEuMMGZ
         NojgdeYmky5CD6tmQ2L5kjRVd3TBF3ekJjEsuZt/DyW1ev423bgXWsCGxa5am2w6bCc7
         7WMA==
X-Gm-Message-State: AOJu0YyNCKVQMEmOA2AQPdO745ohy4KHquJ4HBL0iFDqtHxrIyvxJZG0
	d9NmnhJS5KHKyYNp2HN4q9aUhsI4JOQwwBtfuWQTTnJqy7msriA8ll2t0h9yGxxS
X-Gm-Gg: AR+sD10eR9/PduQdKAk3bvyWQjLkibxq8Y9YPjzq6zc/kkYo6KmuImmmLeDVM4v9SnX
	Nsq+YEkMjxfabBu89xLWoeOGlMSl7hYgLK9ehPgH+BaEg0gZ4/AWSGITOr8e6umRig5rspSigzk
	cEQeqEHcS3aEpo341gEjLGHV/cHuuis8ZeFU9WeLc6qSMNsr6k2qzLo9RiMM8+SsNSnbKKXwXgg
	V0rd+Cbdf9KwsYUeQi8hXR0V65RGk9FSGwmWdR5cAdo8LokKpvO2E0QFEvqZqqLTo+vBEW+9GTu
	Gl5RVbtHP+B36LoN+kMydF6gpZFLnoYf1ksXtO1PnfE2vXrRv/on0fUjDJElEZiIGIJE0kd0mWY
	ERxMlik/lFuJw8F+53Z9k7i2GQgkJgUH5JRlGRTof7lJk+rHdqfOAtEzYDBh1lKvZbYDu4S2BX4
	7D4qR/Hx/mLCglJ2q0p7ciF2fEXGEfVKOJV7H/0To+butzz8XXVwkiMlBD5I1bz1/Rel8oe0JdU
	JW0rqD5S6Yzb/waulXbMiOSLydyYjO8IxUHL8CyX3sMYQ==
X-Received: by 2002:a17:90b:1cc6:b0:38f:474f:e77 with SMTP id 98e67ed59e1d1-38fbc5abb9amr2444382a91.37.1785569272558;
        Sat, 01 Aug 2026 00:27:52 -0700 (PDT)
Received: from r912.tailbb6e1e.ts.net ([160.30.85.32])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e04491dsm18610263eec.16.2026.08.01.00.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 00:27:51 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v3] datatype: accept a numeric cgroupsv2 id on input
Date: Sat,  1 Aug 2026 12:57:47 +0530
Message-ID: <20260801072747.75504-1-avinash.duduskar@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft prints non-existent cgroup names as the raw id using PRIu64, but
cgroupv2_type_parse() only stats /sys/fs/cgroup/<identifier>, so the
listing does not load back:

  # nft list set ip t s
  table ip t {
          set s {
                  type cgroupsv2
                  elements = { 50834 }
          }
  }
  # nft delete element ip t s { 50834 }
  Error: cgroupv2 path fails: No such file or directory

The element cannot be deleted by key once its cgroup is gone, only
flushed with the set, and a dump does not restore. The json dump has
the same problem, and the stale id has been visible in the wild since
2022 (see Link). tests/shell/testcases/packetpath/cgroupv2 already
works around this in cleanup().

Fall back to integer_type_parse() when the path does not resolve, as
boolean_type_parse() already does. The path lookup stays first, so a
cgroup named as a number still resolves as a path. Improving the
integer parser is left for a follow-up as discussed in v1.

Fixes: 38228087252c ("src: add cgroupsv2 support")
Link: https://lore.kernel.org/netfilter-devel/fabde324-383a-622c-7e69-32c9b2d06191@gmail.com/
Signed-off-by: Avinash Duduskar <avinash.duduskar@gmail.com>
---
Changes since v2 (https://lore.kernel.org/netfilter-devel/20260729173748.1033454-1-avinash.duduskar@gmail.com/):
- return the error from integer_type_parse() instead of discarding it (Pablo)

Changes since v1 (https://lore.kernel.org/netfilter-devel/20260727082427.740789-1-avinash.duduskar@gmail.com/):
- drop the strict decimal parser, delegate to integer_type_parse()
  (Pablo, Phil)
- json test arm uses a here-string instead of a tempfile (Phil)
- shorter commit message and test

 src/datatype.c                                |   4 +-
 .../shell/testcases/parsing/cgroupv2_stale_id | 128 ++++++++++++++++++
 .../parsing/dumps/cgroupv2_stale_id.json-nft  |  11 ++
 .../parsing/dumps/cgroupv2_stale_id.nft       |   0
 4 files changed, 141 insertions(+), 2 deletions(-)
 create mode 100755 tests/shell/testcases/parsing/cgroupv2_stale_id
 create mode 100644 tests/shell/testcases/parsing/dumps/cgroupv2_stale_id.json-nft
 create mode 100644 tests/shell/testcases/parsing/dumps/cgroupv2_stale_id.nft

diff --git a/src/datatype.c b/src/datatype.c
index 4dbca16e..5025b276 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1665,9 +1665,9 @@ static struct error_record *cgroupv2_type_parse(struct parse_ctx *ctx,
 		 SYSFS_CGROUPSV2_PATH, sym->identifier);
 	cgroupv2_path[sizeof(cgroupv2_path) - 1] = '\0';
 
+	/* the listing prints a raw id once the path is gone */
 	if (stat(cgroupv2_path, &st) < 0)
-		return error(&sym->location, "cgroupv2 path fails: %s",
-			     strerror(errno));
+		return integer_type_parse(ctx, sym, res);
 
 	ino = st.st_ino;
 	*res = constant_expr_alloc(&sym->location, &cgroupv2_type,
diff --git a/tests/shell/testcases/parsing/cgroupv2_stale_id b/tests/shell/testcases/parsing/cgroupv2_stale_id
new file mode 100755
index 00000000..7f1833a8
--- /dev/null
+++ b/tests/shell/testcases/parsing/cgroupv2_stale_id
@@ -0,0 +1,128 @@
+#!/bin/bash
+
+# A cgroupsv2 element has to stay addressable once its cgroup is gone: the
+# listing prints the raw id, so that id has to be accepted back.
+
+CGROUP="/sys/fs/cgroup/nft-stale-$$"
+# numeric on purpose: a cgroup named as a number must still resolve as a path
+CGNUM="/sys/fs/cgroup/$$"
+
+cleanup()
+{
+	$NFT delete table t 2>/dev/null
+	rmdir "$CGROUP" 2>/dev/null
+	rmdir "$CGNUM" 2>/dev/null
+}
+trap cleanup EXIT
+
+if [ ! -w /sys/fs/cgroup ]; then
+	echo "cgroup filesystem not writable"
+	exit 77
+fi
+
+# -w alone passes on a v1 or hybrid layout, where everything below tests nothing
+if [ "$(stat -f --printf=%T /sys/fs/cgroup)" != "cgroup2fs" ]; then
+	echo "not a cgroupv2 mount"
+	exit 77
+fi
+
+if ! mkdir "$CGROUP" 2>/dev/null; then
+	# unprivileged and left over from a dead run are different facts
+	[ -d "$CGROUP" ] && {
+		echo "E: $CGROUP already exists" >&2
+		exit 1
+	}
+	echo "cannot create a cgroup"
+	exit 77
+fi
+name="${CGROUP##*/}"
+id=$(stat --printf=%i "$CGROUP")
+
+$NFT add table t || exit 1
+$NFT add set t s '{ type cgroupsv2; }' || exit 1
+$NFT add element t s "{ \"$name\" }" || exit 1
+
+rmdir "$CGROUP" || exit 1
+
+# Another cgroup can take this inode between the rmdir and the listing, which
+# resolves it back to a name. Narrow, and not closable from here.
+$NFT list set t s | grep -qw "$id" || {
+	echo "E: listing does not show the stale cgroup id $id" >&2
+	$NFT list set t s >&2
+	exit 1
+}
+
+$NFT delete element t s "{ $id }" || {
+	echo "E: cannot delete a cgroupsv2 element by the id that was listed" >&2
+	exit 1
+}
+
+$NFT list set t s | grep -qw "$id" && {
+	echo "E: element still present after delete" >&2
+	exit 1
+}
+
+$NFT add element t s "{ $id }" || exit 1
+
+# json serialises the id as a string, so it reaches the same parser. The harness
+# round trip at exit sees an empty ruleset here, so do it inline, scoped to this
+# table.
+if [ "$NFT_TEST_HAVE_json" != n ] && $NFT -j list tables >/dev/null 2>&1; then
+	out=$($NFT -j list table t) || exit 1
+	$NFT delete table t || exit 1
+	$NFT -j -f - <<< "$out" || {
+		echo "E: a json dump holding a stale cgroupsv2 id does not reload" >&2
+		exit 1
+	}
+	$NFT list set t s | grep -qw "$id" || {
+		echo "E: the id did not survive the json round trip" >&2
+		exit 1
+	}
+else
+	echo "I: no json support, skipping the json reload check"
+fi
+
+$NFT flush set t s || exit 1
+
+# a name that is neither a path nor an integer must still fail, and a value
+# wider than the 64-bit key must be rejected by evaluation
+for bogus in "nft-does-not-exist" "12abc" "18446744073709551616"; do
+	$NFT add element t s "{ \"$bogus\" }" 2>/dev/null && {
+		echo "E: accepted \"$bogus\" as a cgroupsv2 id" >&2
+		$NFT list set t s >&2
+		exit 1
+	}
+done
+
+# each add above also "passes" if it fails for an unrelated reason, so check
+# nothing was stored, without a pipeline that goes vacuous when list fails
+out=$($NFT list set t s) || exit 1
+case "$out" in
+*elements*)
+	echo "E: something was stored despite every add failing" >&2
+	echo "$out" >&2
+	exit 1
+	;;
+esac
+
+# The path has to win for a cgroup named as a number. While the directory
+# exists both readings print the same, so remove it before asserting.
+mkdir "$CGNUM" || exit 1
+numino=$(stat --printf=%i "$CGNUM")
+$NFT add element t s "{ \"$$\" }" || {
+	echo "E: cannot add a cgroup whose name is a number" >&2
+	exit 1
+}
+rmdir "$CGNUM" || exit 1
+if [ "$numino" = "$$" ]; then
+	echo "I: cgroup $$ happens to have inode $$, cannot tell the two apart"
+else
+	$NFT list set t s | grep -qw "$numino" || {
+		echo "E: \"$$\" was taken as an id, not resolved as a path" >&2
+		$NFT list set t s >&2
+		exit 1
+	}
+fi
+$NFT flush set t s || exit 1
+
+exit 0
diff --git a/tests/shell/testcases/parsing/dumps/cgroupv2_stale_id.json-nft b/tests/shell/testcases/parsing/dumps/cgroupv2_stale_id.json-nft
new file mode 100644
index 00000000..546cc597
--- /dev/null
+++ b/tests/shell/testcases/parsing/dumps/cgroupv2_stale_id.json-nft
@@ -0,0 +1,11 @@
+{
+  "nftables": [
+    {
+      "metainfo": {
+        "version": "VERSION",
+        "release_name": "RELEASE_NAME",
+        "json_schema_version": 1
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/parsing/dumps/cgroupv2_stale_id.nft b/tests/shell/testcases/parsing/dumps/cgroupv2_stale_id.nft
new file mode 100644
index 00000000..e69de29b

base-commit: 31fb7af1a99d67c87e94b4415e553589b21db2d1
-- 
2.55.0

