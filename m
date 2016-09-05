From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [conntrack-tools PATCH 4/4 v2] doc/manual/conntrack-tools: include
 some bits about init systems
Date: Mon, 05 Sep 2016 09:16:45 +0200
Message-ID: <147305973403.17904.10544144874704834411.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:38404 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753859AbcIEHQn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 03:16:43 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 093CF51F243
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 07:16:40 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id n_y0D-zC8OTn for <netfilter-devel@vger.kernel.org>;
        Mon,  5 Sep 2016 09:16:34 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id B665D51F23B
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 09:16:33 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Update the conntrack-tools manual to include some bits regarding init systems
and the integration with systemd.

More on this topic here:
 http://ral-arturo.blogspot.com.es/2016/08/why-conntrackd-in-debian-is-better-with.html

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: include suggestions reported by Rami Rosen.

 doc/manual/conntrack-tools.tmpl |   51 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/doc/manual/conntrack-tools.tmpl b/doc/manual/conntrack-tools.tmpl
index 87a792e..3e83d78 100644
--- a/doc/manual/conntrack-tools.tmpl
+++ b/doc/manual/conntrack-tools.tmpl
@@ -1185,4 +1185,55 @@ not enough space errors:                   0
 
 </chapter>
 
+  <chapter id="system-integration"><title>System integration</title>
+
+  <para>
+	You may want to integrate conntrackd into your system in order to build
+	a robust firewall cluster. You should take a look at how the linux
+	distro of your choose does this, as there are some interesting things
+	to take into account.
+  </para>
+
+  <para>
+	Depending on the architecture of the firewall cluster, you may want to
+	sync each node after a fallback operation, so the new node
+	inmediately knows the connection of the other. This is specially
+	interesting in <emphasis>Active-Active</emphasis> mode.
+  </para>
+
+  <para>
+	This can be done using <emphasis>conntrackd -n</emphasis> just after
+	the new node has joined the conntrackd cluster, for example at boot
+	time. These operations require the main conntrackd daemon to open the
+	UNIX socket to receive the order from the
+	<emphasis>conntrackd -n</emphasis> call.
+  </para>
+
+  <para>
+	Care must be taken that no race conditions happens (i.e, the UNIX
+	socket is actually opened before <emphasis>conntrackd -n</emphasis> is
+	launched). Otherwise, you may end with a new node (after fallback)
+	which doesn't know any connection states from the other node.
+  </para>
+
+  <para>
+	Since <emphasis>conntrack-tools 1.4.4</emphasis>, the conntrackd
+	daemon includes integration with <emphasis>libsystemd</emphasis>. If
+	conntrackd is configured at build time with this support
+	(using <emphasis>--enable-systemd</emphasis>), then you can
+	use <emphasis>Systemd on</emphasis> in the
+	<emphasis>conntrackd.conf</emphasis> main configuration file.
+	To benefit from this integration, you should use a systemd service file
+	of <emphasis>Type=notify</emphasis>, which also includes support for
+	the systemd watchdog.
+  </para>
+
+  <para>
+	Using systemd and conntrackd with libsystemd support and a service file
+	of Type=notify means that conntrackd will notify of its readiness to
+	systemd, so you can launch <emphasis>conntrackd -n</emphasis> safely,
+	avoiding such race conditions.
+  </para>
+
+  </chapter>
 </book>

