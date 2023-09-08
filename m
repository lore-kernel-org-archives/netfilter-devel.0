Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46269EE8012
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 15:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244415AbjIHPOb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 11:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244407AbjIHPOa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 11:14:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FC11FC1
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 08:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694186019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RhxR0DjTZvlA+aK24q065l9ADef0I026BeO2r8X9vJk=;
        b=TRNyMq4rTF/a+5YK2jAgXCgmYGVV50sbUtdLpES27VMgpIDLR/GABBJmvaEg798SzKg+vx
        yEmZhRUKHvWHBUZY/i6885SHZXhKtk8hJ6rQsnTtdE8/V28eycErJyL3KdrlJhiDytfGcU
        wyaCs8LleZkQ+pBtTV3x8ilWxXS/OiE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-WyVnjoETMAaiCvehjwCunA-1; Fri, 08 Sep 2023 11:13:36 -0400
X-MC-Unique: WyVnjoETMAaiCvehjwCunA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 246EE181C284;
        Fri,  8 Sep 2023 15:13:36 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F3CD493110;
        Fri,  8 Sep 2023 15:13:34 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/2] tests/shell: skip tests if nft does not support JSON mode
Date:   Fri,  8 Sep 2023 17:07:24 +0200
Message-ID: <20230908151323.1161159-2-thaller@redhat.com>
In-Reply-To: <20230908151323.1161159-1-thaller@redhat.com>
References: <20230908151323.1161159-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We can build nft without JSON support, and some tests will fail without
it. Instead, they should be skipped. Also note, that the test accepts any
nft binary via the "NFT" environment variable. So it's not enough to
make the skipping dependent on build configuration, but on the currently
used $NFT variable.

Let "run-test.sh" detect and export a "NFT_TEST_HAVE_json=3Dy|n" variable. =
This
is heavily inspired by Florian's feature probing patches.

Tests that require JSON can check that variable, and skip. Note that
they check in the form of [ "$NFT_TEST_HAVE_json" !=3D n ], so the test is
only skipped, if we explicitly detect lack of support. That is, don't
check via [ "$NFT_TEST_HAVE_json" =3D y ].

Some of the tests still run parts of the tests that don't require JSON.
Only towards the end of such partial run, mark the test as skipped.

Some tests require JSON support throughout. For those, add  a mechanism
where tests can add a tag (in their first 10 lines):

  # NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)

This will be checked by "test-wrapper.sh", which will skip the test.
The purpose of this is to make it low-effort to skip a test and to print
the reason in the text output as

    Test skipped due to NFT_TEST_HAVE_json=3Dn (test has "NFT_TEST_REQUIRES=
(NFT_TEST_HAVE_json)" tag)

This is intentionally not shortened to NFT_TEST_REQUIRES(json), so that
we can grep for NFT_TEST_HAVE_json to find all relevant places.

Note that while NFT_TEST_HAVE_json is autodetected, the caller can also
force it by setting the environment variable. This allows to see what
would happen to such a test.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh           | 35 ++++++++++++++++-
 tests/shell/run-tests.sh                      | 38 ++++++++++++++++++-
 .../shell/testcases/json/0001set_statements_0 |  2 +
 tests/shell/testcases/json/0002table_map_0    |  2 +
 .../testcases/json/0003json_schema_version_0  |  2 +
 .../testcases/json/0004json_schema_version_1  |  2 +
 .../shell/testcases/json/0005secmark_objref_0 |  2 +
 tests/shell/testcases/json/0006obj_comment_0  |  2 +
 tests/shell/testcases/json/netdev             |  9 ++++-
 .../listing/0021ruleset_json_terse_0          | 13 +++++--
 tests/shell/testcases/transactions/0049huge_0 | 14 ++++++-
 11 files changed, 112 insertions(+), 9 deletions(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test=
-wrapper.sh
index 405e70c86751..a91baf743d9a 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -5,6 +5,16 @@
 #
 # For some printf debugging, you can also patch this file.
=20
+array_contains() {
+	local needle=3D"$1"
+	local a
+	shift
+	for a; do
+		[ "$a" =3D "$needle" ] && return 0
+	done
+	return 1
+}
+
 TEST=3D"$1"
 TESTBASE=3D"$(basename "$TEST")"
 TESTDIR=3D"$(dirname "$TEST")"
@@ -40,8 +50,31 @@ if [ "$NFT_TEST_HAS_UNSHARED_MOUNT" =3D y ] ; then
 	fi
 fi
=20
+TEST_TAGS_PARSED=3D0
+ensure_TEST_TAGS() {
+	if [ "$TEST_TAGS_PARSED" =3D 0 ] ; then
+		TEST_TAGS_PARSED=3D1
+		TEST_TAGS=3D( $(sed -n '1,10 { s/^.*\<\(NFT_TEST_REQUIRES\)\>\s*(\s*\(NF=
T_TEST_HAVE_[a-zA-Z0-9_]\+\)\s*).*$/\1(\2)/p }' "$1" 2>/dev/null || : ) )
+	fi
+}
+
 rc_test=3D0
-"$TEST" &> "$NFT_TEST_TESTTMPDIR/testout.log" || rc_test=3D$?
+
+for KEY in $(compgen -v | grep '^NFT_TEST_HAVE_') ; do
+	if [ "${!KEY}" !=3D n ]; then
+		continue
+	fi
+	ensure_TEST_TAGS "$TEST"
+	if array_contains "NFT_TEST_REQUIRES($KEY)" "${TEST_TAGS[@]}" ; then
+		echo "Test skipped due to $KEY=3Dn (test has \"NFT_TEST_REQUIRES($KEY)\"=
 tag)" >> "$NFT_TEST_TESTTMPDIR/testout.log"
+		rc_test=3D77
+		break
+	fi
+done
+
+if [ "$rc_test" -eq 0 ] ; then
+	"$TEST" &>> "$NFT_TEST_TESTTMPDIR/testout.log" || rc_test=3D$?
+fi
=20
 $NFT list ruleset > "$NFT_TEST_TESTTMPDIR/ruleset-after"
=20
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index c622c1509500..e3ab9e744fe4 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -11,6 +11,16 @@ if [[ -t 1 && -z "$NO_COLOR" ]] ; then
 	RESET=3D$'\e[0m'
 fi
=20
+array_contains() {
+	local needle=3D"$1"
+	local a
+	shift
+	for a; do
+		[ "$a" =3D "$needle" ] && return 0
+	done
+	return 1
+}
+
 _msg() {
 	local level=3D"$1"
 	shift
@@ -160,6 +170,10 @@ usage() {
 	echo "                 kernel modules)."
 	echo "                 Parallel jobs requires unshare and are disabled wi=
th NFT_TEST_UNSHARE_CMD=3D\"\"."
 	echo " TMPDIR=3D<PATH> : select a different base directory for the result=
 data."
+	echo
+	echo " NFT_TEST_HAVE_<FEATURE>=3D*|y: Some tests requires certain feature=
s or will be skipped."
+	echo "                 The features are autodetected, but you can force i=
t by setting the variable."
+	echo "                 Supported <FEATURE>s are: ${_HAVE_OPTS[@]}."
 }
=20
 NFT_TEST_BASEDIR=3D"$(dirname "$0")"
@@ -167,6 +181,13 @@ NFT_TEST_BASEDIR=3D"$(dirname "$0")"
 # Export the base directory. It may be used by tests.
 export NFT_TEST_BASEDIR
=20
+_HAVE_OPTS=3D( json )
+for KEY in $(compgen -v | grep '^NFT_TEST_HAVE_' | sort) ; do
+	if ! array_contains "${KEY#NFT_TEST_HAVE_}" "${_HAVE_OPTS[@]}" ; then
+		unset "$KEY"
+	fi
+done
+
 _NFT_TEST_JOBS_DEFAULT=3D"$(nproc)"
 [ "$_NFT_TEST_JOBS_DEFAULT" -gt 0 ] 2>/dev/null || _NFT_TEST_JOBS_DEFAULT=
=3D1
 _NFT_TEST_JOBS_DEFAULT=3D"$(( _NFT_TEST_JOBS_DEFAULT + (_NFT_TEST_JOBS_DEF=
AULT + 1) / 2 ))"
@@ -362,6 +383,16 @@ if [ ${ret} -eq 126 ] || [ ${ret} -eq 127 ]; then
 	msg_error "cannot execute nft command: $NFT"
 fi
=20
+NFT_REAL=3D"${NFT_REAL-$NFT}"
+
+if [ -z "${NFT_TEST_HAVE_json+x}" ] ; then
+	NFT_TEST_HAVE_json=3Dy
+	$NFT_TEST_UNSHARE_CMD "$NFT_REAL" -j list ruleset &>/dev/null || NFT_TEST=
_HAVE_json=3Dn
+else
+	NFT_TEST_HAVE_json=3D"$(bool_n "$NFT_TEST_HAVE_json")"
+fi
+export NFT_TEST_HAVE_json
+
 if [ "$NFT_TEST_JOBS" -eq 0 ] ; then
 	MODPROBE=3D"$(which modprobe)"
 	if [ ! -x "$MODPROBE" ] ; then
@@ -387,8 +418,6 @@ chmod 755 "$NFT_TEST_TMPDIR"
=20
 exec &> >(tee "$NFT_TEST_TMPDIR/test.log")
=20
-NFT_REAL=3D"${NFT_REAL-$NFT}"
-
 msg_info "conf: NFT=3D$(printf '%q' "$NFT")"
 msg_info "conf: NFT_REAL=3D$(printf '%q' "$NFT_REAL")"
 msg_info "conf: VERBOSE=3D$(printf '%q' "$VERBOSE")"
@@ -403,6 +432,11 @@ msg_info "conf: NFT_TEST_HAS_UNSHARED_MOUNT=3D$(printf=
 '%q' "$NFT_TEST_HAS_UNSHARE
 msg_info "conf: NFT_TEST_KEEP_LOGS=3D$(printf '%q' "$NFT_TEST_KEEP_LOGS")"
 msg_info "conf: NFT_TEST_JOBS=3D$NFT_TEST_JOBS"
 msg_info "conf: TMPDIR=3D$(printf '%q' "$_TMPDIR")"
+echo
+for KEY in $(compgen -v | grep '^NFT_TEST_HAVE_' | sort) ; do
+	msg_info "conf: $KEY=3D$(printf '%q' "${!KEY}")"
+	export "$KEY"
+done
=20
 NFT_TEST_LATEST=3D"$_TMPDIR/nft-test.latest.$USER"
=20
diff --git a/tests/shell/testcases/json/0001set_statements_0 b/tests/shell/=
testcases/json/0001set_statements_0
index 1c72d35b2dbd..fc4941f4da11 100755
--- a/tests/shell/testcases/json/0001set_statements_0
+++ b/tests/shell/testcases/json/0001set_statements_0
@@ -1,5 +1,7 @@
 #!/bin/bash
=20
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
+
 set -e
=20
 $NFT flush ruleset
diff --git a/tests/shell/testcases/json/0002table_map_0 b/tests/shell/testc=
ases/json/0002table_map_0
index 4b54527bc839..b375e9969608 100755
--- a/tests/shell/testcases/json/0002table_map_0
+++ b/tests/shell/testcases/json/0002table_map_0
@@ -1,5 +1,7 @@
 #!/bin/bash
=20
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
+
 set -e
=20
 $NFT flush ruleset
diff --git a/tests/shell/testcases/json/0003json_schema_version_0 b/tests/s=
hell/testcases/json/0003json_schema_version_0
index 0ccf94c88cc5..43f387a19444 100755
--- a/tests/shell/testcases/json/0003json_schema_version_0
+++ b/tests/shell/testcases/json/0003json_schema_version_0
@@ -1,5 +1,7 @@
 #!/bin/bash
=20
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
+
 set -e
=20
 $NFT flush ruleset
diff --git a/tests/shell/testcases/json/0004json_schema_version_1 b/tests/s=
hell/testcases/json/0004json_schema_version_1
index bc451ae7eaaa..0f8d586f9d7c 100755
--- a/tests/shell/testcases/json/0004json_schema_version_1
+++ b/tests/shell/testcases/json/0004json_schema_version_1
@@ -1,5 +1,7 @@
 #!/bin/bash
=20
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
+
 set -e
=20
 $NFT flush ruleset
diff --git a/tests/shell/testcases/json/0005secmark_objref_0 b/tests/shell/=
testcases/json/0005secmark_objref_0
index ae967435038f..992d1b000d86 100755
--- a/tests/shell/testcases/json/0005secmark_objref_0
+++ b/tests/shell/testcases/json/0005secmark_objref_0
@@ -1,5 +1,7 @@
 #!/bin/bash
=20
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
+
 set -e
=20
 $NFT flush ruleset
diff --git a/tests/shell/testcases/json/0006obj_comment_0 b/tests/shell/tes=
tcases/json/0006obj_comment_0
index 76d8fe1652ac..4c2a0e8c0880 100755
--- a/tests/shell/testcases/json/0006obj_comment_0
+++ b/tests/shell/testcases/json/0006obj_comment_0
@@ -1,5 +1,7 @@
 #!/bin/bash
=20
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
+
 set -e
=20
 $NFT flush ruleset
diff --git a/tests/shell/testcases/json/netdev b/tests/shell/testcases/json=
/netdev
index 9f6033810b55..dad7afcdc020 100755
--- a/tests/shell/testcases/json/netdev
+++ b/tests/shell/testcases/json/netdev
@@ -16,4 +16,11 @@ $NFT flush ruleset
=20
 RULESET=3D'{"nftables":[{"flush":{"ruleset":null}},{"add":{"table":{"famil=
y":"netdev","name":"test_table"}}},{"add":{"chain":{"family":"netdev","tabl=
e":"test_table","name":"test_chain","type":"filter","hook":"ingress","prio"=
:0,"dev":"d0","policy":"accept"}}}]}'
=20
-$NFT -j -f - <<< $RULESET
+if [ "$NFT_TEST_HAVE_json" !=3D n ]; then
+	$NFT -j -f - <<< $RULESET
+fi
+
+if [ "$NFT_TEST_HAVE_json" =3D n ]; then
+	echo "Test partially skipped due to missing JSON support."
+	exit 77
+fi
diff --git a/tests/shell/testcases/listing/0021ruleset_json_terse_0 b/tests=
/shell/testcases/listing/0021ruleset_json_terse_0
index 6be41b8635ae..98a7ce8a4be9 100755
--- a/tests/shell/testcases/listing/0021ruleset_json_terse_0
+++ b/tests/shell/testcases/listing/0021ruleset_json_terse_0
@@ -6,7 +6,14 @@ $NFT add chain ip test c
 $NFT add set ip test s { type ipv4_addr\; }
 $NFT add element ip test s { 192.168.3.4, 192.168.3.5 }
=20
-if $NFT -j -t list ruleset | grep '192\.168'
-then
-	exit 1
+if [ "$NFT_TEST_HAVE_json" !=3D n ]; then
+	if $NFT -j -t list ruleset | grep '192\.168'
+	then
+		exit 1
+	fi
+fi
+
+if [ "$NFT_TEST_HAVE_json" =3D n ]; then
+    echo "Test partially skipped due to missing JSON support."
+    exit 77
 fi
diff --git a/tests/shell/testcases/transactions/0049huge_0 b/tests/shell/te=
stcases/transactions/0049huge_0
index 1a3a75c7cdaa..f66953c2ab70 100755
--- a/tests/shell/testcases/transactions/0049huge_0
+++ b/tests/shell/testcases/transactions/0049huge_0
@@ -37,7 +37,10 @@ done
 	echo '{"add": {"rule": {"family": "inet", "table": "test", "chain": "c", =
"expr": [{"accept": null}], "comment": "rule'$((${RULE_COUNT} - 1))'"}}}'
 echo ']}'
 )
-test $($NFT -j -e -a -f - <<< "$RULESET" |sed 's/\({"add":\)/\n\1/g' |grep=
 '"handle"' |wc -l) -eq ${RULE_COUNT} || exit 1
+
+if [ "$NFT_TEST_HAVE_json" !=3D n ]; then
+	test $($NFT -j -e -a -f - <<< "$RULESET" |sed 's/\({"add":\)/\n\1/g' |gre=
p '"handle"' |wc -l) -eq ${RULE_COUNT} || exit 1
+fi
=20
 # Now an example from firewalld's testsuite
 #
@@ -47,7 +50,14 @@ RULESET=3D'{"nftables": [{"metainfo": {"json_schema_vers=
ion": 1}}, {"add": {"table
 {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "raw_PR=
EROUTING", "type": "filter", "hook": "prerouting", "prio": -290}}}, {"add":=
 {"chain": {"family": "inet", "table": "firewalld", "name": "raw_PREROUTING=
_ZONES"}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chai=
n": "raw_PREROUTING", "expr": [{"jump": {"target": "raw_PREROUTING_ZONES"}}=
]}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "m=
angle_PREROUTING", "type": "filter", "hook": "prerouting", "prio": -140}}},=
 {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "mangle=
_PREROUTING_ZONES"}}}, {"add": {"rule": {"family": "inet", "table": "firewa=
lld", "chain": "mangle_PREROUTING", "expr": [{"jump": {"target": "mangle_PR=
EROUTING_ZONES"}}]}}}, {"add": {"chain": {"family": "ip", "table": "firewal=
ld", "name": "nat_PREROUTING", "type": "nat", "hook": "prerouting", "prio":=
 -90}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "=
nat_PREROUTING_ZONES"}}}, {"add": {"rule": {"family": "ip", "table": "firew=
alld", "chain": "nat_PREROUTING", "expr": [{"jump": {"target": "nat_PREROUT=
ING_ZONES"}}]}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", =
"name": "nat_POSTROUTING", "type": "nat", "hook": "postrouting", "prio": 11=
0}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "nat=
_POSTROUTING_ZONES"}}}, {"add": {"rule": {"family": "ip", "table": "firewal=
ld", "chain": "nat_POSTROUTING", "expr": [{"jump": {"target": "nat_POSTROUT=
ING_ZONES"}}]}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld",=
 "name": "nat_PREROUTING", "type": "nat", "hook": "prerouting", "prio": -90=
}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat=
_PREROUTING_ZONES"}}}, {"add": {"rule": {"family": "ip6", "table": "firewal=
ld", "chain": "nat_PREROUTING", "expr": [{"jump": {"target": "nat_PREROUTIN=
G_ZONES"}}]}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "=
name": "nat_POSTROUTING", "type": "nat", "hook": "postrouting", "prio": 110=
}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat=
_POSTROUTING_ZONES"}}}, {"add": {"rule": {"family": "ip6", "table": "firewa=
lld", "chain": "nat_POSTROUTING", "expr": [{"jump": {"target": "nat_POSTROU=
TING_ZONES"}}]}}}, {"add": {"chain": {"family": "inet", "table": "firewalld=
", "name": "filter_INPUT", "type": "filter", "hook": "input", "prio": 10}}}=
, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "filte=
r_FORWARD", "type": "filter", "hook": "forward", "prio": 10}}}, {"add": {"c=
hain": {"family": "inet", "table": "firewalld", "name": "filter_OUTPUT", "t=
ype": "filter", "hook": "output", "prio": 10}}}, {"add": {"chain": {"family=
": "inet", "table": "firewalld", "name": "filter_INPUT_ZONES"}}}, {"add": {=
"rule": {"family": "inet", "table": "firewalld", "chain": "filter_INPUT", "=
expr": [{"match": {"left": {"ct": {"key": "state"}}, "op": "in", "right": {=
"set": ["established", "related"]}}}, {"accept": null}]}}}, {"add": {"rule"=
: {"family": "inet", "table": "firewalld", "chain": "filter_INPUT", "expr":=
 [{"match": {"left": {"ct": {"key": "status"}}, "op": "in", "right": "dnat"=
}}, {"accept": null}]}}}, {"add": {"rule": {"family": "inet", "table": "fir=
ewalld", "chain": "filter_INPUT", "expr": [{"match": {"left": {"meta": {"ke=
y": "iifname"}}, "op": "=3D=3D", "right": "lo"}}, {"accept": null}]}}}, {"a=
dd": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter_INP=
UT", "expr": [{"jump": {"target": "filter_INPUT_ZONES"}}]}}}, {"add": {"rul=
e": {"family": "inet", "table": "firewalld", "chain": "filter_INPUT", "expr=
": [{"match": {"left": {"ct": {"key": "state"}}, "op": "in", "right": {"set=
": ["invalid"]}}}, {"drop": null}]}}}, {"add": {"rule": {"family": "inet", =
"table": "firewalld", "chain": "filter_INPUT", "expr": [{"reject": {"type":=
 "icmpx", "expr": "admin-prohibited"}}]}}}, {"add": {"chain": {"family": "i=
net", "table": "firewalld", "name": "filter_FORWARD_IN_ZONES"}}}, {"add": {=
"chain": {"family": "inet", "table": "firewalld", "name": "filter_FORWARD_O=
UT_ZONES"}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "ch=
ain": "filter_FORWARD", "expr": [{"match": {"left": {"ct": {"key": "state"}=
}, "op": "in", "right": {"set": ["established", "related"]}}}, {"accept": n=
ull}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain"=
: "filter_FORWARD", "expr": [{"match": {"left": {"ct": {"key": "status"}}, =
"op": "in", "right": "dnat"}}, {"accept": null}]}}}, {"add": {"rule": {"fam=
ily": "inet", "table": "firewalld", "chain": "filter_FORWARD", "expr": [{"m=
atch": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "lo"=
}}, {"accept": null}]}}}, {"add": {"rule": {"family": "inet", "table": "fir=
ewalld", "chain": "filter_FORWARD", "expr": [{"jump": {"target": "filter_FO=
RWARD_IN_ZONES"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewa=
lld", "chain": "filter_FORWARD", "expr": [{"jump": {"target": "filter_FORWA=
RD_OUT_ZONES"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewall=
d", "chain": "filter_FORWARD", "expr": [{"match": {"left": {"ct": {"key": "=
state"}}, "op": "in", "right": {"set": ["invalid"]}}}, {"drop": null}]}}}, =
{"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter_=
FORWARD", "expr": [{"reject": {"type": "icmpx", "expr": "admin-prohibited"}=
}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "=
filter_OUTPUT", "expr": [{"match": {"left": {"meta": {"key": "oifname"}}, "=
op": "=3D=3D", "right": "lo"}}, {"accept": null}]}}}, {"insert": {"rule": {=
"family": "inet", "table": "firewalld", "chain": "raw_PREROUTING", "expr": =
[{"match": {"left": {"meta": {"key": "nfproto"}}, "op": "=3D=3D", "right": =
"ipv6"}}, {"match": {"left": {"fib": {"flags": ["saddr", "iif"], "result": =
"oif"}}, "op": "=3D=3D", "right": false}}, {"drop": null}]}}}, {"insert": {=
"rule": {"family": "inet", "table": "firewalld", "chain": "raw_PREROUTING",=
 "expr": [{"match": {"left": {"payload": {"protocol": "icmpv6", "field": "t=
ype"}}, "op": "=3D=3D", "right": {"set": ["nd-router-advert", "nd-neighbor-=
solicit"]}}}, {"accept": null}]}}},
 {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter=
_OUTPUT", "index": 0, "expr": [{"match": {"left": {"payload": {"protocol": =
"ip6", "field": "daddr"}}, "op": "=3D=3D", "right": {"set": [{"prefix": {"a=
ddr": "::0.0.0.0", "len": 96}}, {"prefix": {"addr": "::ffff:0.0.0.0", "len"=
: 96}}, {"prefix": {"addr": "2002:0000::", "len": 24}}, {"prefix": {"addr":=
 "2002:0a00::", "len": 24}}, {"prefix": {"addr": "2002:7f00::", "len": 24}}=
, {"prefix": {"addr": "2002:ac10::", "len": 28}}, {"prefix": {"addr": "2002=
:c0a8::", "len": 32}}, {"prefix": {"addr": "2002:a9fe::", "len": 32}}, {"pr=
efix": {"addr": "2002:e000::", "len": 19}}]}}}, {"reject": {"type": "icmpv6=
", "expr": "addr-unreachable"}}]}}}, {"add": {"rule": {"family": "inet", "t=
able": "firewalld", "chain": "filter_FORWARD", "index": 2, "expr": [{"match=
": {"left": {"payload": {"protocol": "ip6", "field": "daddr"}}, "op": "=3D=
=3D", "right": {"set": [{"prefix": {"addr": "::0.0.0.0", "len": 96}}, {"pre=
fix": {"addr": "::ffff:0.0.0.0", "len": 96}}, {"prefix": {"addr": "2002:000=
0::", "len": 24}}, {"prefix": {"addr": "2002:0a00::", "len": 24}}, {"prefix=
": {"addr": "2002:7f00::", "len": 24}}, {"prefix": {"addr": "2002:ac10::", =
"len": 28}}, {"prefix": {"addr": "2002:c0a8::", "len": 32}}, {"prefix": {"a=
ddr": "2002:a9fe::", "len": 32}}, {"prefix": {"addr": "2002:e000::", "len":=
 19}}]}}}, {"reject": {"type": "icmpv6", "expr": "addr-unreachable"}}]}}}, =
{"add": {"chain": {"family": "inet", "table": "firewalld", "name": "raw_PRE=
_public"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "na=
me": "raw_PRE_public_pre"}}}, {"add": {"chain": {"family": "inet", "table":=
 "firewalld", "name": "raw_PRE_public_log"}}}, {"add": {"chain": {"family":=
 "inet", "table": "firewalld", "name": "raw_PRE_public_deny"}}}, {"add": {"=
chain": {"family": "inet", "table": "firewalld", "name": "raw_PRE_public_al=
low"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name":=
 "raw_PRE_public_post"}}}, {"add": {"rule": {"family": "inet", "table": "fi=
rewalld", "chain": "raw_PRE_public", "expr": [{"jump": {"target": "raw_PRE_=
public_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld"=
, "chain": "raw_PRE_public", "expr": [{"jump": {"target": "raw_PRE_public_l=
og"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain=
": "raw_PRE_public", "expr": [{"jump": {"target": "raw_PRE_public_deny"}}]}=
}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "raw=
_PRE_public", "expr": [{"jump": {"target": "raw_PRE_public_allow"}}]}}}, {"=
add": {"rule": {"family": "inet", "table": "firewalld", "chain": "raw_PRE_p=
ublic", "expr": [{"jump": {"target": "raw_PRE_public_post"}}]}}}, {"add": {=
"chain": {"family": "inet", "table": "firewalld", "name": "filter_IN_public=
"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "f=
ilter_IN_public_pre"}}}, {"add": {"chain": {"family": "inet", "table": "fir=
ewalld", "name": "filter_IN_public_log"}}}, {"add": {"chain": {"family": "i=
net", "table": "firewalld", "name": "filter_IN_public_deny"}}}, {"add": {"c=
hain": {"family": "inet", "table": "firewalld", "name": "filter_IN_public_a=
llow"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name"=
: "filter_IN_public_post"}}}, {"add": {"rule": {"family": "inet", "table": =
"firewalld", "chain": "filter_IN_public", "expr": [{"jump": {"target": "fil=
ter_IN_public_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table": "fir=
ewalld", "chain": "filter_IN_public", "expr": [{"jump": {"target": "filter_=
IN_public_log"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewal=
ld", "chain": "filter_IN_public", "expr": [{"jump": {"target": "filter_IN_p=
ublic_deny"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld"=
, "chain": "filter_IN_public", "expr": [{"jump": {"target": "filter_IN_publ=
ic_allow"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", =
"chain": "filter_IN_public", "expr": [{"jump": {"target": "filter_IN_public=
_post"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "ch=
ain": "filter_IN_public_allow", "expr": [{"match": {"left": {"payload": {"p=
rotocol": "tcp", "field": "dport"}}, "op": "=3D=3D", "right": 22}}, {"match=
": {"left": {"ct": {"key": "state"}}, "op": "in", "right": {"set": ["new", =
"untracked"]}}}, {"accept": null}]}}}, {"add": {"rule": {"family": "inet", =
"table": "firewalld", "chain": "filter_IN_public_allow", "expr": [{"match":=
 {"left": {"payload": {"protocol": "ip6", "field": "daddr"}}, "op": "=3D=3D=
", "right": {"prefix": {"addr": "fe80::", "len": 64}}}}, {"match": {"left":=
 {"payload": {"protocol": "udp", "field": "dport"}}, "op": "=3D=3D", "right=
": 546}}, {"match": {"left": {"ct": {"key": "state"}}, "op": "in", "right":=
 {"set": ["new", "untracked"]}}}, {"accept": null}]}}}, {"add": {"chain": {=
"family": "inet", "table": "firewalld", "name": "filter_FWDI_public"}}}, {"=
add": {"chain": {"family": "inet", "table": "firewalld", "name": "filter_FW=
DI_public_pre"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld=
", "name": "filter_FWDI_public_log"}}}, {"add": {"chain": {"family": "inet"=
, "table": "firewalld", "name": "filter_FWDI_public_deny"}}}, {"add": {"cha=
in": {"family": "inet", "table": "firewalld", "name": "filter_FWDI_public_a=
llow"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name"=
: "filter_FWDI_public_post"}}}, {"add": {"rule": {"family": "inet", "table"=
: "firewalld", "chain": "filter_FWDI_public", "expr": [{"jump": {"target": =
"filter_FWDI_public_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table"=
: "firewalld", "chain": "filter_FWDI_public", "expr": [{"jump": {"target": =
"filter_FWDI_public_log"}}]}}}, {"add": {"rule": {"family": "inet", "table"=
: "firewalld", "chain": "filter_FWDI_public", "expr": [{"jump": {"target": =
"filter_FWDI_public_deny"}}]}}}, {"add": {"rule": {"family": "inet", "table=
": "firewalld", "chain": "filter_FWDI_public", "expr": [{"jump": {"target":=
 "filter_FWDI_public_allow"}}]}}}, {"add": {"rule": {"family": "inet", "tab=
le": "firewalld", "chain": "filter_FWDI_public", "expr": [{"jump": {"target=
": "filter_FWDI_public_post"}}]}}}, {"add": {"rule": {"family": "inet", "ta=
ble": "firewalld", "chain": "filter_IN_public", "index": 4, "expr": [{"matc=
h": {"left": {"meta": {"key": "l4proto"}}, "op": "=3D=3D", "right": {"set":=
 ["icmp", "icmpv6"]}}}, {"accept": null}]}}}, {"add": {"rule": {"family": "=
inet", "table": "firewalld", "chain": "filter_FWDI_public", "index": 4, "ex=
pr": [{"match": {"left": {"meta": {"key": "l4proto"}}, "op": "=3D=3D", "rig=
ht": {"set": ["icmp", "icmpv6"]}}}, {"accept": null}]}}}, {"add": {"rule": =
{"family": "inet", "table": "firewalld", "chain": "raw_PREROUTING_ZONES", "=
expr": [{"goto": {"target": "raw_PRE_public"}}]}}}, {"add": {"chain": {"fam=
ily": "inet", "table": "firewalld", "name": "mangle_PRE_public"}}}, {"add":=
 {"chain": {"family": "inet", "table": "firewalld", "name": "mangle_PRE_pub=
lic_pre"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "na=
me": "mangle_PRE_public_log"}}}, {"add": {"chain": {"family": "inet", "tabl=
e": "firewalld", "name": "mangle_PRE_public_deny"}}}, {"add": {"chain": {"f=
amily": "inet", "table": "firewalld", "name": "mangle_PRE_public_allow"}}},=
 {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "mangle=
_PRE_public_post"}}}, {"add": {"rule": {"family": "inet", "table": "firewal=
ld", "chain": "mangle_PRE_public", "expr": [{"jump": {"target": "mangle_PRE=
_public_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld=
", "chain": "mangle_PRE_public", "expr": [{"jump": {"target": "mangle_PRE_p=
ublic_log"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld",=
 "chain": "mangle_PRE_public", "expr": [{"jump": {"target": "mangle_PRE_pub=
lic_deny"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", =
"chain": "mangle_PRE_public", "expr": [{"jump": {"target": "mangle_PRE_publ=
ic_allow"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", =
"chain": "mangle_PRE_public", "expr": [{"jump": {"target": "mangle_PRE_publ=
ic_post"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "=
chain": "mangle_PREROUTING_ZONES", "expr": [{"goto": {"target": "mangle_PRE=
_public"}}]}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "n=
ame": "nat_PRE_public"}}}, {"add": {"chain": {"family": "ip", "table": "fir=
ewalld", "name": "nat_PRE_public_pre"}}}, {"add": {"chain": {"family": "ip"=
, "table": "firewalld", "name": "nat_PRE_public_log"}}}, {"add": {"chain": =
{"family": "ip", "table": "firewalld", "name": "nat_PRE_public_deny"}}}, {"=
add": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_PRE_pub=
lic_allow"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "na=
me": "nat_PRE_public_post"}}}, {"add": {"rule": {"family": "ip", "table": "=
firewalld", "chain": "nat_PRE_public", "expr": [{"jump": {"target": "nat_PR=
E_public_pre"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld"=
, "chain": "nat_PRE_public", "expr": [{"jump": {"target": "nat_PRE_public_l=
og"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain":=
 "nat_PRE_public", "expr": [{"jump": {"target": "nat_PRE_public_deny"}}]}}}=
, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat_PRE=
_public", "expr": [{"jump": {"target": "nat_PRE_public_allow"}}]}}}, {"add"=
: {"rule": {"family": "ip", "table": "firewalld", "chain": "nat_PRE_public"=
, "expr": [{"jump": {"target": "nat_PRE_public_post"}}]}}}, {"add": {"chain=
": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_public"}}}, {"a=
dd": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_pub=
lic_pre"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "nam=
e": "nat_PRE_public_log"}}}, {"add": {"chain": {"family": "ip6", "table": "=
firewalld", "name": "nat_PRE_public_deny"}}}, {"add": {"chain": {"family": =
"ip6", "table": "firewalld", "name": "nat_PRE_public_allow"}}}, {"add": {"c=
hain": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_public_post=
"}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "na=
t_PRE_public", "expr": [{"jump": {"target": "nat_PRE_public_pre"}}]}}}, {"a=
dd": {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_pub=
lic", "expr": [{"jump": {"target": "nat_PRE_public_log"}}]}}}, {"add": {"ru=
le": {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_public", "ex=
pr": [{"jump": {"target": "nat_PRE_public_deny"}}]}}}, {"add": {"rule": {"f=
amily": "ip6", "table": "firewalld", "chain": "nat_PRE_public", "expr": [{"=
jump": {"target": "nat_PRE_public_allow"}}]}}}, {"add": {"rule": {"family":=
 "ip6", "table": "firewalld", "chain": "nat_PRE_public", "expr": [{"jump": =
{"target": "nat_PRE_public_post"}}]}}}, {"add": {"rule": {"family": "ip", "=
table": "firewalld", "chain": "nat_PREROUTING_ZONES", "expr": [{"goto": {"t=
arget": "nat_PRE_public"}}]}}}, {"add": {"rule": {"family": "ip6", "table":=
 "firewalld", "chain": "nat_PREROUTING_ZONES", "expr": [{"goto": {"target":=
 "nat_PRE_public"}}]}}}, {"add": {"chain": {"family": "ip", "table": "firew=
alld", "name": "nat_POST_public"}}}, {"add": {"chain": {"family": "ip", "ta=
ble": "firewalld", "name": "nat_POST_public_pre"}}}, {"add": {"chain": {"fa=
mily": "ip", "table": "firewalld", "name": "nat_POST_public_log"}}}, {"add"=
: {"chain": {"family": "ip", "table": "firewalld", "name": "nat_POST_public=
_deny"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name":=
 "nat_POST_public_allow"}}}, {"add": {"chain": {"family": "ip", "table": "f=
irewalld", "name": "nat_POST_public_post"}}}, {"add": {"rule": {"family": "=
ip", "table": "firewalld", "chain": "nat_POST_public", "expr": [{"jump": {"=
target": "nat_POST_public_pre"}}]}}}, {"add": {"rule": {"family": "ip", "ta=
ble": "firewalld", "chain": "nat_POST_public", "expr": [{"jump": {"target":=
 "nat_POST_public_log"}}]}}}, {"add": {"rule": {"family": "ip", "table": "f=
irewalld", "chain": "nat_POST_public", "expr": [{"jump": {"target": "nat_PO=
ST_public_deny"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewall=
d", "chain": "nat_POST_public", "expr": [{"jump": {"target": "nat_POST_publ=
ic_allow"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "c=
hain": "nat_POST_public", "expr": [{"jump": {"target": "nat_POST_public_pos=
t"}}]}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name":=
 "nat_POST_public"}}}, {"add": {"chain": {"family": "ip6", "table": "firewa=
lld", "name": "nat_POST_public_pre"}}}, {"add": {"chain": {"family": "ip6",=
 "table": "firewalld", "name": "nat_POST_public_log"}}}, {"add": {"chain": =
{"family": "ip6", "table": "firewalld", "name": "nat_POST_public_deny"}}}, =
{"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_POST=
_public_allow"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld"=
, "name": "nat_POST_public_post"}}}, {"add": {"rule": {"family": "ip6", "ta=
ble": "firewalld", "chain": "nat_POST_public", "expr": [{"jump": {"target":=
 "nat_POST_public_pre"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "=
firewalld", "chain": "nat_POST_public", "expr": [{"jump": {"target": "nat_P=
OST_public_log"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewal=
ld", "chain": "nat_POST_public", "expr": [{"jump": {"target": "nat_POST_pub=
lic_deny"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "=
chain": "nat_POST_public", "expr": [{"jump": {"target": "nat_POST_public_al=
low"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "chain=
": "nat_POST_public", "expr": [{"jump": {"target": "nat_POST_public_post"}}=
]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat=
_POSTROUTING_ZONES", "expr": [{"goto": {"target": "nat_POST_public"}}]}}}, =
{"add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_POST=
ROUTING_ZONES", "expr": [{"goto": {"target": "nat_POST_public"}}]}}}, {"add=
": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter_INPUT=
_ZONES", "expr": [{"goto": {"target": "filter_IN_public"}}]}}}, {"add": {"r=
ule": {"family": "inet", "table": "firewalld", "chain": "filter_FORWARD_IN_=
ZONES", "expr": [{"goto": {"target": "filter_FWDI_public"}}]}}}, {"add": {"=
chain": {"family": "inet", "table": "firewalld", "name": "filter_FWDO_publi=
c"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "=
filter_FWDO_public_pre"}}}, {"add": {"chain": {"family": "inet", "table": "=
firewalld", "name": "filter_FWDO_public_log"}}}, {"add": {"chain": {"family=
": "inet", "table": "firewalld", "name": "filter_FWDO_public_deny"}}}, {"ad=
d": {"chain": {"family": "inet", "table": "firewalld", "name": "filter_FWDO=
_public_allow"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld=
", "name": "filter_FWDO_public_post"}}}, {"add": {"rule": {"family": "inet"=
, "table": "firewalld", "chain": "filter_FWDO_public", "expr": [{"jump": {"=
target": "filter_FWDO_public_pre"}}]}}}, {"add": {"rule": {"family": "inet"=
, "table": "firewalld", "chain": "filter_FWDO_public", "expr": [{"jump": {"=
target": "filter_FWDO_public_log"}}]}}}, {"add": {"rule": {"family": "inet"=
, "table": "firewalld", "chain": "filter_FWDO_public", "expr": [{"jump": {"=
target": "filter_FWDO_public_deny"}}]}}}, {"add": {"rule": {"family": "inet=
", "table": "firewalld", "chain": "filter_FWDO_public", "expr": [{"jump": {=
"target": "filter_FWDO_public_allow"}}]}}}, {"add": {"rule": {"family": "in=
et", "table": "firewalld", "chain": "filter_FWDO_public", "expr": [{"jump":=
 {"target": "filter_FWDO_public_post"}}]}}}, {"add": {"rule": {"family": "i=
net", "table": "firewalld", "chain": "filter_FORWARD_OUT_ZONES", "expr": [{=
"goto": {"target": "filter_FWDO_public"}}]}}}, {"add": {"chain": {"family":=
 "inet", "table": "firewalld", "name": "raw_PRE_trusted"}}}, {"add": {"chai=
n": {"family": "inet", "table": "firewalld", "name": "raw_PRE_trusted_pre"}=
}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "raw=
_PRE_trusted_log"}}}, {"add": {"chain": {"family": "inet", "table": "firewa=
lld", "name": "raw_PRE_trusted_deny"}}}, {"add": {"chain": {"family": "inet=
", "table": "firewalld", "name": "raw_PRE_trusted_allow"}}}, {"add": {"chai=
n": {"family": "inet", "table": "firewalld", "name": "raw_PRE_trusted_post"=
}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "ra=
w_PRE_trusted", "expr": [{"jump": {"target": "raw_PRE_trusted_pre"}}]}}}, {=
"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "raw_PRE_=
trusted", "expr": [{"jump": {"target": "raw_PRE_trusted_log"}}]}}}, {"add":=
 {"rule": {"family": "inet", "table": "firewalld", "chain": "raw_PRE_truste=
d", "expr": [{"jump": {"target": "raw_PRE_trusted_deny"}}]}}}, {"add": {"ru=
le": {"family": "inet", "table": "firewalld", "chain": "raw_PRE_trusted", "=
expr": [{"jump": {"target": "raw_PRE_trusted_allow"}}]}}}, {"add": {"rule":=
 {"family": "inet", "table": "firewalld", "chain": "raw_PRE_trusted", "expr=
": [{"jump": {"target": "raw_PRE_trusted_post"}}]}}}, {"insert": {"rule": {=
"family": "inet", "table": "firewalld", "chain": "raw_PREROUTING_ZONES", "e=
xpr": [{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "ri=
ght": "perm_dummy2"}}, {"goto": {"target": "raw_PRE_trusted"}}]}}}, {"add":=
 {"chain": {"family": "inet", "table": "firewalld", "name": "mangle_PRE_tru=
sted"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name"=
: "mangle_PRE_trusted_pre"}}}, {"add": {"chain": {"family": "inet", "table"=
: "firewalld", "name": "mangle_PRE_trusted_log"}}}, {"add": {"chain": {"fam=
ily": "inet", "table": "firewalld", "name": "mangle_PRE_trusted_deny"}}}, {=
"add": {"chain": {"family": "inet", "table": "firewalld", "name": "mangle_P=
RE_trusted_allow"}}}, {"add": {"chain": {"family": "inet", "table": "firewa=
lld", "name": "mangle_PRE_trusted_post"}}}, {"add": {"rule": {"family": "in=
et", "table": "firewalld", "chain": "mangle_PRE_trusted", "expr": [{"jump":=
 {"target": "mangle_PRE_trusted_pre"}}]}}}, {"add": {"rule": {"family": "in=
et", "table": "firewalld", "chain": "mangle_PRE_trusted", "expr": [{"jump":=
 {"target": "mangle_PRE_trusted_log"}}]}}}, {"add": {"rule": {"family": "in=
et", "table": "firewalld", "chain": "mangle_PRE_trusted", "expr": [{"jump":=
 {"target": "mangle_PRE_trusted_deny"}}]}}}, {"add": {"rule": {"family": "i=
net", "table": "firewalld", "chain": "mangle_PRE_trusted", "expr": [{"jump"=
: {"target": "mangle_PRE_trusted_allow"}}]}}}, {"add": {"rule": {"family": =
"inet", "table": "firewalld", "chain": "mangle_PRE_trusted", "expr": [{"jum=
p": {"target": "mangle_PRE_trusted_post"}}]}}}, {"insert": {"rule": {"famil=
y": "inet", "table": "firewalld", "chain": "mangle_PREROUTING_ZONES", "expr=
": [{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right=
": "perm_dummy2"}}, {"goto": {"target": "mangle_PRE_trusted"}}]}}}, {"add":=
 {"chain": {"family": "ip", "table": "firewalld", "name": "nat_PRE_trusted"=
}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_=
PRE_trusted_pre"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld=
", "name": "nat_PRE_trusted_log"}}}, {"add": {"chain": {"family": "ip", "ta=
ble": "firewalld", "name": "nat_PRE_trusted_deny"}}}, {"add": {"chain": {"f=
amily": "ip", "table": "firewalld", "name": "nat_PRE_trusted_allow"}}}, {"a=
dd": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_PRE_trus=
ted_post"}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chai=
n": "nat_PRE_trusted", "expr": [{"jump": {"target": "nat_PRE_trusted_pre"}}=
]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat=
_PRE_trusted", "expr": [{"jump": {"target": "nat_PRE_trusted_log"}}]}}}, {"=
add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat_PRE_tru=
sted", "expr": [{"jump": {"target": "nat_PRE_trusted_deny"}}]}}}, {"add": {=
"rule": {"family": "ip", "table": "firewalld", "chain": "nat_PRE_trusted", =
"expr": [{"jump": {"target": "nat_PRE_trusted_allow"}}]}}}, {"add": {"rule"=
: {"family": "ip", "table": "firewalld", "chain": "nat_PRE_trusted", "expr"=
: [{"jump": {"target": "nat_PRE_trusted_post"}}]}}}, {"add": {"chain": {"fa=
mily": "ip6", "table": "firewalld", "name": "nat_PRE_trusted"}}}, {"add": {=
"chain": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_trusted_p=
re"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "=
nat_PRE_trusted_log"}}}, {"add": {"chain": {"family": "ip6", "table": "fire=
walld", "name": "nat_PRE_trusted_deny"}}}, {"add": {"chain": {"family": "ip=
6", "table": "firewalld", "name": "nat_PRE_trusted_allow"}}}, {"add": {"cha=
in": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_trusted_post"=
}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat=
_PRE_trusted", "expr": [{"jump": {"target": "nat_PRE_trusted_pre"}}]}}}, {"=
add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_tr=
usted", "expr": [{"jump": {"target": "nat_PRE_trusted_log"}}]}}}, {"add": {=
"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_trusted",=
 "expr": [{"jump": {"target": "nat_PRE_trusted_deny"}}]}}}, {"add": {"rule"=
: {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_trusted", "expr=
": [{"jump": {"target": "nat_PRE_trusted_allow"}}]}}}, {"add": {"rule": {"f=
amily": "ip6", "table": "firewalld", "chain": "nat_PRE_trusted", "expr": [{=
"jump": {"target": "nat_PRE_trusted_post"}}]}}}, {"insert": {"rule": {"fami=
ly": "ip", "table": "firewalld", "chain": "nat_PREROUTING_ZONES", "expr": [=
{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "=
perm_dummy2"}}, {"goto": {"target": "nat_PRE_trusted"}}]}}}, {"insert": {"r=
ule": {"family": "ip6", "table": "firewalld", "chain": "nat_PREROUTING_ZONE=
S", "expr": [{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D=
", "right": "perm_dummy2"}}, {"goto": {"target": "nat_PRE_trusted"}}]}}}, {=
"add": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_POST_t=
rusted"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name"=
: "nat_POST_trusted_pre"}}}, {"add": {"chain": {"family": "ip", "table": "f=
irewalld", "name": "nat_POST_trusted_log"}}}, {"add": {"chain": {"family": =
"ip", "table": "firewalld", "name": "nat_POST_trusted_deny"}}}, {"add": {"c=
hain": {"family": "ip", "table": "firewalld", "name": "nat_POST_trusted_all=
ow"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "n=
at_POST_trusted_post"}}}, {"add": {"rule": {"family": "ip", "table": "firew=
alld", "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_=
trusted_pre"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld",=
 "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_truste=
d_log"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chai=
n": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_trusted_deny=
"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "=
nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_trusted_allow"}}]=
}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat_=
POST_trusted", "expr": [{"jump": {"target": "nat_POST_trusted_post"}}]}}}, =
{"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_POST=
_trusted"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "na=
me": "nat_POST_trusted_pre"}}}, {"add": {"chain": {"family": "ip6", "table"=
: "firewalld", "name": "nat_POST_trusted_log"}}}, {"add": {"chain": {"famil=
y": "ip6", "table": "firewalld", "name": "nat_POST_trusted_deny"}}}, {"add"=
: {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_POST_trust=
ed_allow"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "na=
me": "nat_POST_trusted_post"}}}, {"add": {"rule": {"family": "ip6", "table"=
: "firewalld", "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "n=
at_POST_trusted_pre"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "fi=
rewalld", "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_PO=
ST_trusted_log"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewal=
ld", "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_tr=
usted_deny"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld",=
 "chain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_truste=
d_allow"}}]}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "c=
hain": "nat_POST_trusted", "expr": [{"jump": {"target": "nat_POST_trusted_p=
ost"}}]}}}, {"insert": {"rule": {"family": "ip", "table": "firewalld", "cha=
in": "nat_POSTROUTING_ZONES", "expr": [{"match": {"left": {"meta": {"key": =
"oifname"}}, "op": "=3D=3D", "right": "perm_dummy2"}}, {"goto": {"target": =
"nat_POST_trusted"}}]}}}, {"insert": {"rule": {"family": "ip6", "table": "f=
irewalld", "chain": "nat_POSTROUTING_ZONES", "expr": [{"match": {"left": {"=
meta": {"key": "oifname"}}, "op": "=3D=3D", "right": "perm_dummy2"}}, {"got=
o": {"target": "nat_POST_trusted"}}]}}}, {"add": {"chain": {"family": "inet=
", "table": "firewalld", "name": "filter_IN_trusted"}}}, {"add": {"chain": =
{"family": "inet", "table": "firewalld", "name": "filter_IN_trusted_pre"}}}=
, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "filte=
r_IN_trusted_log"}}}, {"add": {"chain": {"family": "inet", "table": "firewa=
lld", "name": "filter_IN_trusted_deny"}}}, {"add": {"chain": {"family": "in=
et", "table": "firewalld", "name": "filter_IN_trusted_allow"}}}, {"add": {"=
chain": {"family": "inet", "table": "firewalld", "name": "filter_IN_trusted=
_post"}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain=
": "filter_IN_trusted", "expr": [{"jump": {"target": "filter_IN_trusted_pre=
"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain":=
 "filter_IN_trusted", "expr": [{"jump": {"target": "filter_IN_trusted_log"}=
}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "=
filter_IN_trusted", "expr": [{"jump": {"target": "filter_IN_trusted_deny"}}=
]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "f=
ilter_IN_trusted", "expr": [{"jump": {"target": "filter_IN_trusted_allow"}}=
]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "f=
ilter_IN_trusted", "expr": [{"jump": {"target": "filter_IN_trusted_post"}}]=
}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "fi=
lter_IN_trusted", "expr": [{"accept": null}]}}}, {"insert": {"rule": {"fami=
ly": "inet", "table": "firewalld", "chain": "filter_INPUT_ZONES", "expr": [=
{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "=
perm_dummy2"}}, {"goto": {"target": "filter_IN_trusted"}}]}}}, {"add": {"ch=
ain": {"family": "inet", "table": "firewalld", "name": "filter_FWDI_trusted=
"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "f=
ilter_FWDI_trusted_pre"}}}, {"add": {"chain": {"family": "inet", "table": "=
firewalld", "name": "filter_FWDI_trusted_log"}}}, {"add": {"chain": {"famil=
y": "inet", "table": "firewalld", "name": "filter_FWDI_trusted_deny"}}}, {"=
add": {"chain": {"family": "inet", "table": "firewalld", "name": "filter_FW=
DI_trusted_allow"}}}, {"add": {"chain": {"family": "inet", "table": "firewa=
lld", "name": "filter_FWDI_trusted_post"}}}, {"add": {"rule": {"family": "i=
net", "table": "firewalld", "chain": "filter_FWDI_trusted", "expr": [{"jump=
": {"target": "filter_FWDI_trusted_pre"}}]}}}, {"add": {"rule": {"family": =
"inet", "table": "firewalld", "chain": "filter_FWDI_trusted", "expr": [{"ju=
mp": {"target": "filter_FWDI_trusted_log"}}]}}}, {"add": {"rule": {"family"=
: "inet", "table": "firewalld", "chain": "filter_FWDI_trusted", "expr": [{"=
jump": {"target": "filter_FWDI_trusted_deny"}}]}}}, {"add": {"rule": {"fami=
ly": "inet", "table": "firewalld", "chain": "filter_FWDI_trusted", "expr": =
[{"jump": {"target": "filter_FWDI_trusted_allow"}}]}}}, {"add": {"rule": {"=
family": "inet", "table": "firewalld", "chain": "filter_FWDI_trusted", "exp=
r": [{"jump": {"target": "filter_FWDI_trusted_post"}}]}}}, {"add": {"rule":=
 {"family": "inet", "table": "firewalld", "chain": "filter_FWDI_trusted", "=
expr": [{"accept": null}]}}}, {"insert": {"rule": {"family": "inet", "table=
": "firewalld", "chain": "filter_FORWARD_IN_ZONES", "expr": [{"match": {"le=
ft": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "perm_dummy2"}}=
, {"goto": {"target": "filter_FWDI_trusted"}}]}}}, {"add": {"chain": {"fami=
ly": "inet", "table": "firewalld", "name": "filter_FWDO_trusted"}}}, {"add"=
: {"chain": {"family": "inet", "table": "firewalld", "name": "filter_FWDO_t=
rusted_pre"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", =
"name": "filter_FWDO_trusted_log"}}}, {"add": {"chain": {"family": "inet", =
"table": "firewalld", "name": "filter_FWDO_trusted_deny"}}}, {"add": {"chai=
n": {"family": "inet", "table": "firewalld", "name": "filter_FWDO_trusted_a=
llow"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name"=
: "filter_FWDO_trusted_post"}}}, {"add": {"rule": {"family": "inet", "table=
": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"jump": {"target"=
: "filter_FWDO_trusted_pre"}}]}}}, {"add": {"rule": {"family": "inet", "tab=
le": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"jump": {"targe=
t": "filter_FWDO_trusted_log"}}]}}}, {"add": {"rule": {"family": "inet", "t=
able": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"jump": {"tar=
get": "filter_FWDO_trusted_deny"}}]}}}, {"add": {"rule": {"family": "inet",=
 "table": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"jump": {"=
target": "filter_FWDO_trusted_allow"}}]}}}, {"add": {"rule": {"family": "in=
et", "table": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"jump"=
: {"target": "filter_FWDO_trusted_post"}}]}}}, {"add": {"rule": {"family": =
"inet", "table": "firewalld", "chain": "filter_FWDO_trusted", "expr": [{"ac=
cept": null}]}}}, {"insert": {"rule": {"family": "inet", "table": "firewall=
d", "chain": "filter_FORWARD_OUT_ZONES", "expr": [{"match": {"left": {"meta=
": {"key": "oifname"}}, "op": "=3D=3D", "right": "perm_dummy2"}}, {"goto": =
{"target": "filter_FWDO_trusted"}}]}}}, {"add": {"chain": {"family": "inet"=
, "table": "firewalld", "name": "raw_PRE_work"}}}, {"add": {"chain": {"fami=
ly": "inet", "table": "firewalld", "name": "raw_PRE_work_pre"}}}, {"add": {=
"chain": {"family": "inet", "table": "firewalld", "name": "raw_PRE_work_log=
"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "r=
aw_PRE_work_deny"}}}, {"add": {"chain": {"family": "inet", "table": "firewa=
lld", "name": "raw_PRE_work_allow"}}}, {"add": {"chain": {"family": "inet",=
 "table": "firewalld", "name": "raw_PRE_work_post"}}}, {"add": {"rule": {"f=
amily": "inet", "table": "firewalld", "chain": "raw_PRE_work", "expr": [{"j=
ump": {"target": "raw_PRE_work_pre"}}]}}}, {"add": {"rule": {"family": "ine=
t", "table": "firewalld", "chain": "raw_PRE_work", "expr": [{"jump": {"targ=
et": "raw_PRE_work_log"}}]}}}, {"add": {"rule": {"family": "inet", "table":=
 "firewalld", "chain": "raw_PRE_work", "expr": [{"jump": {"target": "raw_PR=
E_work_deny"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld=
", "chain": "raw_PRE_work", "expr": [{"jump": {"target": "raw_PRE_work_allo=
w"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain"=
: "raw_PRE_work", "expr": [{"jump": {"target": "raw_PRE_work_post"}}]}}}, {=
"add": {"chain": {"family": "inet", "table": "firewalld", "name": "filter_I=
N_work"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "nam=
e": "filter_IN_work_pre"}}}, {"add": {"chain": {"family": "inet", "table": =
"firewalld", "name": "filter_IN_work_log"}}}, {"add": {"chain": {"family": =
"inet", "table": "firewalld", "name": "filter_IN_work_deny"}}}, {"add": {"c=
hain": {"family": "inet", "table": "firewalld", "name": "filter_IN_work_all=
ow"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": =
"filter_IN_work_post"}}}, {"add": {"rule": {"family": "inet", "table": "fir=
ewalld", "chain": "filter_IN_work", "expr": [{"jump": {"target": "filter_IN=
_work_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld",=
 "chain": "filter_IN_work", "expr": [{"jump": {"target": "filter_IN_work_lo=
g"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain"=
: "filter_IN_work", "expr": [{"jump": {"target": "filter_IN_work_deny"}}]}}=
}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "filt=
er_IN_work", "expr": [{"jump": {"target": "filter_IN_work_allow"}}]}}}, {"a=
dd": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter_IN_=
work", "expr": [{"jump": {"target": "filter_IN_work_post"}}]}}}, {"add": {"=
rule": {"family": "inet", "table": "firewalld", "chain": "filter_IN_work_al=
low", "expr": [{"match": {"left": {"payload": {"protocol": "tcp", "field": =
"dport"}}, "op": "=3D=3D", "right": 22}}, {"match": {"left": {"ct": {"key":=
 "state"}}, "op": "in", "right": {"set": ["new", "untracked"]}}}, {"accept"=
: null}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "cha=
in": "filter_IN_work_allow", "expr": [{"match": {"left": {"payload": {"prot=
ocol": "ip6", "field": "daddr"}}, "op": "=3D=3D", "right": {"prefix": {"add=
r": "fe80::", "len": 64}}}}, {"match": {"left": {"payload": {"protocol": "u=
dp", "field": "dport"}}, "op": "=3D=3D", "right": 546}}, {"match": {"left":=
 {"ct": {"key": "state"}}, "op": "in", "right": {"set": ["new", "untracked"=
]}}}, {"accept": null}]}}}, {"insert": {"rule": {"family": "inet", "table":=
 "firewalld", "chain": "raw_PREROUTING_ZONES", "expr": [{"match": {"left": =
{"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "perm_dummy"}}, {"go=
to": {"target": "raw_PRE_work"}}]}}}, {"add": {"chain": {"family": "inet", =
"table": "firewalld", "name": "mangle_PRE_work"}}}, {"add": {"chain": {"fam=
ily": "inet", "table": "firewalld", "name": "mangle_PRE_work_pre"}}}, {"add=
": {"chain": {"family": "inet", "table": "firewalld", "name": "mangle_PRE_w=
ork_log"}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "na=
me": "mangle_PRE_work_deny"}}}, {"add": {"chain": {"family": "inet", "table=
": "firewalld", "name": "mangle_PRE_work_allow"}}}, {"add": {"chain": {"fam=
ily": "inet", "table": "firewalld", "name": "mangle_PRE_work_post"}}}, {"ad=
d": {"rule": {"family": "inet", "table": "firewalld", "chain": "mangle_PRE_=
work", "expr": [{"jump": {"target": "mangle_PRE_work_pre"}}]}}}, {"add": {"=
rule": {"family": "inet", "table": "firewalld", "chain": "mangle_PRE_work",=
 "expr": [{"jump": {"target": "mangle_PRE_work_log"}}]}}}, {"add": {"rule":=
 {"family": "inet", "table": "firewalld", "chain": "mangle_PRE_work", "expr=
": [{"jump": {"target": "mangle_PRE_work_deny"}}]}}}, {"add": {"rule": {"fa=
mily": "inet", "table": "firewalld", "chain": "mangle_PRE_work", "expr": [{=
"jump": {"target": "mangle_PRE_work_allow"}}]}}}, {"add": {"rule": {"family=
": "inet", "table": "firewalld", "chain": "mangle_PRE_work", "expr": [{"jum=
p": {"target": "mangle_PRE_work_post"}}]}}}, {"insert": {"rule": {"family":=
 "inet", "table": "firewalld", "chain": "mangle_PREROUTING_ZONES", "expr": =
[{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": =
"perm_dummy"}}, {"goto": {"target": "mangle_PRE_work"}}]}}}, {"add": {"chai=
n": {"family": "ip", "table": "firewalld", "name": "nat_PRE_work"}}}, {"add=
": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_PRE_work_p=
re"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "n=
at_PRE_work_log"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld=
", "name": "nat_PRE_work_deny"}}}, {"add": {"chain": {"family": "ip", "tabl=
e": "firewalld", "name": "nat_PRE_work_allow"}}}, {"add": {"chain": {"famil=
y": "ip", "table": "firewalld", "name": "nat_PRE_work_post"}}}, {"add": {"r=
ule": {"family": "ip", "table": "firewalld", "chain": "nat_PRE_work", "expr=
": [{"jump": {"target": "nat_PRE_work_pre"}}]}}}, {"add": {"rule": {"family=
": "ip", "table": "firewalld", "chain": "nat_PRE_work", "expr": [{"jump": {=
"target": "nat_PRE_work_log"}}]}}}, {"add": {"rule": {"family": "ip", "tabl=
e": "firewalld", "chain": "nat_PRE_work", "expr": [{"jump": {"target": "nat=
_PRE_work_deny"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewall=
d", "chain": "nat_PRE_work", "expr": [{"jump": {"target": "nat_PRE_work_all=
ow"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain":=
 "nat_PRE_work", "expr": [{"jump": {"target": "nat_PRE_work_post"}}]}}}, {"=
add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_wo=
rk"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "=
nat_PRE_work_pre"}}}, {"add": {"chain": {"family": "ip6", "table": "firewal=
ld", "name": "nat_PRE_work_log"}}}, {"add": {"chain": {"family": "ip6", "ta=
ble": "firewalld", "name": "nat_PRE_work_deny"}}}, {"add": {"chain": {"fami=
ly": "ip6", "table": "firewalld", "name": "nat_PRE_work_allow"}}}, {"add": =
{"chain": {"family": "ip6", "table": "firewalld", "name": "nat_PRE_work_pos=
t"}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "n=
at_PRE_work", "expr": [{"jump": {"target": "nat_PRE_work_pre"}}]}}}, {"add"=
: {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_PRE_work",=
 "expr": [{"jump": {"target": "nat_PRE_work_log"}}]}}}, {"add": {"rule": {"=
family": "ip6", "table": "firewalld", "chain": "nat_PRE_work", "expr": [{"j=
ump": {"target": "nat_PRE_work_deny"}}]}}}, {"add": {"rule": {"family": "ip=
6", "table": "firewalld", "chain": "nat_PRE_work", "expr": [{"jump": {"targ=
et": "nat_PRE_work_allow"}}]}}}, {"add": {"rule": {"family": "ip6", "table"=
: "firewalld", "chain": "nat_PRE_work", "expr": [{"jump": {"target": "nat_P=
RE_work_post"}}]}}}, {"insert": {"rule": {"family": "ip", "table": "firewal=
ld", "chain": "nat_PREROUTING_ZONES", "expr": [{"match": {"left": {"meta": =
{"key": "iifname"}}, "op": "=3D=3D", "right": "perm_dummy"}}, {"goto": {"ta=
rget": "nat_PRE_work"}}]}}}, {"insert": {"rule": {"family": "ip6", "table":=
 "firewalld", "chain": "nat_PREROUTING_ZONES", "expr": [{"match": {"left": =
{"meta": {"key": "iifname"}}, "op": "=3D=3D", "right": "perm_dummy"}}, {"go=
to": {"target": "nat_PRE_work"}}]}}}, {"add": {"chain": {"family": "ip", "t=
able": "firewalld", "name": "nat_POST_work"}}}, {"add": {"chain": {"family"=
: "ip", "table": "firewalld", "name": "nat_POST_work_pre"}}}, {"add": {"cha=
in": {"family": "ip", "table": "firewalld", "name": "nat_POST_work_log"}}},=
 {"add": {"chain": {"family": "ip", "table": "firewalld", "name": "nat_POST=
_work_deny"}}}, {"add": {"chain": {"family": "ip", "table": "firewalld", "n=
ame": "nat_POST_work_allow"}}}, {"add": {"chain": {"family": "ip", "table":=
 "firewalld", "name": "nat_POST_work_post"}}}, {"add": {"rule": {"family": =
"ip", "table": "firewalld", "chain": "nat_POST_work", "expr": [{"jump": {"t=
arget": "nat_POST_work_pre"}}]}}}, {"add": {"rule": {"family": "ip", "table=
": "firewalld", "chain": "nat_POST_work", "expr": [{"jump": {"target": "nat=
_POST_work_log"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewall=
d", "chain": "nat_POST_work", "expr": [{"jump": {"target": "nat_POST_work_d=
eny"}}]}}}, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain"=
: "nat_POST_work", "expr": [{"jump": {"target": "nat_POST_work_allow"}}]}}}=
, {"add": {"rule": {"family": "ip", "table": "firewalld", "chain": "nat_POS=
T_work", "expr": [{"jump": {"target": "nat_POST_work_post"}}]}}}, {"add": {=
"chain": {"family": "ip6", "table": "firewalld", "name": "nat_POST_work"}}}=
, {"add": {"chain": {"family": "ip6", "table": "firewalld", "name": "nat_PO=
ST_work_pre"}}}, {"add": {"chain": {"family": "ip6", "table": "firewalld", =
"name": "nat_POST_work_log"}}}, {"add": {"chain": {"family": "ip6", "table"=
: "firewalld", "name": "nat_POST_work_deny"}}}, {"add": {"chain": {"family"=
: "ip6", "table": "firewalld", "name": "nat_POST_work_allow"}}}, {"add": {"=
chain": {"family": "ip6", "table": "firewalld", "name": "nat_POST_work_post=
"}}}, {"add": {"rule": {"family": "ip6", "table": "firewalld", "chain": "na=
t_POST_work", "expr": [{"jump": {"target": "nat_POST_work_pre"}}]}}}, {"add=
": {"rule": {"family": "ip6", "table": "firewalld", "chain": "nat_POST_work=
", "expr": [{"jump": {"target": "nat_POST_work_log"}}]}}}, {"add": {"rule":=
 {"family": "ip6", "table": "firewalld", "chain": "nat_POST_work", "expr": =
[{"jump": {"target": "nat_POST_work_deny"}}]}}}, {"add": {"rule": {"family"=
: "ip6", "table": "firewalld", "chain": "nat_POST_work", "expr": [{"jump": =
{"target": "nat_POST_work_allow"}}]}}}, {"add": {"rule": {"family": "ip6", =
"table": "firewalld", "chain": "nat_POST_work", "expr": [{"jump": {"target"=
: "nat_POST_work_post"}}]}}}, {"insert": {"rule": {"family": "ip", "table":=
 "firewalld", "chain": "nat_POSTROUTING_ZONES", "expr": [{"match": {"left":=
 {"meta": {"key": "oifname"}}, "op": "=3D=3D", "right": "perm_dummy"}}, {"g=
oto": {"target": "nat_POST_work"}}]}}}, {"insert": {"rule": {"family": "ip6=
", "table": "firewalld", "chain": "nat_POSTROUTING_ZONES", "expr": [{"match=
": {"left": {"meta": {"key": "oifname"}}, "op": "=3D=3D", "right": "perm_du=
mmy"}}, {"goto": {"target": "nat_POST_work"}}]}}}, {"insert": {"rule": {"fa=
mily": "inet", "table": "firewalld", "chain": "filter_INPUT_ZONES", "expr":=
 [{"match": {"left": {"meta": {"key": "iifname"}}, "op": "=3D=3D", "right":=
 "perm_dummy"}}, {"goto": {"target": "filter_IN_work"}}]}}}, {"add": {"chai=
n": {"family": "inet", "table": "firewalld", "name": "filter_FWDI_work"}}},=
 {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "filter=
_FWDI_work_pre"}}}, {"add": {"chain": {"family": "inet", "table": "firewall=
d", "name": "filter_FWDI_work_log"}}}, {"add": {"chain": {"family": "inet",=
 "table": "firewalld", "name": "filter_FWDI_work_deny"}}}, {"add": {"chain"=
: {"family": "inet", "table": "firewalld", "name": "filter_FWDI_work_allow"=
}}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "fi=
lter_FWDI_work_post"}}}, {"add": {"rule": {"family": "inet", "table": "fire=
walld", "chain": "filter_FWDI_work", "expr": [{"jump": {"target": "filter_F=
WDI_work_pre"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewall=
d", "chain": "filter_FWDI_work", "expr": [{"jump": {"target": "filter_FWDI_=
work_log"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", =
"chain": "filter_FWDI_work", "expr": [{"jump": {"target": "filter_FWDI_work=
_deny"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "ch=
ain": "filter_FWDI_work", "expr": [{"jump": {"target": "filter_FWDI_work_al=
low"}}]}}}, {"add": {"rule": {"family": "inet", "table": "firewalld", "chai=
n": "filter_FWDI_work", "expr": [{"jump": {"target": "filter_FWDI_work_post=
"}}]}}}, {"insert": {"rule": {"family": "inet", "table": "firewalld", "chai=
n": "filter_FORWARD_IN_ZONES", "expr": [{"match": {"left": {"meta": {"key":=
 "iifname"}}, "op": "=3D=3D", "right": "perm_dummy"}}, {"goto": {"target": =
"filter_FWDI_work"}}]}}}, {"add": {"chain": {"family": "inet", "table": "fi=
rewalld", "name": "filter_FWDO_work"}}}, {"add": {"chain": {"family": "inet=
", "table": "firewalld", "name": "filter_FWDO_work_pre"}}}, {"add": {"chain=
": {"family": "inet", "table": "firewalld", "name": "filter_FWDO_work_log"}=
}}, {"add": {"chain": {"family": "inet", "table": "firewalld", "name": "fil=
ter_FWDO_work_deny"}}}, {"add": {"chain": {"family": "inet", "table": "fire=
walld", "name": "filter_FWDO_work_allow"}}}, {"add": {"chain": {"family": "=
inet", "table": "firewalld", "name": "filter_FWDO_work_post"}}}, {"add": {"=
rule": {"family": "inet", "table": "firewalld", "chain": "filter_FWDO_work"=
, "expr": [{"jump": {"target": "filter_FWDO_work_pre"}}]}}}, {"add": {"rule=
": {"family": "inet", "table": "firewalld", "chain": "filter_FWDO_work", "e=
xpr": [{"jump": {"target": "filter_FWDO_work_log"}}]}}}, {"add": {"rule": {=
"family": "inet", "table": "firewalld", "chain": "filter_FWDO_work", "expr"=
: [{"jump": {"target": "filter_FWDO_work_deny"}}]}}}, {"add": {"rule": {"fa=
mily": "inet", "table": "firewalld", "chain": "filter_FWDO_work", "expr": [=
{"jump": {"target": "filter_FWDO_work_allow"}}]}}}, {"add": {"rule": {"fami=
ly": "inet", "table": "firewalld", "chain": "filter_FWDO_work", "expr": [{"=
jump": {"target": "filter_FWDO_work_post"}}]}}}, {"insert": {"rule": {"fami=
ly": "inet", "table": "firewalld", "chain": "filter_FORWARD_OUT_ZONES", "ex=
pr": [{"match": {"left": {"meta": {"key": "oifname"}}, "op": "=3D=3D", "rig=
ht": "perm_dummy"}}, {"goto": {"target": "filter_FWDO_work"}}]}}}, {"add": =
{"rule": {"family": "inet", "table": "firewalld", "chain": "filter_IN_work"=
, "index": 4, "expr": [{"match": {"left": {"meta": {"key": "l4proto"}}, "op=
": "=3D=3D", "right": {"set": ["icmp", "icmpv6"]}}}, {"accept": null}]}}}, =
{"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter_=
FWDI_work", "index": 4, "expr": [{"match": {"left": {"meta": {"key": "l4pro=
to"}}, "op": "=3D=3D", "right": {"set": ["icmp", "icmpv6"]}}}, {"accept": n=
ull}]}}}]}'
=20
-test -z "$($NFT -j -e -a -f - <<< "$RULESET" |sed 's/\({"add":\|{"insert":=
\)/\n\1/g' |grep '\({"add":\|{"insert":\)' | grep -v '"handle"')"
+if [ "$NFT_TEST_HAVE_json" !=3D n ]; then
+	test -z "$($NFT -j -e -a -f - <<< "$RULESET" |sed 's/\({"add":\|{"insert"=
:\)/\n\1/g' |grep '\({"add":\|{"insert":\)' | grep -v '"handle"')"
+fi
+
+if [ "$NFT_TEST_HAVE_json" =3D n ]; then
+	echo "Test partially skipped due to missing JSON support."
+	exit 77
+fi
=20
 if [ "$RULE_COUNT" !=3D 3000 ] ; then
 	echo "NFT_TEST_HAS_SOCKET_LIMITS indicates that the socket limit for"
--=20
2.41.0

