From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack accounting
Date: Sat, 05 Jan 2008 15:36:37 +0100
Message-ID: <477F95F5.8070507@netfilter.org>
References: <477704CB.8030809@channing-bete.com> <477D0553.4010906@netfilter.org> <477D257B.4060901@channing-bete.com> <477DA70E.5080301@channing-bete.com> <477DA84A.3030304@channing-bete.com> <477EAEF0.4000300@channing-bete.com> <477F7BF1.8060705@netfilter.org> <477F928A.70206@channing-bete.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060708040902010406020909"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ben Lentz <BLentz@channing-bete.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40296 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753310AbYAEOg4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 09:36:56 -0500
In-Reply-To: <477F928A.70206@channing-bete.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060708040902010406020909
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Ben Lentz wrote:
> Hmmm... file descriptors for STDIN, STDOUT, and STDERR should be closed,
> too... the setsid() detaches the controlling terminal but a terminal
> still hangs at logout after starting the daemon. A quick-and-dirty patch
> is attached, but there's probably a "better" way to do this.

I have applied a similar patch. I have also moved the initialization
before the daemonization so that the error messages that may occur are
still printed ;)

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------060708040902010406020909
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="x"

Index: src/main.c
===================================================================
--- src/main.c	(revisión: 7171)
+++ src/main.c	(copia de trabajo)
@@ -270,6 +270,18 @@
 	}
 	close(ret);
 
+	/*
+	 * initialization process
+	 */
+
+	if (init() == -1) {
+		close_log();
+		fprintf(stderr, "ERROR: conntrackd cannot start, please "
+				"check the logfile for more info\n");
+		unlink(CONFIG(lockfile));
+		exit(EXIT_FAILURE);
+	}
+
 	/* Daemonize conntrackd */
 	if (type == DAEMON) {
 		pid_t pid, sid;
@@ -287,23 +299,15 @@
 			exit(EXIT_FAILURE);
 		}
 
+		close(STDIN_FILENO);
+		close(STDOUT_FILENO);
+		close(STDERR_FILENO);
+
 		dlog(STATE(log), LOG_NOTICE, "-- starting in daemon mode --");
 	} else
 		dlog(STATE(log), LOG_NOTICE, "-- starting in console mode --");
 
 	/*
-	 * initialization process
-	 */
-
-	if (init() == -1) {
-		close_log();
-		fprintf(stderr, "ERROR: conntrackd cannot start, please "
-				"check the logfile for more info\n");
-		unlink(CONFIG(lockfile));
-		exit(EXIT_FAILURE);
-	}
-
-	/*
 	 * run main process
 	 */
 	run();
Index: ChangeLog
===================================================================
--- ChangeLog	(revisión: 7171)
+++ ChangeLog	(copia de trabajo)
@@ -29,6 +29,7 @@
 o minor irrelevant fixes for uncommon error paths and fix several typos
 o detach daemon from its terminal (Ben Lenitz <BLentz@channing-bete.com>)
 o obsolete `-S' option: Use information provided by the config file
+o daemonize conntrackd after initialization
 
 version 0.9.5 (2007/07/29)
 ------------------------------

--------------060708040902010406020909--
