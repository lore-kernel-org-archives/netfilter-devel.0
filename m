From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft] doc: Document sets
Date: Thu, 9 Feb 2017 15:35:25 -0200
Message-ID: <20170209173525.GA10010@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34797 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754354AbdBIRfd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Feb 2017 12:35:33 -0500
Received: by mail-qk0-f196.google.com with SMTP id e1so1605627qkh.1
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Feb 2017 09:35:32 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the missing documentation for sets.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 doc/nft.xml | 124 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 124 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index ac31c3b..be729a8 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -668,6 +668,130 @@ filter input iif $int_ifs accept
 	</refsect1>
 
 	<refsect1>
+		<title>Sets</title>
+		<para>
+			<cmdsynopsis>
+				<arg choice="req">add</arg>
+				<command> set</command>
+				<arg choice="opt"><replaceable>family</replaceable></arg>
+				<arg choice="req"><replaceable>table</replaceable></arg>
+				<arg choice="req"><replaceable>set</replaceable></arg>
+				{
+				<arg choice="req"><replaceable>type</replaceable></arg>
+				<arg choice="opt"><replaceable>flags</replaceable></arg>
+				<arg choice="opt"><replaceable>timeout</replaceable></arg>
+				<arg choice="opt"><replaceable>gc-interval</replaceable></arg>
+				<arg choice="opt"><replaceable>elements</replaceable></arg>
+				<arg choice="opt"><replaceable>size</replaceable></arg>
+				<arg choice="opt"><replaceable>policy</replaceable></arg>
+				}
+			</cmdsynopsis>
+			<cmdsynopsis>
+				<group choice="req">
+					<arg>delete</arg>
+					<arg>list</arg>
+					<arg>flush</arg>
+				</group>
+				<command> set</command>
+				<arg choice="opt"><replaceable>family</replaceable></arg>
+				<arg choice="req"><replaceable>table</replaceable></arg>
+				<arg choice="req"><replaceable>set</replaceable></arg>
+			</cmdsynopsis>
+		</para>
+		<para>
+			Sets are elements containers of an user-defined data type, they are uniquely identified by an user-defined name and attached to tables.
+		</para>
+
+		<variablelist>
+			<varlistentry>
+				<term><option>add</option></term>
+				<listitem>
+					<para>
+						Add a new set in the specified table.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
+				<term><option>delete</option></term>
+				<listitem>
+					<para>
+						Delete the specified set.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
+				<term><option>list</option></term>
+				<listitem>
+					<para>
+						Display the elements in the specified set.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
+				<term><option>flush</option></term>
+				<listitem>
+					<para>
+						Remove all elements from the specified set.
+					</para>
+				</listitem>
+			</varlistentry>
+		</variablelist>
+
+		<table frame="all">
+			<title>Set specifications</title>
+			<tgroup cols='3' align='left' colsep='1' rowsep='1'>
+				<colspec colname='c1'/>
+				<colspec colname='c2'/>
+				<colspec colname='c3'/>
+				<thead>
+					<row>
+						<entry>Keyword</entry>
+						<entry>Description</entry>
+						<entry>Type</entry>
+					</row>
+				</thead>
+				<tbody>
+					<row>
+						<entry>type</entry>
+						<entry>data type of set elements</entry>
+						<entry>string:  ipv4_addr, ipv6_addr, ether_addr, inet_proto, inet_service, mark</entry>
+					</row>
+					<row>
+						<entry>flags</entry>
+						<entry>set flags</entry>
+						<entry>string: constant, interval, timeout</entry>
+					</row>
+					<row>
+						<entry>timeout</entry>
+						<entry>time an element stays in the set</entry>
+						<entry>string, decimal followed by unit. Units are: d, h, m, s</entry>
+					</row>
+					<row>
+						<entry>gc-interval</entry>
+						<entry>garbage collection interval, only available when timeout or flag timeout are active</entry>
+						<entry>string, decimal followed by unit. Units are: d, h, m, s</entry>
+					</row>
+					<row>
+						<entry>elements</entry>
+						<entry>elements contained by the set</entry>
+						<entry>set data type</entry>
+					</row>
+					<row>
+						<entry>size</entry>
+						<entry>maximun number of elements in the set</entry>
+						<entry>unsigned integer (64 bit)</entry>
+					</row>
+					<row>
+						<entry>policy</entry>
+						<entry>set policy</entry>
+						<entry>string: performance, memory</entry>
+					</row>
+				</tbody>
+			</tgroup>
+		</table>
+	</refsect1>
+
+	<refsect1>
 		<title>Stateful objects</title>
 		<para>
 			<cmdsynopsis>
-- 
2.7.4

