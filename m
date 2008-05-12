From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: [patch 1/4] Make iptables-restore usable over a pipe
Date: Mon, 12 May 2008 20:20:33 +0200
Message-ID: <1210616433.3442.28.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-gzoGtItBkNKUfyqXzOyY"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:52171 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbYELSUh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 14:20:37 -0400
Received: from henriknordstrom.net (183.159.216.81.static.tb.siw.siwnet.net [81.216.159.183])
	by vps1.henriknordstrom.net (8.13.8/8.13.8/Debian-3) with ESMTP id m4CIKY2i032722
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2008 20:20:34 +0200
Received: from henrik ([127.0.0.1])
	(authenticated bits=0)
	by henriknordstrom.net (8.12.11.20060308/8.12.8) with ESMTP id m4CIKX6f027136
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2008 20:20:34 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-gzoGtItBkNKUfyqXzOyY
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The attached patch flushes stdout between commands to make output
operations (-L etc) in iptables-restore usable over a pipe. stdio by
defaut buffers output if not connected to a terminal.

Regards
Henrik

--=-gzoGtItBkNKUfyqXzOyY
Content-Disposition: attachment; filename=iptables-restore-pipe.patch
Content-Type: text/x-patch; name=iptables-restore-pipe.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: iptables/ip6tables-restore.c
===================================================================
--- iptables.orig/ip6tables-restore.c
+++ iptables/ip6tables-restore.c
@@ -436,6 +436,7 @@ int main(int argc, char *argv[])
 					 &newargv[2], &handle);
 
 			free_argv();
+			fflush(stdout);
 		}
 		if (!ret) {
 			fprintf(stderr, "%s: line %u failed\n",
Index: iptables/iptables-restore.c
===================================================================
--- iptables.orig/iptables-restore.c
+++ iptables/iptables-restore.c
@@ -442,6 +442,7 @@ main(int argc, char *argv[])
 					 &newargv[2], &handle);
 
 			free_argv();
+			fflush(stdout);
 		}
 		if (tablename && (strcmp(tablename, curtable) != 0))
 			continue;

--=-gzoGtItBkNKUfyqXzOyY--

