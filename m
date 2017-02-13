From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft] doc: Document maps
Date: Mon, 13 Feb 2017 14:47:11 -0200
Message-ID: <20170213164711.GA12126@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36820 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbdBMQrR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Feb 2017 11:47:17 -0500
Received: by mail-qk0-f193.google.com with SMTP id p22so7902658qka.3
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Feb 2017 08:47:17 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the missing documentation for maps. Also, updates sets
policy to match maps.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 doc/nft.xml | 105 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 104 insertions(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 2825810..ed97859 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -784,7 +784,110 @@ filter input iif $int_ifs accept
 					<row>
 						<entry>policy</entry>
 						<entry>set policy</entry>
-						<entry>string: performance, memory</entry>
+						<entry>string: performance [default], memory</entry>
+					</row>
+				</tbody>
+			</tgroup>
+		</table>
+	</refsect1>
+
+	<refsect1>
+		<title>Maps</title>
+		<para>
+			<cmdsynopsis>
+				<arg choice="req">add</arg>
+				<command> map</command>
+				<arg choice="opt"><replaceable>family</replaceable></arg>
+				<arg choice="req"><replaceable>table</replaceable></arg>
+				<arg choice="req"><replaceable>map</replaceable></arg>
+				{
+				<arg choice="req"><replaceable>type</replaceable></arg>
+				<arg choice="opt"><replaceable>flags</replaceable></arg>
+				<arg choice="opt"><replaceable>elements</replaceable></arg>
+				<arg choice="opt"><replaceable>size</replaceable></arg>
+				<arg choice="opt"><replaceable>policy</replaceable></arg>
+				}
+			</cmdsynopsis>
+			<cmdsynopsis>
+				<group choice="req">
+					<arg>delete</arg>
+					<arg>list</arg>
+				</group>
+				<command> map</command>
+				<arg choice="opt"><replaceable>family</replaceable></arg>
+				<arg choice="req"><replaceable>table</replaceable></arg>
+				<arg choice="req"><replaceable>map</replaceable></arg>
+			</cmdsynopsis>
+		</para>
+		<para>
+			Maps store data based on some specific key used as input, they are uniquely identified by an user-defined name and attached to tables.
+		</para>
+
+		<variablelist>
+			<varlistentry>
+				<term><option>add</option></term>
+				<listitem>
+					<para>
+						Add a new map in the specified table.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
+				<term><option>delete</option></term>
+				<listitem>
+					<para>
+						Delete the specified map.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
+				<term><option>list</option></term>
+				<listitem>
+					<para>
+						Display the elements in the specified map.
+					</para>
+				</listitem>
+			</varlistentry>
+		</variablelist>
+
+		<table frame="all">
+			<title>Map specifications</title>
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
+						<entry>data type of map elements</entry>
+						<entry>string ':' string:  ipv4_addr, ipv6_addr, ether_addr, inet_proto, inet_service, mark, counter, quota. Counter and quota can't be used as keys</entry>
+					</row>
+					<row>
+						<entry>flags</entry>
+						<entry>map flags</entry>
+						<entry>string: constant, interval</entry>
+					</row>
+					<row>
+						<entry>elements</entry>
+						<entry>elements contained by the map</entry>
+						<entry>map data type</entry>
+					</row>
+					<row>
+						<entry>size</entry>
+						<entry>maximun number of elements in the map</entry>
+						<entry>unsigned integer (64 bit)</entry>
+					</row>
+					<row>
+						<entry>policy</entry>
+						<entry>map policy</entry>
+						<entry>string: performance [default], memory</entry>
 					</row>
 				</tbody>
 			</tgroup>
-- 
2.7.4

