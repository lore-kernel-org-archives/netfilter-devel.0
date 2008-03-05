From: Filippo Zangheri <filippo.zangheri@yahoo.it>
Subject: [PATCH] xtables: remove white spaces from iptables-xml manpages
Date: Thu, 06 Mar 2008 00:13:04 +0100
Message-ID: <47CF2900.2080903@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from n18.bullet.mail.mud.yahoo.com ([68.142.201.235]:25157 "HELO
	n18.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757695AbYCFBCN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Mar 2008 20:02:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patch removes useless white spaces from iptables-xml manpages.

Signed-off-by: Filippo Zangheri <filippo.zangheri@yahoo.it>

---
 iptables-xml.8 |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/iptables-xml.8 b/iptables-xml.8
index 2e4a3da..705dc5e 100644
--- a/iptables-xml.8
+++ b/iptables-xml.8
@@ -50,21 +50,21 @@ target like SNAT and another chain.
 Some sample output is:
 
 <iptables-rules>
-  <table name="mangle" >
+  <table name="mangle">
     <chain name="PREROUTING" policy="ACCEPT" packet-count="63436"
-byte-count="7137573" >
-      <rule >
+byte-count="7137573">
+      <rule>
        <conditions>
-        <match >
-          <p >tcp</p>
+        <match>
+          <p>tcp</p>
         </match>
-        <tcp >
-          <sport >8443</sport>
+        <tcp>
+          <sport>8443</sport>
         </tcp>
        </conditions>
        <actions>
-        <call >
-          <check_ip />
+        <call>
+          <check_ip/>
         </call>
         <ACCEPT/>
        </actions>
-- 
Filippo Zangheri

GPG key ID: 0xE1D879FA
Key fingerprint: 816B CE57 D43C 0A47 EF35 3378 EA5F A72A E1D8 79FA
Key server: pgp.mit.edu

-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GE d- s+:- a-- C++ UL+++ P+ L+++ E-- W+ N* o-- K- w--- O-- M--
V- PS++ PE+ Y+ PGP++ t 5-- X++ R* tv b+ DI-- D---- G-- e++ h--
r++ z*
------END GEEK CODE BLOCK------

