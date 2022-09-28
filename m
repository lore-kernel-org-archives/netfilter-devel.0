Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF07FC32771
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Sep 2022 18:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiI1S1E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 14:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbiI1S1C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 14:27:02 -0400
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A640F1845
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Sep 2022 11:26:58 -0700 (PDT)
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SFeWP3024932;
        Wed, 28 Sep 2022 19:26:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=n4xjRffZydzajZgDrDDDoTaZ4WZyCpV1n1okKvo4a5M=;
 b=mwTTuQAXIdEkfLZ1jl5ZeD9lzBq+3xa/reWDV1SR0HzPE/EKxXcobMFFO9802Esq/O29
 trf8nZfK3Ym/dWTmifJGVIKI1Z4uGj9vvGk5jleo22WjFE2ZbOOGj7+2CysyveqQev/n
 IcefCdLhngF2C32fYrYHEjINLWpVUuOOleRZLHRlcEfanha9kN0HeeW2R/zrjcd2CNT1
 JEKdtRyQFS/eBn6WrbS6SJyY5s/l3+CcpHiB+Gezp4SCVVcTiKvpORx0HEz0ZV3ImtHa
 +Qd0vsF0kBDH6A4YTmo2aPKL24fTkoYKYJXC2Eg+vLjhqpLM7iuWYIJnSzJknVjy2OhH Iw== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0a-00190b01.pphosted.com (PPS) with ESMTPS id 3jvpb219xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 19:26:50 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 28SFnZ3Q002079;
        Wed, 28 Sep 2022 14:26:49 -0400
Received: from email.msg.corp.akamai.com ([172.27.91.21])
        by prod-mail-ppoint6.akamai.com (PPS) with ESMTPS id 3juckuy8dt-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 14:26:49 -0400
Received: from usma1ex-dag4mb8.msg.corp.akamai.com (172.27.91.27) by
 usma1ex-dag4mb3.msg.corp.akamai.com (172.27.91.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.12; Wed, 28 Sep 2022 14:26:25 -0400
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb8.msg.corp.akamai.com (172.27.91.27) with Microsoft SMTP Server
 id 15.2.1118.12 via Frontend Transport; Wed, 28 Sep 2022 14:26:25 -0400
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id D41C715FA1F; Wed, 28 Sep 2022 14:26:25 -0400 (EDT)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH v2 6/6] netfilter: ipset: add tests for the new bitmask feature
Date:   Wed, 28 Sep 2022 14:25:36 -0400
Message-ID: <20220928182536.602688-7-vpai@akamai.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220928182536.602688-1-vpai@akamai.com>
References: <20220928182536.602688-1-vpai@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_07,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 mlxlogscore=705 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209280108
X-Proofpoint-ORIG-GUID: 00kqJ9LJy7dNHQEqalPBF9aL-jRRWFQv
X-Proofpoint-GUID: 00kqJ9LJy7dNHQEqalPBF9aL-jRRWFQv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_07,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 impostorscore=0 mlxlogscore=706 mlxscore=0 malwarescore=0 clxscore=1015
 spamscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209280109
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The hash:ip type had a test for netmask, add a similar test for bitmask
feature as well, and add another test where bitmask is not a valid
netmask.

Repeat the same three tests for hash:ip,port and hash:net,net, but the
net,net type only has the bitmask feature and not netmask.

Signed-off-by: Vishwanath Pai <vpai@akamai.com>
---
 tests/hash:ip,port.t       | 118 +++++++++++++++++++++++++++++++++++++
 tests/hash:ip,port.t.list3 |  11 ++++
 tests/hash:ip,port.t.list4 |   9 +++
 tests/hash:ip,port.t.list5 |  11 ++++
 tests/hash:ip,port.t.list6 |   9 +++
 tests/hash:ip,port.t.list7 |   9 +++
 tests/hash:ip.t            |  74 ++++++++++++++++++++++-
 tests/hash:ip.t.list4      |  11 ++++
 tests/hash:ip.t.list5      |   9 +++
 tests/hash:ip.t.list6      |   9 +++
 tests/hash:net,net.t       |  66 +++++++++++++++++++++
 tests/hash:net,net.t.list3 |  11 ++++
 tests/hash:net,net.t.list4 |   9 +++
 tests/hash:net,net.t.list5 |   9 +++
 14 files changed, 364 insertions(+), 1 deletion(-)
 create mode 100644 tests/hash:ip,port.t.list3
 create mode 100644 tests/hash:ip,port.t.list4
 create mode 100644 tests/hash:ip,port.t.list5
 create mode 100644 tests/hash:ip,port.t.list6
 create mode 100644 tests/hash:ip,port.t.list7
 create mode 100644 tests/hash:ip.t.list4
 create mode 100644 tests/hash:ip.t.list5
 create mode 100644 tests/hash:ip.t.list6
 create mode 100644 tests/hash:net,net.t.list3
 create mode 100644 tests/hash:net,net.t.list4
 create mode 100644 tests/hash:net,net.t.list5

diff --git a/tests/hash:ip,port.t b/tests/hash:ip,port.t
index 7a0e821..addbe3b 100644
--- a/tests/hash:ip,port.t
+++ b/tests/hash:ip,port.t
@@ -170,4 +170,122 @@
 0 ./check_extensions test 2.0.0.20 700 13 12479
 # Counters and timeout: destroy set
 0 ipset x test
+# Network: Create a set with timeout and netmask
+0 ipset -N test hash:ip,port --hashsize 128 --netmask 24 timeout 4
+# Network: Add zero valued element
+1 ipset -A test 0.0.0.0,80
+# Network: Test zero valued element
+1 ipset -T test 0.0.0.0,80
+# Network: Delete zero valued element
+1 ipset -D test 0.0.0.0,80
+# Network: Add first random network
+0 ipset -A test 2.0.0.1,8080
+# Network: Add second random network
+0 ipset -A test 192.168.68.69,22
+# Network: Test first random value
+0 ipset -T test 2.0.0.255,8080
+# Network: Test second random value
+0 ipset -T test 192.168.68.95,22
+# Network: Test value not added to the set
+1 ipset -T test 2.0.1.0,8080
+# Network: Add third element
+0 ipset -A test 200.100.10.1,22 timeout 0
+# Network: Add third random network
+0 ipset -A test 200.100.0.12,22
+# Network: Delete the same network
+0 ipset -D test 200.100.0.12,22
+# Network: List set
+0 ipset -L test > .foo0 && ./sort.sh .foo0
+# Network: Check listing
+0 ./diff.sh .foo hash:ip,port.t.list3
+# Sleep 5s so that elements can time out
+0 sleep 5
+# Network: List set
+0 ipset -L test > .foo
+# Network: Check listing
+0 ./diff.sh .foo hash:ip,port.t.list4
+# Network: Flush test set
+0 ipset -F test
+# Network: add element with 1s timeout
+0 ipset add test 200.100.0.12,80 timeout 1
+# Network: readd element with 3s timeout
+0 ipset add test 200.100.0.12,80 timeout 3 -exist
+# Network: sleep 2s
+0 sleep 2s
+# Network: check readded element
+0 ipset test test 200.100.0.12,80
+# Network: Delete test set
+0 ipset -X test
+# Network: Create a set with timeout and bitmask
+0 ipset -N test hash:ip,port --hashsize 128 --bitmask 255.255.255.0 timeout 4
+# Network: Add zero valued element
+1 ipset -A test 0.0.0.0,80
+# Network: Test zero valued element
+1 ipset -T test 0.0.0.0,80
+# Network: Delete zero valued element
+1 ipset -D test 0.0.0.0,80
+# Network: Add first random network
+0 ipset -A test 2.0.0.1,8080
+# Network: Add second random network
+0 ipset -A test 192.168.68.69,22
+# Network: Test first random value
+0 ipset -T test 2.0.0.255,8080
+# Network: Test second random value
+0 ipset -T test 192.168.68.95,22
+# Network: Test value not added to the set
+1 ipset -T test 2.0.1.0,8080
+# Network: Add third element
+0 ipset -A test 200.100.10.1,22 timeout 0
+# Network: Add third random network
+0 ipset -A test 200.100.0.12,22
+# Network: Delete the same network
+0 ipset -D test 200.100.0.12,22
+# Network: List set
+0 ipset -L test > .foo0 && ./sort.sh .foo0
+# Network: Check listing
+0 ./diff.sh .foo hash:ip,port.t.list5
+# Sleep 5s so that elements can time out
+0 sleep 5
+# Network: List set
+0 ipset -L test > .foo
+# Network: Check listing
+0 ./diff.sh .foo hash:ip,port.t.list6
+# Network: Flush test set
+0 ipset -F test
+# Network: add element with 1s timeout
+0 ipset add test 200.100.0.12,80 timeout 1
+# Network: readd element with 3s timeout
+0 ipset add test 200.100.0.12,80 timeout 3 -exist
+# Network: sleep 2s
+0 sleep 2s
+# Network: check readded element
+0 ipset test test 200.100.0.12,80
+# Network: Delete test set
+0 ipset -X test
+# Network: Create a set with bitmask which is not a valid netmask
+0 ipset -N test hash:ip,port --hashsize 128 --bitmask 255.255.0.255
+# Network: Add zero valued element
+1 ipset -A test 0.0.0.0
+# Network: Test zero valued element
+1 ipset -T test 0.0.0.0
+# Network: Delete zero valued element
+1 ipset -D test 0.0.0.0
+# Network: Add first random network
+0 ipset -A test 1.2.3.4,22
+# Network: Add second random network
+0 ipset -A test 1.168.122.124,22
+# Network: Test first random value
+0 ipset -T test 1.2.9.4,22
+# Network: Test second random value
+0 ipset -T test 1.168.68.124,22
+# Network: Test value not added to the set
+1 ipset -T test 2.0.1.0,23
+# Network: Test delete value
+0 ipset -D test 1.168.0.124,22
+# Network: List set
+0 ipset -L test > .foo
+# Network: Check listing
+0 ./diff.sh .foo hash:ip,port.t.list7
+# Network: Delete test set
+0 ipset -X test
 # eof
diff --git a/tests/hash:ip,port.t.list3 b/tests/hash:ip,port.t.list3
new file mode 100644
index 0000000..b2cdc28
--- /dev/null
+++ b/tests/hash:ip,port.t.list3
@@ -0,0 +1,11 @@
+Name: test
+Type: hash:ip,port
+Revision: 7
+Header: family inet hashsize 128 maxelem 65536 timeout 4 bucketsize 12 initval 0xf49ba001 netmask 24
+Size in memory: 408
+References: 0
+Number of entries: 3
+Members:
+192.168.68.0,tcp:22 timeout 3
+2.0.0.0,tcp:8080 timeout 3
+200.100.10.0,tcp:22 timeout 0
diff --git a/tests/hash:ip,port.t.list4 b/tests/hash:ip,port.t.list4
new file mode 100644
index 0000000..c28987a
--- /dev/null
+++ b/tests/hash:ip,port.t.list4
@@ -0,0 +1,9 @@
+Name: test
+Type: hash:ip,port
+Revision: 7
+Header: family inet hashsize 128 maxelem 65536 timeout 4 bucketsize 12 initval 0x18b2277a netmask 24
+Size in memory: 408
+References: 0
+Number of entries: 1
+Members:
+200.100.10.0,tcp:22 timeout 0
diff --git a/tests/hash:ip,port.t.list5 b/tests/hash:ip,port.t.list5
new file mode 100644
index 0000000..b5fa817
--- /dev/null
+++ b/tests/hash:ip,port.t.list5
@@ -0,0 +1,11 @@
+Name: test
+Type: hash:ip,port
+Revision: 7
+Header: family inet hashsize 128 maxelem 65536 timeout 4 bucketsize 12 initval 0x6a0e903a bitmask 255.255.255.0
+Size in memory: 408
+References: 0
+Number of entries: 3
+Members:
+192.168.68.0,tcp:22 timeout 3
+2.0.0.0,tcp:8080 timeout 3
+200.100.10.0,tcp:22 timeout 0
diff --git a/tests/hash:ip,port.t.list6 b/tests/hash:ip,port.t.list6
new file mode 100644
index 0000000..33969cf
--- /dev/null
+++ b/tests/hash:ip,port.t.list6
@@ -0,0 +1,9 @@
+Name: test
+Type: hash:ip,port
+Revision: 7
+Header: family inet hashsize 128 maxelem 65536 timeout 4 bucketsize 12 initval 0x2fcffdca bitmask 255.255.255.0
+Size in memory: 408
+References: 0
+Number of entries: 1
+Members:
+200.100.10.0,tcp:22 timeout 0
diff --git a/tests/hash:ip,port.t.list7 b/tests/hash:ip,port.t.list7
new file mode 100644
index 0000000..f223657
--- /dev/null
+++ b/tests/hash:ip,port.t.list7
@@ -0,0 +1,9 @@
+Name: test
+Type: hash:ip,port
+Revision: 7
+Header: family inet hashsize 128 maxelem 65536 bucketsize 12 initval 0x98bdfa72 bitmask 255.255.0.255
+Size in memory: 312
+References: 0
+Number of entries: 1
+Members:
+1.2.0.4,tcp:22
diff --git a/tests/hash:ip.t b/tests/hash:ip.t
index 3239701..1b5bfcb 100644
--- a/tests/hash:ip.t
+++ b/tests/hash:ip.t
@@ -72,7 +72,7 @@
 0 n=`ipset list test|grep '^10.0'|wc -l` && test $n -eq 1024
 # IP: Destroy sets
 0 ipset -X
-# Network: Create a set with timeout
+# Network: Create a set with timeout and netmask
 0 ipset -N test iphash --hashsize 128 --netmask 24 timeout 4
 # Network: Add zero valued element
 1 ipset -A test 0.0.0.0
@@ -210,4 +210,76 @@ skip which sendip
 0 ./check_extensions test 10.255.255.64 600 6 $((6*40))
 # Counters and timeout: destroy set
 0 ipset x test
+# Network: Create a set with timeout and bitmask
+0 ipset -N test iphash --hashsize 128 --bitmask 255.255.255.0 timeout 4
+# Network: Add zero valued element
+1 ipset -A test 0.0.0.0
+# Network: Test zero valued element
+1 ipset -T test 0.0.0.0
+# Network: Delete zero valued element
+1 ipset -D test 0.0.0.0
+# Network: Add first random network
+0 ipset -A test 2.0.0.1
+# Network: Add second random network
+0 ipset -A test 192.168.68.69
+# Network: Test first random value
+0 ipset -T test 2.0.0.255
+# Network: Test second random value
+0 ipset -T test 192.168.68.95
+# Network: Test value not added to the set
+1 ipset -T test 2.0.1.0
+# Network: Add third element
+0 ipset -A test 200.100.10.1 timeout 0
+# Network: Add third random network
+0 ipset -A test 200.100.0.12
+# Network: Delete the same network
+0 ipset -D test 200.100.0.12
+# Network: List set
+0 ipset -L test > .foo0 && ./sort.sh .foo0
+# Network: Check listing
+0 ./diff.sh .foo hash:ip.t.list4
+# Sleep 5s so that elements can time out
+0 sleep 5
+# Network: List set
+0 ipset -L test > .foo
+# Network: Check listing
+0 ./diff.sh .foo hash:ip.t.list5
+# Network: Flush test set
+0 ipset -F test
+# Network: add element with 1s timeout
+0 ipset add test 200.100.0.12 timeout 1
+# Network: readd element with 3s timeout
+0 ipset add test 200.100.0.12 timeout 3 -exist
+# Network: sleep 2s
+0 sleep 2s
+# Network: check readded element
+0 ipset test test 200.100.0.12
+# Network: Delete test set
+0 ipset -X test
+# Network: Create a set with bitmask which is not a valid netmask
+0 ipset -N test iphash --hashsize 128 --bitmask 255.255.0.255
+# Network: Add zero valued element
+1 ipset -A test 0.0.0.0
+# Network: Test zero valued element
+1 ipset -T test 0.0.0.0
+# Network: Delete zero valued element
+1 ipset -D test 0.0.0.0
+# Network: Add first random network
+0 ipset -A test 1.2.3.4
+# Network: Add second random network
+0 ipset -A test 1.2.4.5
+# Network: Test first random value
+0 ipset -T test 1.2.9.4
+# Network: Test second random value
+0 ipset -T test 1.2.9.5
+# Network: Test value not added to the set
+1 ipset -T test 2.0.1.0
+# Network: Test delete value
+0 ipset -D test 1.2.0.5
+# Network: List set
+0 ipset -L test > .foo
+# Network: Check listing
+0 ./diff.sh .foo hash:ip.t.list6
+# Network: Delete test set
+0 ipset -X test
 # eof
diff --git a/tests/hash:ip.t.list4 b/tests/hash:ip.t.list4
new file mode 100644
index 0000000..5f92afa
--- /dev/null
+++ b/tests/hash:ip.t.list4
@@ -0,0 +1,11 @@
+Name: test
+Type: hash:ip
+Revision: 5
+Header: family inet hashsize 128 maxelem 65536 bitmask 255.255.255.0 timeout 4 bucketsize 12 initval 0xfe970e91
+Size in memory: 528
+References: 0
+Number of entries: 3
+Members:
+192.168.68.0 timeout 3
+2.0.0.0 timeout 3
+200.100.10.0 timeout 0
diff --git a/tests/hash:ip.t.list5 b/tests/hash:ip.t.list5
new file mode 100644
index 0000000..9a29e75
--- /dev/null
+++ b/tests/hash:ip.t.list5
@@ -0,0 +1,9 @@
+Name: test
+Type: hash:ip
+Revision: 5
+Header: family inet hashsize 128 maxelem 65536 bitmask 255.255.255.0 timeout 4 bucketsize 12 initval 0xbc66e38a
+Size in memory: 528
+References: 0
+Number of entries: 1
+Members:
+200.100.10.0 timeout 0
diff --git a/tests/hash:ip.t.list6 b/tests/hash:ip.t.list6
new file mode 100644
index 0000000..44c5a49
--- /dev/null
+++ b/tests/hash:ip.t.list6
@@ -0,0 +1,9 @@
+Name: test
+Type: hash:ip
+Revision: 6
+Header: family inet hashsize 128 maxelem 65536 bitmask 255.255.0.255 bucketsize 12 initval 0xd7d821e1
+Size in memory: 296
+References: 0
+Number of entries: 1
+Members:
+1.2.0.4
diff --git a/tests/hash:net,net.t b/tests/hash:net,net.t
index feb13d9..8886c34 100644
--- a/tests/hash:net,net.t
+++ b/tests/hash:net,net.t
@@ -166,4 +166,70 @@
 0 ./check_extensions test 2.0.0.0/25,2.0.0.0/25 700 13 12479
 # Counters and timeout: destroy set
 0 ipset x test
+# Network: Create a set with timeout and bitmask
+0 ipset -N test hash:net,net --hashsize 128 --bitmask 255.255.255.0 timeout 4
+# Network: Add first random network
+0 ipset -A test 2.0.10.1,2.10.10.254
+# Network: Add second random network
+0 ipset -A test 192.168.68.1,192.168.68.254
+# Network: Test first random value
+0 ipset -T test 2.0.10.11,2.10.10.25
+# Network: Test second random value
+0 ipset -T test 192.168.68.11,192.168.68.5
+# Network: Test value not added to the set
+1 ipset -T test 2.10.1.0,21.0.1.0
+# Network: Add third element
+0 ipset -A test 200.100.10.1,200.100.10.100 timeout 0
+# Network: Add third random network
+0 ipset -A test 200.100.0.12,200.100.0.13
+# Network: Delete the same network
+0 ipset -D test 200.100.0.12,200.100.0.13
+# Network: List set
+0 ipset -L test > .foo0 && ./sort.sh .foo0
+# Network: Check listing
+0 ./diff.sh .foo hash:net,net.t.list3
+# Sleep 5s so that elements can time out
+0 sleep 5
+# Network: List set
+0 ipset -L test > .foo
+# Network: Check listing
+0 ./diff.sh .foo hash:net,net.t.list4
+# Network: Flush test set
+0 ipset -F test
+# Network: add element with 1s timeout
+0 ipset add test 200.100.0.12,80 timeout 1
+# Network: readd element with 3s timeout
+0 ipset add test 200.100.0.12,80 timeout 3 -exist
+# Network: sleep 2s
+0 sleep 2s
+# Network: check readded element
+0 ipset test test 200.100.0.12,80
+# Network: Delete test set
+0 ipset -X test
+# Network: Create a set with bitmask which is not a valid netmask
+0 ipset -N test hash:net,net --hashsize 128 --bitmask 255.255.0.255
+# Network: Add zero valued element
+1 ipset -A test 0.0.0.0
+# Network: Test zero valued element
+1 ipset -T test 0.0.0.0
+# Network: Delete zero valued element
+1 ipset -D test 0.0.0.0
+# Network: Add first random network
+0 ipset -A test 1.2.3.4,22.23.24.25
+# Network: Add second random network
+0 ipset -A test 1.168.122.124,122.23.45.50
+# Network: Test first random value
+0 ipset -T test 1.2.43.4,22.23.2.25
+# Network: Test second random value
+0 ipset -T test 1.168.12.124,122.23.4.50
+# Network: Test value not added to the set
+1 ipset -T test 2.168.122.124,22.23.45.50
+# Network: Test delete value
+0 ipset -D test 1.168.12.124,122.23.0.50
+# Network: List set
+0 ipset -L test > .foo
+# Network: Check listing
+0 ./diff.sh .foo hash:net,net.t.list5
+# Network: Delete test set
+0 ipset -X test
 # eof
diff --git a/tests/hash:net,net.t.list3 b/tests/hash:net,net.t.list3
new file mode 100644
index 0000000..0ff37fb
--- /dev/null
+++ b/tests/hash:net,net.t.list3
@@ -0,0 +1,11 @@
+Name: test
+Type: hash:net,net
+Revision: 4
+Header: family inet hashsize 128 maxelem 65536 timeout 4 bucketsize 12 initval 0xe17e4732 bitmask 255.255.255.0
+Size in memory: 848
+References: 0
+Number of entries: 3
+Members:
+192.168.68.0,192.168.68.0 timeout 3
+2.0.10.0,2.10.10.0 timeout 3
+200.100.10.0,200.100.10.0 timeout 0
diff --git a/tests/hash:net,net.t.list4 b/tests/hash:net,net.t.list4
new file mode 100644
index 0000000..84beb5b
--- /dev/null
+++ b/tests/hash:net,net.t.list4
@@ -0,0 +1,9 @@
+Name: test
+Type: hash:net,net
+Revision: 4
+Header: family inet hashsize 128 maxelem 65536 timeout 4 bucketsize 12 initval 0xb69e293e bitmask 255.255.255.0
+Size in memory: 848
+References: 0
+Number of entries: 1
+Members:
+200.100.10.0,200.100.10.0 timeout 0
diff --git a/tests/hash:net,net.t.list5 b/tests/hash:net,net.t.list5
new file mode 100644
index 0000000..6601795
--- /dev/null
+++ b/tests/hash:net,net.t.list5
@@ -0,0 +1,9 @@
+Name: test
+Type: hash:net,net
+Revision: 4
+Header: family inet hashsize 128 maxelem 65536 bucketsize 12 initval 0x6223fef7 bitmask 255.255.0.255
+Size in memory: 736
+References: 0
+Number of entries: 1
+Members:
+1.2.0.4,22.23.0.25
-- 
2.25.1

