Return-Path: <SRS0=aq0Q=4C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B440C2BA83
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 15:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBF2824673
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 15:28:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NvO+3SwN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387724AbgBNP2C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Feb 2020 10:28:02 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37320 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387445AbgBNP2A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 10:28:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581694079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wWgawZJjK7OvgT9C2xcfLcAqQeg6c+EqJfN+Vk4hR2c=;
        b=NvO+3SwNXVGCJJ78BAWIDMU0I9tA5AJam6pad9M2REaJ4xEC+C9+m0DZg2uIXVNqm20Ha6
        Axyv/TbRR/azH7nKJhWdcWvPtZXY/I86FB0WL9KCJ/UKP4iWFhqrPK2XGOe1TO5bo8qjfl
        JbT4Qe89MW9Js0ZxxXWSIv58K1Tpxo8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-PuZkQFeqMOqdYzC1giMzQg-1; Fri, 14 Feb 2020 10:27:44 -0500
X-MC-Unique: PuZkQFeqMOqdYzC1giMzQg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59A1110CE784;
        Fri, 14 Feb 2020 15:27:42 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C05E75DA7D;
        Fri, 14 Feb 2020 15:27:39 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v5] tests: Introduce test for set with concatenated ranges
Date:   Fri, 14 Feb 2020 16:27:25 +0100
Message-Id: <546dccfe97760ba910676b84799b15d38164e192.1581693171.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This test checks that set elements can be added, deleted, that
addition and deletion are refused when appropriate, that entries
time out properly, and that they can be fetched by matching values
in the given ranges.

v5:
 - speed this up by performing the timeout test for one single
   permutation (Phil Sutter), by decreasing the number of
   permutations from 96 to 12 if this is invoked by run-tests.sh
   (Pablo Neira Ayuso) and by combining some commands into single
   nft calls where possible: with dash 0.5.8 on AMD Epyc 7351 the
   test now takes 1.8s instead of 82.5s
 - renumber test to 0043, 0042 was added meanwhile
v4: No changes
v3:
 - renumber test to 0042, 0041 was added meanwhile
v2:
 - actually check an IPv6 prefix, instead of specifying everything
   as explicit ranges in ELEMS_ipv6_addr
 - renumber test to 0041, 0038 already exists

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 .../testcases/sets/0043concatenated_ranges_0  | 180 ++++++++++++++++++
 1 file changed, 180 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0043concatenated_ranges_0

diff --git a/tests/shell/testcases/sets/0043concatenated_ranges_0 b/tests=
/shell/testcases/sets/0043concatenated_ranges_0
new file mode 100755
index 000000000000..a783dacc361c
--- /dev/null
+++ b/tests/shell/testcases/sets/0043concatenated_ranges_0
@@ -0,0 +1,180 @@
+#!/bin/sh -e
+#
+# 0043concatenated_ranges_0 - Add, get, list, timeout for concatenated r=
anges
+#
+# Cycle over supported data types, forming concatenations of three field=
s, for
+# all possible permutations, and:
+# - add entries to set
+# - list them
+# - check that they can't be added again
+# - get entries by specifying a value matching ranges for all fields
+# - delete them
+# - add them with 1s timeout
+# - check that they can't be added again right away
+# - check that they are not listed after 1s, just once, for the first en=
try
+# - delete them
+# - make sure they can't be deleted again
+
+if [ "$(ps -o comm=3D $PPID)" =3D "run-tests.sh" ]; then
+	# Skip some permutations on a full test suite run to keep it quick
+	TYPES=3D"ipv4_addr ipv6_addr ether_addr inet_service"
+else
+	TYPES=3D"ipv4_addr ipv6_addr ether_addr inet_proto inet_service mark"
+fi
+
+RULESPEC_ipv4_addr=3D"ip saddr"
+ELEMS_ipv4_addr=3D"192.0.2.1 198.51.100.0/25 203.0.113.0-203.0.113.129"
+ADD_ipv4_addr=3D"192.0.2.252/31"
+GET_ipv4_addr=3D"198.51.100.127 198.51.100.0/25"
+
+RULESPEC_ipv6_addr=3D"ip6 daddr"
+ELEMS_ipv6_addr=3D"2001:db8:c0c:c0de::1-2001:db8:cacc::a 2001:db8::1 200=
1:db8:dada:da::/64"
+ADD_ipv6_addr=3D"2001:db8::d1ca:d1ca"
+GET_ipv6_addr=3D"2001:db8::1 2001:db8::1"
+
+RULESPEC_ether_addr=3D"ether saddr"
+ELEMS_ether_addr=3D"00:0a:c1:d1:f1:ed-00:0a:c1:dd:ec:af 00:0b:0c:ca:cc:1=
0-c1:a0:c1:cc:10:00 f0:ca:cc:1a:b0:1a"
+ADD_ether_addr=3D"00:be:1d:ed:ab:e1"
+GET_ether_addr=3D"ac:c1:ac:c0:ce:c0 00:0b:0c:ca:cc:10-c1:a0:c1:cc:10:00"
+
+RULESPEC_inet_proto=3D"meta l4proto"
+ELEMS_inet_proto=3D"tcp udp icmp"
+ADD_inet_proto=3D"sctp"
+GET_inet_proto=3D"udp udp"
+
+RULESPEC_inet_service=3D"tcp dport"
+ELEMS_inet_service=3D"22-23 1024-32768 31337"
+ADD_inet_service=3D"32769-65535"
+GET_inet_service=3D"32768 1024-32768"
+
+RULESPEC_mark=3D"mark"
+ELEMS_mark=3D"0x00000064-0x000000c8 0x0000006f 0x0000fffd-0x0000ffff"
+ADD_mark=3D"0x0000002a"
+GET_mark=3D"0x0000006f 0x0000006f"
+
+tmp=3D"$(mktemp)"
+trap "rm -f ${tmp}" EXIT
+
+render() {
+	eval "echo \"$(cat ${1})\""
+}
+
+cat <<'EOF' > "${tmp}"
+flush ruleset
+
+table inet filter {
+	set test {
+		type ${ta} . ${tb} . ${tc}
+		flags interval,timeout
+		elements =3D { ${a1} . ${b1} . ${c1} ,
+			     ${a2} . ${b2} . ${c2} ,
+			     ${a3} . ${b3} . ${c3} }
+	}
+
+	chain output {
+		type filter hook output priority 0; policy accept;
+		${sa} . ${sb} . ${sc} @test counter
+	}
+}
+EOF
+
+timeout_tested=3D0
+for ta in ${TYPES}; do
+	eval a=3D\$ELEMS_${ta}
+	a1=3D${a%% *}; a2=3D$(expr "$a" : ".* \(.*\) .*"); a3=3D${a##* }
+	eval sa=3D\$RULESPEC_${ta}
+
+	for tb in ${TYPES}; do
+		[ "${tb}" =3D "${ta}" ] && continue
+		if [ "${tb}" =3D "ipv6_addr" ]; then
+			[ "${ta}" =3D "ipv4_addr" ] && continue
+		elif [ "${tb}" =3D "ipv4_addr" ]; then
+			[ "${ta}" =3D "ipv6_addr" ] && continue
+		fi
+
+		eval b=3D\$ELEMS_${tb}
+		b1=3D${b%% *}; b2=3D$(expr "$b" : ".* \(.*\) .*"); b3=3D${b##* }
+		eval sb=3D\$RULESPEC_${tb}
+
+		for tc in ${TYPES}; do
+			[ "${tc}" =3D "${ta}" ] && continue
+			[ "${tc}" =3D "${tb}" ] && continue
+			if [ "${tc}" =3D "ipv6_addr" ]; then
+				[ "${ta}" =3D "ipv4_addr" ] && continue
+				[ "${tb}" =3D "ipv4_addr" ] && continue
+			elif [ "${tc}" =3D "ipv4_addr" ]; then
+				[ "${ta}" =3D "ipv6_addr" ] && continue
+				[ "${tb}" =3D "ipv6_addr" ] && continue
+			fi
+
+			echo "TYPE: ${ta} ${tb} ${tc}"
+
+			eval c=3D\$ELEMS_${tc}
+			c1=3D${c%% *}; c2=3D$(expr "$c" : ".* \(.*\) .*"); c3=3D${c##* }
+			eval sc=3D\$RULESPEC_${tc}
+
+			render ${tmp} | ${NFT} -f -
+
+			[ $(${NFT} list set inet filter test |		\
+			   grep -c -e "${a1} . ${b1} . ${c1}"		\
+				   -e "${a2} . ${b2} . ${c2}"		\
+				   -e "${a3} . ${b3} . ${c3}") -eq 3 ]
+
+			! ${NFT} "add element inet filter test \
+				  { ${a1} . ${b1} . ${c1} };
+				  add element inet filter test \
+				  { ${a2} . ${b2} . ${c2} };
+				  add element inet filter test \
+				  { ${a3} . ${b3} . ${c3} }" 2>/dev/null
+
+			${NFT} delete element inet filter test \
+				"{ ${a1} . ${b1} . ${c1} }"
+			! ${NFT} delete element inet filter test \
+				"{ ${a1} . ${b1} . ${c1} }" 2>/dev/null
+
+			eval add_a=3D\$ADD_${ta}
+			eval add_b=3D\$ADD_${tb}
+			eval add_c=3D\$ADD_${tc}
+			${NFT} add element inet filter test \
+				"{ ${add_a} . ${add_b} . ${add_c} timeout 1s}"
+			[ $(${NFT} list set inet filter test |		\
+			   grep -c "${add_a} . ${add_b} . ${add_c}") -eq 1 ]
+			! ${NFT} add element inet filter test \
+				"{ ${add_a} . ${add_b} . ${add_c} timeout 1s}" \
+				2>/dev/null
+
+			eval get_a=3D\$GET_${ta}
+			eval get_b=3D\$GET_${tb}
+			eval get_c=3D\$GET_${tc}
+			exp_a=3D${get_a##* }; get_a=3D${get_a%% *}
+			exp_b=3D${get_b##* }; get_b=3D${get_b%% *}
+			exp_c=3D${get_c##* }; get_c=3D${get_c%% *}
+			[ $(${NFT} get element inet filter test 	\
+			   "{ ${get_a} . ${get_b} . ${get_c} }" |	\
+			   grep -c "${exp_a} . ${exp_b} . ${exp_c}") -eq 1 ]
+
+			${NFT} "delete element inet filter test \
+				{ ${a2} . ${b2} . ${c2} };
+				delete element inet filter test \
+				{ ${a3} . ${b3} . ${c3} }"
+			! ${NFT} "delete element inet filter test \
+				  { ${a2} . ${b2} . ${c2} };
+				  delete element inet filter test \
+				  { ${a3} . ${b3} . ${c3} }" 2>/dev/null
+
+			if [ ${timeout_tested} -eq 1 ]; then
+				${NFT} delete element inet filter test \
+					"{ ${add_a} . ${add_b} . ${add_c} }"
+				! ${NFT} delete element inet filter test \
+					"{ ${add_a} . ${add_b} . ${add_c} }" \
+					2>/dev/null
+				continue
+			fi
+
+			sleep 1
+			[ $(${NFT} list set inet filter test |		\
+			   grep -c "${add_a} . ${add_b} . ${add_c}") -eq 0 ]
+			timeout_tested=3D1
+		done
+	done
+done
--=20
2.25.0

