Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD9EC072A2
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Nov 2023 17:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjKQRUM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Nov 2023 12:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbjKQRUL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Nov 2023 12:20:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA20AD
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Nov 2023 09:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1700241605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6sp6FrVh8hCbl1Q1Oso0fkI9nAQtmm+XlEnQy0X0VEU=;
        b=csUC/DFpZPnifyTKgB6vx6E+fqo4I5IkDn3qBIw8W0hp1ovhbxqgaS2wGi5SSY2Fl5cTUt
        iTJA3gi2YlP67vWQ94sB1lnNxHTGrIYdDe6IaMTIKBQskUHSVgkyhmraINfjSREqfFU4NW
        ZW2T9c5VL4bcu0sfP7IX71UFgw9M5lk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-437-DUochCZ1PuWmJ6fom5R5zQ-1; Fri,
 17 Nov 2023 12:20:04 -0500
X-MC-Unique: DUochCZ1PuWmJ6fom5R5zQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB84738C6160
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Nov 2023 17:20:03 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.84])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1125F40C6EBB;
        Fri, 17 Nov 2023 17:20:02 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/1] tests/shell: sanitize "handle" in JSON output
Date:   Fri, 17 Nov 2023 18:18:45 +0100
Message-ID: <20231117171948.897229-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The "handle" in JSON output is not stable. Sanitize/normalizeit to 1216.

The number is chosen arbitrarily, but it's somewhat unique in the code
base. So when you see it, you may guess it originates from sanitization.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
Note that only a few .json-nft files are adjusted, because otherwise the
patch is too large. Before applying, you need to adjust them all, by
running `./tests/shell/run-tests.sh -g`.

 tests/shell/helpers/json-sanitize-ruleset.sh             | 9 ++++++++-
 tests/shell/helpers/test-wrapper.sh                      | 3 +--
 .../testcases/bitwise/dumps/0040mark_binop_0.json-nft    | 2 +-
 .../testcases/bitwise/dumps/0040mark_binop_1.json-nft    | 2 +-
 .../testcases/bitwise/dumps/0040mark_binop_2.json-nft    | 2 +-
 .../testcases/bitwise/dumps/0040mark_binop_3.json-nft    | 2 +-
 .../testcases/bitwise/dumps/0040mark_binop_4.json-nft    | 2 +-
 .../testcases/bitwise/dumps/0040mark_binop_5.json-nft    | 2 +-
 .../testcases/bitwise/dumps/0040mark_binop_6.json-nft    | 2 +-
 .../testcases/bitwise/dumps/0040mark_binop_7.json-nft    | 2 +-
 .../testcases/bitwise/dumps/0040mark_binop_8.json-nft    | 2 +-
 .../testcases/bitwise/dumps/0040mark_binop_9.json-nft    | 2 +-
 .../sets/dumps/0043concatenated_ranges_0.json-nft        | 2 +-
 .../testcases/sets/dumps/0044interval_overlap_1.json-nft | 2 +-
 14 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/tests/shell/helpers/json-sanitize-ruleset.sh b/tests/shell/hel=
pers/json-sanitize-ruleset.sh
index 270a6107e0aa..3b66adabf055 100755
--- a/tests/shell/helpers/json-sanitize-ruleset.sh
+++ b/tests/shell/helpers/json-sanitize-ruleset.sh
@@ -6,7 +6,14 @@ die() {
 }
=20
 do_sed() {
-	sed '1s/\({"nftables": \[{"metainfo": {"version": "\)[0-9.]\+\(", "releas=
e_name": "\)[^"]\+\(", "\)/\1VERSION\2RELEASE_NAME\3/' "$@"
+	# Normalize the "version"/"release_name", otherwise we have to regenerate=
 the
+	# JSON output upon new release.
+	#
+	# Also, "handle" are not stable. Normalize them to 1216 (arbitrarily chos=
en).
+	sed \
+		-e '1s/\({"nftables": \[{"metainfo": {"version": "\)[0-9.]\+\(", "releas=
e_name": "\)[^"]\+\(", "\)/\1VERSION\2RELEASE_NAME\3/' \
+		-e '1s/"handle": [0-9]\+\>/"handle": 1216/g' \
+		"$@"
 }
=20
 if [ "$#" =3D 0 ] ; then
diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test=
-wrapper.sh
index 62414d0db074..9e8e60581890 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -138,8 +138,7 @@ if [ "$NFT_TEST_HAVE_json" !=3D n ] ; then
 		show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$NFT -j list ruleset=
\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
 		rc_chkdump=3D1
 	fi
-	# Normalize the version number from the JSON output. Otherwise, we'd
-	# have to regenerate the .json-nft files upon release.
+	# JSON output needs normalization/sanitization, otherwise it's not stable.
 	"$NFT_TEST_BASEDIR/helpers/json-sanitize-ruleset.sh" "$NFT_TEST_TESTTMPDI=
R/ruleset-after.json"
 fi
=20
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_0.json-nft =
b/tests/shell/testcases/bitwise/dumps/0040mark_binop_0.json-nft
index 782cde4225ff..83f7a3445244 100644
--- a/tests/shell/testcases/bitwise/dumps/0040mark_binop_0.json-nft
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_0.json-nft
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t",=
 "handle": 1}}, {"chain": {"family": "ip", "table": "t", "name": "c", "hand=
le": 1, "type": "filter", "hook": "output", "prio": 0, "policy": "accept"}}=
, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 2, "expr"=
: [{"match": {"op": "=3D=3D", "left": {"meta": {"key": "oif"}}, "right": "l=
o"}}, {"mangle": {"key": {"ct": {"key": "mark"}}, "value": {"<<": [{"|": [{=
"meta": {"key": "mark"}}, 16]}, 8]}}}]}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t",=
 "handle": 1216}}, {"chain": {"family": "ip", "table": "t", "name": "c", "h=
andle": 1216, "type": "filter", "hook": "output", "prio": 0, "policy": "acc=
ept"}}, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 121=
6, "expr": [{"match": {"op": "=3D=3D", "left": {"meta": {"key": "oif"}}, "r=
ight": "lo"}}, {"mangle": {"key": {"ct": {"key": "mark"}}, "value": {"<<": =
[{"|": [{"meta": {"key": "mark"}}, 16]}, 8]}}}]}}]}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_1.json-nft =
b/tests/shell/testcases/bitwise/dumps/0040mark_binop_1.json-nft
index b887fb5befa4..365e13388673 100644
--- a/tests/shell/testcases/bitwise/dumps/0040mark_binop_1.json-nft
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_1.json-nft
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t",=
 "handle": 1}}, {"chain": {"family": "ip", "table": "t", "name": "c", "hand=
le": 1, "type": "filter", "hook": "input", "prio": 0, "policy": "accept"}},=
 {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 2, "expr":=
 [{"match": {"op": "=3D=3D", "left": {"meta": {"key": "iif"}}, "right": "lo=
"}}, {"match": {"op": "=3D=3D", "left": {"&": [{"ct": {"key": "mark"}}, 255=
]}, "right": 16}}, {"mangle": {"key": {"meta": {"key": "mark"}}, "value": {=
">>": [{"ct": {"key": "mark"}}, 8]}}}]}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t",=
 "handle": 1216}}, {"chain": {"family": "ip", "table": "t", "name": "c", "h=
andle": 1216, "type": "filter", "hook": "input", "prio": 0, "policy": "acce=
pt"}}, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 1216=
, "expr": [{"match": {"op": "=3D=3D", "left": {"meta": {"key": "iif"}}, "ri=
ght": "lo"}}, {"match": {"op": "=3D=3D", "left": {"&": [{"ct": {"key": "mar=
k"}}, 255]}, "right": 16}}, {"mangle": {"key": {"meta": {"key": "mark"}}, "=
value": {">>": [{"ct": {"key": "mark"}}, 8]}}}]}}]}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_2.json-nft =
b/tests/shell/testcases/bitwise/dumps/0040mark_binop_2.json-nft
index 4ebe509c1cf6..cad1ea57e30d 100644
--- a/tests/shell/testcases/bitwise/dumps/0040mark_binop_2.json-nft
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_2.json-nft
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t",=
 "handle": 1}}, {"chain": {"family": "ip", "table": "t", "name": "c", "hand=
le": 1, "type": "filter", "hook": "output", "prio": 0, "policy": "accept"}}=
, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 2, "expr"=
: [{"mangle": {"key": {"ct": {"key": "mark"}}, "value": {"|": [{"<<": [{"pa=
yload": {"protocol": "ip", "field": "dscp"}}, 2]}, 16]}}}]}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t",=
 "handle": 1216}}, {"chain": {"family": "ip", "table": "t", "name": "c", "h=
andle": 1216, "type": "filter", "hook": "output", "prio": 0, "policy": "acc=
ept"}}, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 121=
6, "expr": [{"mangle": {"key": {"ct": {"key": "mark"}}, "value": {"|": [{"<=
<": [{"payload": {"protocol": "ip", "field": "dscp"}}, 2]}, 16]}}}]}}]}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_3.json-nft =
b/tests/shell/testcases/bitwise/dumps/0040mark_binop_3.json-nft
index df64f4e1ba84..d92d62dfe56f 100644
--- a/tests/shell/testcases/bitwise/dumps/0040mark_binop_3.json-nft
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_3.json-nft
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t",=
 "handle": 1}}, {"chain": {"family": "ip", "table": "t", "name": "c", "hand=
le": 1, "type": "filter", "hook": "input", "prio": 0, "policy": "accept"}},=
 {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 2, "expr":=
 [{"mangle": {"key": {"meta": {"key": "mark"}}, "value": {"|": [{"<<": [{"p=
ayload": {"protocol": "ip", "field": "dscp"}}, 2]}, 16]}}}]}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t",=
 "handle": 1216}}, {"chain": {"family": "ip", "table": "t", "name": "c", "h=
andle": 1216, "type": "filter", "hook": "input", "prio": 0, "policy": "acce=
pt"}}, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 1216=
, "expr": [{"mangle": {"key": {"meta": {"key": "mark"}}, "value": {"|": [{"=
<<": [{"payload": {"protocol": "ip", "field": "dscp"}}, 2]}, 16]}}}]}}]}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_4.json-nft =
b/tests/shell/testcases/bitwise/dumps/0040mark_binop_4.json-nft
index 76bb83cff96f..d56adbbcf34c 100644
--- a/tests/shell/testcases/bitwise/dumps/0040mark_binop_4.json-nft
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_4.json-nft
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t",=
 "handle": 1}}, {"chain": {"family": "ip", "table": "t", "name": "c", "hand=
le": 1, "type": "filter", "hook": "output", "prio": 0, "policy": "accept"}}=
, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 2, "expr"=
: [{"mangle": {"key": {"ct": {"key": "mark"}}, "value": {"|": [{"<<": [{"pa=
yload": {"protocol": "ip", "field": "dscp"}}, 26]}, 16]}}}]}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t",=
 "handle": 1216}}, {"chain": {"family": "ip", "table": "t", "name": "c", "h=
andle": 1216, "type": "filter", "hook": "output", "prio": 0, "policy": "acc=
ept"}}, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 121=
6, "expr": [{"mangle": {"key": {"ct": {"key": "mark"}}, "value": {"|": [{"<=
<": [{"payload": {"protocol": "ip", "field": "dscp"}}, 26]}, 16]}}}]}}]}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_5.json-nft =
b/tests/shell/testcases/bitwise/dumps/0040mark_binop_5.json-nft
index eaa9df04fa3c..8cc9fecd2ec6 100644
--- a/tests/shell/testcases/bitwise/dumps/0040mark_binop_5.json-nft
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_5.json-nft
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t",=
 "handle": 1}}, {"chain": {"family": "ip", "table": "t", "name": "c", "hand=
le": 1, "type": "filter", "hook": "input", "prio": 0, "policy": "accept"}},=
 {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 2, "expr":=
 [{"mangle": {"key": {"meta": {"key": "mark"}}, "value": {"|": [{"<<": [{"p=
ayload": {"protocol": "ip", "field": "dscp"}}, 26]}, 16]}}}]}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t",=
 "handle": 1216}}, {"chain": {"family": "ip", "table": "t", "name": "c", "h=
andle": 1216, "type": "filter", "hook": "input", "prio": 0, "policy": "acce=
pt"}}, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 1216=
, "expr": [{"mangle": {"key": {"meta": {"key": "mark"}}, "value": {"|": [{"=
<<": [{"payload": {"protocol": "ip", "field": "dscp"}}, 26]}, 16]}}}]}}]}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_6.json-nft =
b/tests/shell/testcases/bitwise/dumps/0040mark_binop_6.json-nft
index 100c604ba5c5..bc439fa67db8 100644
--- a/tests/shell/testcases/bitwise/dumps/0040mark_binop_6.json-nft
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_6.json-nft
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip6", "name": "t"=
, "handle": 1}}, {"chain": {"family": "ip6", "table": "t", "name": "c", "ha=
ndle": 1, "type": "filter", "hook": "output", "prio": 0, "policy": "accept"=
}}, {"rule": {"family": "ip6", "table": "t", "chain": "c", "handle": 2, "ex=
pr": [{"mangle": {"key": {"ct": {"key": "mark"}}, "value": {"|": [{"<<": [{=
"payload": {"protocol": "ip6", "field": "dscp"}}, 2]}, 16]}}}]}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip6", "name": "t"=
, "handle": 1216}}, {"chain": {"family": "ip6", "table": "t", "name": "c", =
"handle": 1216, "type": "filter", "hook": "output", "prio": 0, "policy": "a=
ccept"}}, {"rule": {"family": "ip6", "table": "t", "chain": "c", "handle": =
1216, "expr": [{"mangle": {"key": {"ct": {"key": "mark"}}, "value": {"|": [=
{"<<": [{"payload": {"protocol": "ip6", "field": "dscp"}}, 2]}, 16]}}}]}}]}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_7.json-nft =
b/tests/shell/testcases/bitwise/dumps/0040mark_binop_7.json-nft
index 0e61a15eee2a..7eb6712254d6 100644
--- a/tests/shell/testcases/bitwise/dumps/0040mark_binop_7.json-nft
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_7.json-nft
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip6", "name": "t"=
, "handle": 1}}, {"chain": {"family": "ip6", "table": "t", "name": "c", "ha=
ndle": 1, "type": "filter", "hook": "input", "prio": 0, "policy": "accept"}=
}, {"rule": {"family": "ip6", "table": "t", "chain": "c", "handle": 2, "exp=
r": [{"mangle": {"key": {"meta": {"key": "mark"}}, "value": {"|": [{"<<": [=
{"payload": {"protocol": "ip6", "field": "dscp"}}, 2]}, 16]}}}]}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip6", "name": "t"=
, "handle": 1216}}, {"chain": {"family": "ip6", "table": "t", "name": "c", =
"handle": 1216, "type": "filter", "hook": "input", "prio": 0, "policy": "ac=
cept"}}, {"rule": {"family": "ip6", "table": "t", "chain": "c", "handle": 1=
216, "expr": [{"mangle": {"key": {"meta": {"key": "mark"}}, "value": {"|": =
[{"<<": [{"payload": {"protocol": "ip6", "field": "dscp"}}, 2]}, 16]}}}]}}]}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_8.json-nft =
b/tests/shell/testcases/bitwise/dumps/0040mark_binop_8.json-nft
index f077295c7b42..d41a6f29386d 100644
--- a/tests/shell/testcases/bitwise/dumps/0040mark_binop_8.json-nft
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_8.json-nft
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip6", "name": "t"=
, "handle": 1}}, {"chain": {"family": "ip6", "table": "t", "name": "c", "ha=
ndle": 1, "type": "filter", "hook": "output", "prio": 0, "policy": "accept"=
}}, {"rule": {"family": "ip6", "table": "t", "chain": "c", "handle": 2, "ex=
pr": [{"mangle": {"key": {"ct": {"key": "mark"}}, "value": {"|": [{"<<": [{=
"payload": {"protocol": "ip6", "field": "dscp"}}, 26]}, 16]}}}]}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip6", "name": "t"=
, "handle": 1216}}, {"chain": {"family": "ip6", "table": "t", "name": "c", =
"handle": 1216, "type": "filter", "hook": "output", "prio": 0, "policy": "a=
ccept"}}, {"rule": {"family": "ip6", "table": "t", "chain": "c", "handle": =
1216, "expr": [{"mangle": {"key": {"ct": {"key": "mark"}}, "value": {"|": [=
{"<<": [{"payload": {"protocol": "ip6", "field": "dscp"}}, 26]}, 16]}}}]}}]}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_9.json-nft =
b/tests/shell/testcases/bitwise/dumps/0040mark_binop_9.json-nft
index a71eebaea7f4..554153980427 100644
--- a/tests/shell/testcases/bitwise/dumps/0040mark_binop_9.json-nft
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_9.json-nft
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip6", "name": "t"=
, "handle": 1}}, {"chain": {"family": "ip6", "table": "t", "name": "c", "ha=
ndle": 1, "type": "filter", "hook": "input", "prio": 0, "policy": "accept"}=
}, {"rule": {"family": "ip6", "table": "t", "chain": "c", "handle": 2, "exp=
r": [{"mangle": {"key": {"meta": {"key": "mark"}}, "value": {"|": [{"<<": [=
{"payload": {"protocol": "ip6", "field": "dscp"}}, 26]}, 16]}}}]}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip6", "name": "t"=
, "handle": 1216}}, {"chain": {"family": "ip6", "table": "t", "name": "c", =
"handle": 1216, "type": "filter", "hook": "input", "prio": 0, "policy": "ac=
cept"}}, {"rule": {"family": "ip6", "table": "t", "chain": "c", "handle": 1=
216, "expr": [{"mangle": {"key": {"meta": {"key": "mark"}}, "value": {"|": =
[{"<<": [{"payload": {"protocol": "ip6", "field": "dscp"}}, 26]}, 16]}}}]}}=
]}
diff --git a/tests/shell/testcases/sets/dumps/0043concatenated_ranges_0.jso=
n-nft b/tests/shell/testcases/sets/dumps/0043concatenated_ranges_0.json-nft
index 9d5ef47dfd7c..a4e4100446e1 100644
--- a/tests/shell/testcases/sets/dumps/0043concatenated_ranges_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0043concatenated_ranges_0.json-nft
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "inet", "name": "f=
ilter", "handle": 192}}, {"map": {"family": "inet", "name": "test", "table"=
: "filter", "type": ["mark", "inet_service", "inet_proto"], "handle": 2, "m=
ap": "mark", "flags": ["interval", "timeout"]}}, {"chain": {"family": "inet=
", "table": "filter", "name": "output", "handle": 1, "type": "filter", "hoo=
k": "output", "prio": 0, "policy": "accept"}}, {"rule": {"family": "inet", =
"table": "filter", "chain": "output", "handle": 3, "expr": [{"mangle": {"ke=
y": {"meta": {"key": "mark"}}, "value": {"map": {"key": {"concat": [{"meta"=
: {"key": "mark"}}, {"payload": {"protocol": "tcp", "field": "dport"}}, {"m=
eta": {"key": "l4proto"}}]}, "data": "@test"}}}}, {"counter": {"packets": 0=
, "bytes": 0}}]}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "inet", "name": "f=
ilter", "handle": 1216}}, {"map": {"family": "inet", "name": "test", "table=
": "filter", "type": ["mark", "inet_service", "inet_proto"], "handle": 1216=
, "map": "mark", "flags": ["interval", "timeout"]}}, {"chain": {"family": "=
inet", "table": "filter", "name": "output", "handle": 1216, "type": "filter=
", "hook": "output", "prio": 0, "policy": "accept"}}, {"rule": {"family": "=
inet", "table": "filter", "chain": "output", "handle": 1216, "expr": [{"man=
gle": {"key": {"meta": {"key": "mark"}}, "value": {"map": {"key": {"concat"=
: [{"meta": {"key": "mark"}}, {"payload": {"protocol": "tcp", "field": "dpo=
rt"}}, {"meta": {"key": "l4proto"}}]}, "data": "@test"}}}}, {"counter": {"p=
ackets": 0, "bytes": 0}}]}}]}
diff --git a/tests/shell/testcases/sets/dumps/0044interval_overlap_1.json-n=
ft b/tests/shell/testcases/sets/dumps/0044interval_overlap_1.json-nft
index db9340bcd1a1..af738f15bdb6 100644
--- a/tests/shell/testcases/sets/dumps/0044interval_overlap_1.json-nft
+++ b/tests/shell/testcases/sets/dumps/0044interval_overlap_1.json-nft
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t",=
 "handle": 1}}, {"set": {"family": "ip", "name": "s", "table": "t", "type":=
 "inet_service", "handle": 1, "flags": ["interval"], "elem": [25, 30, 82, 1=
19, 349, 745, 748, 1165, 1233, 1476, 1550, 1562, 1743, 1745, 1882, 2070, 21=
94, 2238, 2450, 2455, 2642, 2671, 2906, 3093, 3203, 3287, 3348, 3411, 3540,=
 3892, 3943, 4133, 4205, 4317, 4733, 5095, 5156, 5223, 5230, 5432, 5826, 58=
28, 6044, 6377, 6388, 6491, 6952, 6986, 7012, 7187, 7300, 7305, 7549, 7664,=
 8111, 8206, 8396, 8782, 8920, 8981, 9067, 9216, 9245, 9315, 9432, 9587, 96=
89, 9844, 9991, 10045, 10252, 10328, 10670, 10907, 11021, 11337, 11427, 114=
97, 11502, 11523, 11552, 11577, 11721, 11943, 12474, 12718, 12764, 12794, 1=
2922, 13186, 13232, 13383, 13431, 13551, 13676, 13685, 13747, 13925, 13935,=
 14015, 14090, 14320, 14392, 14515, 14647, 14911, 15096, 15105, 15154, 1544=
0, 15583, 15623, 15677, 15710, 15926, 15934, 15960, 16068, 16166, 16486, 16=
489, 16528, 16646, 16650, 16770, 16882, 17052, 17237, 17387, 17431, 17886, =
17939, 17999, 18092, 18123, 18238, 18562, 18698, 19004, 19229, 19237, 19585=
, 19879, 19938, 19950, 19958, 20031, 20138, 20157, 20205, 20368, 20682, 206=
87, 20873, 20910, 20919, 21019, 21068, 21115, 21188, 21236, 21319, 21563, 2=
1734, 21806, 21810, 21959, 21982, 22078, 22181, 22308, 22480, 22643, 22854,=
 22879, 22961, 23397, 23534, 23845, 23893, 24130, 24406, 24794, 24997, 2501=
9, 25143, 25179, 25439, 25603, 25718, 25859, 25949, 26006, 26022, 26047, 26=
170, 26193, 26725, 26747, 26924, 27023, 27040, 27233, 27344, 27478, 27593, =
27600, 27664, 27678, 27818, 27822, 28003, 28038, 28709, 28808, 29010, 29057=
, 29228, 29485, 30132, 30160, 30415, 30469, 30673, 30736, 30776, 30780, 314=
50, 31537, 31669, 31839, 31873, 32019, 32229, 32685, 32879, 33318, 33337, 3=
3404, 33517, 33906, 34214, 34346, 34416, 34727, 34848, 35325, 35400, 35451,=
 35501, 35637, 35653, 35710, 35761, 35767, 36238, 36258, 36279, 36464, 3658=
6, 36603, 36770, 36774, 36805, 36851, 37079, 37189, 37209, 37565, 37570, 37=
585, 37832, 37931, 37954, 38006, 38015, 38045, 38109, 38114, 38200, 38209, =
38214, 38277, 38306, 38402, 38606, 38697, 38960, 39004, 39006, 39197, 39217=
, 39265, 39319, 39460, 39550, 39615, 39871, 39886, 40088, 40135, 40244, 403=
23, 40339, 40355, 40385, 40428, 40538, 40791, 40848, 40959, 41003, 41131, 4=
1349, 41643, 41710, 41826, 41904, 42027, 42148, 42235, 42255, 42498, 42680,=
 42973, 43118, 43135, 43233, 43349, 43411, 43487, 43840, 43843, 43870, 4404=
0, 44204, 44817, 44883, 44894, 44958, 45201, 45259, 45283, 45357, 45423, 45=
473, 45498, 45519, 45561, 45611, 45627, 45831, 46043, 46105, 46116, 46147, =
46169, 46349, 47147, 47252, 47314, 47335, 47360, 47546, 47617, 47648, 47772=
, 47793, 47846, 47913, 47952, 48095, 48325, 48334, 48412, 48419, 48540, 485=
69, 48628, 48751, 48944, 48971, 49008, 49025, 49503, 49505, 49613, 49767, 4=
9839, 49925, 50022, 50028, 50238, 51057, 51477, 51617, 51910, 52044, 52482,=
 52550, 52643, 52832, 53382, 53690, 53809, 53858, 54001, 54198, 54280, 5432=
7, 54376, 54609, 54776, 54983, 54984, 55019, 55038, 55094, 55368, 55737, 55=
793, 55904, 55941, 55960, 55978, 56063, 56121, 56314, 56505, 56548, 56568, =
56696, 56798, 56855, 57102, 57236, 57333, 57334, 57441, 57574, 57659, 57987=
, 58325, 58404, 58509, 58782, 58876, 59116, 59544, 59685, 59700, 59750, 597=
99, 59866, 59870, 59894, 59984, 60343, 60481, 60564, 60731, 61075, 61087, 6=
1148, 61174, 61655, 61679, 61691, 61723, 61730, 61758, 61824, 62035, 62056,=
 62661, 62768, 62946, 63059, 63116, 63338, 63387, 63672, 63719, 63881, 6399=
5, 64197, 64374, 64377, 64472, 64606, 64662, 64777, 64795, 64906, 65049, 65=
122, 65318]}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t",=
 "handle": 1216}}, {"set": {"family": "ip", "name": "s", "table": "t", "typ=
e": "inet_service", "handle": 1216, "flags": ["interval"], "elem": [25, 30,=
 82, 119, 349, 745, 748, 1165, 1233, 1476, 1550, 1562, 1743, 1745, 1882, 20=
70, 2194, 2238, 2450, 2455, 2642, 2671, 2906, 3093, 3203, 3287, 3348, 3411,=
 3540, 3892, 3943, 4133, 4205, 4317, 4733, 5095, 5156, 5223, 5230, 5432, 58=
26, 5828, 6044, 6377, 6388, 6491, 6952, 6986, 7012, 7187, 7300, 7305, 7549,=
 7664, 8111, 8206, 8396, 8782, 8920, 8981, 9067, 9216, 9245, 9315, 9432, 95=
87, 9689, 9844, 9991, 10045, 10252, 10328, 10670, 10907, 11021, 11337, 1142=
7, 11497, 11502, 11523, 11552, 11577, 11721, 11943, 12474, 12718, 12764, 12=
794, 12922, 13186, 13232, 13383, 13431, 13551, 13676, 13685, 13747, 13925, =
13935, 14015, 14090, 14320, 14392, 14515, 14647, 14911, 15096, 15105, 15154=
, 15440, 15583, 15623, 15677, 15710, 15926, 15934, 15960, 16068, 16166, 164=
86, 16489, 16528, 16646, 16650, 16770, 16882, 17052, 17237, 17387, 17431, 1=
7886, 17939, 17999, 18092, 18123, 18238, 18562, 18698, 19004, 19229, 19237,=
 19585, 19879, 19938, 19950, 19958, 20031, 20138, 20157, 20205, 20368, 2068=
2, 20687, 20873, 20910, 20919, 21019, 21068, 21115, 21188, 21236, 21319, 21=
563, 21734, 21806, 21810, 21959, 21982, 22078, 22181, 22308, 22480, 22643, =
22854, 22879, 22961, 23397, 23534, 23845, 23893, 24130, 24406, 24794, 24997=
, 25019, 25143, 25179, 25439, 25603, 25718, 25859, 25949, 26006, 26022, 260=
47, 26170, 26193, 26725, 26747, 26924, 27023, 27040, 27233, 27344, 27478, 2=
7593, 27600, 27664, 27678, 27818, 27822, 28003, 28038, 28709, 28808, 29010,=
 29057, 29228, 29485, 30132, 30160, 30415, 30469, 30673, 30736, 30776, 3078=
0, 31450, 31537, 31669, 31839, 31873, 32019, 32229, 32685, 32879, 33318, 33=
337, 33404, 33517, 33906, 34214, 34346, 34416, 34727, 34848, 35325, 35400, =
35451, 35501, 35637, 35653, 35710, 35761, 35767, 36238, 36258, 36279, 36464=
, 36586, 36603, 36770, 36774, 36805, 36851, 37079, 37189, 37209, 37565, 375=
70, 37585, 37832, 37931, 37954, 38006, 38015, 38045, 38109, 38114, 38200, 3=
8209, 38214, 38277, 38306, 38402, 38606, 38697, 38960, 39004, 39006, 39197,=
 39217, 39265, 39319, 39460, 39550, 39615, 39871, 39886, 40088, 40135, 4024=
4, 40323, 40339, 40355, 40385, 40428, 40538, 40791, 40848, 40959, 41003, 41=
131, 41349, 41643, 41710, 41826, 41904, 42027, 42148, 42235, 42255, 42498, =
42680, 42973, 43118, 43135, 43233, 43349, 43411, 43487, 43840, 43843, 43870=
, 44040, 44204, 44817, 44883, 44894, 44958, 45201, 45259, 45283, 45357, 454=
23, 45473, 45498, 45519, 45561, 45611, 45627, 45831, 46043, 46105, 46116, 4=
6147, 46169, 46349, 47147, 47252, 47314, 47335, 47360, 47546, 47617, 47648,=
 47772, 47793, 47846, 47913, 47952, 48095, 48325, 48334, 48412, 48419, 4854=
0, 48569, 48628, 48751, 48944, 48971, 49008, 49025, 49503, 49505, 49613, 49=
767, 49839, 49925, 50022, 50028, 50238, 51057, 51477, 51617, 51910, 52044, =
52482, 52550, 52643, 52832, 53382, 53690, 53809, 53858, 54001, 54198, 54280=
, 54327, 54376, 54609, 54776, 54983, 54984, 55019, 55038, 55094, 55368, 557=
37, 55793, 55904, 55941, 55960, 55978, 56063, 56121, 56314, 56505, 56548, 5=
6568, 56696, 56798, 56855, 57102, 57236, 57333, 57334, 57441, 57574, 57659,=
 57987, 58325, 58404, 58509, 58782, 58876, 59116, 59544, 59685, 59700, 5975=
0, 59799, 59866, 59870, 59894, 59984, 60343, 60481, 60564, 60731, 61075, 61=
087, 61148, 61174, 61655, 61679, 61691, 61723, 61730, 61758, 61824, 62035, =
62056, 62661, 62768, 62946, 63059, 63116, 63338, 63387, 63672, 63719, 63881=
, 63995, 64197, 64374, 64377, 64472, 64606, 64662, 64777, 64795, 64906, 650=
49, 65122, 65318]}}]}
--=20
2.42.0

