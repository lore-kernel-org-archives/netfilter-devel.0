From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] src: rename ct eventmask to event
Date: Wed,  7 Jun 2017 12:24:10 +0200
Message-ID: <20170607102410.21024-2-fw@strlen.de>
References: <20170607102410.21024-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44860 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751207AbdFGKX4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 06:23:56 -0400
In-Reply-To: <20170607102410.21024-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ct status isn't named 'statusmask' either.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Pablo, we could still change kernel API and rename
 NFT_CT_EVENTMASK to NFT_CT_EVENT, let me know (or
 do so yourself), it just has to hit Linus tree before 4.12.

 The needed libnftnl patch is trivial, i'll just push it
 out if you don't NAK this one.

 doc/nft.xml               |  6 +++---
 src/ct.c                  |  2 +-
 tests/py/any/ct.t         | 10 +++++-----
 tests/py/any/ct.t.payload | 16 ++++++++--------
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index f613f69cb764..6f5b8bf90c6f 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -3864,7 +3864,7 @@ ip6 filter output log flags all
 					<command>ct</command>
 					<group choice="req">
 						<arg>mark</arg>
-						<arg>eventmask</arg>
+						<arg>event</arg>
 						<arg>label</arg>
 						<arg>zone</arg>
 					</group>
@@ -3895,7 +3895,7 @@ ip6 filter output log flags all
 						</thead>
 						<tbody>
 							<row>
-								<entry>eventmask</entry>
+								<entry>event</entry>
 								<entry>conntrack event bits</entry>
 								<entry>bitmask, integer (32 bit)</entry>
 							</row>
@@ -3950,7 +3950,7 @@ table inet raw {
 			<example>
 					<title>restrict events reported by ctnetlink</title>
 				<programlisting>
-ct eventmask set new or related or destroy
+ct event set new,related,destroy
 				</programlisting>
 			</example>
 
diff --git a/src/ct.c b/src/ct.c
index 5014265a3427..ab50a1668404 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -264,7 +264,7 @@ static const struct ct_template ct_templates[] = {
 					      BYTEORDER_HOST_ENDIAN, 64),
 	[NFT_CT_ZONE]		= CT_TEMPLATE("zone", &integer_type,
 					      BYTEORDER_HOST_ENDIAN, 16),
-	[NFT_CT_EVENTMASK]	= CT_TEMPLATE("eventmask", &ct_event_type,
+	[NFT_CT_EVENTMASK]	= CT_TEMPLATE("event", &ct_event_type,
 					      BYTEORDER_HOST_ENDIAN, 32),
 };
 
diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 667126e656ae..1c90ec1c769d 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -100,11 +100,11 @@ ct original mark 42;fail
 # swapped key and direction
 ct mark original;fail
 
-ct eventmask set new;ok
-ct eventmask set new or related or destroy or foobar;fail
-ct eventmask set 'new | related | destroy | label';ok;ct eventmask set new | related | destroy | label
-ct eventmask set 1;ok;ct eventmask set new
-ct eventmask set 0x0;ok
+ct event set new;ok
+ct event set new or related or destroy or foobar;fail
+ct event set 'new | related | destroy | label';ok;ct event set new | related | destroy | label
+ct event set 1;ok;ct event set new
+ct event set 0x0;ok
 
 ct label 127;ok
 ct label set 127;ok
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index c5fa7c8d49e4..dea985a3016b 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -398,25 +398,25 @@ ip test-ip4 output
   [ bitwise reg 1 = (reg=1 & 0x00000020 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
 
-# ct eventmask set new
+# ct event set new
 ip test-ip4 output
   [ immediate reg 1 0x00000001 ]
-  [ ct set eventmask with reg 1 ]
+  [ ct set event with reg 1 ]
 
-# ct eventmask set 'new | related | destroy | label'
+# ct event set 'new | related | destroy | label'
 ip test-ip4 output
   [ immediate reg 1 0x00000407 ]
-  [ ct set eventmask with reg 1 ]
+  [ ct set event with reg 1 ]
 
-# ct eventmask set 1
+# ct event set 1
 ip test-ip4 output
   [ immediate reg 1 0x00000001 ]
-  [ ct set eventmask with reg 1 ]
+  [ ct set event with reg 1 ]
 
-# ct eventmask set 0x0
+# ct event set 0x0
 ip test-ip4 output
   [ immediate reg 1 0x00000000 ]
-  [ ct set eventmask with reg 1 ]
+  [ ct set event with reg 1 ]
 
 # ct label 127
 ip test-ip4 output
-- 
2.13.0

