From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1/8] Import iptables-apply
Date: Sun, 13 Apr 2008 10:25:47 +0200
Message-ID: <1ef315a194b6db19e54a835a0b7a77ebec71a8c7.1208075035.git.jengelh@computergmbh.de>
References: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36083 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbYDMIZ4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:25:56 -0400
In-Reply-To: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 iptables-apply   |  174 ++++++++++++++++++++++++++++++++++++++++++++++
 iptables-apply.8 |   44 ++++++++++++
 2 files changed, 218 insertions(+), 0 deletions(-)
 create mode 100755 iptables-apply
 create mode 100644 iptables-apply.8

diff --git a/iptables-apply b/iptables-apply
new file mode 100755
index 0000000..5fec76b
--- /dev/null
+++ b/iptables-apply
@@ -0,0 +1,174 @@
+#!/bin/bash
+#
+# iptables-apply -- a safer way to update iptables remotely
+#
+# Copyright =C2=A9 Martin F. Krafft <madduck@madduck.net>
+# Released under the terms of the Artistic Licence 2.0
+#
+set -eu
+
+PROGNAME=3D"${0##*/}";
+VERSION=3D1.0
+
+TIMEOUT=3D10
+DEFAULT_FILE=3D/etc/network/iptables
+
+function blurb()
+{
+	cat <<-_eof
+	$PROGNAME $VERSION -- a safer way to update iptables remotely
+	_eof
+}
+
+function copyright()
+{
+	cat <<-_eof
+	$PROGNAME is C Martin F. Krafft <madduck@madduck.net>.
+
+	The program has been published under the terms of the Artistic Licenc=
e 2.0
+	_eof
+}
+
+function about()
+{
+	blurb
+	echo
+	copyright
+}
+
+function usage()
+{
+	cat <<-_eof
+	Usage: $PROGNAME [options] ruleset
+
+	The script will try to apply a new ruleset (as output by iptables-sav=
e/read
+	by iptables-restore) to iptables, then prompt the user whether the ch=
anges
+	are okay. If the new ruleset cut the existing connection, the user wi=
ll not
+	be able to answer affirmatively. In this case, the script rolls back =
to the
+	previous ruleset.
+
+	The following options may be specified, using standard conventions:
+
+	-t | --timeout	Specify the timeout in seconds (default: $TIMEOUT)
+	-V | --version	Display version information
+	-h | --help	Display this help text
+	_eof
+}
+
+SHORTOPTS=3D"t:Vh";
+LONGOPTS=3D"timeout:,version,help";
+
+OPTS=3D$(getopt -s bash -o "$SHORTOPTS" -l "$LONGOPTS" -n "$PROGNAME" =
-- "$@") || exit $?
+for opt in $OPTS; do
+	case "$opt" in
+		(-*) unset OPT_STATE;;
+		(*)
+			case "${OPT_STATE:-}" in
+				(SET_TIMEOUT)
+					eval TIMEOUT=3D$opt
+					case "$TIMEOUT" in
+						([0-9]*) :;;
+						(*)
+							echo "E: non-numeric timeout value." >&2
+							exit 1
+							;;
+					esac
+					;;
+			esac
+			;;
+	esac
+
+	case "$opt" in
+		(-h|--help) usage >&2; exit 0;;
+		(-V|--version) about >&2; exit 0;;
+		(-t|--timeout) OPT_STATE=3DSET_TIMEOUT;;
+		(--) break;;
+	esac
+	shift
+done
+
+FILE=3D"${1:-$DEFAULT_FILE}";
+
+if [[ -z "$FILE" ]]; then
+	echo "E: missing file argument." >&2
+	exit 1
+fi
+
+if [[ ! -r "$FILE" ]]; then
+	echo "E: cannot read $FILE" >&2
+	exit 2
+fi
+
+case "${0##*/}" in
+	(*6*)
+		SAVE=3Dip6tables-save
+		RESTORE=3Dip6tables-restore
+		;;
+	(*)
+		SAVE=3Diptables-save
+		RESTORE=3Diptables-restore
+		;;
+esac
+
+COMMANDS=3D(tempfile "$SAVE" "$RESTORE")
+
+for cmd in "${COMMANDS[@]}"; do
+	if ! command -v $cmd >/dev/null; then
+		echo "E: command not found: $cmd" >&2
+		exit 127
+	fi
+done
+
+umask 0700
+
+TMPFILE=3D$(tempfile -p iptap)
+trap "rm -f $TMPFILE" EXIT 1 2 3 4 5 6 7 8 10 11 12 13 14 15
+
+if ! "$SAVE" >"$TMPFILE"; then
+	if ! grep -q ipt /proc/modules 2>/dev/null; then
+		echo "E: iptables support lacking from the kernel." >&2
+		exit 3
+	else
+		echo "E: unknown error saving current iptables ruleset." >&2
+		exit 4
+	fi
+fi
+
+[ -x /etc/init.d/fail2ban ] && /etc/init.d/fail2ban stop
+
+echo -n "Applying new ruleset... "
+if ! "$RESTORE" <"$FILE"; then
+	echo "failed."
+	echo "E: unknown error applying new iptables ruleset." >&2
+	exit 5
+else
+	echo done.
+fi
+
+echo -n "Can you establish NEW connections to the machine? (y/N) "
+
+read -n1 -t "${TIMEOUT:-15}" ret 2>&1 || :
+case "${ret:-}" in
+	(y*|Y*)
+		echo
+		echo ... then my job is done. See you next time.
+		;;
+	(*)
+		if [[ -z "${ret:-}" ]]; then
+			echo "apparently not..."
+		else
+			echo
+		fi
+		echo "Timeout. Something happened (or did not). Better play it safe.=
=2E."
+		echo -n "Reverting to old ruleset... "
+		"$RESTORE" <"$TMPFILE";
+		echo done.
+		exit 255
+		;;
+esac
+
+[ -x /etc/init.d/fail2ban ] && /etc/init.d/fail2ban start
+
+exit 0
+
+# vim:noet:sw=3D8
diff --git a/iptables-apply.8 b/iptables-apply.8
new file mode 100644
index 0000000..8208fd0
--- /dev/null
+++ b/iptables-apply.8
@@ -0,0 +1,44 @@
+.\"     Title: iptables-apply
+.\"    Author: Martin F. Krafft
+.\"      Date: Jun 04, 2006
+.\"
+.TH iptables\-apply 8 2006-06-04
+.\" disable hyphenation
+.nh
+.SH NAME
+iptables-apply \- a safer way to update iptables remotely
+.SH SYNOPSIS
+\fBiptables\-apply\fP [\-\fBhV\fP] [\fB-t\fP \fItimeout\fP] \fIruleset=
\-file\fP
+.SH "DESCRIPTION"
+.PP
+iptables\-apply will try to apply a new ruleset (as output by
+iptables\-save/read by iptables\-restore) to iptables, then prompt the
+user whether the changes are okay. If the new ruleset cut the existing
+connection, the user will not be able to answer affirmatively. In this
+case, the script rolls back to the previous ruleset after the timeout
+expired. The timeout can be set with \fB\-t\fP.
+.PP
+When called as ip6tables\-apply, the script will use
+ip6tables\-save/\-restore instead.
+.SH OPTIONS
+.TP
+\fB\-t\fP \fIseconds\fR, \fB\-\-timeout\fP \fIseconds\fR
+Sets the timeout after which the script will roll back to the previous
+ruleset.
+.TP
+\fB\-h\fP, \fB\-\-help\fP
+Display usage information.
+.TP
+\fB\-V\fP, \fB\-\-version\fP
+Display version information.
+.SH "SEE ALSO"
+.PP
+\fBiptables-restore\fP(8), \fBiptables-save\fP(8), \fBiptables\fR(8).
+.SH LEGALESE
+.PP
+iptables\-apply is copyright by Martin F. Krafft.
+.PP
+This manual page was written by Martin F. Krafft <madduck@madduck.net>
+.PP
+Permission is granted to copy, distribute and/or modify this document
+under the terms of the Artistic License 2.0.
--=20
1.5.5.rc3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
