Return-Path: <SRS0=uHYT=BB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73CB0C433E6
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jul 2020 11:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BC5E206F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jul 2020 11:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732089AbgGVLvk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jul 2020 07:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgGVLvj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 07:51:39 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C73C0619DC
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jul 2020 04:51:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jyDHe-0008Qq-Ah; Wed, 22 Jul 2020 13:51:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     sbrivio@redhat.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] tests: extend 0043concatenated_ranges_0 to cover maps too
Date:   Wed, 22 Jul 2020 13:51:26 +0200
Message-Id: <20200722115126.12596-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200722115126.12596-1-fw@strlen.de>
References: <20200722115126.12596-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/sets/0043concatenated_ranges_0  | 78 ++++++++++++-------
 1 file changed, 50 insertions(+), 28 deletions(-)

diff --git a/tests/shell/testcases/sets/0043concatenated_ranges_0 b/tests/shell/testcases/sets/0043concatenated_ranges_0
index a783dacc361c..bb13bdada610 100755
--- a/tests/shell/testcases/sets/0043concatenated_ranges_0
+++ b/tests/shell/testcases/sets/0043concatenated_ranges_0
@@ -63,27 +63,31 @@ cat <<'EOF' > "${tmp}"
 flush ruleset
 
 table inet filter {
-	set test {
-		type ${ta} . ${tb} . ${tc}
+	${setmap} test {
+		type ${ta} . ${tb} . ${tc} ${mapt}
 		flags interval,timeout
-		elements = { ${a1} . ${b1} . ${c1} ,
-			     ${a2} . ${b2} . ${c2} ,
-			     ${a3} . ${b3} . ${c3} }
+		elements = { ${a1} . ${b1} . ${c1} ${mapv},
+			     ${a2} . ${b2} . ${c2} ${mapv},
+			     ${a3} . ${b3} . ${c3} ${mapv}, }
 	}
 
 	chain output {
 		type filter hook output priority 0; policy accept;
-		${sa} . ${sb} . ${sc} @test counter
+		${rule} @test counter
 	}
 }
 EOF
 
 timeout_tested=0
+run_test()
+{
+setmap="$1"
 for ta in ${TYPES}; do
 	eval a=\$ELEMS_${ta}
 	a1=${a%% *}; a2=$(expr "$a" : ".* \(.*\) .*"); a3=${a##* }
 	eval sa=\$RULESPEC_${ta}
 
+	mark=0
 	for tb in ${TYPES}; do
 		[ "${tb}" = "${ta}" ] && continue
 		if [ "${tb}" = "ipv6_addr" ]; then
@@ -107,40 +111,54 @@ for ta in ${TYPES}; do
 				[ "${tb}" = "ipv6_addr" ] && continue
 			fi
 
-			echo "TYPE: ${ta} ${tb} ${tc}"
+			echo "$setmap TYPE: ${ta} ${tb} ${tc}"
 
 			eval c=\$ELEMS_${tc}
 			c1=${c%% *}; c2=$(expr "$c" : ".* \(.*\) .*"); c3=${c##* }
 			eval sc=\$RULESPEC_${tc}
 
+			case "${setmap}" in
+			"set")
+				mapt=""
+				mapv=""
+				rule="${sa} . ${sb} . ${sc}"
+			;;
+			"map")
+				mapt=": mark"
+				mark=$RANDOM
+				mapv=$(printf " : 0x%08x" ${mark})
+				rule="meta mark set ${sa} . ${sb} . ${sc} map"
+			;;
+			esac
+
 			render ${tmp} | ${NFT} -f -
 
-			[ $(${NFT} list set inet filter test |		\
-			   grep -c -e "${a1} . ${b1} . ${c1}"		\
-				   -e "${a2} . ${b2} . ${c2}"		\
-				   -e "${a3} . ${b3} . ${c3}") -eq 3 ]
+			[ $(${NFT} list ${setmap} inet filter test |		\
+			   grep -c -e "${a1} . ${b1} . ${c1}${mapv}"		\
+				   -e "${a2} . ${b2} . ${c2}${mapv}"		\
+				   -e "${a3} . ${b3} . ${c3}${mapv}") -eq 3 ]
 
 			! ${NFT} "add element inet filter test \
-				  { ${a1} . ${b1} . ${c1} };
+				  { ${a1} . ${b1} . ${c1}${mapv} };
 				  add element inet filter test \
-				  { ${a2} . ${b2} . ${c2} };
+				  { ${a2} . ${b2} . ${c2}${mapv} };
 				  add element inet filter test \
-				  { ${a3} . ${b3} . ${c3} }" 2>/dev/null
+				  { ${a3} . ${b3} . ${c3}${mapv} }" 2>/dev/null
 
 			${NFT} delete element inet filter test \
-				"{ ${a1} . ${b1} . ${c1} }"
+				"{ ${a1} . ${b1} . ${c1}${mapv} }"
 			! ${NFT} delete element inet filter test \
-				"{ ${a1} . ${b1} . ${c1} }" 2>/dev/null
+				"{ ${a1} . ${b1} . ${c1}${mapv} }" 2>/dev/null
 
 			eval add_a=\$ADD_${ta}
 			eval add_b=\$ADD_${tb}
 			eval add_c=\$ADD_${tc}
 			${NFT} add element inet filter test \
-				"{ ${add_a} . ${add_b} . ${add_c} timeout 1s}"
-			[ $(${NFT} list set inet filter test |		\
+				"{ ${add_a} . ${add_b} . ${add_c} timeout 1s${mapv}}"
+			[ $(${NFT} list ${setmap} inet filter test |	\
 			   grep -c "${add_a} . ${add_b} . ${add_c}") -eq 1 ]
 			! ${NFT} add element inet filter test \
-				"{ ${add_a} . ${add_b} . ${add_c} timeout 1s}" \
+				"{ ${add_a} . ${add_b} . ${add_c} timeout 1s${mapv}}" \
 				2>/dev/null
 
 			eval get_a=\$GET_${ta}
@@ -150,31 +168,35 @@ for ta in ${TYPES}; do
 			exp_b=${get_b##* }; get_b=${get_b%% *}
 			exp_c=${get_c##* }; get_c=${get_c%% *}
 			[ $(${NFT} get element inet filter test 	\
-			   "{ ${get_a} . ${get_b} . ${get_c} }" |	\
+			   "{ ${get_a} . ${get_b} . ${get_c}${mapv} }" |	\
 			   grep -c "${exp_a} . ${exp_b} . ${exp_c}") -eq 1 ]
 
 			${NFT} "delete element inet filter test \
-				{ ${a2} . ${b2} . ${c2} };
+				{ ${a2} . ${b2} . ${c2}${mapv} };
 				delete element inet filter test \
-				{ ${a3} . ${b3} . ${c3} }"
+				{ ${a3} . ${b3} . ${c3}${mapv} }"
 			! ${NFT} "delete element inet filter test \
-				  { ${a2} . ${b2} . ${c2} };
+				  { ${a2} . ${b2} . ${c2}${mapv} };
 				  delete element inet filter test \
-				  { ${a3} . ${b3} . ${c3} }" 2>/dev/null
+				  { ${a3} . ${b3} . ${c3} ${mapv} }" 2>/dev/null
 
 			if [ ${timeout_tested} -eq 1 ]; then
 				${NFT} delete element inet filter test \
-					"{ ${add_a} . ${add_b} . ${add_c} }"
+					"{ ${add_a} . ${add_b} . ${add_c} ${mapv} }"
 				! ${NFT} delete element inet filter test \
-					"{ ${add_a} . ${add_b} . ${add_c} }" \
+					"{ ${add_a} . ${add_b} . ${add_c} ${mapv} }" \
 					2>/dev/null
 				continue
 			fi
 
 			sleep 1
-			[ $(${NFT} list set inet filter test |		\
-			   grep -c "${add_a} . ${add_b} . ${add_c}") -eq 0 ]
+			[ $(${NFT} list ${setmap} inet filter test |		\
+			   grep -c "${add_a} . ${add_b} . ${add_c} ${mapv}") -eq 0 ]
 			timeout_tested=1
 		done
 	done
 done
+}
+
+run_test "set"
+run_test "map"
-- 
2.26.2

