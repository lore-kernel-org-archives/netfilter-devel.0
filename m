Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19548C433DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 10:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C81DC6525D
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 10:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhCIKx7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 05:53:59 -0500
Received: from zucker.schokokeks.org ([178.63.68.96]:50921 "EHLO
        zucker.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhCIKxm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 05:53:42 -0500
Received: from blood-stain-child.wan.ruderich.org (localhost [::1])
  (AUTH: PLAIN simon@ruderich.org, TLS: TLSv1.3,256bits,TLS_AES_256_GCM_SHA384)
  by zucker.schokokeks.org with ESMTPSA
  id 00000000000000A9.00000000604753B5.000009A5; Tue, 09 Mar 2021 11:53:41 +0100
From:   Simon Ruderich <simon@ruderich.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] doc: use symbolic names for chain priorities
Date:   Tue,  9 Mar 2021 11:53:30 +0100
Message-Id: <568a5508e53d6e710c06f5a726fac0357e35a9bb.1615287064.git.simon@ruderich.org>
X-Mailer: git-send-email 2.30.1
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mime-Autoconverted: from 8bit to 7bit by courier 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This replaces the numbers with the matching symbolic names with one
exception: The NAT example used "priority 0" for the prerouting
priority. This is replaced by "dstnat" which has priority -100 which is
the new recommended priority.

Also use spaces instead of tabs for consistency in lines which require
updates.

Signed-off-by: Simon Ruderich <simon@ruderich.org>
---

Hello,

this is mostly similar to my RFC patch with a slightly updated
commit message and additional whitespace changes.

Now that my confusion is mostly lifted this change looks fine to
me.

Regards
Simon

 doc/nft.txt                |  4 ++--
 doc/primary-expression.txt |  8 ++++----
 doc/statements.txt         | 18 +++++++++---------
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index e4f32179..55747036 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -319,7 +319,7 @@ nft --interactive
 create table inet mytable
 
 # add a new base chain: get input packets
-add chain inet mytable myin { type filter hook input priority 0; }
+add chain inet mytable myin { type filter hook input priority filter; }
 
 # add a single counter to the chain
 add rule inet mytable myin counter
@@ -487,7 +487,7 @@ nft add rule ip filter output ip daddr 192.168.0.0/24 accept
 # nft -a list ruleset
 table inet filter {
 	chain input {
-		type filter hook input priority 0; policy accept;
+		type filter hook input priority filter; policy accept;
 		ct state established,related accept # handle 4
 		ip saddr 10.1.1.1 tcp dport ssh accept # handle 5
 	  ...
diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index e87e8cc2..c24e2636 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -221,7 +221,7 @@ boolean (1 bit)
 # exactly what you want).
 table inet x {
     chain y {
-	type filter hook prerouting priority -150; policy accept;
+        type filter hook prerouting priority mangle; policy accept;
         socket transparent 1 socket wildcard 0 mark set 0x00000001 accept
     }
 }
@@ -229,7 +229,7 @@ table inet x {
 # Trace packets that corresponds to a socket with a mark value of 15
 table inet x {
     chain y {
-        type filter hook prerouting priority -150; policy accept;
+        type filter hook prerouting priority mangle; policy accept;
         socket mark 0x0000000f nftrace set 1
     }
 }
@@ -237,7 +237,7 @@ table inet x {
 # Set packet mark to socket mark
 table inet x {
     chain y {
-        type filter hook prerouting priority -150; policy accept;
+        type filter hook prerouting priority mangle; policy accept;
         tcp dport 8080 mark set socket mark
     }
 }
@@ -280,7 +280,7 @@ If no TTL attribute is passed, make a true IP header and fingerprint TTL true co
 # Accept packets that match the "Linux" OS genre signature without comparing TTL.
 table inet x {
     chain y {
-	type filter hook input priority 0; policy accept;
+        type filter hook input priority filter; policy accept;
         osf ttl skip name "Linux"
     }
 }
diff --git a/doc/statements.txt b/doc/statements.txt
index 0973e5ef..c1fd5e55 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -216,7 +216,7 @@ The conntrack statement can be used to set the conntrack mark and conntrack labe
 The ct statement sets meta data associated with a connection. The zone id
 has to be assigned before a conntrack lookup takes place, i.e. this has to be
 done in prerouting and possibly output (if locally generated packets need to be
-placed in a distinct zone), with a hook priority of -300.
+placed in a distinct zone), with a hook priority of *raw* (-300).
 
 Unlike iptables, where the helper assignment happens in the raw table,
 the helper needs to be assigned after a conntrack entry has been
@@ -253,11 +253,11 @@ ct mark set meta mark
 ------------------------------
 table inet raw {
   chain prerouting {
-      type filter hook prerouting priority -300;
+      type filter hook prerouting priority raw;
       ct zone set iif map { "eth1" : 1, "veth1" : 2 }
   }
   chain output {
-      type filter hook output priority -300;
+      type filter hook output priority raw;
       ct zone set oif map { "eth1" : 1, "veth1" : 2 }
   }
 }
@@ -278,7 +278,7 @@ packets.
 
 Note that for this statement to be effective, it has to be applied to packets
 before a conntrack lookup happens. Therefore, it needs to sit in a chain with
-either prerouting or output hook and a hook priority of -300 or less.
+either prerouting or output hook and a hook priority of -300 (*raw*) or less.
 
 See SYNPROXY STATEMENT for an example usage.
 
@@ -420,8 +420,8 @@ If used then port mapping is generated based on a 32-bit pseudo-random algorithm
 ---------------------
 # create a suitable table/chain setup for all further examples
 add table nat
-add chain nat prerouting { type nat hook prerouting priority 0; }
-add chain nat postrouting { type nat hook postrouting priority 100; }
+add chain nat prerouting { type nat hook prerouting priority dstnat; }
+add chain nat postrouting { type nat hook postrouting priority srcnat; }
 
 # translate source addresses of all packets leaving via eth0 to address 1.2.3.4
 add rule nat postrouting oif eth0 snat to 1.2.3.4
@@ -482,21 +482,21 @@ this case the rule will match for both families.
 -------------------------------------
 table ip x {
     chain y {
-        type filter hook prerouting priority -150; policy accept;
+        type filter hook prerouting priority mangle; policy accept;
         tcp dport ntp tproxy to 1.1.1.1
         udp dport ssh tproxy to :2222
     }
 }
 table ip6 x {
     chain y {
-       type filter hook prerouting priority -150; policy accept;
+       type filter hook prerouting priority mangle; policy accept;
        tcp dport ntp tproxy to [dead::beef]
        udp dport ssh tproxy to :2222
     }
 }
 table inet x {
     chain y {
-        type filter hook prerouting priority -150; policy accept;
+        type filter hook prerouting priority mangle; policy accept;
         tcp dport 321 tproxy to :ssh
         tcp dport 99 tproxy ip to 1.1.1.1:999
         udp dport 155 tproxy ip6 to [dead::beef]:smux
-- 
2.30.1

