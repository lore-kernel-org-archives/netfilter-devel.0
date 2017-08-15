From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: [conntrack-tools PATCH] tests: don't fail on modprobe since the
 driver might be built-in
Date: Tue, 15 Aug 2017 14:54:18 +0200
Message-ID: <150280165807.21062.1101236218834054083.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36820 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752516AbdHOMy1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2017 08:54:27 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id D6D8151F42B
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Aug 2017 12:54:24 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hLy2AXlCVZHJ for <netfilter-devel@vger.kernel.org>;
        Tue, 15 Aug 2017 14:54:19 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 5FDA351F429
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Aug 2017 14:54:19 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Steve Langasek <steve.langasek@ubuntu.com>

Any of these nf drivers could be built-ins instead of modules; don't cause
the testsuite to fail on modprobe, instead let it proceed and succeed/fail
later based on actual test results.

Ideally we would check up front if the driver is loaded rather than trying
to modprobe and ignoring failures, but there doesn't seem to be a reliable
place to check this in the kernel filesystem.

Signed-off-by: Steve Langasek <steve.langasek@ubuntu.com>
Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 tests/conntrack/run-test.sh |   14 ++++++++------
 tests/nfct/run-test.sh      |   14 ++++++++------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/tests/conntrack/run-test.sh b/tests/conntrack/run-test.sh
index 1403e2c..1c1f8e4 100644
--- a/tests/conntrack/run-test.sh
+++ b/tests/conntrack/run-test.sh
@@ -10,10 +10,12 @@ gcc test-conntrack.c -o test
 #
 # XXX: module auto-load not support by nfnetlink_cttimeout yet :-(
 #
-modprobe nf_conntrack_ipv4
-modprobe nf_conntrack_ipv6
-modprobe nf_conntrack_proto_udplite
-modprobe nf_conntrack_proto_sctp
-modprobe nf_conntrack_proto_dccp
-modprobe nf_conntrack_proto_gre
+# any or all of these might be built-ins rather than modules, so don't error
+# out on failure from modprobe
+modprobe nf_conntrack_ipv4 || true
+modprobe nf_conntrack_ipv6 || true
+modprobe nf_conntrack_proto_udplite || true
+modprobe nf_conntrack_proto_sctp || true
+modprobe nf_conntrack_proto_dccp || true
+modprobe nf_conntrack_proto_gre || true
 ./test testcases
diff --git a/tests/nfct/run-test.sh b/tests/nfct/run-test.sh
index 851ee75..f5f220b 100644
--- a/tests/nfct/run-test.sh
+++ b/tests/nfct/run-test.sh
@@ -11,10 +11,12 @@ gcc test.c -o test
 #
 # XXX: module auto-load not support by nfnetlink_cttimeout yet :-(
 #
-modprobe nf_conntrack_ipv4
-modprobe nf_conntrack_ipv6
-modprobe nf_conntrack_proto_udplite
-modprobe nf_conntrack_proto_sctp
-modprobe nf_conntrack_proto_dccp
-modprobe nf_conntrack_proto_gre
+# any or all of these might be built-ins rather than modules, so don't error
+# out on failure from modprobe
+modprobe nf_conntrack_ipv4 || true
+modprobe nf_conntrack_ipv6 || true
+modprobe nf_conntrack_proto_udplite || true
+modprobe nf_conntrack_proto_sctp || true
+modprobe nf_conntrack_proto_dccp || true
+modprobe nf_conntrack_proto_gre || true
 ./test timeout

