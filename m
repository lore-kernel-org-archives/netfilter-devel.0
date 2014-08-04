From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] doc: update documentation with 'monitor' and 'export'
Date: Mon, 04 Aug 2014 10:29:45 +0200
Message-ID: <20140804082945.22646.43301.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:48994 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751632AbaHDI3v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2014 04:29:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's add info about 'monitor' and 'export'.

While at it, fix other minors things, like the no-netlink return code and
indentations of the document.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 doc/nft.xml |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 67 insertions(+), 3 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 702891c..41c0840 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2080,6 +2080,70 @@ filter input iif eth0 drop
 	</refsect1>
 
 	<refsect1>
+		<title>Additional commands</title>
+		<para>
+			These are some additional commands included in nft.
+		</para>
+		<refsect2>
+			<title>export</title>
+			<para>
+				Export your current ruleset in XML or JSON format to stdout.
+			</para>
+			<para>
+				Examples:
+				<programlisting>
+% nft export xml
+[...]
+% nft export json
+[...]
+				</programlisting>
+			</para>
+		</refsect2>
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
+	</refsect1>
+
+	<refsect1>
 		<title>Error reporting</title>
 		<para>
 			When an error is detected, nft shows the line(s) containing the error, the position
@@ -2097,7 +2161,7 @@ filter input iif eth0 drop
 			<programlisting>
 &lt;cmdline&gt;:1:19-22: Error: Interface does not exist
 filter output oif eth0
-^^^
+                  ^^^^
 			</programlisting>
 		</example>
 		<example>
@@ -2105,7 +2169,7 @@ filter output oif eth0
 			<programlisting>
 &lt;cmdline&gt;:1:28-36: Error: Right hand side of relational expression (==) must be constant
 filter output tcp dport == tcp dport
-~~ ^^^^^^^^^
+                        ~~ ^^^^^^^^^
 			</programlisting>
 		</example>
 
@@ -2124,7 +2188,7 @@ filter output oif wlan0
 		<para>
 			On success, nft exits with a status of 0. Unspecified
 			errors cause it to exit with a status of 1, memory allocation
-			errors with a status of 2.
+			errors with a status of 2, unable to open Netlink socket with 3.
 		</para>
 	</refsect1>
 

