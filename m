From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft] doc: Document stateful objects
Date: Wed, 8 Feb 2017 17:30:55 -0200
Message-ID: <20170208193055.GA16329@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34885 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751055AbdBHT6f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Feb 2017 14:58:35 -0500
Received: by mail-qk0-f195.google.com with SMTP id u25so19291941qki.2
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Feb 2017 11:58:34 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds documentation for stateful objects and updates
tables description to mention them.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 doc/nft.xml | 134 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 133 insertions(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 78e112f..9c2fe78 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -453,7 +453,7 @@ filter input iif $int_ifs accept
 		</para>
 
 		<para>
-			Tables are containers for chains and sets. They are identified by their address family
+			Tables are containers for chains, sets and stateful objects. They are identified by their address family
 			and their name. The address family must be one of
 
 			<simplelist type="inline">
@@ -668,6 +668,138 @@ filter input iif $int_ifs accept
 	</refsect1>
 
 	<refsect1>
+		<title>Stateful objects</title>
+		<para>
+			<cmdsynopsis>
+				<group choice="req">
+					<arg>add</arg>
+					<arg>delete</arg>
+					<arg>list</arg>
+					<arg>reset</arg>
+				</group>
+				<command> type</command>
+				<arg choice="opt"><replaceable>family</replaceable></arg>
+				<arg choice="req"><replaceable>table</replaceable></arg>
+				<arg choice="req"><replaceable>object</replaceable></arg>
+			</cmdsynopsis>
+		</para>
+		<para>
+			Stateful objects are attached to tables and are identified by an unique name. They group stateful information from rules, to reference them in rules the keywords "type name" are used e.g. "counter name".
+		</para>
+
+		<variablelist>
+			<varlistentry>
+				<term><option>add</option></term>
+				<listitem>
+					<para>
+						Add a new stateful object in the specified table.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
+				<term><option>delete</option></term>
+				<listitem>
+					<para>
+						Delete the specified object.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
+				<term><option>list</option></term>
+				<listitem>
+					<para>
+						Display stateful information the object holds.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
+				<term><option>reset</option></term>
+				<listitem>
+					<para>
+						List-and-reset stateful object.
+					</para>
+				</listitem>
+			</varlistentry>
+		</variablelist>
+
+		<refsect2>
+			<title>Counter</title>
+			<para>
+				<cmdsynopsis>
+					<command>counter</command>
+					<arg choice="opt">packets bytes</arg>
+				</cmdsynopsis>
+			</para>
+			<table frame="all">
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
+							<entry>packets</entry>
+							<entry>initial count of packets</entry>
+							<entry>unsigned integer (64 bit)</entry>
+						</row>
+						<row>
+							<entry>bytes</entry>
+							<entry>initial count of bytes</entry>
+							<entry>unsigned integer (64 bit)</entry>
+						</row>
+					</tbody>
+				</tgroup>
+			</table>
+		</refsect2>
+
+		<refsect2>
+			<title>Quota</title>
+			<para>
+				<cmdsynopsis>
+					<command>quota</command>
+					<group choice="opt">
+						<arg>over</arg>
+						<arg>until</arg>
+					</group>
+					<arg choice="opt">used</arg>
+				</cmdsynopsis>
+			</para>
+			<table frame="all">
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
+							<entry>quota</entry>
+							<entry>quota limit, used as the quota name</entry>
+							<entry>Two arguments, unsigned interger (64 bit) and string: bytes, kbytes, mbytes. "over" and "until" go before these arguments</entry>
+						</row>
+						<row>
+							<entry>used</entry>
+							<entry>initial value of used quota</entry>
+							<entry>Two arguments, unsigned interger (64 bit) and string: bytes, kbytes, mbytes</entry>
+						</row>
+					</tbody>
+				</tgroup>
+			</table>
+		</refsect2>
+	</refsect1>
+
+	<refsect1>
 		<title>Expressions</title>
 		<para>
 			Expressions represent values, either constants like network addresses, port numbers etc. or data
-- 
2.7.4

