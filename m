Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC8D1C84BC
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 08:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785140674; cv=none; b=YLMmPo3h6ca+4WN+n6RXnCaZu9FIgiELfJTrAm4wikjSlXz2T4O5XeSdoYYAL6mZ6M7ELZWae/F0lGVGSgXSBfuqUD7BMezoFiwwEj6H6VAUXP2yYezqG8QK8bbo7priKejTCe4N3PzRRBQDc5IHWwPbf9F9VtxROippk4h+q8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785140674; c=relaxed/simple;
	bh=31m1I3L6yrQHAiIEKUQFsNfqJ1ihqwR64inM1bAsva0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=umk6w2uzOcPBM8oRl1yR2HzOzZia2rMSF5Gz/KnR+SRP902YQVftdapJiiWk58hYXjTDdYzZ3bBT2V5URMDGY+fHMTmpiB8R0p0gF2167z7J4yHp6UnfxK+7Y3UjETfWAEX2yIDeMxmv/2d5esVidp2cMUr5X+PhgbOZMfnXevI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tLxqIVjm; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tLxqIVjm"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38101f85591so3056284a91.1
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 01:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785140673; x=1785745473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8m6N3mFtdOhOJHQiHuemxfvyUCmQ5tidBvHqyyWq+o8=;
        b=tLxqIVjmwiS4YUMUGy+GYGIjV8PzyxKkprxiKEa52ky5VbvfHWtRbTLejWTyu/UG44
         OQQ1c4Le2/oxrDroAhJfi6gTQW+CCC8dD69E1dfWt1QconIXSphC0H5BMvjAmVCbr/GE
         wDdbqlAOt4oN32iHAaQcSPEXL80cs6qqDndvlD/vC/BTaKtMWqipeLg0YD44bRGBl9Iy
         Vd/KqKPjvToT27lZpXZeSHHk2R39p+QzuHoR6Ik+sCd/FlAyD29s3fg+2BkcGQZ+uTx7
         IxhTjiG0tXh/BK4AAjSOMNOqNd7OB5bIAos/ZE8Z2sMfCu5DXfsUSI7/xJ+yUSpexyn1
         noPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785140673; x=1785745473;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8m6N3mFtdOhOJHQiHuemxfvyUCmQ5tidBvHqyyWq+o8=;
        b=IrflPScgp+a3ZjWWAADLAixVtwM4p7ptubzfZ1IgZw9zGTa+4xPx9s1Q2iNDQ37nCI
         RGkzVhQ2eCFw7S+B3hCstyTdDmQGg+t7KkjPVt0010P4/vzHtbBKXHOpobUaOCDvgMbj
         zdo6DQ1pjymnMr0trFsGmH8+QFYwvGZUJ55DU4T52MqgNrPcchaQ6+QhZuMZhTxzKgH0
         S87JIuGw2JRvKl+T3iRRbggwDx7aKEGkhhcs0Ib+aBBHZAM9zo5mAL3xhFbvLdsUxts/
         CYxZLviR0+Uq9b1o2t8bWo2D38cY1CBczkcjCzSANE4US64XY+UEg/IYALaDMHQA9KYz
         qzig==
X-Gm-Message-State: AOJu0YwFIKQ/JX6H+O6Txa6iH+I8lkPHM+6fIo3w6Cx5gchYsVdYBP9f
	bnC/wyVMVxKtxj9Fi8DU9zDlUM9csfxgXkU9j4+3OrUsURyXxLxcntRqBKLK+AmC
X-Gm-Gg: AR+sD10WAA4MazL7b/R+KwA13jg3oWqWUWAo2t5yO6gPms2FxInc9+tgbEbNizSc4JN
	ahzOOcZJnJ0uhaMfsmRNF8J2zipGTWSO47OubofBgSnxIRbJc3xU7T8N/zWy+K0+5dkQRthuBOG
	pDYRyYABaaZoYLsKif7ROGT2ZKrTo4ZbqiA+uWi7nsE0avUoJ7g8nWSMAbtCuCthOzzn2gIxa2R
	AZz+4EzfDE32n8x2YLap8taoOJhvvXZJeuOx/iERJyFhUDc6rBlz/lKnxLZ1jJs6g8YJwr300Gl
	zmW6cLjtE624Y4EXNQEIRmVb3iziDBdWx267UUgkkxXXGjskuJeFqBqNZGl5+ti1O7eAbJFIRlL
	qGuNJBZ6YAS9MnFEY90zhvroRsYy2Pg8HDxfjU8Fm8QY9zrVyOk4NIGnKI5iaGEOlTR5VdEtubF
	WaJIJEovZi5y6MJtHH3SgT7L3LMwFXK7+i6vTik8odPgNxZpuZ
X-Received: by 2002:a17:90b:38d1:b0:36b:4d63:4a93 with SMTP id 98e67ed59e1d1-38f1eea84b1mr9289562a91.13.1785140672362;
        Mon, 27 Jul 2026 01:24:32 -0700 (PDT)
Received: from r912.tailbb6e1e.ts.net ([160.30.85.32])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d2eb01aa0sm40424106c88.3.2026.07.27.01.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 01:24:31 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft] datatype: accept a numeric cgroupsv2 id on input
Date: Mon, 27 Jul 2026 13:54:27 +0530
Message-ID: <20260727082427.740789-1-avinash.duduskar@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Once a cgroup is removed there is no path left to resolve, so the listing
falls back to printing the raw id:

  # nft list set ip t s
  table ip t {
          set s {
                  type cgroupsv2
                  elements = { 50834 }
          }
  }

That output is not valid input. cgroupv2_type_parse() only stats
/sys/fs/cgroup/<identifier>, so handing the id back fails:

  # nft delete element ip t s { 50834 }
  Error: cgroupv2 path fails: No such file or directory

The element cannot be addressed by key at all once its cgroup is gone,
which leaves flushing the containing set as the only way to remove it.
The json dump does not reload either, since the id is serialised as a
string and reaches the same parser.
tests/shell/testcases/packetpath/cgroupv2 works around this in its
cleanup(), added by commit 9fbc77c127e7 ("tests: shell: add cgroupv2
socket match test case"), because "nft can't find the human-readable
names anymore".

Take the id back when the path does not resolve, accepting a decimal
number and nothing else. integer_type_parse() converts with base 0 and
expr_evaluate_integer() does not check the sign, so it would take "0755"
as 493, "0x1f" as 31 and "-1" as 1; strtoull() alone still accepts a
leading sign or space. Requiring a leading digit closes both. The path
lookup stays first, so a cgroup named as a number still resolves as a
path.

A plain decimal name that does not resolve now becomes an id rather than
an error, the way meta skuid falls back to the numeric uid when there is
no passwd entry. nft accepting what nft printed is worth more than
diagnosing a mistyped path.

Fixes: 38228087252c ("src: add cgroupsv2 support")
Signed-off-by: Avinash Duduskar <avinash.duduskar@gmail.com>
---
cgroupv2_type_print() still ignores -n and prints the resolved path when it
can. This patch only makes the id nft already prints acceptable as input;
making the print side honour -n is a separate change.

dumps/cgroupv2_stale_id.nft is empty and the json dump is the metainfo
boilerplate, because the test leaves no ruleset behind and the ids it uses are
not stable across runs. There is no .nodump, so the dump comparison still runs.

No NFT_TEST_REQUIRES: the test uses no socket expression, so neither
NFT_TEST_HAVE_cgroupsv2 nor nft_socket is involved. It skips with 77 without a
writable cgroup2 mount, and the json arm skips unless -j actually works.

Searched the netfilter-devel archive for cgroupv2: 133 messages, 2021-04-21 to
2026-05-28, none proposing that a numeric id be accepted on input.

Tested on b315dd55 with a libnftnl built from git 363b0e3, since master needs
nftnl_set_elem_set_imm which is not in libnftnl 1.3.1. The suite gains this one
test and no regressions; two pre-existing failures are unchanged with and
without the patch.

 src/datatype.c                                |  29 +++-
 .../shell/testcases/parsing/cgroupv2_stale_id | 154 ++++++++++++++++++
 .../parsing/dumps/cgroupv2_stale_id.json-nft  |  11 ++
 .../parsing/dumps/cgroupv2_stale_id.nft       |   0
 4 files changed, 190 insertions(+), 4 deletions(-)
 create mode 100755 tests/shell/testcases/parsing/cgroupv2_stale_id
 create mode 100644 tests/shell/testcases/parsing/dumps/cgroupv2_stale_id.json-nft
 create mode 100644 tests/shell/testcases/parsing/dumps/cgroupv2_stale_id.nft

diff --git a/src/datatype.c b/src/datatype.c
index 4dbca16e..adbbbacf 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1665,11 +1665,32 @@ static struct error_record *cgroupv2_type_parse(struct parse_ctx *ctx,
 		 SYSFS_CGROUPSV2_PATH, sym->identifier);
 	cgroupv2_path[sizeof(cgroupv2_path) - 1] = '\0';
 
-	if (stat(cgroupv2_path, &st) < 0)
-		return error(&sym->location, "cgroupv2 path fails: %s",
-			     strerror(errno));
+	if (stat(cgroupv2_path, &st) < 0) {
+		int stat_errno = errno;
+		char *end;
+
+		/* The path is gone, so the listing prints the raw id; take it
+		 * back or nft cannot parse its own output. Decimal only: a
+		 * leading zero is read as decimal, not octal, and a bare
+		 * strtoull() would take a leading sign or space too. A
+		 * non-number keeps the path error, which is what it most
+		 * likely is; only an over-wide number gets its own.
+		 */
+		if (!isdigit((unsigned char)sym->identifier[0]))
+			return error(&sym->location, "cgroupv2 path fails: %s",
+				     strerror(stat_errno));
+
+		errno = 0;
+		ino = strtoull(sym->identifier, &end, 10);
+		if (*end != '\0')
+			return error(&sym->location, "cgroupv2 path fails: %s",
+				     strerror(stat_errno));
+		if (errno == ERANGE)
+			return error(&sym->location, "cgroupv2 id out of range");
+	} else {
+		ino = st.st_ino;
+	}
 
-	ino = st.st_ino;
 	*res = constant_expr_alloc(&sym->location, &cgroupv2_type,
 				   BYTEORDER_HOST_ENDIAN,
 				   sizeof(ino) * BITS_PER_BYTE, &ino);
diff --git a/tests/shell/testcases/parsing/cgroupv2_stale_id b/tests/shell/testcases/parsing/cgroupv2_stale_id
new file mode 100755
index 00000000..9f2d49d8
--- /dev/null
+++ b/tests/shell/testcases/parsing/cgroupv2_stale_id
@@ -0,0 +1,154 @@
+#!/bin/bash
+
+# A cgroupsv2 element has to stay addressable once its cgroup is gone: the
+# listing prints the raw id, so that id has to be accepted back, and nothing
+# else has to be.
+
+CGROUP="/sys/fs/cgroup/nft-stale-$$"
+# numeric on purpose: a cgroup named as a number must still resolve as a path
+CGNUM="/sys/fs/cgroup/$$"
+JDUMP=
+
+cleanup()
+{
+	$NFT delete table t 2>/dev/null
+	rmdir "$CGROUP" 2>/dev/null
+	rmdir "$CGNUM" 2>/dev/null
+	[ -n "$JDUMP" ] && rm -f "$JDUMP"
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
+	JDUMP=$(mktemp) || exit 1
+	$NFT -j list table t > "$JDUMP" || exit 1
+	$NFT delete table t || exit 1
+	$NFT -j -f "$JDUMP" || {
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
+# Nothing outside the form the listing emits: a plain strtoull() would take
+# "-1", "+5" and " 42", a base 0 conversion "-1", " 42", "0x10" and "1 2".
+for bogus in "-1" "+5" " 42" "0x10" "1 2" "nft-does-not-exist" "12abc"; do
+	$NFT add element t s "{ \"$bogus\" }" 2>/dev/null && {
+		echo "E: accepted \"$bogus\" as a cgroupsv2 id" >&2
+		$NFT list set t s >&2
+		exit 1
+	}
+done
+
+# Each add above also "passes" when it fails for an unrelated reason, so check
+# the set is really empty rather than trusting seven rejections.
+out=$($NFT list set t s) || exit 1
+case "$out" in
+*elements*)
+	echo "E: something was stored despite every add failing" >&2
+	echo "$out" >&2
+	exit 1
+	;;
+esac
+
+# 64 bits wide, so one past the top has to fail while the top itself works
+$NFT add element t s "{ 18446744073709551616 }" 2>/dev/null && {
+	echo "E: accepted an id wider than 64 bits" >&2
+	exit 1
+}
+$NFT add element t s "{ 18446744073709551615 }" || {
+	echo "E: rejected the largest valid id" >&2
+	exit 1
+}
+$NFT flush set t s || exit 1
+
+# 010 is decimal 10, not octal 8. Asserted by delete, since the listing would
+# try to resolve 10 to a path.
+$NFT add element t s '{ "010" }' || {
+	echo "E: rejected a decimal id with a leading zero" >&2
+	exit 1
+}
+$NFT delete element t s "{ 10 }" || {
+	echo "E: \"010\" was not taken as decimal 10" >&2
+	exit 1
+}
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

base-commit: b315dd551dd963f052fe49e4408e0ee02ff1ae25
-- 
2.55.0

