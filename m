Received: from mail-pz2-f39.google.com (mail-pz2-f39.google.com [74.125.228.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC16435E94F
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 14:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138797; cv=none; b=fHTVaBrnzQmu+a01Sf6q6dIZHcR48W2lpJGsPvEZxJBNNVzwa2S5ii6Vl1WsGo3/+BddhUcEqmFDJ6eMA0KuuNHK03rIOz5Zw9rSdIA18o5p3Ir6fy/9ltPHQA6kT+wGkRF93EicGyLK5XRj2uNRdisGMfXqXB/LIJFQhjAwjyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138797; c=relaxed/simple;
	bh=Usat8xz3UqpSSfKNuaqFESpqvYc1Nf1epx0yc3zzBFo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TjZIRFSJq/YQfvcR+JhPCW5h+gIvoxU1jSmspmAr9RxezmXoa+h+0niFJqY4soSgn6iiLoBOfmhey2AoyzpRRpMPufnN7szT1gJmXnviMrbCHD3lTe8BIcrjArsoa7LK5xAByrUGblBi7wMEZK+KSG98PIVcWvs5qi7j1BUDsJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jWb5S88A; arc=none smtp.client-ip=74.125.228.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jWb5S88A"
Received: by mail-pz2-f39.google.com with SMTP id 41be03b00d2f7-cc4b29fa803so34473a12.1
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 07:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789138795; x=1789743595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bBgINZr+o2IuvA/OKo1w80EwBRPUUPH1Co9Itt86ykY=;
        b=jWb5S88AmYie6Z816j3h60Oq/P26oyAX0beKMAX5foXzQ4cjowVUcxzfeHFxO5lTdP
         lZwGzsQkw4xwXWWb9KM6v96LfbY/fvtcccf8EEjZikw6zkAki2uVfDHAxS+nXwT/e9kq
         hZ0V3wVuOVeQ7Tegi+6izBi46Rnb/XTJLNpwjq5Ae7p1HN7EyVTEnpRIDyUzBI3T+TzN
         fkwz7EKd4FHLaKqvaBOnrEkg3caWtRH9HmYJWsT1zhS5PwpuLm8SpGFBX4fH6USQXo1W
         23AO3aXisrownmuJOsL1hX59/ACYk0ECl2yAvOXhBKIet25HnktP7X82Y25sQUznV3tp
         5rxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789138795; x=1789743595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bBgINZr+o2IuvA/OKo1w80EwBRPUUPH1Co9Itt86ykY=;
        b=SvDODd5ho38Np12qwIMEWgTZr8rZZExXYlAvnJcQvjRq44Jd6KQ5OkT7f+Cpn+CYf1
         sPSU/eLbPS2X5XSI/SUXld6UKFCP/8cBxUZbqfcMkFPwU+BwoatxhD0hE/wrsoR04Lyb
         IFyXdAUae5wRJLpBYYrgz4vVNxgWqxV5VL/19n3uPSX/J1cUeTLFJokgKigmS7oPa8fc
         /DUopbcA795e1afnAlf8M/eL6qxrTkd4RLtfspxSmT6XLHjH0Ix5o/i0P2kVgf8tQxFR
         WCvCGnp7BEw+4nCM2zyKxqthgIXtc/kAHUuj5cvGyP2k9H8EZlXt4wKoLOPPupdWyUE8
         4eeQ==
X-Gm-Message-State: AFuF++lFf8izANu4dBvYq3GfH2RPq+Qdqt1rDGeqgTome7p0jicjALej
	bGYQOH9K8BhQIEPUcVM78+v2WU6sSzCDpJIV8UKt8ULlsjvwtEqbaHhdOqdXuQ==
X-Gm-Gg: AYBFou1qnTTHkKALtXJxsSj7W20XoCuQEZTGiocvhbgWC+qZduIpGQRjKFn2B8Cfhz1
	5mcZONegZehUuVYY/qUcmoehcq9y1qCP4SdwBR7SHgrlNnalaIpp7MT/yJKj8juouiPW1ZsIUgN
	kkNf7/clvEIbQ4qMW2xW4L0Xnc3cupTJOiL8xej5t3yGz6QEpIq11JPl4BRlJ4Rpv6Cf5a3x6ig
	x/3Y6aVgeEYjnYm3ncSTKhaynu7A7SF4d9Hk4/YhVeLsM+HfDYDLX4KaPbHO99BNr1O/2ChBk6+
	pD8auWACjxBX+eeSWfvuLBhLaOH4n/HDv5DnPHKe5qIt/hj87XWC9UqgOPnYOcs04/mniNlPgpo
	KhxboNPpiH/OP82Cp6Kx9Z6zGa0G0BSAjY+5up7aUZaDBywSrjdjhnbb+t0v/3Hb+Vvgv62+5YX
	CNCg6T8P+I7ynj6qg6szWumWtuPfPDvRZjS598Lu4gmreAHffhYg9ge8/bgF9RrRuAO4hbQ8mey
	NsNOyssXqSQp6aUPch021ruZue7fNsO
X-Received: by 2002:a05:6a21:4cc1:b0:3d3:b00b:50fc with SMTP id adf61e73a8af0-3daed434594mr7926293637.28.1789138794823;
        Fri, 11 Sep 2026 07:59:54 -0700 (PDT)
Received: from r912.4v1.in ([182.70.116.80])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4efc398sm8129995eec.19.2026.09.11.07.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 07:59:54 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft] tests: shell: drop metainfo from the json dump comparison
Date: Fri, 11 Sep 2026 20:29:49 +0530
Message-ID: <20260911145949.30765-1-avinash.duduskar@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The comparison reads nothing from the metainfo object, but 431 dumps carry
one, so bumping json_schema_version would mean regenerating all of them.

Add a helper that drops the object and apply it to both sides of the dump
diff. Nothing else changes: json-pretty.sh stays as it is, so what nft
emits, what `nft -j --check` is fed and what DUMPGEN writes are untouched.

Nothing then asserts that nft still emits metainfo, so add a test. It also
pins that the jq and python3 branches agree and that both reject a
malformed ruleset, which a host with jq never exercises.

Link: https://lore.kernel.org/netfilter-devel/amnGEhXHD5175bxC@orbyte.nwl.cc/
Suggested-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Avinash Duduskar <avinash.duduskar@gmail.com>
---
 tests/shell/helpers/json-strip-metainfo.sh    | 39 +++++++++++
 tests/shell/helpers/test-wrapper.sh           | 24 ++++++-
 tests/shell/testcases/json/0009metainfo_0     | 69 +++++++++++++++++++
 .../json/dumps/0009metainfo_0.nodump          |  0
 4 files changed, 129 insertions(+), 3 deletions(-)
 create mode 100755 tests/shell/helpers/json-strip-metainfo.sh
 create mode 100755 tests/shell/testcases/json/0009metainfo_0
 create mode 100644 tests/shell/testcases/json/dumps/0009metainfo_0.nodump

diff --git a/tests/shell/helpers/json-strip-metainfo.sh b/tests/shell/helpers/json-strip-metainfo.sh
new file mode 100755
index 00000000..0115250d
--- /dev/null
+++ b/tests/shell/helpers/json-strip-metainfo.sh
@@ -0,0 +1,39 @@
+#!/bin/bash -e
+
+exec_strip() {
+	# `jq` and the python3 fallback must produce the same output. Both
+	# reject a non-array "nftables" rather than reshaping it. They are not
+	# equivalent on every malformed input, only on what the test pins, and
+	# only nft's own output reaches this.
+
+	if command -v jq &>/dev/null ; then
+		exec jq '
+			if (.nftables | type) != "array" then
+				error("nftables is not an array")
+			else
+				.nftables |= map(select(has("metainfo") | not))
+			end'
+	fi
+
+	# Fallback to python3.
+	exec python3 -c '
+import json
+import sys
+
+parsed = json.load(sys.stdin)
+if not isinstance(parsed.get("nftables"), list):
+    sys.exit("nftables is not an array")
+parsed["nftables"] = [x for x in parsed["nftables"] if "metainfo" not in x]
+print(json.dumps(parsed, indent=2))
+'
+}
+
+[ "$#" -le 1 ] || { echo "At most one argument supported" ; exit 1 ; }
+
+if [ "$#" -eq 1 ] ; then
+	# One argument passed. This must be a JSON file.
+	[ -f "$1" ] || { echo "File \"$1\" does not exist" ; exit 1 ; }
+	exec_strip < "$1"
+fi
+
+exec_strip
diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index 78a01d56..49b5d66e 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -54,6 +54,12 @@ json_pretty() {
 	"$NFT_TEST_BASEDIR/helpers/json-pretty.sh" "$@" 2>&1 || :
 }
 
+json_strip_metainfo() {
+	# No `|| :` here. A failure must fail the dump check, not silently
+	# leave a truncated file for the diff to compare.
+	"$NFT_TEST_BASEDIR/helpers/json-strip-metainfo.sh" "$@"
+}
+
 TEST="$1"
 TESTBASE="$(basename "$TEST")"
 TESTDIR="$(dirname "$TEST")"
@@ -228,11 +234,23 @@ if [ "$rc_test" -ne 77 -a "$dump_written" != y ] ; then
 		diff_check_setcount "$DUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after"
 	fi
 	if [ "$NFT_TEST_HAVE_json" != n -a -f "$JDUMPFILE" ] ; then
-		if ! $DIFF -u "$JDUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" ; then
-			show_file "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" "Failed \`$DIFF -u \"$JDUMPFILE\" \"$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty\"\`" >> "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
+		# Drop metainfo from both sides: the comparison ignores it, so
+		# a json_schema_version bump needs no dump regeneration.
+		rc_strip=0
+		json_strip_metainfo "$JDUMPFILE" \
+			> "$NFT_TEST_TESTTMPDIR/dump-expected.json-stripped" \
+			2> "$NFT_TEST_TESTTMPDIR/strip-err" || rc_strip=1
+		json_strip_metainfo "$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty" \
+			> "$NFT_TEST_TESTTMPDIR/ruleset-after.json-stripped" \
+			2>> "$NFT_TEST_TESTTMPDIR/strip-err" || rc_strip=1
+		if [ "$rc_strip" -ne 0 ] ; then
+			show_file "$NFT_TEST_TESTTMPDIR/strip-err" "Command \`json-strip-metainfo.sh\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
+			rc_dump=1
+		elif ! $DIFF -u "$NFT_TEST_TESTTMPDIR/dump-expected.json-stripped" "$NFT_TEST_TESTTMPDIR/ruleset-after.json-stripped" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" ; then
+			show_file "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" "Failed \`$DIFF -u \"$NFT_TEST_TESTTMPDIR/dump-expected.json-stripped\" \"$NFT_TEST_TESTTMPDIR/ruleset-after.json-stripped\"\` (metainfo stripped from \"$JDUMPFILE\" and the live dump)" >> "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
 			rc_dump=1
 		else
-			rm -f "$NFT_TEST_TESTTMPDIR/ruleset-diff.json"
+			rm -f "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" "$NFT_TEST_TESTTMPDIR/strip-err"
 		fi
 	fi
 fi
diff --git a/tests/shell/testcases/json/0009metainfo_0 b/tests/shell/testcases/json/0009metainfo_0
new file mode 100755
index 00000000..63b726a0
--- /dev/null
+++ b/tests/shell/testcases/json/0009metainfo_0
@@ -0,0 +1,69 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
+
+# The dump comparison strips the metainfo object, so nothing else asserts
+# that nft still emits one. Both branches of the strip helper are exercised
+# here too, because a host with jq never runs the python3 fallback. The
+# ruleset below is scaffolding for those checks, hence the .nodump stub.
+
+set -e
+
+STRIP="$NFT_TEST_BASEDIR/helpers/json-strip-metainfo.sh"
+
+TMP="$NFT_TEST_TESTTMPDIR/metainfo"
+mkdir -p "$TMP"
+
+$NFT flush ruleset
+$NFT add table ip t
+$NFT add chain ip t c
+
+$NFT -j list ruleset > "$TMP/ruleset.json"
+
+if ! grep -q '"metainfo"' "$TMP/ruleset.json" ; then
+	echo "E: nft no longer emits a metainfo object" >&2
+	exit 1
+fi
+if ! grep -q '"json_schema_version"' "$TMP/ruleset.json" ; then
+	echo "E: metainfo carries no json_schema_version" >&2
+	exit 1
+fi
+
+"$STRIP" "$TMP/ruleset.json" > "$TMP/stripped.json"
+
+if grep -q '"metainfo"' "$TMP/stripped.json" ; then
+	echo "E: metainfo survived the strip" >&2
+	cat "$TMP/stripped.json" >&2
+	exit 1
+fi
+if ! grep -q '"table"' "$TMP/stripped.json" ; then
+	echo "E: the strip removed more than metainfo" >&2
+	cat "$TMP/stripped.json" >&2
+	exit 1
+fi
+
+# Both branches must agree. Hide jq so the fallback runs.
+if command -v python3 &>/dev/null ; then
+	mkdir -p "$TMP/nojq"
+	ln -s "$(command -v python3)" "$TMP/nojq/python3"
+	PATH="$TMP/nojq" "$STRIP" "$TMP/ruleset.json" > "$TMP/stripped-python3.json"
+	if ! cmp "$TMP/stripped.json" "$TMP/stripped-python3.json" ; then
+		echo "E: jq and python3 branches disagree" >&2
+		diff -u "$TMP/stripped.json" "$TMP/stripped-python3.json" >&2 || :
+		exit 1
+	fi
+fi
+
+# Malformed input must fail, not be silently reshaped.
+for bad in '{"nftables":{"a":1}}' '{"a":1}' ; do
+	if echo "$bad" | "$STRIP" > /dev/null 2>&1 ; then
+		echo "E: strip accepted malformed input: $bad" >&2
+		exit 1
+	fi
+	if command -v python3 &>/dev/null ; then
+		if echo "$bad" | PATH="$TMP/nojq" "$STRIP" > /dev/null 2>&1 ; then
+			echo "E: python3 branch accepted malformed input: $bad" >&2
+			exit 1
+		fi
+	fi
+done
diff --git a/tests/shell/testcases/json/dumps/0009metainfo_0.nodump b/tests/shell/testcases/json/dumps/0009metainfo_0.nodump
new file mode 100644
index 00000000..e69de29b

base-commit: fcef13a358a0755a0bd980910d47989b064a756d
-- 
2.55.0

