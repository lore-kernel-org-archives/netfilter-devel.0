Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8F0381EB3
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 17:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346676; cv=none; b=UMhwkIvtE2UwCiIdTWNQ0JdvOzWn6Mpv7zOWbhgPkuLusZLBn68mxIQblrXHASX9uhAwr9puxgIn5Wx02maSS34beM8KVmqFSdnvGKkh4C4wHjKhCMAn+KIUEkUcWVPdhZ/vUnFt+J+O1N0/p0DtOVOPYbQ5KlxiE2IH64qjASQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346676; c=relaxed/simple;
	bh=6le1kIyGkNgByDxM5kKg8oTtLcOmNWnau6YLJ725uq0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cbFXtuExgFkptr853OMZaGq6EOTR6ax+JVswwlaMBmBi5RnZHSbZLE2T8JntR6TdXNUCLbWjKdZJmZgt1WD8KCXt3BBxmHN0ePPcAun+rYNgAhNJYNTMHrrJN5mBkEAHz9Xzlr5HgN0c+70aXkmMh70qvnlKbwd9n6xylGM7lZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jlD7VjKK; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jlD7VjKK"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cc73e322dbso15077125ad.1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 10:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785346674; x=1785951474; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tTF6Lf8Acf1kPG+HAuLSB6OtiKVdXLXaXFxzVOxHHqw=;
        b=jlD7VjKK5FZ5ogicdbKor0IuOGobeEJmvgPdGnJ8MlZB2Sw0EbvOjwyj13gFaYS6T0
         EXYvm9pJqPqp+ifRre7uRKlRs2g7Zfoaw+o99Kuz6VTNoB8YGXP9zBapjvSxeholfO/Y
         vqZgsqgS6LX5zxItTzUMa8PhP7dXjyLgLnBd4n3X2/qX9qPu8oN66+ua+ELEDFLnsV4k
         rhJujeTutW3QipGjB+ihL2r4YB809DzeHxnbvJnOQuC7Kqlp8x6Lnrvsz5TzPLWZ9Qo6
         vLyYl6BvRxJXOGG7vzljbbe3HR+m4UcsCTDdwgNH2WAaU2lwae3QrwErf9uY+U45sq9U
         2I0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785346674; x=1785951474;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tTF6Lf8Acf1kPG+HAuLSB6OtiKVdXLXaXFxzVOxHHqw=;
        b=CP46xrejbVoIsqsx7ycauNEnkGXnK3nl+IpIHpMzzocUQDxCjN3Cwi3O0LW76Kvi0Y
         pPQuGIDfqReSe2/vS2dktdOoRz//6MtD0nYT5v5ADLodn+9SwECjKcDRiV5srrf4zKYr
         c7dBBOjZVklW/8keEEzeMBidMJQcEtoSwRE0CKzulbbE4yc2VtvJ0cmLnoKGvywJAzjq
         SbYjYsS2NQ2Fr4J0uB7YY9sTZayFTX9KGPqtH7hjxEEuo0OgosCERCLn2cCXGOzDBHpV
         O+MGv+9HdMV79+9P6NBdojlFf8XMFQFSG1uzEU1NdFNjfT1+cuSBWRN+31B3naCrQKFa
         eLyg==
X-Gm-Message-State: AOJu0YyIVOAL3atZqbS94sfXyUSjAKtJByKOHU2+lXhp+Nosl+axQdFF
	9wTX4g2+svQNYEvdn2d5TphG/beX+kl1uqF0Xh62/qBGbOxBpniXT/tIoFHt8FNn
X-Gm-Gg: AR+sD12BwiWYbTi7cTb+oss20ElcHKGX397KHtJvREibRluK8nTUDnJAwekUYoRutHM
	g28q3+iZatNczquJTNC8SNkDH2Y2goDdzKeOc77fFBcLY0gAJNg1Ab62XSflXNewq8p1n3Rn0x4
	NRI/i5ZfMJoKxcm1RiSmzxQ+sHWv1hTdoUcPY/dnGBt1JUML10d6t9EsKI9/NN4MYiJQ7RHzO66
	OEqdAYc+T2gM8g919CzuVPJqUlfWUp4sa+D2sYP0FbZqV9D5mbgYthhQ2lWIJebtOuvxXk+3iIm
	lIJB8SejPyvPRePj7lC6vK7Qsdy2tFX0H36WdDWwi/WeJgI+M9LVvpEAYHx/Bf2zCa+1QRboLkP
	CsC4qejFdqOpGS7YpEgq13NQKLkvLJ6uXrr7KJDsQTGb4ZqdyRdZwqBznKdVi4mjojKmMMzczlv
	GAEM7rzMSLO0L94bp1e75bKa/lyZIwcwjPKjEU5g0vO1uGFoEVe8uYFQj1VjvdMo+cezHJJxDK1
	NWywK6dEbc2x7dX9Vb+BByLcYw4LuY=
X-Received: by 2002:a17:903:78e:b0:2cc:9763:e607 with SMTP id d9443c01a7336-2d015d23403mr58419445ad.27.1785346673440;
        Wed, 29 Jul 2026 10:37:53 -0700 (PDT)
Received: from r912.4v1.in ([160.30.85.32])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504cc6936sm11438236eec.17.2026.07.29.10.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 10:37:52 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v2] datatype: accept a numeric cgroupsv2 id on input
Date: Wed, 29 Jul 2026 23:07:48 +0530
Message-ID: <20260729173748.1033454-1-avinash.duduskar@gmail.com>
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
Changes since v1 (https://lore.kernel.org/netfilter-devel/20260727082427.740789-1-avinash.duduskar@gmail.com/):
- drop the strict decimal parser, delegate to integer_type_parse()
  (Pablo, Phil)
- json test arm uses a here-string instead of a tempfile (Phil)
- shorter commit message and test

 src/datatype.c                                |  13 +-
 .../shell/testcases/parsing/cgroupv2_stale_id | 129 ++++++++++++++++++
 .../parsing/dumps/cgroupv2_stale_id.json-nft  |  11 ++
 .../parsing/dumps/cgroupv2_stale_id.nft       |   0
 4 files changed, 151 insertions(+), 2 deletions(-)
 create mode 100755 tests/shell/testcases/parsing/cgroupv2_stale_id
 create mode 100644 tests/shell/testcases/parsing/dumps/cgroupv2_stale_id.json-nft
 create mode 100644 tests/shell/testcases/parsing/dumps/cgroupv2_stale_id.nft

diff --git a/src/datatype.c b/src/datatype.c
index 4dbca16e..5b3b350c 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1665,9 +1665,18 @@ static struct error_record *cgroupv2_type_parse(struct parse_ctx *ctx,
 		 SYSFS_CGROUPSV2_PATH, sym->identifier);
 	cgroupv2_path[sizeof(cgroupv2_path) - 1] = '\0';
 
-	if (stat(cgroupv2_path, &st) < 0)
+	if (stat(cgroupv2_path, &st) < 0) {
+		struct error_record *erec;
+		int stat_errno = errno;
+
+		/* the listing prints a raw id once the path is gone */
+		erec = integer_type_parse(ctx, sym, res);
+		if (!erec)
+			return NULL;
+		erec_destroy(erec);
 		return error(&sym->location, "cgroupv2 path fails: %s",
-			     strerror(errno));
+			     strerror(stat_errno));
+	}
 
 	ino = st.st_ino;
 	*res = constant_expr_alloc(&sym->location, &cgroupv2_type,
diff --git a/tests/shell/testcases/parsing/cgroupv2_stale_id b/tests/shell/testcases/parsing/cgroupv2_stale_id
new file mode 100755
index 00000000..9e77e2b1
--- /dev/null
+++ b/tests/shell/testcases/parsing/cgroupv2_stale_id
@@ -0,0 +1,129 @@
+#!/bin/bash
+
+# A cgroupsv2 element has to stay addressable once its cgroup is gone: the
+# listing prints the raw id, so that id has to be accepted back, and nothing
+# else has to be.
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
+# junk that is neither a path nor a number must still fail, and a value wider
+# than the 64-bit key must be rejected by evaluation
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

