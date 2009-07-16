From: Jan Engelhardt <jengelh@medozas.de>
Subject: conntrack: fix English typo in documentation
Date: Thu, 16 Jul 2009 12:49:36 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907161249180.8760@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57197 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbZGPKti (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:49:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent 9d57b20ca51ee4de21b938bc20f9e3345aa9b02b (conntrack-tools-0.9.12-38-g9d57b20)
commit 88a98cc401541402283fa0354c1361505eed6406
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Jul 16 12:48:42 2009 +0200

conntrack: fix English typo in documentation

This is an update to commit 575fc906a302599cb9afeb136096dfd96bb57b17.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 doc/manual/conntrack-tools.tmpl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/doc/manual/conntrack-tools.tmpl b/doc/manual/conntrack-tools.tmpl
index 50ae23f..b897318 100644
--- a/doc/manual/conntrack-tools.tmpl
+++ b/doc/manual/conntrack-tools.tmpl
@@ -181,14 +181,14 @@
  # conntrack -L
  tcp      6 431982 ESTABLISHED src=192.168.2.100 dst=123.59.27.117 sport=34846 dport=993 packets=169 bytes=14322 src=123.59.27.117 dst=192.168.2.100 sport=993 dport=34846 packets=113 bytes=34787 [ASSURED] mark=0 secmark=0 use=1
  tcp      6 431698 ESTABLISHED src=192.168.2.100 dst=123.59.27.117 sport=34849 dport=993 packets=244 bytes=18723 src=123.59.27.117 dst=192.168.2.100 sport=993 dport=34849 packets=203 bytes=144731 [ASSURED] mark=0 secmark=0 use=1
-conntrack v0.9.7 (conntrack-tools): 2 flow entries has been shown.
+conntrack v0.9.7 (conntrack-tools): 2 flow entries have been shown.
  </programlisting>
 
 <para>You can natively filter the output without using <emphasis>grep</emphasis>:</para>
 <programlisting>
  # conntrack -L -p tcp --dport 34856
  tcp      6 431982 ESTABLISHED src=192.168.2.100 dst=123.59.27.117 sport=34846 dport=993 packets=169 bytes=14322 src=123.59.27.117 dst=192.168.2.100 sport=993 dport=34846 packets=113 bytes=34787 [ASSURED] mark=0 secmark=0 use=1
-conntrack v0.9.7 (conntrack-tools): 1 flow entries has been shown.
+conntrack v0.9.7 (conntrack-tools): 1 flow entries have been shown.
  </programlisting>
 
 <para>Update the mark based on a selection, this allows you to change the mark of an entry without using the CONNMARK target:</para>
-- 
# Created with git-export-patch

