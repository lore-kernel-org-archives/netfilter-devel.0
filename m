From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] tests: add regression tests for xtables-translate
Date: Tue, 17 Oct 2017 01:02:18 +0530
Message-ID: <20171016193218.8197-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:45134 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754998AbdJPTef (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Oct 2017 15:34:35 -0400
Received: by mail-pf0-f194.google.com with SMTP id d28so16547830pfe.2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2017 12:34:35 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This test suite is intended to detect regressions in the translation
infrastructure. The script checks if ip[6]tables-translate produces the
expected output, otherwise it prints the wrong translation and the
expected one.

** Arguments

  --all     # Show also passed tests
  [test]    # Run only the specified test file

** Test files structure

Test files are located under extensions directory. Every file contains
tests about specific extension translations. A test file name must end
with ".txlate".

Inside the files, every single test is defined by two consecutive lines:
ip[6]tables-translate command and expected result. One blank line is left
between tests by convention.

e.g.

  $ cat extensions/libxt_cpu.txlate
  iptables-translate -A INPUT -p tcp --dport 80 -m cpu --cpu 0 -j ACCEPT
  nft add rule ip filter INPUT tcp dport 80 cpu 0 counter accept

  iptables-translate -A INPUT -p tcp --dport 80 -m cpu ! --cpu 1 -j ACCEPT
  nft add rule ip filter INPUT tcp dport 80 cpu != 1 counter accept

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 extensions/libxt_TOS.txlate | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 extensions/libxt_TOS.txlate

diff --git a/extensions/libxt_TOS.txlate b/extensions/libxt_TOS.txlate
new file mode 100644
index 00000000..6d55eb24
--- /dev/null
+++ b/extensions/libxt_TOS.txlate
@@ -0,0 +1,25 @@
+ip6tables-translate -A INPUT -j TOS --set-tos 0x1f
+nft add rule ip6 filter INPUT counter ip6 dscp set 0x07
+
+ip6tables-translate -A INPUT -j TOS --set-tos 0xff
+nft add rule ip6 filter INPUT counter ip6 dscp set 0x3f
+
+ip6tables-translate -A INPUT -j TOS --set-tos Minimize-Delay
+nft add rule ip6 filter INPUT counter ip6 dscp set 0x04
+
+ip6tables-translate -A INPUT -j TOS --set-tos Minimize-Cost
+nft add rule ip6 filter INPUT counter ip6 dscp set 0x00
+
+ip6tables-translate -A INPUT -j TOS --set-tos Normal-Service
+nft add rule ip6 filter INPUT counter ip6 dscp set 0x00
+
+ip6tables-translate -A INPUT -j TOS --and-tos 0x12
+nft add rule ip6 filter INPUT counter ip6 dscp set 0x00
+
+ip6tables-translate -A INPUT -j TOS --or-tos 0x12
+nft add rule ip6 filter INPUT counter ip6 dscp set 0x04
+
+ip6tables-translate -A INPUT -j TOS --xor-tos 0x12
+nft add rule ip6 filter INPUT counter ip6 dscp set 0x04
+
+
-- 
2.11.0

