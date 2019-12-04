Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB20BC43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 18:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9854520675
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 18:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbfLDSSk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 13:18:40 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:46720 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731314AbfLDSSj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 13:18:39 -0500
Received: by mail-wr1-f52.google.com with SMTP id z7so282488wrl.13
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Dec 2019 10:18:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8DPOzz5BlVGHDK9kYbG8cus3R04Kq6AjeYfeBXM6tlA=;
        b=tD9VqKHLDwtZ77TO7uXA7wgvAEB016i/0Vgp4R5Ui9gFRsZFUTtC/D3tBkQr1unMhI
         ncL7IrpKJdo8nZW2j/OLJSjsy2hB3vc/jOBZ8pKetXVLvIxRdqWVtY4YqAqcjDah4lnm
         32ATwiR78XFCzgF7cIg4zSMSfKFsLkmkWbFJCpqURKWsGzrqsPbXoJBHuJA2GJmatNqZ
         /IDC90Yr29gBb/cGEA+DsbNjagu19qr8XLvQH6BqiDRD76hR/HKkt65KNyNqwnDQh+IV
         N9tXdT+lZqRgxHQMft0mYJdFx4GK6BcV/PcQ4/Tbpu/qY9vlkOXt6mvC+9f0bSNhFFbH
         5Viw==
X-Gm-Message-State: APjAAAWY32QoGcKpzujJaVEfvHObHHYtMzLb8GJIbBSEBTYKBBsE2e1U
        lajKV3lfLjrM9pcu3U6WRPIpbv+eMQw=
X-Google-Smtp-Source: APXvYqxgORc3vNOWMrZgX+KhXgTHduXL8FBCLj9zxr4TTKNdU8ZpJizbD14qI3RU5W7Euanfp4GdrQ==
X-Received: by 2002:adf:ff84:: with SMTP id j4mr6077423wrr.27.1575483516489;
        Wed, 04 Dec 2019 10:18:36 -0800 (PST)
Received: from localhost (static.68.138.194.213.ibercom.com. [213.194.138.68])
        by smtp.gmail.com with ESMTPSA id y20sm7339794wmi.25.2019.12.04.10.18.35
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 10:18:35 -0800 (PST)
Subject: [iptables PATCH 7/7] iptables-apply: script and manpage update
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Wed, 04 Dec 2019 19:18:34 +0100
Message-ID: <157548351481.125234.6471420892849038650.stgit@endurance>
In-Reply-To: <157548347377.125234.12163057581146113349.stgit@endurance>
References: <157548347377.125234.12163057581146113349.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: GW <gw.2010@tnode.com>

This is GW's update to iptables-apply. It does a code cleanup and adds two
options: one runs a command and the other writes the sucessful rules file.

I modified the script to use mktemp instead of tempfile. I also fixed a couple
of hyphens in the man page addition.

Arturo says:
 I'm not a strong supporter of this script, but there are many users of it, so
 better do things right and add this patch that should produce no harm anyway.
 This patch is forwarded from the iptables Debian package, where it has been
 around for many years now.

Signed-off-by: GW <gw.2010@tnode.com>
Signed-off-by: Laurence J. Lane <ljlane@debian.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 iptables/iptables-apply      |  302 +++++++++++++++++++++++++++++-------------
 iptables/iptables-apply.8.in |   46 ++++--
 2 files changed, 242 insertions(+), 106 deletions(-)

diff --git a/iptables/iptables-apply b/iptables/iptables-apply
index 819ca4a4..4683b1b4 100755
--- a/iptables/iptables-apply
+++ b/iptables/iptables-apply
@@ -1,174 +1,294 @@
 #!/bin/bash
-#
 # iptables-apply -- a safer way to update iptables remotely
 #
-# Copyright © Martin F. Krafft <madduck@madduck.net>
+# Usage:
+#   iptables-apply [-hV] [-t timeout] [-w savefile] {[rulesfile]|-c [runcmd]}
+#
+# Versions:
+#   * 1.0 Copyright 2006 Martin F. Krafft <madduck@madduck.net>
+#         Original version
+#   * 1.1 Copyright 2010 GW <gw.2010@tnode.com or http://gw.tnode.com/>
+#         Added parameter -c (run command)
+#         Added parameter -w (save successfully applied rules to file)
+#         Major code cleanup
+#
 # Released under the terms of the Artistic Licence 2.0
 #
 set -eu
 
-PROGNAME="${0##*/}";
-VERSION=1.0
+PROGNAME="${0##*/}"
+VERSION=1.1
+
+
+### Default settings
+
+DEF_TIMEOUT=10
+
+MODE=0  # apply rulesfile mode
+# MODE=1  # run command mode
+
+case "$PROGNAME" in
+	(*6*)
+		SAVE=ip6tables-save
+		RESTORE=ip6tables-restore
+		DEF_RULESFILE="/etc/network/ip6tables.up.rules"
+		DEF_SAVEFILE="$DEF_RULESFILE"
+		DEF_RUNCMD="/etc/network/ip6tables.up.run"
+		;;
+	(*)
+		SAVE=iptables-save
+		RESTORE=iptables-restore
+		DEF_RULESFILE="/etc/network/iptables.up.rules"
+		DEF_SAVEFILE="$DEF_RULESFILE"
+		DEF_RUNCMD="/etc/network/iptables.up.run"
+		;;
+esac
+
 
-TIMEOUT=10
+### Functions
 
-function blurb()
-{
-	cat <<-_eof
+function blurb() {
+	cat <<-__EOF__
 	$PROGNAME $VERSION -- a safer way to update iptables remotely
-	_eof
+	__EOF__
 }
 
-function copyright()
-{
-	cat <<-_eof
-	$PROGNAME is C Martin F. Krafft <madduck@madduck.net>.
+function copyright() {
+	cat <<-__EOF__
+	$PROGNAME has been published under the terms of the Artistic Licence 2.0.
 
-	The program has been published under the terms of the Artistic Licence 2.0
-	_eof
+	Original version - Copyright 2006 Martin F. Krafft <madduck@madduck.net>.
+	Version 1.1 - Copyright 2010 GW <gw.2010@tnode.com or http://gw.tnode.com/>.
+	__EOF__
 }
 
-function about()
-{
+function about() {
 	blurb
 	echo
 	copyright
 }
 
-function usage()
-{
-	cat <<-_eof
-	Usage: $PROGNAME [options] ruleset
+function usage() {
+	blurb
+	echo
+	cat <<-__EOF__
+	Usage:
+	  $PROGNAME [-hV] [-t timeout] [-w savefile] {[rulesfile]|-c [runcmd]}
+
+	The script will try to apply a new rulesfile (as output by iptables-save,
+	read by iptables-restore) or run a command to configure iptables and then
+	prompt the user whether the changes are okay. If the new iptables rules cut
+	the existing connection, the user will not be able to answer affirmatively.
+	In this case, the script rolls back to the previous working iptables rules
+	after the timeout expires.
+
+	Successfully applied rules can also be written to savefile and later used
+	to roll back to this state. This can be used to implement a store last good
+	configuration mechanism when experimenting with an iptables setup script:
+	  $PROGNAME -w $DEF_SAVEFILE -c $DEF_RUNCMD
 
-	The script will try to apply a new ruleset (as output by iptables-save/read
-	by iptables-restore) to iptables, then prompt the user whether the changes
-	are okay. If the new ruleset cut the existing connection, the user will not
-	be able to answer affirmatively. In this case, the script rolls back to the
-	previous ruleset.
+	When called as ip6tables-apply, the script will use ip6tables-save/-restore
+	and IPv6 default values instead. Default value for rulesfile is
+	'$DEF_RULESFILE'.
+
+	Options:
+
+	-t seconds, --timeout seconds
+	  Specify the timeout in seconds (default: $DEF_TIMEOUT).
+	-w savefile, --write savefile
+	  Specify the savefile where successfully applied rules will be written to
+	  (default if empty string is given: $DEF_SAVEFILE).
+	-c runcmd, --command runcmd
+	  Run command runcmd to configure iptables instead of applying a rulesfile
+	  (default: $DEF_RUNCMD).
+	-h, --help
+	  Display this help text.
+	-V, --version
+	  Display version information.
+
+	__EOF__
+}
 
-	The following options may be specified, using standard conventions:
+function checkcommands() {
+	for cmd in "${COMMANDS[@]}"; do
+		if ! command -v "$cmd" >/dev/null; then
+			echo "Error: needed command not found: $cmd" >&2
+			exit 127
+		fi
+	done
+}
 
-	-t | --timeout	Specify the timeout in seconds (default: $TIMEOUT)
-	-V | --version	Display version information
-	-h | --help	Display this help text
-	_eof
+function revertrules() {
+	echo -n "Reverting to old iptables rules... "
+	"$RESTORE" <"$TMPFILE"
+	echo "done."
 }
 
-SHORTOPTS="t:Vh";
-LONGOPTS="timeout:,version,help";
+
+### Parsing and checking parameters
+
+TIMEOUT="$DEF_TIMEOUT"
+SAVEFILE=""
+
+SHORTOPTS="t:w:chV";
+LONGOPTS="timeout:,write:,command,help,version";
 
 OPTS=$(getopt -s bash -o "$SHORTOPTS" -l "$LONGOPTS" -n "$PROGNAME" -- "$@") || exit $?
 for opt in $OPTS; do
 	case "$opt" in
-		(-*) unset OPT_STATE;;
+		(-*)
+			unset OPT_STATE
+			;;
 		(*)
 			case "${OPT_STATE:-}" in
-				(SET_TIMEOUT)
-					eval TIMEOUT=$opt
-					case "$TIMEOUT" in
-						([0-9]*) :;;
-						(*)
-							echo "E: non-numeric timeout value." >&2
-							exit 1
-							;;
-					esac
+				(SET_TIMEOUT) eval TIMEOUT=$opt;;
+				(SET_SAVEFILE)
+					eval SAVEFILE=$opt
+					[ -z "$SAVEFILE" ] && SAVEFILE="$DEF_SAVEFILE"
 					;;
 			esac
 			;;
 	esac
 
 	case "$opt" in
+		(-t|--timeout) OPT_STATE="SET_TIMEOUT";;
+		(-w|--write) OPT_STATE="SET_SAVEFILE";;
+		(-c|--command) MODE=1;;
 		(-h|--help) usage >&2; exit 0;;
 		(-V|--version) about >&2; exit 0;;
-		(-t|--timeout) OPT_STATE=SET_TIMEOUT;;
 		(--) break;;
 	esac
 	shift
 done
 
-case "$PROGNAME" in
-	(*6*)
-		SAVE=ip6tables-save
-		RESTORE=ip6tables-restore
-		DEFAULT_FILE=/etc/network/ip6tables
-		;;
-	(*)
-		SAVE=iptables-save
-		RESTORE=iptables-restore
-		DEFAULT_FILE=/etc/network/iptables
-		;;
-esac
-
-FILE="${1:-$DEFAULT_FILE}";
-
-if [[ -z "$FILE" ]]; then
-	echo "E: missing file argument." >&2
+# Validate parameters
+if [ "$TIMEOUT" -ge 0 ] 2>/dev/null; then
+	TIMEOUT=$(($TIMEOUT))
+else
+	echo "Error: timeout must be a positive number" >&2
 	exit 1
 fi
 
-if [[ ! -r "$FILE" ]]; then
-	echo "E: cannot read $FILE" >&2
-	exit 2
+if [ -n "$SAVEFILE" -a -e "$SAVEFILE" -a ! -w "$SAVEFILE" ]; then
+	echo "Error: savefile not writable: $SAVEFILE" >&2
+	exit 8
 fi
 
-COMMANDS=(tempfile "$SAVE" "$RESTORE")
+case "$MODE" in
+	(1)
+		# Treat parameter as runcmd (run command mode)
+		RUNCMD="${1:-$DEF_RUNCMD}"
+		if [ ! -x "$RUNCMD" ]; then
+			echo "Error: runcmd not executable: $RUNCMD" >&2
+			exit 6
+		fi
+
+		# Needed commands
+		COMMANDS=(mktemp "$SAVE" "$RESTORE" "$RUNCMD")
+		checkcommands
+		;;
+	(*)
+		# Treat parameter as rulesfile (apply rulesfile mode)
+		RULESFILE="${1:-$DEF_RULESFILE}";
+		if [ ! -r "$RULESFILE" ]; then
+			echo "Error: rulesfile not readable: $RULESFILE" >&2
+			exit 2
+		fi
+
+		# Needed commands
+		COMMANDS=(mktemp "$SAVE" "$RESTORE")
+		checkcommands
+		;;
+esac
 
-for cmd in "${COMMANDS[@]}"; do
-	if ! command -v $cmd >/dev/null; then
-		echo "E: command not found: $cmd" >&2
-		exit 127
-	fi
-done
 
-umask 0700
+### Begin work
 
-TMPFILE=$(tempfile -p iptap)
+# Store old iptables rules to temporary file
+TMPFILE=`mktemp /tmp/$PROGNAME-XXXXXXXX`
 trap "rm -f $TMPFILE" EXIT HUP INT QUIT ILL TRAP ABRT BUS \
 		      FPE USR1 SEGV USR2 PIPE ALRM TERM
 
 if ! "$SAVE" >"$TMPFILE"; then
+	# An error occured
 	if ! grep -q ipt /proc/modules 2>/dev/null; then
-		echo "E: iptables support lacking from the kernel." >&2
+		echo "Error: iptables support lacking from the kernel" >&2
 		exit 3
 	else
-		echo "E: unknown error saving current iptables ruleset." >&2
+		echo "Error: unknown error saving old iptables rules: $TMPFILE" >&2
 		exit 4
 	fi
 fi
 
+# Legacy to stop the fail2ban daemon if present
 [ -x /etc/init.d/fail2ban ] && /etc/init.d/fail2ban stop
 
-echo -n "Applying new ruleset... "
-if ! "$RESTORE" <"$FILE"; then
-	echo "failed."
-	echo "E: unknown error applying new iptables ruleset." >&2
-	exit 5
-else
-	echo "done."
-fi
+# Configure iptables
+case "$MODE" in
+	(1)
+		# Run command in background and kill it if it times out
+		echo -n "Running command '$RUNCMD'... "
+		"$RUNCMD" &
+		CMD_PID=$!
+		( sleep "$TIMEOUT"; kill "$CMD_PID" 2>/dev/null; exit 0 ) &
+		CMDTIMEOUT_PID=$!
+		if ! wait "$CMD_PID"; then
+			echo "failed."
+			echo "Error: unknown error running command: $RUNCMD" >&2
+			revertrules
+			exit 7
+		else
+			echo "done."
+		fi
+		;;
+	(*)
+		# Apply iptables rulesfile
+		echo -n "Applying new iptables rules from '$RULESFILE'... "
+		if ! "$RESTORE" <"$RULESFILE"; then
+			echo "failed."
+			echo "Error: unknown error applying new iptables rules: $RULESFILE" >&2
+			revertrules
+			exit 5
+		else
+			echo "done."
+		fi
+		;;
+esac
 
+# Prompt user for confirmation
 echo -n "Can you establish NEW connections to the machine? (y/N) "
 
-read -n1 -t "${TIMEOUT:-15}" ret 2>&1 || :
+read -n1 -t "$TIMEOUT" ret 2>&1 || :
 case "${ret:-}" in
 	(y*|Y*)
+		# Success
 		echo
+
+		if [ ! -z "$SAVEFILE" ]; then
+			# Write successfully applied rules to the savefile
+			echo "Writing successfully applied rules to '$SAVEFILE'..."
+			if ! "$SAVE" >"$SAVEFILE"; then
+				echo "Error: unknown error writing successfully applied rules: $SAVEFILE" >&2
+				exit 9
+			fi
+		fi
+
 		echo "... then my job is done. See you next time."
 		;;
 	(*)
-		if [[ -z "${ret:-}" ]]; then
-			echo "apparently not..."
+		# Failed
+		echo
+		if [ -z "${ret:-}" ]; then
+			echo "Timeout! Something happened (or did not). Better play it safe..."
 		else
-			echo
+			echo "No affirmative response! Better play it safe..."
 		fi
-		echo "Timeout. Something happened (or did not). Better play it safe..."
-		echo -n "Reverting to old ruleset... "
-		"$RESTORE" <"$TMPFILE";
-		echo "done."
+		revertrules
 		exit 255
 		;;
 esac
 
+# Legacy to start the fail2ban daemon again
 [ -x /etc/init.d/fail2ban ] && /etc/init.d/fail2ban start
 
 exit 0
diff --git a/iptables/iptables-apply.8.in b/iptables/iptables-apply.8.in
index cdc9c447..f0ed4e5f 100644
--- a/iptables/iptables-apply.8.in
+++ b/iptables/iptables-apply.8.in
@@ -1,6 +1,6 @@
 .\"     Title: iptables-apply
-.\"    Author: Martin F. Krafft
-.\"      Date: Jun 04, 2006
+.\"    Author: Martin F. Krafft, GW
+.\"      Date: May 10, 2010
 .\"
 .TH IPTABLES\-APPLY 8 "" "@PACKAGE_STRING@" "@PACKAGE_STRING@"
 .\" disable hyphenation
@@ -8,23 +8,37 @@
 .SH NAME
 iptables-apply \- a safer way to update iptables remotely
 .SH SYNOPSIS
-\fBiptables\-apply\fP [\-\fBhV\fP] [\fB-t\fP \fItimeout\fP] \fIruleset\-file\fP
+\fBiptables\-apply\fP [\-\fBhV\fP] [\fB-t\fP \fItimeout\fP] [\fB-w\fP \fIsavefile\fP] {[\fIrulesfile]|-c [runcmd]}\fP
 .SH "DESCRIPTION"
 .PP
-iptables\-apply will try to apply a new ruleset (as output by
-iptables\-save/read by iptables\-restore) to iptables, then prompt the
-user whether the changes are okay. If the new ruleset cut the existing
-connection, the user will not be able to answer affirmatively. In this
-case, the script rolls back to the previous ruleset after the timeout
-expired. The timeout can be set with \fB\-t\fP.
+iptables\-apply will try to apply a new rulesfile (as output by
+iptables-save, read by iptables-restore) or run a command to configure
+iptables and then prompt the user whether the changes are okay. If the
+new iptables rules cut the existing connection, the user will not be
+able to answer affirmatively. In this case, the script rolls back to
+the previous working iptables rules after the timeout expires.
 .PP
-When called as \fBip6tables\-apply\fP, the script will use
-ip6tables\-save/\-restore instead.
+Successfully applied rules can also be written to savefile and later used
+to roll back to this state. This can be used to implement a store last good
+configuration mechanism when experimenting with an iptables setup script:
+iptables-apply \-w /etc/network/iptables.up.rules \-c /etc/network/iptables.up.run
+.PP
+When called as ip6tables\-apply, the script will use
+ip6tables\-save/\-restore and IPv6 default values instead. Default
+value for rulesfile is '/etc/network/iptables.up.rules'.
 .SH OPTIONS
 .TP
 \fB\-t\fP \fIseconds\fR, \fB\-\-timeout\fP \fIseconds\fR
-Sets the timeout after which the script will roll back to the previous
-ruleset.
+Sets the timeout in seconds after which the script will roll back
+to the previous ruleset (default: 10).
+.TP
+\fB\-w\fP \fIsavefile\fR, \fB\-\-write\fP \fIsavefile\fR
+Specify the savefile where successfully applied rules will be written to
+(default if empty string is given: /etc/network/iptables.up.rules).
+.TP
+\fB\-c\fP \fIruncmd\fR, \fB\-\-command\fP \fIruncmd\fR
+Run command runcmd to configure iptables instead of applying a rulesfile
+(default: /etc/network/iptables.up.run).
 .TP
 \fB\-h\fP, \fB\-\-help\fP
 Display usage information.
@@ -36,9 +50,11 @@ Display version information.
 \fBiptables-restore\fP(8), \fBiptables-save\fP(8), \fBiptables\fR(8).
 .SH LEGALESE
 .PP
-iptables\-apply is copyright by Martin F. Krafft.
+Original iptables-apply - Copyright 2006 Martin F. Krafft <madduck@madduck.net>.
+Version 1.1 - Copyright 2010 GW <gw.2010@tnode.com or http://gw.tnode.com/>.
 .PP
-This manual page was written by Martin F. Krafft <madduck@madduck.net>
+This manual page was written by Martin F. Krafft <madduck@madduck.net> and
+extended by GW <gw.2010@tnode.com or http://gw.tnode.com/>.
 .PP
 Permission is granted to copy, distribute and/or modify this document
 under the terms of the Artistic License 2.0.

