Return-Path: <SRS0=SOhW=3T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC51FC2D0DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 00:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5E30206A2
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 00:17:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NhCYZcki"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgA3ARh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 19:17:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40411 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726939AbgA3ARh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 19:17:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580343455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I1m/kf/EoTLaPQVZ9puyf5iet6TXj7fk1aeiUWOc+34=;
        b=NhCYZckieTQ7GTqiD4oHYXF9J/0QHPXPf/UGpbqj065lo4lOwXTZX1IeMZ5O0dDuThDy/M
        PpQSQbQrKhVuSf1YQco1J9yKOijm2eIW68CvMT06tPjCEYS2ig9cJRbnzIKCrzqnTv0Qbc
        br1pxOcnQhIpiXtpc5O7OrZJxUr45Nw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-nEFgytL_M9mhwlvIoKs9bQ-1; Wed, 29 Jan 2020 19:17:15 -0500
X-MC-Unique: nEFgytL_M9mhwlvIoKs9bQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA0521005512;
        Thu, 30 Jan 2020 00:17:13 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDDE1166A9;
        Thu, 30 Jan 2020 00:17:11 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v4 4/4] tests: Introduce test for set with concatenated ranges
Date:   Thu, 30 Jan 2020 01:16:58 +0100
Message-Id: <6f1dbaf2ab5a98b2616b14d93ee589a7e741e5f9.1580342294.git.sbrivio@redhat.com>
In-Reply-To: <cover.1580342294.git.sbrivio@redhat.com>
References: <cover.1580342294.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This test checks that set elements can be added, deleted, that
addition and deletion are refused when appropriate, that entries
time out properly, and that they can be fetched by matching values
in the given ranges.

v4: No changes
v3:
 - renumber test to 0042, 0041 was added meanwhile
v2:
 - actually check an IPv6 prefix, instead of specifying everything
   as explicit ranges in ELEMS_ipv6_addr
 - renumber test to 0041, 0038 already exists

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 .../testcases/sets/0042concatenated_ranges_0  | 162 ++++++++++++++++++
 1 file changed, 162 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0042concatenated_ranges_0

diff --git a/tests/shell/testcases/sets/0042concatenated_ranges_0 b/tests=
/shell/testcases/sets/0042concatenated_ranges_0
new file mode 100755
index 000000000000..244c5ffe7c75
--- /dev/null
+++ b/tests/shell/testcases/sets/0042concatenated_ranges_0
@@ -0,0 +1,162 @@
+#!/bin/sh -e
+#
+# 0042concatenated_ranges_0 - Add, get, list, timeout for concatenated r=
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
+# - check that they are not listed after 1s
+# - delete them
+# - make sure they can't be deleted again
+
+TYPES=3D"ipv4_addr ipv6_addr ether_addr inet_proto inet_service mark"
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
+			! ${NFT} add element inet filter test \
+				"{ ${a1} . ${b1} . ${c1} }" 2>/dev/null
+			! ${NFT} add element inet filter test \
+				"{ ${a2} . ${b2} . ${c2} }" 2>/dev/null
+			! ${NFT} add element inet filter test \
+				"{ ${a3} . ${b3} . ${c3} }" 2>/dev/null
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
+			sleep 1
+			[ $(${NFT} list set inet filter test |		\
+			   grep -c "${add_a} . ${add_b} . ${add_c}") -eq 0 ]
+
+			${NFT} delete element inet filter test \
+				"{ ${a2} . ${b2} . ${c2} }"
+			${NFT} delete element inet filter test \
+				"{ ${a3} . ${b3} . ${c3} }"
+			! ${NFT} delete element inet filter test \
+				"{ ${a2} . ${b2} . ${c2} }" 2>/dev/null
+			! ${NFT} delete element inet filter test \
+				"{ ${a3} . ${b3} . ${c3} }" 2>/dev/null
+		done
+	done
+done
--=20
2.24.1

