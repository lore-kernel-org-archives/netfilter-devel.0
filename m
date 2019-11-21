Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0828C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFC65206CC
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:10:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EHmY27Ww"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKURK1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 12:10:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46233 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726568AbfKURK1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 12:10:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574356225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sUR/BHwqQTn/mtJ5OCDa4hyMdh13+5AhDroBoU+c5YI=;
        b=EHmY27WwzMKfv7/CW5bmdNVOCMgvRVOv7NlOQEnZu2hdztOe4T1t0GeRiPbYT+XKinH1YQ
        k5zuEju5i/Icfxad84claKQgPKF5ls6pySa6BWGxJwqp+BCPLpqjIvignE7fyPFIiE790t
        TEogsHitUBHFJgTE303+avn+tX1caQ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-EkA0iUu1ME-mOIvK1g0KBg-1; Thu, 21 Nov 2019 12:10:21 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8481B802699;
        Thu, 21 Nov 2019 17:10:20 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56A816E3F9;
        Thu, 21 Nov 2019 17:10:16 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v2 3/3] tests: Introduce test for set with concatenated ranges
Date:   Thu, 21 Nov 2019 18:10:06 +0100
Message-Id: <ecec1c16ea949fa2515a129568972e5ff263bff8.1574353687.git.sbrivio@redhat.com>
In-Reply-To: <cover.1574353687.git.sbrivio@redhat.com>
References: <cover.1574353687.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: EkA0iUu1ME-mOIvK1g0KBg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This test checks that set elements can be added, deleted, that
addition and deletion are refused when appropriate, that entries
time out properly, and that they can be fetched by matching values
in the given ranges.

v2:
 - actually check an IPv6 prefix, instead of specifying everything
   as explicit ranges in ELEMS_ipv6_addr
 - renumber test to 0041, 0038 already exists

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 .../testcases/sets/0041concatenated_ranges_0  | 162 ++++++++++++++++++
 1 file changed, 162 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0041concatenated_ranges_0

diff --git a/tests/shell/testcases/sets/0041concatenated_ranges_0 b/tests/s=
hell/testcases/sets/0041concatenated_ranges_0
new file mode 100755
index 000000000000..dd6fc215397c
--- /dev/null
+++ b/tests/shell/testcases/sets/0041concatenated_ranges_0
@@ -0,0 +1,162 @@
+#!/bin/sh -e
+#
+# 0041concatenated_ranges_0 - Add, get, list, timeout for concatenated ran=
ges
+#
+# Cycle over supported data types, forming concatenations of three fields,=
 for
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
+ELEMS_ipv6_addr=3D"2001:db8:c0c:c0de::1-2001:db8:cacc::a 2001:db8::1 2001:=
db8:dada:da::/64"
+ADD_ipv6_addr=3D"2001:db8::d1ca:d1ca"
+GET_ipv6_addr=3D"2001:db8::1 2001:db8::1"
+
+RULESPEC_ether_addr=3D"ether saddr"
+ELEMS_ether_addr=3D"00:0a:c1:d1:f1:ed-00:0a:c1:dd:ec:af 00:0b:0c:ca:cc:10-=
c1:a0:c1:cc:10:00 f0:ca:cc:1a:b0:1a"
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
+=09eval "echo \"$(cat ${1})\""
+}
+
+cat <<'EOF' > "${tmp}"
+flush ruleset
+
+table inet filter {
+=09set test {
+=09=09type ${ta} . ${tb} . ${tc}
+=09=09flags interval,timeout
+=09=09elements =3D { ${a1} . ${b1} . ${c1} ,
+=09=09=09     ${a2} . ${b2} . ${c2} ,
+=09=09=09     ${a3} . ${b3} . ${c3} }
+=09}
+
+=09chain output {
+=09=09type filter hook output priority 0; policy accept;
+=09=09${sa} . ${sb} . ${sc} @test counter
+=09}
+}
+EOF
+
+for ta in ${TYPES}; do
+=09eval a=3D\$ELEMS_${ta}
+=09a1=3D${a%% *}; a2=3D$(expr "$a" : ".* \(.*\) .*"); a3=3D${a##* }
+=09eval sa=3D\$RULESPEC_${ta}
+
+=09for tb in ${TYPES}; do
+=09=09[ "${tb}" =3D "${ta}" ] && continue
+=09=09if [ "${tb}" =3D "ipv6_addr" ]; then
+=09=09=09[ "${ta}" =3D "ipv4_addr" ] && continue
+=09=09elif [ "${tb}" =3D "ipv4_addr" ]; then
+=09=09=09[ "${ta}" =3D "ipv6_addr" ] && continue
+=09=09fi
+
+=09=09eval b=3D\$ELEMS_${tb}
+=09=09b1=3D${b%% *}; b2=3D$(expr "$b" : ".* \(.*\) .*"); b3=3D${b##* }
+=09=09eval sb=3D\$RULESPEC_${tb}
+
+=09=09for tc in ${TYPES}; do
+=09=09=09[ "${tc}" =3D "${ta}" ] && continue
+=09=09=09[ "${tc}" =3D "${tb}" ] && continue
+=09=09=09if [ "${tc}" =3D "ipv6_addr" ]; then
+=09=09=09=09[ "${ta}" =3D "ipv4_addr" ] && continue
+=09=09=09=09[ "${tb}" =3D "ipv4_addr" ] && continue
+=09=09=09elif [ "${tc}" =3D "ipv4_addr" ]; then
+=09=09=09=09[ "${ta}" =3D "ipv6_addr" ] && continue
+=09=09=09=09[ "${tb}" =3D "ipv6_addr" ] && continue
+=09=09=09fi
+
+=09=09=09eval c=3D\$ELEMS_${tc}
+=09=09=09c1=3D${c%% *}; c2=3D$(expr "$c" : ".* \(.*\) .*"); c3=3D${c##* }
+=09=09=09eval sc=3D\$RULESPEC_${tc}
+
+=09=09=09render ${tmp} | ${NFT} -f -
+
+=09=09=09[ $(${NFT} list set inet filter test |=09=09\
+=09=09=09   grep -c -e "${a1} . ${b1} . ${c1}"=09=09\
+=09=09=09=09   -e "${a2} . ${b2} . ${c2}"=09=09\
+=09=09=09=09   -e "${a3} . ${b3} . ${c3}") -eq 3 ]
+
+=09=09=09! ${NFT} add element inet filter test \
+=09=09=09=09"{ ${a1} . ${b1} . ${c1} }" 2>/dev/null
+=09=09=09! ${NFT} add element inet filter test \
+=09=09=09=09"{ ${a2} . ${b2} . ${c2} }" 2>/dev/null
+=09=09=09! ${NFT} add element inet filter test \
+=09=09=09=09"{ ${a3} . ${b3} . ${c3} }" 2>/dev/null
+
+=09=09=09${NFT} delete element inet filter test \
+=09=09=09=09"{ ${a1} . ${b1} . ${c1} }"
+=09=09=09! ${NFT} delete element inet filter test \
+=09=09=09=09"{ ${a1} . ${b1} . ${c1} }" 2>/dev/null
+
+=09=09=09eval add_a=3D\$ADD_${ta}
+=09=09=09eval add_b=3D\$ADD_${tb}
+=09=09=09eval add_c=3D\$ADD_${tc}
+=09=09=09${NFT} add element inet filter test \
+=09=09=09=09"{ ${add_a} . ${add_b} . ${add_c} timeout 1s}"
+=09=09=09[ $(${NFT} list set inet filter test |=09=09\
+=09=09=09   grep -c "${add_a} . ${add_b} . ${add_c}") -eq 1 ]
+=09=09=09! ${NFT} add element inet filter test \
+=09=09=09=09"{ ${add_a} . ${add_b} . ${add_c} timeout 1s}" \
+=09=09=09=092>/dev/null
+
+=09=09=09eval get_a=3D\$GET_${ta}
+=09=09=09eval get_b=3D\$GET_${tb}
+=09=09=09eval get_c=3D\$GET_${tc}
+=09=09=09exp_a=3D${get_a##* }; get_a=3D${get_a%% *}
+=09=09=09exp_b=3D${get_b##* }; get_b=3D${get_b%% *}
+=09=09=09exp_c=3D${get_c##* }; get_c=3D${get_c%% *}
+=09=09=09[ $(${NFT} get element inet filter test =09\
+=09=09=09   "{ ${get_a} . ${get_b} . ${get_c} }" |=09\
+=09=09=09   grep -c "${exp_a} . ${exp_b} . ${exp_c}") -eq 1 ]
+
+=09=09=09sleep 1
+=09=09=09[ $(${NFT} list set inet filter test |=09=09\
+=09=09=09   grep -c "${add_a} . ${add_b} . ${add_c}") -eq 0 ]
+
+=09=09=09${NFT} delete element inet filter test \
+=09=09=09=09"{ ${a2} . ${b2} . ${c2} }"
+=09=09=09${NFT} delete element inet filter test \
+=09=09=09=09"{ ${a3} . ${b3} . ${c3} }"
+=09=09=09! ${NFT} delete element inet filter test \
+=09=09=09=09"{ ${a2} . ${b2} . ${c2} }" 2>/dev/null
+=09=09=09! ${NFT} delete element inet filter test \
+=09=09=09=09"{ ${a3} . ${b3} . ${c3} }" 2>/dev/null
+=09=09done
+=09done
+done
--=20
2.20.1

