From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 5/6] nft.8: Describe base chain details
Date: Thu, 10 Aug 2017 19:29:19 +0200
Message-ID: <20170810172920.14893-6-phil@nwl.cc>
References: <20170810172920.14893-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35289 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753145AbdHJRaE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2017 13:30:04 -0400
In-Reply-To: <20170810172920.14893-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This mostly covers base chain types, but also tries to clarify meaning
of priority values, chain policy and the ominous device parameter.

Command synopsis is adjusted as well to point out which parts of a base
chain definition are optional and which are not.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.xml | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 85 insertions(+), 9 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 00095ddafcdad..73ef4d18f462f 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -616,20 +616,26 @@ filter input iif $int_ifs accept
 		<title>Chains</title>
 		<para>
 			<cmdsynopsis>
-				<arg choice="req">add</arg>
+				<group choice="req">
+					<arg>add</arg>
+					<arg>create</arg>
+				</group>
 				<command>chain</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
-				<arg choice="req"><replaceable>table</replaceable></arg>
-				<arg choice="req"><replaceable>chain</replaceable></arg>
-				<arg choice="req"><replaceable>hook</replaceable></arg>
-				<arg choice="req"><replaceable>priority</replaceable></arg>
-				<arg choice="req"><replaceable>policy</replaceable></arg>
-				<arg choice="req"><replaceable>device</replaceable></arg>
+				<arg choice="plain"><replaceable>table</replaceable></arg>
+				<arg choice="plain"><replaceable>chain</replaceable></arg>
+				<arg choice="opt">
+					<arg choice="req">
+						<arg choice="req"><replaceable>type</replaceable></arg>
+						<arg choice="req"><replaceable>hook</replaceable></arg>
+						<arg choice="opt"><replaceable>device</replaceable></arg>
+						<arg choice="req"><replaceable>priority</replaceable></arg>
+					</arg>
+					<arg choice="opt"><replaceable>policy</replaceable></arg>
+				</arg>
 			</cmdsynopsis>
 			<cmdsynopsis>
 				<group choice="req">
-					<arg>add</arg>
-					<arg>create</arg>
 					<arg>delete</arg>
 					<arg>list</arg>
 					<arg>flush</arg>
@@ -710,6 +716,76 @@ filter input iif $int_ifs accept
 				</listitem>
 			</varlistentry>
 		</variablelist>
+
+		<para>
+			For base chains, <command>type</command>, <command>hook</command> and <command>priority</command> parameters are mandatory.
+		</para>
+		<para>
+			<table frame="all">
+				<title>Supported chain types</title>
+				<tgroup cols="4" align="left" colsep="1" rowsep="1">
+					<colspec colname="c1"/>
+					<colspec colname="c2"/>
+					<colspec colname="c3"/>
+					<colspec colname="c4"/>
+					<thead>
+						<row>
+							<entry>Type</entry>
+							<entry>Families</entry>
+							<entry>Hooks</entry>
+							<entry>Description</entry>
+						</row>
+					</thead>
+					<tbody>
+						<row>
+							<entry>filter</entry>
+							<entry>all</entry>
+							<entry>all</entry>
+							<entry>Standard chain type to use in doubt.</entry>
+						</row>
+						<row>
+							<entry>nat</entry>
+							<entry>ip, ip6</entry>
+							<entry>prerouting, input, output, postrouting</entry>
+							<entry>Chains of this type perform Native Address Translation based on conntrack entries. Only the first packet of a connection actually traverses this chain - its rules usually define details of the created conntrack entry (NAT statements for instance).</entry>
+						</row>
+						<row>
+							<entry>route</entry>
+							<entry>ip, ip6</entry>
+							<entry>output</entry>
+							<entry>If a packet has traversed a chain of this
+								type and is about to be accepted, a new route
+								lookup is performed if relevant parts of the IP
+								header have changed. This allows to e.g.
+								implement policy routing selectors in
+								nftables.</entry>
+						</row>
+					</tbody>
+				</tgroup>
+			</table>
+		</para>
+		<para>
+			Apart from the special cases illustrated above (e.g. <literal>nat</literal> type not supporting <literal>forward</literal> hook or <literal>route</literal> type only supporting <literal>output</literal> hook), there are two further quirks worth noticing:
+			<itemizedlist>
+				<listitem>
+					<literal>netdev</literal> family supports merely a single
+					combination, namely <literal>filter</literal> type and
+					<literal>ingress</literal> hook. Base chains in this family also require the <literal>device</literal> parameter to be present since they exist per incoming interface only.
+				</listitem>
+				<listitem>
+					<literal>arp</literal> family supports only
+					<literal>input</literal> and <literal>output</literal>
+					hooks, both in chains of type
+					<literal>filter</literal>.
+				</listitem>
+			</itemizedlist>
+		</para>
+		<para>
+			The <literal>priority</literal> parameter accepts a signed integer value which specifies the order in which chains with same <literal>hook</literal> value are traversed. The ordering is ascending, i.e. lower priority values have precedence over higher ones.
+		</para>
+		<para>
+			Base chains also allow to set the chain's <literal>policy</literal>, i.e. what happens to packets not explicitly accepted or refused in contained rules. Supported policy values are <literal>accept</literal> (which is the default) or <literal>drop</literal>.
+		</para>
 	</refsect1>
 
 	<refsect1>
-- 
2.13.1

