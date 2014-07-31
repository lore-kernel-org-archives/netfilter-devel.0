From: Ana Rey <anarey@gmail.com>
Subject: [PATCH 3/6] [nft] tests: Add inet folder with test files.
Date: Thu, 31 Jul 2014 11:08:08 +0200
Message-ID: <1406797691-1080-4-git-send-email-anarey@gmail.com>
References: <1406797691-1080-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:44550 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbaGaJIb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:08:31 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so2470568wgh.9
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2014 02:08:30 -0700 (PDT)
In-Reply-To: <1406797691-1080-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"inet" folder contains the test files that are executed in ipv4, ipv6
and inet family of tables.

These test files are executed with nft-tests.py

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/inet/ah.t      |  63 +++++++++++++++++++++++++++++++
 tests/inet/comp.t    |  31 +++++++++++++++
 tests/inet/dccp.t    |  31 +++++++++++++++
 tests/inet/esp.t     |  23 ++++++++++++
 tests/inet/sctp.t    |  42 +++++++++++++++++++++
 tests/inet/tcp.t     | 104 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/inet/udp.t     |  49 ++++++++++++++++++++++++
 tests/inet/udplite.t |  42 +++++++++++++++++++++
 8 files changed, 385 insertions(+)
 create mode 100644 tests/inet/ah.t
 create mode 100644 tests/inet/comp.t
 create mode 100644 tests/inet/dccp.t
 create mode 100644 tests/inet/esp.t
 create mode 100644 tests/inet/sctp.t
 create mode 100644 tests/inet/tcp.t
 create mode 100644 tests/inet/udp.t
 create mode 100644 tests/inet/udplite.t

diff --git a/tests/inet/ah.t b/tests/inet/ah.t
new file mode 100644
index 0000000..5f710ca
--- /dev/null
+++ b/tests/inet/ah.t
@@ -0,0 +1,63 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+
+:input;type filter hook input priority 0
+
+# nexthdr
+# Bug to list table.
+
+- ah nexthdr esp;ok
+- ah nexthdr ah;ok
+- ah nexthdr comp;ok
+- ah nexthdr udp;ok
+- ah nexthdr udplite;ok
+- ah nexthdr tcp;ok
+- ah nexthdr dccp;ok
+- ah nexthdr sctp;ok
+
+- ah nexthdr { esp, ah, comp, udp, udplite, tcp, dccp, sctp};ok
+- ah nexthdr != { esp, ah, comp, udp, udplite, tcp, dccp, sctp};ok
+
+# hdrlength
+ah hdrlength 11-23;ok;ah hdrlength >= 11 ah hdrlength <= 23
+ah hdrlength != 11-23;ok;ah hdrlength < 11 ah hdrlength > 23
+ah hdrlength { 11-23};ok
+- ah hdrlength != { 11-23};ok
+ah hdrlength {11, 23, 44 };ok
+- ah hdrlength != {11-23 };ok
+
+# reserved
+ah reserved 22;ok
+ah reserved != 233;ok
+ah reserved 33-45;ok;ah reserved >= 33 ah reserved <= 45
+ah reserved != 33-45;ok;ah reserved < 33 ah reserved > 45
+ah reserved {23, 100};ok
+- ah reserved != {33, 55, 67, 88};ok
+ah reserved { 33-55};ok
+- ah reserved != { 33-55};ok
+
+#spi
+ah spi 111;ok
+ah spi != 111;ok
+ah spi 111-222;ok;ah spi >= 111 ah spi <= 222
+ah spi != 111-222;ok;ah spi < 111 ah spi > 222
+ah spi {111, 122};ok
+-ah spi != {111, 122};ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+ah spi { 111-122};ok
+-ah spi != { 111-122};ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+# sequence
+ah sequence 123;ok
+ah sequence != 123;ok
+ah sequence {23, 25, 33};ok
+-ah sequence != {23, 25, 33};ok
+ah sequence { 23-33};ok
+-ah sequence != { 33-44};ok
+ah sequence 23-33;ok;ah sequence >= 23 ah sequence <= 33
+ah sequence != 23-33;ok;ah sequence < 23 ah sequence > 33
diff --git a/tests/inet/comp.t b/tests/inet/comp.t
new file mode 100644
index 0000000..315026e
--- /dev/null
+++ b/tests/inet/comp.t
@@ -0,0 +1,31 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+
+:input;type filter hook input priority 0
+
+# BUG: Do no list table.
+-comp nexthdr esp;ok
+comp nexthdr != esp;ok
+
+-comp nexthdr {esp, ah, comp, udp, udplite, tcp, tcp, dccp, sctp};ok
+# comp flags ## 8-bit field.  Reserved for future use.  MUST be set to zero.
+
+# Bug comp flags: to list. List the decimal value.
+comp flags 0x00;ok
+comp flags != 0x23;ok
+comp flags 0x33-0x45;ok
+comp flags != 0x33-0x45;ok
+comp flags {0x33, 0x55, 0x67, 0x88};ok
+-comp flags != {0x33, 0x55, 0x67, 0x88};ok
+comp flags { 0x33-0x55};ok
+-comp flags != { 0x33-0x55};ok
+
+comp cpi 22;ok
+comp cpi != 233;ok
+comp cpi 33-45;ok;comp cpi >= 33 comp cpi <= 45
+comp cpi != 33-45;ok;comp cpi < 33 comp cpi > 45
+comp cpi {33, 55, 67, 88};ok
+-comp cpi != {33, 55, 67, 88};ok
+comp cpi { 33-55};ok
+-comp cpi != { 33-55};ok
diff --git a/tests/inet/dccp.t b/tests/inet/dccp.t
new file mode 100644
index 0000000..d91ce53
--- /dev/null
+++ b/tests/inet/dccp.t
@@ -0,0 +1,31 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+:input;type filter hook input priority 0
+
+dccp sport 21-35;ok;dccp sport >= ftp dccp sport <= 35
+dccp sport != 21-35;ok;dccp sport < ftp dccp sport > 35
+dccp sport {23, 24, 25};ok;dccp sport { smtp, 24, telnet}
+- dccp sport != { 27, 34};ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+dccp sport { ftp-data - re-mail-ck};ok
+dccp sport ftp-data - re-mail-ck;ok;dccp sport >= ftp-data dccp sport <= re-mail-ck
+dccp sport { 20-50};ok;dccp sport { ftp-data-re-mail-ck}
+# dccp sport != {27-34};ok
+- BUG: invalid expression type set
+- nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+#dccp dport 21-35;ok
+#dccp dport != 21-35;ok
+dccp dport {23, 24, 25};ok;dccp dport { smtp, 24, telnet}
+# dccp dport != {27, 34};ok
+dccp dport { 20-50};ok;dccp dport { ftp-data-re-mail-ck}
+# dccp dport != {27-34};ok
+
+# BUG dccp type
+#dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack};ok
+#dccp type != {request, response, data, ack, dataack, closereq, close, reset, sync, syncack};ok
+#dccp type request;ok
+#dccp type != request;ok
diff --git a/tests/inet/esp.t b/tests/inet/esp.t
new file mode 100644
index 0000000..4436a59
--- /dev/null
+++ b/tests/inet/esp.t
@@ -0,0 +1,23 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+:input;type filter hook input priority 0
+
+esp spi 100;ok
+esp spi != 100;ok
+esp spi 111-222;ok;esp spi >= 111 esp spi <= 222
+esp spi != 111-222;ok;esp spi < 111 esp spi > 222
+esp spi { 100, 102};ok
+-esp spi != { 100, 102};ok
+esp spi { 100-102};ok
+-esp spi {100-102};ok
+
+esp sequence 22;ok
+esp sequence 22-24;ok;esp sequence >= 22 esp sequence <= 24
+esp sequence != 22-24;ok;esp sequence < 22 esp sequence > 24
+esp sequence { 22, 24};ok
+- esp sequence != { 22, 24};ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+esp sequence { 22-25};ok
+-esp sequence != { 22-25};ok
diff --git a/tests/inet/sctp.t b/tests/inet/sctp.t
new file mode 100644
index 0000000..cf5b65c
--- /dev/null
+++ b/tests/inet/sctp.t
@@ -0,0 +1,42 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+:input;type filter hook input priority 0
+
+sctp sport 23;ok;sctp sport telnet
+sctp sport != 23;ok;sctp sport != telnet
+sctp sport 23-44;ok;sctp sport >= telnet sctp sport <= 44
+sctp sport != 23-44;ok;sctp sport < telnet sctp sport > 44
+sctp sport { 23, 24, 25};ok;sctp sport { smtp, 24, telnet}
+# sctp sport != { 23, 24, 25};ok
+sctp sport { 23-44};ok;sctp sport { telnet-44}
+# sctp sport != { 23-44};ok
+-# BUG: invalid expression type set
+-# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+sctp dport 23;ok;sctp dport telnet
+sctp dport != 23;ok;sctp dport != telnet
+sctp dport 23-44;ok;sctp dport >= telnet sctp dport <= 44
+sctp dport != 23-44;ok;sctp dport < telnet sctp dport > 44
+sctp dport { 23, 24, 25};ok;sctp dport { smtp, 24, telnet}
+# sctp dport != { 23, 24, 25};ok
+sctp dport { 23-44};ok;sctp dport { telnet-44}
+# sctp dport != { 23-44};ok
+
+sctp checksum 1111;ok
+sctp checksum != 11;ok
+sctp checksum 21-333;ok;sctp checksum >= 21 sctp checksum <= 333
+sctp checksum != 32-111;ok;sctp checksum < 32 sctp checksum > 111
+sctp checksum { 22, 33, 44};ok
+# sctp checksum != { 22, 33, 44};ok
+sctp checksum { 22-44};ok
+# sctp checksum != { 22-44};ok
+
+sctp vtag 22;ok
+sctp vtag != 233;ok
+sctp vtag 33-45;ok;sctp vtag >= 33 sctp vtag <= 45
+sctp vtag != 33-45;ok;sctp vtag < 33 sctp vtag > 45
+sctp vtag {33, 55, 67, 88};ok
+# sctp vtag != {33, 55, 67, 88};ok
+sctp vtag { 33-55};ok
+# sctp vtag != { 33-55};ok
diff --git a/tests/inet/tcp.t b/tests/inet/tcp.t
new file mode 100644
index 0000000..9799365
--- /dev/null
+++ b/tests/inet/tcp.t
@@ -0,0 +1,104 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+:input;type filter hook input priority 0
+
+tcp dport 22;ok;tcp dport ssh
+tcp dport != 233;ok
+tcp dport 33-45;ok;tcp dport >= 33 tcp dport <= 45
+tcp dport != 33-45;ok;tcp dport < 33 tcp dport > 45
+tcp dport { 33, 55, 67, 88};ok;tcp dport { 33, 55, kerberos, bootps}
+-tcp dport != { 33, 55, 67, 88};ok
+tcp dport { 33-55};ok
+-tcp dport != { 33-55};ok
+tcp dport {telnet, http, https} accept;ok
+tcp dport vmap { 22 : accept, 23 : drop };ok;tcp dport vmap { ssh : accept, telnet : drop}
+tcp dport vmap { 25:accept, 28:drop };ok;tcp dport vmap { 28 : drop, smtp : accept}
+tcp dport { 22, 53, 80, 110 };ok;tcp dport { pop3, domain, ssh, http}
+- tcp dport != { 22, 53, 80, 110 };ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+tcp sport 22;ok;tcp sport ssh
+tcp sport != 233;ok
+tcp sport 33-45;ok;tcp sport >= 33 tcp sport <= 45
+tcp sport != 33-45;ok;tcp sport < 33 tcp sport > 45
+tcp sport { 33, 55, 67, 88};ok;tcp sport { 33, 55, kerberos, bootps}
+- tcp sport != { 33, 55, 67, 88};ok
+tcp sport { 33-55};ok
+- tcp sport != { 33-55};ok
+tcp sport vmap { 25:accept, 28:drop };ok;tcp sport vmap { 28 : drop, smtp : accept}
+
+tcp sport 8080 drop;ok;tcp sport http-alt drop
+tcp sport 1024 tcp dport 22;ok;tcp sport 1024 tcp dport ssh
+tcp sport 1024 tcp dport 22 tcp sequence 0;ok;tcp sport 1024 tcp dport ssh tcp sequence 0
+
+tcp sequence 0 tcp sport 1024 tcp dport 22;ok;tcp sport 1024 tcp dport ssh tcp sequence 0
+tcp sequence 0 tcp sport { 1024, 1022} tcp dport 22;ok
+
+tcp sequence 22;ok
+tcp sequence != 233;ok
+tcp sequence 33-45;ok;tcp sequence >= 33 tcp sequence <= 45
+tcp sequence != 33-45;ok;tcp sequence < 33 tcp sequence > 45
+tcp sequence { 33, 55, 67, 88};ok
+-tcp sequence != { 33, 55, 67, 88};ok
+tcp sequence { 33-55};ok
+-tcp sequence != { 33-55};ok
+
+tcp ackseq 42949672 drop;ok
+tcp ackseq 22;ok
+tcp ackseq != 233;ok
+tcp ackseq 33-45;ok;tcp ackseq >= 33 tcp ackseq <= 45
+tcp ackseq != 33-45;ok;tcp ackseq < 33 tcp ackseq > 45
+tcp ackseq { 33, 55, 67, 88};ok
+-tcp ackseq != { 33, 55, 67, 88};ok
+tcp ackseq { 33-55};ok
+-tcp ackseq != { 33-55};ok
+
+# BUG doff
+-tcp doff 22;ok
+-tcp doff != 233;ok
+-tcp doff 33-45;ok
+-tcp doff != 33-45;ok
+-tcp doff { 33, 55, 67, 88};ok
+-tcp doff != { 33, 55, 67, 88};ok
+-tcp doff { 33-55};ok
+-tcp doff != { 33-55};ok
+
+# BUG reserved
+# BUG: It is accepted but it is not shown then. tcp reserver
+
+tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop;ok
+-tcp flags != { fin, urg, ecn, cwr} drop;ok
+tcp flags cwr;ok
+tcp flags != cwr;ok
+
+tcp window 22222;ok
+tcp window 22;ok
+tcp window != 233;ok
+tcp window 33-45;ok;tcp window >= 33 tcp window <= 45
+tcp window != 33-45;ok;tcp window < 33 tcp window > 45
+tcp window { 33, 55, 67, 88};ok
+-tcp window != { 33, 55, 67, 88};ok
+tcp window { 33-55};ok
+-tcp window != { 33-55};ok
+
+tcp checksum 23456 log drop;ok
+tcp checksum 22;ok
+tcp checksum != 233;ok
+tcp checksum 33-45;ok;tcp checksum >= 33 tcp checksum <= 45
+tcp checksum != 33-45;ok;tcp checksum < 33 tcp checksum > 45
+tcp checksum { 33, 55, 67, 88};ok
+-tcp checksum != { 33, 55, 67, 88};ok
+tcp checksum { 33-55};ok
+-tcp checksum != { 33-55};ok
+
+tcp urgptr 1234 accept;ok
+tcp urgptr 22;ok
+tcp urgptr != 233;ok
+tcp urgptr 33-45;ok;tcp urgptr >= 33 tcp urgptr <= 45
+tcp urgptr != 33-45;ok;tcp urgptr < 33 tcp urgptr > 45
+tcp urgptr { 33, 55, 67, 88};ok
+-tcp urgptr != { 33, 55, 67, 88};ok
+tcp urgptr { 33-55};ok
+-tcp urgptr != { 33-55};ok
diff --git a/tests/inet/udp.t b/tests/inet/udp.t
new file mode 100644
index 0000000..aab7155
--- /dev/null
+++ b/tests/inet/udp.t
@@ -0,0 +1,49 @@
+*ip;test-ip4
+*ip;test-ip6
+*ip;test-inet
+:input;type filter hook input priority 0
+
+udp sport 80 accept;ok;udp sport http accept
+udp sport != 60 accept;ok
+udp sport 50-70 accept;ok;udp sport >= re-mail-ck udp sport <= gopher accept
+udp sport != 50-60 accept;ok;udp sport < re-mail-ck udp sport > 60 accept
+udp sport { 49, 50} drop;ok;udp sport { re-mail-ck, tacacs} drop
+- udp sport != { 50, 60} accept;ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+udp sport { 12-40};ok
+-udp sport != { 13-24};ok
+
+udp dport 80 accept;ok;udp dport http accept
+udp dport != 60 accept;ok
+udp dport 70-75 accept;ok;udp dport >= gopher udp dport <= 75 accept
+udp dport != 50-60 accept;ok;udp dport < re-mail-ck udp dport > 60 accept
+udp dport { 49, 50} drop;ok;udp dport { re-mail-ck, tacacs} drop
+-udp dport != { 50, 60} accept;ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+udp dport { 70-75} accept;ok;udp dport { gopher-75} accept
+- udp dport != { 50-60} accept;ok
+
+udp length 6666;ok
+udp length != 6666;ok
+udp length 50-65 accept;ok;udp length >= 50 udp length <= 65 accept
+udp length != 50-65 accept;ok;udp length < 50 udp length > 65 accept
+udp length { 50, 65} accept;ok
+-udp length != { 50, 65} accept;ok
+udp length { 35-50};ok
+-udp length != { 35-50};ok
+
+udp checksum 6666 drop;ok
+- udp checksum != { 444, 555} accept;ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+udp checksum 22;ok
+udp checksum != 233;ok
+udp checksum 33-45;ok;udp checksum >= 33 udp checksum <= 45
+udp checksum != 33-45;ok;udp checksum < 33 udp checksum > 45
+udp checksum { 33, 55, 67, 88};ok
+-udp checksum != { 33, 55, 67, 88};ok
+udp checksum { 33-55};ok
+-udp checksum != { 33-55};ok
diff --git a/tests/inet/udplite.t b/tests/inet/udplite.t
new file mode 100644
index 0000000..be931ce
--- /dev/null
+++ b/tests/inet/udplite.t
@@ -0,0 +1,42 @@
+*ip;test-ip4
+*ip6;test-ip6
+*inet;test-inet
+:input;type filter hook input priority 0
+
+udplite sport 80 accept;ok;udplite sport http accept
+udplite sport != 60 accept;okudplite sport http != accept
+udplite sport 50-70 accept;ok;udplite sport >= re-mail-ck udplite sport <= gopher accept
+udplite sport != 50-60 accept;ok;udplite sport < re-mail-ck udplite sport > 60 accept
+udplite sport { 49, 50} drop;ok;udplite sport { re-mail-ck, tacacs} drop
+-udplite sport != { 50, 60} accept;ok
+udplite sport { 12-40};ok
+-udplite sport != { 13-24};ok
+
+udplite dport 80 accept;ok;udplite dport http accept
+udplite dport != 60 accept;ok
+udplite dport 70-75 accept;ok;udplite dport >= gopher udplite dport <= 75 accept
+udplite dport != 50-60 accept;ok;udplite dport < re-mail-ck udplite dport > 60 accept
+udplite dport { 49, 50} drop;ok;udplite dport { re-mail-ck, tacacs} drop
+-udplite dport != { 50, 60} accept;ok
+udplite dport { 70-75} accept;ok;udplite dport { gopher-75} accept
+-udplite dport != { 50-60} accept;ok
+
+-udplite csumcov 6666;ok
+-udplite csumcov != 6666;ok
+-udplite csumcov 50-65 accept;ok
+-udplite csumcov != 50-65 accept;ok
+-udplite csumcov { 50, 65} accept;ok
+-udplite csumcov != { 50, 65} accept;ok
+-udplite csumcov { 35-50};ok
+-udplite csumcov != { 35-50};ok
+
+udplite checksum 6666 drop;ok
+-udplite checksum != { 444, 555} accept;ok
+udplite checksum 22;ok
+udplite checksum != 233;ok
+udplite checksum 33-45;ok;udplite checksum >= 33 udplite checksum <= 45
+udplite checksum != 33-45;ok;udplite checksum < 33 udplite checksum > 45
+udplite checksum { 33, 55, 67, 88};ok
+-udplite checksum != { 33, 55, 67, 88};ok
+udplite checksum { 33-55};ok
+-udplite checksum != { 33-55};ok
-- 
2.0.0

