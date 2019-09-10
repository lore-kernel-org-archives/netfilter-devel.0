Return-Path: <SRS0=BTt+=XF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5874CC3A5A2
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 13:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10AA120863
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 13:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732893AbfIJNne (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Sep 2019 09:43:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729662AbfIJNne (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 09:43:34 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AE435612A3;
        Tue, 10 Sep 2019 13:43:33 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-123-28.rdu2.redhat.com [10.10.123.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF7D66377C;
        Tue, 10 Sep 2019 13:43:32 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft 3/3] tests: shell: add huge transaction from firewalld
Date:   Tue, 10 Sep 2019 09:43:28 -0400
Message-Id: <20190910134328.11535-3-eric@garver.life>
In-Reply-To: <20190910134328.11535-1-eric@garver.life>
References: <20190910134328.11535-1-eric@garver.life>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 10 Sep 2019 13:43:33 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is borrowed from one of firewalld's test cases.

Signed-off-by: Eric Garver <eric@garver.life>
---
 tests/shell/testcases/transactions/0049huge_0 | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tests/shell/testcases/transactions/0049huge_0 b/tests/shell/te=
stcases/transactions/0049huge_0
index f029ee3c54d7..684d27a17b5a 100755
--- a/tests/shell/testcases/transactions/0049huge_0
+++ b/tests/shell/testcases/transactions/0049huge_0
@@ -29,3 +29,13 @@ done
 echo ']}'
 )
 test $($NFT -j -e -a -f - <<< "$RULESET" |sed 's/\({"add":\)/\n\1/g' |grep=
 '"handle"' |wc -l) -eq ${RULE_COUNT} || exit 1
+
+# Now an example from firewalld's testsuite
+#
+$NFT flush ruleset
+
+RULESET=3D'{"nftables": [{"metainfo": {"json_schema_version": 1}}, {"add":=
 {"table": {"family": "inet", "name": "firewalld"}}}, {"add": {"table": {"f=
amily": "ip", "name": "firewalld"}}}, {"add": {"table": {"family": "ip6", "=
name": "firewalld"}}},
+{"add": {"chain": {"family": "inet", "table": "firewalld", "name": "raw_PR=
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
+{"add": {"rule": {"family": "inet", "table": "firewalld", "chain": "filter=
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
+
+test -z "$($NFT -j -e -a -f - <<< "$RULESET" |sed 's/\({"add":\|{"insert":=
\)/\n\1/g' |grep '\({"add":\|{"insert":\)' | grep -v '"handle"')"
--=20
2.20.1

