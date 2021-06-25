Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42363C2B9F4
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Jun 2021 20:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E65961965
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Jun 2021 20:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhFYUdQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Jun 2021 16:33:16 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53000 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhFYUdO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Jun 2021 16:33:14 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5388E6164D;
        Fri, 25 Jun 2021 22:30:51 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     kadlec@netfilter.org
Subject: [PATCH ipset,v4 4/4] tests: add tests ipset to nftables
Date:   Fri, 25 Jun 2021 22:30:43 +0200
Message-Id: <20210625203043.17265-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210625203043.17265-1-pablo@netfilter.org>
References: <20210625203043.17265-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This test checks that the translation from ipset to nftables is correct.

term$ cd tests/xlate
term$ ./runtest.sh

in case that the translation is not correct, it shows the diff with expected
translation output.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: new patch in this series :-)

 tests/xlate/runtest.sh  | 29 +++++++++++++++++++++
 tests/xlate/xlate.t     | 55 ++++++++++++++++++++++++++++++++++++++++
 tests/xlate/xlate.t.nft | 56 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 140 insertions(+)
 create mode 100755 tests/xlate/runtest.sh
 create mode 100644 tests/xlate/xlate.t
 create mode 100644 tests/xlate/xlate.t.nft

diff --git a/tests/xlate/runtest.sh b/tests/xlate/runtest.sh
new file mode 100755
index 000000000000..a2a02c05d757
--- /dev/null
+++ b/tests/xlate/runtest.sh
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+DIFF=$(which diff)
+if [ ! -x "$DIFF" ] ; then
+	echo "ERROR: missing diff"
+	exit 1
+fi
+
+IPSET_XLATE=$(which ipset-translate)
+if [ ! -x "$IPSET_XLATE" ] ; then
+	echo "ERROR: ipset-translate is not installed yet"
+	exit 1
+fi
+
+TMP=$(mktemp)
+ipset-translate restore < xlate.t &> $TMP
+if [ $? -ne 0 ]
+then
+	cat $TMP
+	echo -e "[\033[0;31mERROR\033[0m] failed to run ipset-translate"
+	exit 1
+fi
+${DIFF} -u xlate.t.nft $TMP
+if [ $? -eq 0 ]
+then
+	echo -e "[\033[0;32mOK\033[0m] tests are fine!"
+else
+	echo -e "[\033[0;31mERROR\033[0m] unexpected ipset to nftables translation"
+fi
diff --git a/tests/xlate/xlate.t b/tests/xlate/xlate.t
new file mode 100644
index 000000000000..b1e7d288e2a9
--- /dev/null
+++ b/tests/xlate/xlate.t
@@ -0,0 +1,55 @@
+create hip1 hash:ip
+add hip1 192.168.10.2
+add hip1 192.168.10.3
+create hip2 hash:ip hashsize 128 bucketsize 255 timeout 4
+add hip2 192.168.10.3
+add hip2 192.168.10.4 timeout 10
+create hip3 hash:ip counters
+add hip3 192.168.10.3 packets 5 bytes 3456
+create hip4 hash:ip netmask 24
+add hip4 192.168.10.0
+create hip5 hash:ip maxelem 24
+add hip5 192.168.10.0
+create hip6 hash:ip comment
+add hip5 192.168.10.1
+add hip5 192.168.10.2 comment "this is a comment"
+create ipp1 hash:ip,port
+add ipp1 192.168.10.1,0
+add ipp1 192.168.10.2,5
+create ipp2 hash:ip,port timeout 4
+add ipp2 192.168.10.1,0 timeout 12
+add ipp2 192.168.10.2,5
+create ipp3 hash:ip,port counters
+add ipp3 192.168.10.3,20 packets 5 bytes 3456
+create ipp4 hash:ip,port timeout 4 counters
+add ipp4 192.168.10.3,20 packets 5 bytes 3456
+create bip1 bitmap:ip range 2.0.0.1-2.1.0.1 timeout 5
+create bip2 bitmap:ip range 10.0.0.0/8 netmask 24 timeout 5
+add bip2 10.10.10.0
+add bip2 10.10.20.0 timeout 12
+create net1 hash:net
+add net1 192.168.10.0/24
+create net2 hash:net,net
+add net2 192.168.10.0/24,192.168.20.0/24
+create hm1 hash:mac
+add hm1 aa:bb:cc:dd:ee:ff
+create him1 hash:ip,mac
+add him1 1.1.1.1,aa:bb:cc:dd:ee:ff
+create ni1 hash:net,iface
+add ni1 1.1.1.0/24,eth0
+create nip1 hash:net,port
+add nip1 1.1.1.0/24,22
+create npn1 hash:net,port,net
+add npn1 1.1.1.0/24,22,2.2.2.0/24
+create nn1 hash:net,net
+add nn1 1.1.1.0/24,2.2.2.0/24
+create ipn1 hash:ip,port,net
+add ipn1 1.1.1.1,22,2.2.2.0/24
+create ipi1 hash:ip,port,ip
+add ipi1 1.1.1.1,22,2.2.2.2
+create im1 hash:ip,mark
+add im1 1.1.1.1,0x123456
+create bp1 bitmap:port range 1-1024
+add bp1 22
+create bim1 bitmap:ip,mac range 1.1.1.0/24
+add bim1 1.1.1.1,aa:bb:cc:dd:ee:ff
diff --git a/tests/xlate/xlate.t.nft b/tests/xlate/xlate.t.nft
new file mode 100644
index 000000000000..96eba3b0175e
--- /dev/null
+++ b/tests/xlate/xlate.t.nft
@@ -0,0 +1,56 @@
+add table inet global
+add set inet global hip1 { type ipv4_addr; }
+add element inet global hip1 { 192.168.10.2 }
+add element inet global hip1 { 192.168.10.3 }
+add set inet global hip2 { type ipv4_addr; timeout 4s; }
+add element inet global hip2 { 192.168.10.3 }
+add element inet global hip2 { 192.168.10.4 timeout 10s }
+add set inet global hip3 { type ipv4_addr; counter; }
+add element inet global hip3 { 192.168.10.3 counter packets 5 bytes 3456 }
+add set inet global hip4 { type ipv4_addr; flags interval; }
+add element inet global hip4 { 192.168.10.0/24 }
+add set inet global hip5 { type ipv4_addr; size 24; }
+add element inet global hip5 { 192.168.10.0 }
+add set inet global hip6 { type ipv4_addr; }
+add element inet global hip5 { 192.168.10.1 }
+add element inet global hip5 { 192.168.10.2 comment "this is a comment" }
+add set inet global ipp1 { type ipv4_addr . inet_proto . inet_service; }
+add element inet global ipp1 { 192.168.10.1 . tcp . 0 }
+add element inet global ipp1 { 192.168.10.2 . tcp . 5 }
+add set inet global ipp2 { type ipv4_addr . inet_proto . inet_service; timeout 4s; }
+add element inet global ipp2 { 192.168.10.1 . tcp . 0 timeout 12s }
+add element inet global ipp2 { 192.168.10.2 . tcp . 5 }
+add set inet global ipp3 { type ipv4_addr . inet_proto . inet_service; counter; }
+add element inet global ipp3 { 192.168.10.3 . tcp . 20 counter packets 5 bytes 3456 }
+add set inet global ipp4 { type ipv4_addr . inet_proto . inet_service; counter; timeout 4s; }
+add element inet global ipp4 { 192.168.10.3 . tcp . 20 counter packets 5 bytes 3456 }
+add set inet global bip1 { type ipv4_addr; timeout 5s; }
+add set inet global bip2 { type ipv4_addr; timeout 5s; flags interval; }
+add element inet global bip2 { 10.10.10.0/24 }
+add element inet global bip2 { 10.10.20.0/24 timeout 12s }
+add set inet global net1 { type ipv4_addr; flags interval; }
+add element inet global net1 { 192.168.10.0/24 }
+add set inet global net2 { type ipv4_addr . ipv4_addr; flags interval; }
+add element inet global net2 { 192.168.10.0/24 . 192.168.20.0/24 }
+add set inet global hm1 { type ether_addr; }
+add element inet global hm1 { aa:bb:cc:dd:ee:ff }
+add set inet global him1 { type ipv4_addr . ether_addr; }
+add element inet global him1 { 1.1.1.1 . aa:bb:cc:dd:ee:ff }
+add set inet global ni1 { type ipv4_addr . ifname; flags interval; }
+add element inet global ni1 { 1.1.1.0/24 . eth0 }
+add set inet global nip1 { type ipv4_addr . inet_proto . inet_service; flags interval; }
+add element inet global nip1 { 1.1.1.0/24 . tcp . 22 }
+add set inet global npn1 { type ipv4_addr . inet_proto . inet_service . ipv4_addr; flags interval; }
+add element inet global npn1 { 1.1.1.0/24 . tcp . 22 . 2.2.2.0/24 }
+add set inet global nn1 { type ipv4_addr . ipv4_addr; flags interval; }
+add element inet global nn1 { 1.1.1.0/24 . 2.2.2.0/24 }
+add set inet global ipn1 { type ipv4_addr . inet_proto . inet_service . ipv4_addr; flags interval; }
+add element inet global ipn1 { 1.1.1.1 . tcp . 22 . 2.2.2.0/24 }
+add set inet global ipi1 { type ipv4_addr . inet_proto . inet_service . ipv4_addr; }
+add element inet global ipi1 { 1.1.1.1 . tcp . 22 . 2.2.2.2 }
+add set inet global im1 { type ipv4_addr . mark; }
+add element inet global im1 { 1.1.1.1 . 0x00123456 }
+add set inet global bp1 { type inet_service; }
+add element inet global bp1 { 22 }
+add set inet global bim1 { type ipv4_addr . ether_addr; }
+add element inet global bim1 { 1.1.1.1 . aa:bb:cc:dd:ee:ff }
-- 
2.20.1

