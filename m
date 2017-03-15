From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nftables 7/7] doc: ct helper objects and helper set support
Date: Wed, 15 Mar 2017 16:01:11 +0100
Message-ID: <20170315150111.18477-8-fw@strlen.de>
References: <20170315150111.18477-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46454 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753126AbdCOPBS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 11:01:18 -0400
In-Reply-To: <20170315150111.18477-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 changes since v1:
 use <replaceable> in cmdsynopsis, update example

 doc/nft.xml | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index 8ea280417742..80f201e89d37 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -950,6 +950,77 @@ filter input iif $int_ifs accept
 		</variablelist>
 
 		<refsect2>
+			<title>Ct</title>
+			<para>
+				<cmdsynopsis>
+					<command>ct</command>
+					<arg choice="req">helper</arg>
+					<arg choice="req">type</arg>
+					<arg choice="req"><replaceable>type</replaceable></arg>
+					<arg choice="req">protocol</arg>
+					<arg choice="req"><replaceable>protocol</replaceable></arg>
+					<arg choice="opt">l3proto</arg>
+					<arg choice="opt"><replaceable>family</replaceable></arg>
+				</cmdsynopsis>
+			</para>
+			<para>
+				Ct helper is used to define connection tracking helpers that can then be used in combination with the <literal>"ct helper set"</literal> statement.
+				type and protocol are mandatory, l3proto is derived from the table family by default, i.e. in the inet table the kernel will
+				try to load both the ipv4 and ipv6 helper backends, if they are supported by the kernel.
+			</para>
+			<table frame="all">
+				<title>conntrack helper specifications</title>
+				<tgroup cols='3' align='left' colsep='1' rowsep='1'>
+					<colspec colname='c1'/>
+					<colspec colname='c2'/>
+					<colspec colname='c3'/>
+					<thead>
+						<row>
+							<entry>Keyword</entry>
+							<entry>Description</entry>
+							<entry>Type</entry>
+						</row>
+					</thead>
+					<tbody>
+						<row>
+							<entry>type</entry>
+							<entry>name of helper type</entry>
+							<entry>quoted string (e.g. "ftp")</entry>
+						</row>
+						<row>
+							<entry>protocol</entry>
+							<entry>layer 4 protocol of the helper</entry>
+							<entry>string (e.g. tcp)</entry>
+						</row>
+						<row>
+							<entry>l3proto</entry>
+							<entry>layer 3 protocol of the helper</entry>
+							<entry>address family (e.g. ip)</entry>
+						</row>
+					</tbody>
+				</tgroup>
+			</table>
+			<example>
+				<title>defining and assigning ftp helper</title>
+				<para>
+				Unlike iptables, helper assignment needs to be performed after the conntrack lookup has completed, for example
+				with the default 0 hook priority.
+				</para>
+				<programlisting>
+table inet myhelpers {
+  ct helper ftp-standard {
+     type "ftp" protocol tcp
+  }
+  chain prerouting {
+      type filter hook prerouting priority 0;
+      tcp dport 21 ct helper set "ftp-standard"
+  }
+}
+				</programlisting>
+			</example>
+		</refsect2>
+
+		<refsect2>
 			<title>Counter</title>
 			<para>
 				<cmdsynopsis>
@@ -3376,6 +3447,11 @@ ip6 filter output log flags all
 						</thead>
 						<tbody>
 							<row>
+								<entry>helper</entry>
+								<entry>name of ct helper object to assign to the connection</entry>
+								<entry>quoted string</entry>
+							</row>
+							<row>
 								<entry>mark</entry>
 								<entry>Connection tracking mark</entry>
 								<entry>mark</entry>
-- 
2.10.2

