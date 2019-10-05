Return-Path: <SRS0=nJ2K=X6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B31ECE58E
	for <netfilter-devel@archiver.kernel.org>; Sat,  5 Oct 2019 14:38:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F88F222D0
	for <netfilter-devel@archiver.kernel.org>; Sat,  5 Oct 2019 14:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbfJEOiY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 5 Oct 2019 10:38:24 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:2985 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfJEOiX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 5 Oct 2019 10:38:23 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.17]) by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee55d98aacc4f9-c334c; Sat, 05 Oct 2019 22:38:04 +0800 (CST)
X-RM-TRANSID: 2ee55d98aacc4f9-c334c
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee95d98aacb09d-fd9c6;
        Sat, 05 Oct 2019 22:38:04 +0800 (CST)
X-RM-TRANSID: 2ee95d98aacb09d-fd9c6
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     Shuah Khan <shuah@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms@verge.net.au>
Cc:     Julian Anastasov <ja@ssi.bg>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH v4 2/3] selftests: netfilter: add ipvs nat test case
Date:   Sat,  5 Oct 2019 22:37:44 +0800
Message-Id: <1570286265-15855-3-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570286265-15855-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
References: <1570286265-15855-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Test virtual server via NAT.

Tested:
# selftests: netfilter: ipvs.sh
# Testing DR mode...
# Testing NAT mode...
# ipvs.sh: PASS

Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
---
 tools/testing/selftests/netfilter/ipvs.sh | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/ipvs.sh b/tools/testing/selftests/netfilter/ipvs.sh
index f6da1bd..2601a7c 100755
--- a/tools/testing/selftests/netfilter/ipvs.sh
+++ b/tools/testing/selftests/netfilter/ipvs.sh
@@ -160,20 +160,40 @@ test_dr() {
     test_service
 }
 
+test_nat() {
+    ip netns exec ns0 ip route add ${vip_v4} via ${gip_v4} dev br0
+
+    ip netns exec ns1 sysctl -qw net.ipv4.ip_forward=1
+    ip netns exec ns1 ipvsadm -A -t ${vip_v4}:${port} -s rr
+    ip netns exec ns1 ipvsadm -a -m -t ${vip_v4}:${port} -r ${rip_v4}:${port}
+    ip netns exec ns1 ip addr add ${vip_v4}/32 dev lo:1
+
+    ip netns exec ns2 ip link del veth20
+    ip netns exec ns2 ip route add default via ${dip_v4} dev veth21
+
+    test_service
+}
+
 run_tests() {
 	local errors=
 
 	echo "Testing DR mode..."
+	cleanup
 	setup
 	test_dr
 	errors=$(( $errors + $? ))
 
+	echo "Testing NAT mode..."
+	cleanup
+	setup
+	test_nat
+	errors=$(( $errors + $? ))
+
 	return $errors
 }
 
 trap cleanup EXIT
 
-cleanup
 run_tests
 
 if [ $? -ne 0 ]; then
-- 
1.8.3.1



