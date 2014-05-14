From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 4/4] doc: document monitor op
Date: Wed, 14 May 2014 17:36:28 +0200
Message-ID: <20140514153628.25186.45489.stgit@nfdev.cica.es>
References: <20140514153146.25186.58208.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:48874 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753870AbaENPgk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2014 11:36:40 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 6522351EE9B
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2014 15:36:39 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Sd6feAf0xmSq for <netfilter-devel@vger.kernel.org>;
	Wed, 14 May 2014 17:36:29 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 81D0851ED91
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2014 17:36:29 +0200 (CEST)
In-Reply-To: <20140514153146.25186.58208.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's add some documentation about the monitor operation.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 doc/nft.xml |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index 61ca03a..41c0840 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2099,6 +2099,48 @@ filter input iif eth0 drop
 				</programlisting>
 			</para>
 		</refsect2>
+		<refsect2>
+			<title>monitor</title>
+			<para>
+				The monitor command allows you to listen to Netlink events produced
+				by the nf_tables subsystem, related to creation and deletion of objects.
+				When they ocurr, nft will print to stdout the monitored events in either
+				XML, JSON or native nft format.
+			</para>
+			<para>
+				To filter events related to a concrete object, use one of the keywords 'tables', 'chains', 'sets', 'rules', 'elements'.
+			</para>
+			<para>
+				To filter events related to a concrete action, use keyword 'new' or 'destroy'.
+			</para>
+			<para>
+				Hit ^C to finish the monitor operation.
+			</para>
+			<example>
+				<title>Listen to all events, report in native nft format</title>
+				<programlisting>
+% nft monitor
+				</programlisting>
+			</example>
+			<example>
+				<title>Listen to added tables, report in XML format</title>
+				<programlisting>
+% nft monitor new tables xml
+				</programlisting>
+			</example>
+			<example>
+				<title>Listen to deleted rules, report in JSON format</title>
+				<programlisting>
+% nft monitor destroy rules json
+				</programlisting>
+			</example>
+			<example>
+				<title>Listen to both new and destroyed chains, in native nft format</title>
+				<programlisting>
+% nft monitor chains
+				</programlisting>
+			</example>
+		</refsect2>
 	</refsect1>
 
 	<refsect1>

