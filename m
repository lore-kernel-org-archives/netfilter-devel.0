From: Arturo Borrero Gonzalez <aborrero@cica.es>
Subject: [conntrack-tools PATCH] doc/debian.conntrackd.init.d: drop file
Date: Thu, 20 Aug 2015 13:56:42 +0200
Message-ID: <20150820115642.13152.48168.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53168 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751400AbbHTL4u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 07:56:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

This file is likely dead code. It's outdated.

Also I think distributors should manage themselves to integrate daemons in
their operating systems. Following this idea, this file doesn't belong here.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 doc/debian.conntrackd.init.d |   48 ------------------------------------------
 1 file changed, 48 deletions(-)
 delete mode 100644 doc/debian.conntrackd.init.d

diff --git a/doc/debian.conntrackd.init.d b/doc/debian.conntrackd.init.d
deleted file mode 100644
index ba847dd..0000000
--- a/doc/debian.conntrackd.init.d
+++ /dev/null
@@ -1,48 +0,0 @@
-#!/bin/sh
-#
-# /etc/init.d/conntrackd
-#
-# Maximilian Wilhelm <max@rfc2324.org>
-#  -- Mon, 06 Nov 2006 18:39:07 +0100
-#
-
-export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
-
-NAME="conntrackd"
-DAEMON=`command -v conntrackd`
-CONFIG="/etc/conntrack/conntrackd.conf"
-PIDFILE="/var/run/${NAME}.pid"
-
-
-# Gracefully exit if there is no daemon (debian way of life)
-if [ ! -x "${DAEMON}" ]; then
-	exit 0
-fi
-
-# Check for config file
-if [ ! -f /etc/conntrackd/conntrackd.conf ]; then
-	echo "Error: There is no config file for $NAME" >&2
-	exit 1;
-fi
-
-case "$1" in
-  start)
-        echo -n "Starting $NAME: "
-	start-stop-daemon --start --quiet --make-pidfile --pidfile "/var/run/${NAME}.pid" --background --exec "${DAEMON}"  && echo "done." || echo "FAILED!"
-	;;
-  stop)
-        echo -n "Stopping $NAME:"
-	start-stop-daemon --stop --quiet --oknodo --pidfile "/var/run/${NAME}.pid" && echo "done." || echo "FAILED!"
-	;;
-
-  restart)
-	$0 start
-	$0 stop
-	;;
-
-  *)
-	echo "Usage: /etc/init.d/conntrackd {start|stop|restart}"
-	exit 1
-esac
-
-exit 0

