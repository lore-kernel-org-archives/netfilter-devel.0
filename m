From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 6/6] doc: nft: document flowtable
Date: Tue, 23 Jan 2018 13:16:22 +0100
Message-ID: <20180123121622.16287-6-pablo@netfilter.org>
References: <20180123121622.16287-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44816 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751323AbeAWMQe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jan 2018 07:16:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2477C2519A9
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 117ACDA7F7
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0DBF1DA809
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:31 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C8FCB41E4817
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 13:16:30 +0100 (CET)
In-Reply-To: <20180123121622.16287-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Document the new flowtable objects available since Linux kernel 4.16-rc.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.xml | 103 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index 9e979af3c280..1b901c17b5a0 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1160,6 +1160,91 @@ filter input iif $int_ifs accept
 	</refsect1>
 
 	<refsect1>
+		<title>Flowtables</title>
+		<para>
+			<cmdsynopsis>
+				<group choice="req">
+					<arg>add</arg>
+					<arg>create</arg>
+				</group>
+				<command>flowtable</command>
+				<arg choice="opt"><replaceable>family</replaceable></arg>
+				<arg choice="plain"><replaceable>table</replaceable></arg>
+				<arg choice="plain"><replaceable>flowtable</replaceable></arg>
+				<arg choice="req">
+					hook <replaceable>hook</replaceable>
+					priority <replaceable>priority</replaceable> ;
+					devices = { <replaceable>device</replaceable>[,...] } ;
+				</arg>
+			</cmdsynopsis>
+			<cmdsynopsis>
+				<group choice="req">
+					<arg>delete</arg>
+					<arg>list</arg>
+				</group>
+				<command>flowtable</command>
+				<arg choice="opt"><replaceable>family</replaceable></arg>
+				<replaceable>table</replaceable>
+				<replaceable>flowtable</replaceable>
+			</cmdsynopsis>
+		</para>
+
+		<para>
+			Flowtables allow you to accelerate packet forwarding in software.
+			Flowtables entries are represented through a tuple that is composed of the
+			input interface, source and destination address, source and destination
+			port; and layer 3/4 protocols. Each entry also caches the destination
+			interface and the gateway address - to update the destination link-layer
+			address - to forward packets. The ttl and hoplimit fields are also
+			decremented. Hence, flowtables provides an alternative path that allow
+			packets to bypass the classic forwarding path. Flowtables reside in the
+			ingress hook, that is located before the prerouting hook. You can select
+			what flows you want to offload through the <literal>flow offload</literal>
+			expression from the <literal>forward</literal> chain. Flowtables are
+			identified by their address family and their name. The address family
+			must be one of
+
+			<simplelist type="inline">
+				<member><literal>ip</literal></member>
+				<member><literal>ip6</literal></member>
+				<member><literal>inet</literal></member>
+			</simplelist>.
+
+			The <literal>inet</literal> address family is a dummy family which is used to create
+			hybrid IPv4/IPv6 tables.
+
+			When no address family is specified, <literal>ip</literal> is used by default.
+		</para>
+
+		<variablelist>
+			<varlistentry>
+				<term><option>add</option></term>
+				<listitem>
+					<para>
+						Add a new flowtable for the given family with the given name.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
+				<term><option>delete</option></term>
+				<listitem>
+					<para>
+						Delete the specified flowtable.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
+				<term><option>list</option></term>
+				<listitem>
+					<para>
+						List all flowtables.
+					</para>
+				</listitem>
+			</varlistentry>
+		</variablelist>
+	</refsect1>
+
+	<refsect1>
 		<title>Stateful objects</title>
 		<para>
 			<cmdsynopsis>
@@ -4917,6 +5002,24 @@ add rule nat prerouting tcp dport 22 redirect to :2222
 				</example>
 			</para>
 		</refsect2>
+
+		<refsect2>
+			<title>Flow offload statement</title>
+			<para>
+				A flow offload statement allows us to select what flows
+				you want to accelerate forwarding through layer 3 network
+				stack bypass. You have to specify the flowtable name where
+				you want to offload this flow.
+			</para>
+			<para>
+				<cmdsynopsis>
+					<command>flow offload</command>
+					<literal>@flowtable</literal>
+				</cmdsynopsis>
+			</para>
+
+		</refsect2>
+
 		<refsect2>
 			<title>Queue statement</title>
 			<para>
-- 
2.11.0

