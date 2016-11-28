From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 2/2] tests: shell: add testcase for different defines
 usage
Date: Mon, 28 Nov 2016 13:59:28 +0100
Message-ID: <148033796872.16068.6534024929186046379.stgit@nfdev2.cica.es>
References: <148033796252.16068.18014556006915154561.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36499 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753790AbcK1M7g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 07:59:36 -0500
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 26F1451F2FB
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 12:59:34 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2d2lrPn5l_5y for <netfilter-devel@vger.kernel.org>;
        Mon, 28 Nov 2016 13:59:29 +0100 (CET)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 24CDF51F345
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 13:59:29 +0100 (CET)
In-Reply-To: <148033796252.16068.18014556006915154561.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo@debian.org>

This testcase add some defines in a nft -f run and then uses
them in different spots (which are not covered in previous testcases).

 * defines used to define another one
 * different datatypes (numbers, strings, bits, ranges)
 * usage in sets, maps, contatenatios
 * single rules with single statements, multiple statements
 * reuse define in same rule

Perhaps this isn't testing many different code path, but I find this
interesting to have given it will probably be one of the most common
use cases of nftables.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 .../shell/testcases/nft-f/0012different_defines_0  |   44 ++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100755 tests/shell/testcases/nft-f/0012different_defines_0

diff --git a/tests/shell/testcases/nft-f/0012different_defines_0 b/tests/shell/testcases/nft-f/0012different_defines_0
new file mode 100755
index 0000000..9c496d5
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0012different_defines_0
@@ -0,0 +1,44 @@
+#!/bin/bash
+
+# tests different spots, datatypes and usages for nft defines
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+echo "
+define d_iifname = whatever
+define d_oifname = \$d_iifname
+define d_iif = lo
+define d_oif = \$d_iif
+define d_mark = 123
+define d_state = new,established,related
+define d_ipv4 = 10.0.0.0
+define d_ipv4_2 = 10.0.0.2
+define d_ipv6 = fe0::1
+define d_ipv6_2 = fe0::2
+define d_ports = 100-222
+
+table inet t {
+	chain c {
+		iifname \$d_iifname oifname \$d_oifname iif \$d_iif oif \$d_oif
+		iifname { \$d_iifname , \$d_oifname } iif { \$d_iif , \$d_oif } meta mark \$d_mark
+		ct state \$d_state
+		ct state != \$d_state
+		ip saddr \$d_ipv4 ip daddr \$d_ipv4_2 ip saddr \$d_ipv4
+		ip6 daddr \$d_ipv6 ip6 saddr \$d_ipv6_2
+		ip saddr vmap { \$d_ipv4 : drop , \$d_ipv4_2 : accept }
+		ip6 daddr vmap { \$d_ipv6 : drop , \$d_ipv6_2 : accept }
+		ip6 saddr . ip6 nexthdr { \$d_ipv6 . udp, \$d_ipv6_2 . tcp }
+		ip daddr . meta iif vmap { \$d_ipv4 . \$d_iif : accept }
+		tcp dport \$d_ports
+		udp dport vmap { \$d_ports : accept }
+	}
+}" >> $tmpfile
+
+set -e
+$NFT -f $tmpfile

