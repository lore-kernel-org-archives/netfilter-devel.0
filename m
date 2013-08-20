From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 2/3] tests: rule: add json parsing support
Date: Tue, 20 Aug 2013 17:58:56 +0200
Message-ID: <20130820155855.8850.37279.stgit@Ph0enix>
References: <20130820155844.8850.85717.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:44191 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3HTP7T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:59:19 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so597196wes.1
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2013 08:59:18 -0700 (PDT)
In-Reply-To: <20130820155844.8850.85717.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Test the functions for parsing rules in JSON.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 tests/jsonfiles/20-rule-bitwise.json   |    1 +
 tests/jsonfiles/21-rule-byteorder.json |    1 +
 tests/jsonfiles/22-rule-cmp.json       |    1 +
 tests/jsonfiles/23-rule-counter.json   |    1 +
 tests/jsonfiles/24-rule-ct.json        |    1 +
 tests/jsonfiles/25-rule-exthdr.json    |    1 +
 tests/jsonfiles/26-rule-immediate.json |    1 +
 tests/jsonfiles/27-rule-limit.json     |    1 +
 tests/jsonfiles/28-rule-log.json       |    1 +
 tests/jsonfiles/29-rule-match.json     |    1 +
 tests/jsonfiles/30-rule-lookup.json    |    1 +
 tests/jsonfiles/31-rule-meta.json      |    1 +
 tests/jsonfiles/32-rule-nat4.json      |    1 +
 tests/jsonfiles/33-rule-nat6.json      |    1 +
 tests/jsonfiles/34-rule-payload.json   |    1 +
 tests/jsonfiles/35-rule-target.json    |    1 +
 tests/jsonfiles/36-rule-real.json      |    1 +
 tests/jsonfiles/37-rule-real.json      |    1 +
 tests/jsonfiles/38-rule-real.json      |    1 +
 tests/jsonfiles/39-rule-real.json      |    1 +
 tests/jsonfiles/40-rule-real.json      |    1 +
 tests/jsonfiles/41-rule-real.json      |    1 +
 tests/jsonfiles/42-rule-real.json      |    1 +
 tests/jsonfiles/43-rule-real.json      |    1 +
 tests/jsonfiles/44-rule-real.json      |    1 +
 tests/jsonfiles/45-rule-real.json      |    1 +
 tests/jsonfiles/46-rule-real.json      |    1 +
 tests/jsonfiles/47-rule-real.json      |    1 +
 tests/jsonfiles/48-rule-real.json      |    1 +
 tests/jsonfiles/49-rule-real.json      |    1 +
 tests/jsonfiles/50-rule-real.json      |    1 +
 tests/jsonfiles/51-rule-real.json      |    1 +
 tests/jsonfiles/52-rule-real.json      |    1 +
 tests/jsonfiles/53-rule-real.json      |    1 +
 tests/jsonfiles/54-rule-real.json      |    1 +
 tests/jsonfiles/55-rule-real.json      |    1 +
 tests/jsonfiles/56-rule-real.json      |    1 +
 tests/jsonfiles/57-rule-real.json      |    1 +
 tests/jsonfiles/58-rule-real.json      |    1 +
 tests/jsonfiles/59-rule-real.json      |    1 +
 tests/jsonfiles/60-rule-real.json      |    1 +
 tests/jsonfiles/61-rule-real.json      |    1 +
 tests/nft-parsing-test.c               |   11 +++++++++++
 43 files changed, 53 insertions(+)
 create mode 100644 tests/jsonfiles/20-rule-bitwise.json
 create mode 100644 tests/jsonfiles/21-rule-byteorder.json
 create mode 100644 tests/jsonfiles/22-rule-cmp.json
 create mode 100644 tests/jsonfiles/23-rule-counter.json
 create mode 100644 tests/jsonfiles/24-rule-ct.json
 create mode 100644 tests/jsonfiles/25-rule-exthdr.json
 create mode 100644 tests/jsonfiles/26-rule-immediate.json
 create mode 100644 tests/jsonfiles/27-rule-limit.json
 create mode 100644 tests/jsonfiles/28-rule-log.json
 create mode 100644 tests/jsonfiles/29-rule-match.json
 create mode 100644 tests/jsonfiles/30-rule-lookup.json
 create mode 100644 tests/jsonfiles/31-rule-meta.json
 create mode 100644 tests/jsonfiles/32-rule-nat4.json
 create mode 100644 tests/jsonfiles/33-rule-nat6.json
 create mode 100644 tests/jsonfiles/34-rule-payload.json
 create mode 100644 tests/jsonfiles/35-rule-target.json
 create mode 100644 tests/jsonfiles/36-rule-real.json
 create mode 100644 tests/jsonfiles/37-rule-real.json
 create mode 100644 tests/jsonfiles/38-rule-real.json
 create mode 100644 tests/jsonfiles/39-rule-real.json
 create mode 100644 tests/jsonfiles/40-rule-real.json
 create mode 100644 tests/jsonfiles/41-rule-real.json
 create mode 100644 tests/jsonfiles/42-rule-real.json
 create mode 100644 tests/jsonfiles/43-rule-real.json
 create mode 100644 tests/jsonfiles/44-rule-real.json
 create mode 100644 tests/jsonfiles/45-rule-real.json
 create mode 100644 tests/jsonfiles/46-rule-real.json
 create mode 100644 tests/jsonfiles/47-rule-real.json
 create mode 100644 tests/jsonfiles/48-rule-real.json
 create mode 100644 tests/jsonfiles/49-rule-real.json
 create mode 100644 tests/jsonfiles/50-rule-real.json
 create mode 100644 tests/jsonfiles/51-rule-real.json
 create mode 100644 tests/jsonfiles/52-rule-real.json
 create mode 100644 tests/jsonfiles/53-rule-real.json
 create mode 100644 tests/jsonfiles/54-rule-real.json
 create mode 100644 tests/jsonfiles/55-rule-real.json
 create mode 100644 tests/jsonfiles/56-rule-real.json
 create mode 100644 tests/jsonfiles/57-rule-real.json
 create mode 100644 tests/jsonfiles/58-rule-real.json
 create mode 100644 tests/jsonfiles/59-rule-real.json
 create mode 100644 tests/jsonfiles/60-rule-real.json
 create mode 100644 tests/jsonfiles/61-rule-real.json

diff --git a/tests/jsonfiles/20-rule-bitwise.json b/tests/jsonfiles/20-=
rule-bitwise.json
new file mode 100644
index 0000000..d39d0f9
--- /dev/null
+++ b/tests/jsonfiles/20-rule-bitwise.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 20,"flags" : 0, "expr" : [ { "type" : "bitwise", "sreg" : 1, =
"dreg" : 1, "len" : 4, "mask" : {"data_reg": { "type" : "value", "len" =
: 4, "data0" : "0x0000000a"}}, "xor" : {"data_reg": { "type" : "value",=
 "len" : 4, "data0" : "0x00000000"}}}]}}
diff --git a/tests/jsonfiles/21-rule-byteorder.json b/tests/jsonfiles/2=
1-rule-byteorder.json
new file mode 100644
index 0000000..631ee51
--- /dev/null
+++ b/tests/jsonfiles/21-rule-byteorder.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 21,"flags" : 0, "expr" : [ { "type" : "byteorder", "sreg" : 3=
, "dreg" : 4, "op" : "hton", "len" : 4, "size" : 4}]}}
diff --git a/tests/jsonfiles/22-rule-cmp.json b/tests/jsonfiles/22-rule=
-cmp.json
new file mode 100644
index 0000000..ae36cbc
--- /dev/null
+++ b/tests/jsonfiles/22-rule-cmp.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "forward",=
 "handle" : 22,"flags" : 0, "expr" : [ { "type" : "cmp", "sreg" : 1, "o=
p" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 16, "da=
ta0" : "0x00000000", "data1" : "0x6e6f6200", "data2" : "0x2e303164", "d=
ata3" : "0x00393331"}}}]}}
diff --git a/tests/jsonfiles/23-rule-counter.json b/tests/jsonfiles/23-=
rule-counter.json
new file mode 100644
index 0000000..6c0a745
--- /dev/null
+++ b/tests/jsonfiles/23-rule-counter.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 23,"flags" : 0, "expr" : [ { "type" : "counter", "pkts" : 13=
5, "bytes" : 21655}]}}
diff --git a/tests/jsonfiles/24-rule-ct.json b/tests/jsonfiles/24-rule-=
ct.json
new file mode 100644
index 0000000..2c640c5
--- /dev/null
+++ b/tests/jsonfiles/24-rule-ct.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 24,"flags" : 0, "expr" : [ { "type" : "ct", "dreg" : 1, "key"=
 : "state"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"d=
ata_reg": { "type" : "value", "len" : 4, "data0" : "0x00000008"}}}]}}
diff --git a/tests/jsonfiles/25-rule-exthdr.json b/tests/jsonfiles/25-r=
ule-exthdr.json
new file mode 100644
index 0000000..8234a8b
--- /dev/null
+++ b/tests/jsonfiles/25-rule-exthdr.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 25,"flags" : 0, "expr" : [ { "type" : "exthdr", "dreg" : 1, "=
exthdr_type" : "mh", "offset" : 2, "len" : 16}]}}
diff --git a/tests/jsonfiles/26-rule-immediate.json b/tests/jsonfiles/2=
6-rule-immediate.json
new file mode 100644
index 0000000..1751c17
--- /dev/null
+++ b/tests/jsonfiles/26-rule-immediate.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 26,"flags" : 0, "expr" : [ { "type" : "immediate", "dreg" : 0=
, "immediatedata" : {"data_reg": {"type" : "verdict", "verdict" : "acce=
pt"}}}]}}
diff --git a/tests/jsonfiles/27-rule-limit.json b/tests/jsonfiles/27-ru=
le-limit.json
new file mode 100644
index 0000000..4ae3b70
--- /dev/null
+++ b/tests/jsonfiles/27-rule-limit.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 27,"flags" : 0, "expr" : [ { "type" : "limit", "rate" : 32132=
1, "depth" : 0 }]}}
diff --git a/tests/jsonfiles/28-rule-log.json b/tests/jsonfiles/28-rule=
-log.json
new file mode 100644
index 0000000..50e5088
--- /dev/null
+++ b/tests/jsonfiles/28-rule-log.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 28,"flags" : 0, "expr" : [ { "type" : "log", "prefix" : "test=
_chain", "group" : 1, "snaplen" : 0, "qthreshold" : 0 }]}}
diff --git a/tests/jsonfiles/29-rule-match.json b/tests/jsonfiles/29-ru=
le-match.json
new file mode 100644
index 0000000..8270764
--- /dev/null
+++ b/tests/jsonfiles/29-rule-match.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 9,"flags" : 0, "expr" : [ { "type" : "match", "name" : "state=
"}, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
diff --git a/tests/jsonfiles/30-rule-lookup.json b/tests/jsonfiles/30-r=
ule-lookup.json
new file mode 100644
index 0000000..e98b865
--- /dev/null
+++ b/tests/jsonfiles/30-rule-lookup.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 8,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1, "=
offset" : 12, "len" : 4, "base" : "network"}, { "type" : "lookup", "set=
" : "set0", "sreg" : 1, "dreg" : 0}]}}
diff --git a/tests/jsonfiles/31-rule-meta.json b/tests/jsonfiles/31-rul=
e-meta.json
new file mode 100644
index 0000000..b67a719
--- /dev/null
+++ b/tests/jsonfiles/31-rule-meta.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 8,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "ke=
y" : "protocol"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" =
: {"data_reg": { "type" : "value", "len" : 4, "data0" : "0x000003e8"}}}=
, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
diff --git a/tests/jsonfiles/32-rule-nat4.json b/tests/jsonfiles/32-rul=
e-nat4.json
new file mode 100644
index 0000000..fb311d2
--- /dev/null
+++ b/tests/jsonfiles/32-rule-nat4.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 10,"flags" : 0, "expr" : [ { "type" : "nat", "nat_type" : "dn=
at", "family" : "ip", "sreg_addr_min" : 1, "sreg_addr_max" : 2, "sreg_p=
roto_min" : 3, "sreg_proto_max" : 4}]}}
diff --git a/tests/jsonfiles/33-rule-nat6.json b/tests/jsonfiles/33-rul=
e-nat6.json
new file mode 100644
index 0000000..cd11c04
--- /dev/null
+++ b/tests/jsonfiles/33-rule-nat6.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip6", "table" : "nat", "chain"  : "output", "h=
andle" : 33,"flags" : 0, "expr" : [ { "type" : "nat", "nat_type" : "sna=
t", "family" : "ip6", "sreg_addr_min" : 1, "sreg_addr_max" : 2, "sreg_p=
roto_min" : 3, "sreg_proto_max" : 4}]}}
diff --git a/tests/jsonfiles/34-rule-payload.json b/tests/jsonfiles/34-=
rule-payload.json
new file mode 100644
index 0000000..6015dc4
--- /dev/null
+++ b/tests/jsonfiles/34-rule-payload.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "input", "=
handle" : 26,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1, =
"offset" : 9, "len" : 1, "base" : "network"}, { "type" : "cmp", "sreg" =
: 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : =
1, "data0" : "0x00000006"}}}, { "type" : "payload", "dreg" : 1, "offset=
" : 2, "len" : 2, "base" : "transport"}, { "type" : "cmp", "sreg" : 1, =
"op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 2, "d=
ata0" : "0x00001600"}}}, { "type" : "immediate", "dreg" : 0, "immediate=
data" : {"data_reg": {"type" : "verdict", "verdict" : "accept"}}}]}}
diff --git a/tests/jsonfiles/35-rule-target.json b/tests/jsonfiles/35-r=
ule-target.json
new file mode 100644
index 0000000..a435264
--- /dev/null
+++ b/tests/jsonfiles/35-rule-target.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "INPUT", "=
handle" : 20,"flags" : 0, "expr" : [ { "type" : "counter", "pkts" : 17,=
 "bytes" : 4436}, { "type" : "target", "name" : "LOG"}]}}
diff --git a/tests/jsonfiles/36-rule-real.json b/tests/jsonfiles/36-rul=
e-real.json
new file mode 100644
index 0000000..9ea5e48
--- /dev/null
+++ b/tests/jsonfiles/36-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 36,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 12, "len" : 8, "base" : "link"}, { "type" : "cmp", "sreg" :=
 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 8=
, "data0" : "0x0100a8c0", "data1" : "0x6400a8c0"}}}, { "type" : "counte=
r", "pkts" : 0, "bytes" : 0}]}}
diff --git a/tests/jsonfiles/37-rule-real.json b/tests/jsonfiles/37-rul=
e-real.json
new file mode 100644
index 0000000..99bd818
--- /dev/null
+++ b/tests/jsonfiles/37-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 37,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" :=
 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4=
, "data0" : "0x0100a8c0"}}}]}}
diff --git a/tests/jsonfiles/38-rule-real.json b/tests/jsonfiles/38-rul=
e-real.json
new file mode 100644
index 0000000..26384a4
--- /dev/null
+++ b/tests/jsonfiles/38-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 38,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" :=
 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4=
, "data0" : "0x0100a8c0"}}}]}}
diff --git a/tests/jsonfiles/39-rule-real.json b/tests/jsonfiles/39-rul=
e-real.json
new file mode 100644
index 0000000..f77c5a5
--- /dev/null
+++ b/tests/jsonfiles/39-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 39,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" :=
 1, "op" : "gte", "cmpdata" : {"data_reg": { "type" : "value", "len" : =
4, "data0" : "0x0100a8c0"}}}, { "type" : "cmp", "sreg" : 1, "op" : "lte=
", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4, "data0" : "0=
xfa00a8c0"}}}]}}
diff --git a/tests/jsonfiles/40-rule-real.json b/tests/jsonfiles/40-rul=
e-real.json
new file mode 100644
index 0000000..fff70dd
--- /dev/null
+++ b/tests/jsonfiles/40-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 40,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" :=
 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4=
, "data0" : "0x0100a8c0"}}}, { "type" : "counter", "pkts" : 0, "bytes" =
: 0}]}}
diff --git a/tests/jsonfiles/41-rule-real.json b/tests/jsonfiles/41-rul=
e-real.json
new file mode 100644
index 0000000..a5c0e49
--- /dev/null
+++ b/tests/jsonfiles/41-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 41,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" :=
 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4=
, "data0" : "0x0100a8c0"}}}, { "type" : "counter", "pkts" : 0, "bytes" =
: 0}, { "type" : "immediate", "dreg" : 0, "immediatedata" : {"data_reg"=
: {"type" : "verdict", "verdict" : "drop"}}}]}}
diff --git a/tests/jsonfiles/42-rule-real.json b/tests/jsonfiles/42-rul=
e-real.json
new file mode 100644
index 0000000..ec2b4a9
--- /dev/null
+++ b/tests/jsonfiles/42-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 42,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" :=
 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4=
, "data0" : "0x0100a8c0"}}}, { "type" : "counter", "pkts" : 0, "bytes" =
: 0}, { "type" : "log", "prefix" : "(null)", "group" : 0, "snaplen" : 0=
, "qthreshold" : 0 }]}}
diff --git a/tests/jsonfiles/43-rule-real.json b/tests/jsonfiles/43-rul=
e-real.json
new file mode 100644
index 0000000..22f7cd1
--- /dev/null
+++ b/tests/jsonfiles/43-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 43,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 9, "len" : 1, "base" : "link"}, { "type" : "cmp", "sreg" : =
1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 1,=
 "data0" : "0x00000006"}}}, { "type" : "payload", "dreg" : 1, "offset" =
: 2, "len" : 2, "base" : "link"}, { "type" : "cmp", "sreg" : 1, "op" : =
"eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 2, "data0" :=
 "0x00001600"}}}, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
diff --git a/tests/jsonfiles/44-rule-real.json b/tests/jsonfiles/44-rul=
e-real.json
new file mode 100644
index 0000000..c7401ae
--- /dev/null
+++ b/tests/jsonfiles/44-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 44,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 9, "len" : 1, "base" : "link"}, { "type" : "cmp", "sreg" : =
1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 1,=
 "data0" : "0x00000006"}}}, { "type" : "payload", "dreg" : 1, "offset" =
: 0, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" : 1, "op" : =
"eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4, "data0" :=
 "0x16000004"}}}, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
diff --git a/tests/jsonfiles/45-rule-real.json b/tests/jsonfiles/45-rul=
e-real.json
new file mode 100644
index 0000000..5f9df87
--- /dev/null
+++ b/tests/jsonfiles/45-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 45,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 12, "len" : 8, "base" : "link"}, { "type" : "cmp", "sreg" :=
 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 8=
, "data0" : "0x0100a8c0", "data1" : "0x6400a8c0"}}}, { "type" : "counte=
r", "pkts" : 0, "bytes" : 0}]}}
diff --git a/tests/jsonfiles/46-rule-real.json b/tests/jsonfiles/46-rul=
e-real.json
new file mode 100644
index 0000000..3b1a96b
--- /dev/null
+++ b/tests/jsonfiles/46-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 46,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 9, "len" : 1, "base" : "link"}, { "type" : "cmp", "sreg" : =
1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 1,=
 "data0" : "0x00000006"}}}, { "type" : "payload", "dreg" : 1, "offset" =
: 0, "len" : 8, "base" : "link"}, { "type" : "cmp", "sreg" : 1, "op" : =
"eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 8, "data0" :=
 "0x16000004", "data1" : "0x00000000"}}}]}}
diff --git a/tests/jsonfiles/47-rule-real.json b/tests/jsonfiles/47-rul=
e-real.json
new file mode 100644
index 0000000..2f36100
--- /dev/null
+++ b/tests/jsonfiles/47-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 47,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1,=
 "offset" : 9, "len" : 1, "base" : "link"}, { "type" : "cmp", "sreg" : =
1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 1,=
 "data0" : "0x00000006"}}}, { "type" : "payload", "dreg" : 1, "offset" =
: 0, "len" : 8, "base" : "link"}, { "type" : "cmp", "sreg" : 1, "op" : =
"eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 8, "data0" :=
 "0x16000004", "data1" : "0x00000000"}}}]}}
diff --git a/tests/jsonfiles/48-rule-real.json b/tests/jsonfiles/48-rul=
e-real.json
new file mode 100644
index 0000000..86fbd83
--- /dev/null
+++ b/tests/jsonfiles/48-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 48,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "len"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"=
data_reg": { "type" : "value", "len" : 4, "data0" : "0x000003e8"}}}, { =
"type" : "counter", "pkts" : 0, "bytes" : 0}]}}
diff --git a/tests/jsonfiles/49-rule-real.json b/tests/jsonfiles/49-rul=
e-real.json
new file mode 100644
index 0000000..dc6a680
--- /dev/null
+++ b/tests/jsonfiles/49-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 49,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "mark"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {=
"data_reg": { "type" : "value", "len" : 4, "data0" : "0x00000000"}}}, {=
 "type" : "counter", "pkts" : 55, "bytes" : 11407}]}}
diff --git a/tests/jsonfiles/50-rule-real.json b/tests/jsonfiles/50-rul=
e-real.json
new file mode 100644
index 0000000..3845a8c
--- /dev/null
+++ b/tests/jsonfiles/50-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 50,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "iif"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"=
data_reg": { "type" : "value", "len" : 4, "data0" : "0x00000001"}}}, { =
"type" : "counter", "pkts" : 0, "bytes" : 0}]}}
diff --git a/tests/jsonfiles/51-rule-real.json b/tests/jsonfiles/51-rul=
e-real.json
new file mode 100644
index 0000000..f2f1784
--- /dev/null
+++ b/tests/jsonfiles/51-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 51,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "iifname"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" =
: {"data_reg": { "type" : "value", "len" : 16, "data0" : "0x00000000", =
"data1" : "0x00000000", "data2" : "0x65000000", "data3" : "0x00306874"}=
}}, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
diff --git a/tests/jsonfiles/52-rule-real.json b/tests/jsonfiles/52-rul=
e-real.json
new file mode 100644
index 0000000..7d16017
--- /dev/null
+++ b/tests/jsonfiles/52-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 52,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "oif"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"=
data_reg": { "type" : "value", "len" : 4, "data0" : "0x00000001"}}}, { =
"type" : "counter", "pkts" : 0, "bytes" : 0}]}}
diff --git a/tests/jsonfiles/53-rule-real.json b/tests/jsonfiles/53-rul=
e-real.json
new file mode 100644
index 0000000..2ba527c
--- /dev/null
+++ b/tests/jsonfiles/53-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 53,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "oifname"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" =
: {"data_reg": { "type" : "value", "len" : 16, "data0" : "0x00000000", =
"data1" : "0x00000000", "data2" : "0x65000000", "data3" : "0x00306874"}=
}}, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
diff --git a/tests/jsonfiles/54-rule-real.json b/tests/jsonfiles/54-rul=
e-real.json
new file mode 100644
index 0000000..a222e1d
--- /dev/null
+++ b/tests/jsonfiles/54-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 54,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "skuid"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : =
{"data_reg": { "type" : "value", "len" : 4, "data0" : "0x000003e8"}}}, =
{ "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
diff --git a/tests/jsonfiles/55-rule-real.json b/tests/jsonfiles/55-rul=
e-real.json
new file mode 100644
index 0000000..1527349
--- /dev/null
+++ b/tests/jsonfiles/55-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 55,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "skgid"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : =
{"data_reg": { "type" : "value", "len" : 4, "data0" : "0x000003e8"}}}, =
{ "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
diff --git a/tests/jsonfiles/56-rule-real.json b/tests/jsonfiles/56-rul=
e-real.json
new file mode 100644
index 0000000..b33dd78
--- /dev/null
+++ b/tests/jsonfiles/56-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 56,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "secmark"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" =
: {"data_reg": { "type" : "value", "len" : 4, "data0" : "0x00000000"}}}=
, { "type" : "counter", "pkts" : 55, "bytes" : 11407}]}}
diff --git a/tests/jsonfiles/57-rule-real.json b/tests/jsonfiles/57-rul=
e-real.json
new file mode 100644
index 0000000..9c0a1eb
--- /dev/null
+++ b/tests/jsonfiles/57-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 57,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "len"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"=
data_reg": { "type" : "value", "len" : 4, "data0" : "0x000003e8"}}}, { =
"type" : "counter", "pkts" : 0, "bytes" : 0}]}}
diff --git a/tests/jsonfiles/58-rule-real.json b/tests/jsonfiles/58-rul=
e-real.json
new file mode 100644
index 0000000..6934748
--- /dev/null
+++ b/tests/jsonfiles/58-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 58,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "protocol"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata"=
 : {"data_reg": { "type" : "value", "len" : 2, "data0" : "0x00000008"}}=
}, { "type" : "counter", "pkts" : 55, "bytes" : 11407}]}}
diff --git a/tests/jsonfiles/59-rule-real.json b/tests/jsonfiles/59-rul=
e-real.json
new file mode 100644
index 0000000..298a291
--- /dev/null
+++ b/tests/jsonfiles/59-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 59,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "mark"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {=
"data_reg": { "type" : "value", "len" : 4, "data0" : "0x00000000"}}}, {=
 "type" : "counter", "pkts" : 55, "bytes" : 11407}]}}
diff --git a/tests/jsonfiles/60-rule-real.json b/tests/jsonfiles/60-rul=
e-real.json
new file mode 100644
index 0000000..e124411
--- /dev/null
+++ b/tests/jsonfiles/60-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 60,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "iif"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"=
data_reg": { "type" : "value", "len" : 4, "data0" : "0x00000001"}}}, { =
"type" : "counter", "pkts" : 0, "bytes" : 0}]}}
diff --git a/tests/jsonfiles/61-rule-real.json b/tests/jsonfiles/61-rul=
e-real.json
new file mode 100644
index 0000000..f74acf2
--- /dev/null
+++ b/tests/jsonfiles/61-rule-real.json
@@ -0,0 +1 @@
+{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", =
"handle" : 61,"flags" : 0, "expr" : [ { "type" : "meta", "dreg" : 1, "k=
ey" : "iifname"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" =
: {"data_reg": { "type" : "value", "len" : 16, "data0" : "0x00000000", =
"data1" : "0x00000000", "data2" : "0x65000000", "data3" : "0x00306874"}=
}}, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}}
diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 9e457e8..bf5b519 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -157,6 +157,7 @@ static int test_json(const char *filename)
 	int ret =3D -1;
 	struct nft_table *t =3D NULL;
 	struct nft_chain *c =3D NULL;
+	struct nft_rule *r =3D NULL;
 	json_t *root;
 	json_error_t error;
 	char *json =3D NULL;
@@ -189,6 +190,16 @@ static int test_json(const char *filename)
=20
 			nft_chain_free(c);
 		}
+	} else if (json_object_get(root, "rule") !=3D NULL) {
+		r =3D nft_rule_alloc();
+		if (r !=3D NULL) {
+			if (nft_rule_parse(r, NFT_RULE_PARSE_JSON, json) =3D=3D 0)
+				ret =3D compare_test(TEST_JSON_RULE, r, filename);
+			else
+				goto failparsing;
+
+			nft_rule_free(r);
+		}
 	}
=20
 	free(json);

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
