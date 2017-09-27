From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 10/10] doc: update man page
Date: Wed, 27 Sep 2017 20:16:54 +0200
Message-ID: <20170927181654.3129-11-fw@strlen.de>
References: <20170927181654.3129-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37780 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751555AbdI0SRJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 14:17:09 -0400
In-Reply-To: <20170927181654.3129-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

you can now use "rt ip|ip6 nexthop" and "ct original|reply ip|ip6 saddr|daddr"
to tell nft if you want to match ipv4 or ipv6.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.xml | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 9d97a782d3a5..c0f42ddccbeb 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -608,7 +608,6 @@ filter input iif $int_ifs accept
 			hybrid IPv4/IPv6 tables.  The <literal>meta</literal> expression <literal>nfproto</literal>
 			keyword can be used to test which family (ipv4 or ipv6) context the packet is being processed in.
 
-
 			When no address family is specified, <literal>ip</literal> is used by default.
 		</para>
 
@@ -2905,8 +2904,8 @@ filter output rt classid 10
 # IP family dependent rt expressions
 ip filter output rt nexthop 192.168.0.1
 ip6 filter output rt nexthop fd00::1
-inet filter meta nfproto ipv4 output rt nexthop 192.168.0.1
-inet filter meta nfproto ipv6 output rt nexthop fd00::1
+inet filter output rt ip nexthop 192.168.0.1
+inet filter output rt ip6 nexthop fd00::1
 					</programlisting>
 				</example>
 			</para>
@@ -4025,8 +4024,6 @@ ip6 filter input frag more-fragments 1 counter
 					<group choice="req">
 						<arg>l3proto</arg>
 						<arg>protocol</arg>
-						<arg>saddr</arg>
-						<arg>daddr</arg>
 						<arg>proto-src</arg>
 						<arg>proto-dst</arg>
 						<arg>bytes</arg>
@@ -4035,6 +4032,22 @@ ip6 filter input frag more-fragments 1 counter
 						<arg>zone</arg>
 					</group>
 				</cmdsynopsis>
+				<cmdsynopsis>
+					<command>ct</command>
+					<group choice="req">
+						<arg>original</arg>
+						<arg>reply</arg>
+					</group>
+					<group choice="req">
+						<arg>ip</arg>
+						<arg>ip6</arg>
+					</group>
+					<group choice="req">
+						<arg>saddr</arg>
+						<arg>daddr</arg>
+					</group>
+				</cmdsynopsis>
+
 			</para>
 			<para>
 				<table frame="all">
-- 
2.13.5

