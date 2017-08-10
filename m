From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/6] nft.8: Document operations on ruleset
Date: Thu, 10 Aug 2017 19:29:15 +0200
Message-ID: <20170810172920.14893-2-phil@nwl.cc>
References: <20170810172920.14893-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:57819 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753114AbdHJR35 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2017 13:29:57 -0400
In-Reply-To: <20170810172920.14893-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

People new to nftables and yet unaware of 'list ruleset' and 'flush
ruleset' commands have a hard time. Therefore put description of those
prominently at the top, even before explaining operations on tables and
chains.

Since 'export ruleset' is closely related, document it here as well and
remove it's sparse description from ADDITIONAL COMMANDS section.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.xml | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 72 insertions(+), 15 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 4d03a3dbc75bf..91b9bb378c80a 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -465,6 +465,78 @@ filter input iif $int_ifs accept
 	</refsect1>
 
 	<refsect1>
+		<title>Ruleset</title>
+		<para>
+			<cmdsynopsis>
+				<group choice="req">
+					<arg>list</arg>
+					<arg>flush</arg>
+				</group>
+				<command>ruleset</command>
+				<arg choice="opt"><replaceable>family</replaceable></arg>
+			</cmdsynopsis>
+			<cmdsynopsis>
+				<arg choice="req">export</arg>
+				<arg choice="opt"><command>ruleset</command></arg>
+				<arg choice="req"><replaceable>format</replaceable></arg>
+			</cmdsynopsis>
+		</para>
+
+		<para>
+			The <command>ruleset</command> keyword is used to identify the whole
+			set of tables, chains, etc. currently in place in kernel. The
+			following <command>ruleset</command> commands exist:
+		</para>
+
+		<variablelist>
+			<varlistentry>
+				<term><option>list</option></term>
+				<listitem>
+					<para>
+						Print the ruleset in human-readable format.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
+				<term><option>flush</option></term>
+				<listitem>
+					<para>
+						Clear the whole ruleset. Note that unlike iptables, this
+						will remove all tables and whatever they contain,
+						effectively leading to an empty ruleset - no packet
+						filtering will happen anymore, so the kernel accepts any
+						valid packet it receives.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
+				<term><option>export</option></term>
+				<listitem>
+					<para>
+						Print the ruleset in machine readable format. The
+						mandatory <replaceable>format</replaceable> parameter
+						may be either <literal>xml</literal> or
+						<literal>json</literal>.
+					</para>
+				</listitem>
+			</varlistentry>
+		</variablelist>
+
+		<para>
+			It is possible to limit <command>list</command> and
+			<command>flush</command> to a specific address family only. For a
+			list of valid family names, see <literal>ADDRESS FAMILIES</literal> above.
+		</para>
+
+		<para>
+			Note that contrary to what one might assume, the output generated
+			by <command>export</command> is not parseable by
+			<command>nft -f</command>. Instead, the output of
+			<command>list</command> command serves well for that purpose.
+		</para>
+	</refsect1>
+
+	<refsect1>
 		<title>Tables</title>
 		<para>
 			<cmdsynopsis>
@@ -4362,21 +4434,6 @@ add rule nat prerouting tcp dport 22 redirect to :2222
 			These are some additional commands included in nft.
 		</para>
 		<refsect2>
-			<title>export</title>
-			<para>
-				Export your current ruleset in XML or JSON format to stdout.
-			</para>
-			<para>
-				Examples:
-				<programlisting>
-% nft export xml
-[...]
-% nft export json
-[...]
-				</programlisting>
-			</para>
-		</refsect2>
-		<refsect2>
 			<title>monitor</title>
 			<para>
 				The monitor command allows you to listen to Netlink events produced
-- 
2.13.1

