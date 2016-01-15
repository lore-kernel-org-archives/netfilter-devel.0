From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [xtables-compat PATCH] iptables: add xtables-compat.8 manpage
Date: Fri, 15 Jan 2016 15:11:51 +0100
Message-ID: <145286711132.19120.16830872786493397972.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:56777 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752839AbcAOOMA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jan 2016 09:12:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new manpage tries to explain to users how to deal with the new compat
tools.

This is really useful for distributions, for example Debian requires a manpage
per binary. This manpage can be used for all compat tools.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/Makefile.am      |    4 +
 iptables/xtables-compat.8 |  177 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 181 insertions(+)
 create mode 100644 iptables/xtables-compat.8

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index c3eb8a8..d07b0a9 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -58,6 +58,10 @@ endif
 man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
                    iptables-xml.1 ip6tables.8 ip6tables-restore.8 \
                    ip6tables-save.8 iptables-extensions.8
+if ENABLE_NFTABLES
+man_MANS	+= xtables-compat.8
+endif
+
 CLEANFILES       = iptables.8 \
 		   xtables-config-parser.c xtables-config-syntax.c
 
diff --git a/iptables/xtables-compat.8 b/iptables/xtables-compat.8
new file mode 100644
index 0000000..25dc078
--- /dev/null
+++ b/iptables/xtables-compat.8
@@ -0,0 +1,177 @@
+.\"
+.\" (C) Copyright 2016, Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" This is free documentation; you can redistribute it and/or
+.\" modify it under the terms of the GNU General Public License as
+.\" published by the Free Software Foundation; either version 2 of
+.\" the License, or (at your option) any later version.
+.\"
+.\" The GNU General Public License's references to "object code"
+.\" and "executables" are to be interpreted as the output of any
+.\" document formatting or typesetting system, including
+.\" intermediate and printed output.
+.\"
+.\" This manual is distributed in the hope that it will be useful,
+.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\" GNU General Public License for more details.
+.\"
+.\" You should have received a copy of the GNU General Public
+.\" License along with this manual; if not, see
+.\" <http://www.gnu.org/licenses/>.
+.\" %%%LICENSE_END
+.\"
+.TH XTABLES-COMPAT 8 "Jan 15, 2015"
+
+.SH NAME
+xtables-compat \- compat tools to migrate from iptables to nftables
+
+.SH DESCRIPTION
+\fBxtables-compat\fP is set of tools to help the system administrator migrate the
+ruleset from \fBiptables(8)\fP, \fBip6tables(8)\fP, \fBarptables(8)\fP, and
+\fBebtables(8)\fP to \fBnftables(8)\fP.
+
+The \fBxtables-compat\fP set is composed of several commands:
+.IP \[bu] 2
+iptables-compat
+.IP \[bu]
+iptables-compat-save
+.IP \[bu]
+iptables-compat-restore
+.IP \[bu]
+ip6tables-compat
+.IP \[bu]
+ip6tables-compat-save
+.IP \[bu]
+ip6tables-compat-restore
+.IP \[bu]
+arptables-compat
+.IP \[bu]
+ebtables-compat
+
+These tools use the libxtables framework extensions and hook to the nf_tables
+kernel subsystem using the \fBnft_compat\fP module.
+
+.SH USAGE
+The compat tools set allows you to manage the nf_tables backend using the
+native syntax of \fBiptables(8)\fP, \fBip6tables(8)\fP, \fBarptables(8)\fP, and
+\fBebtables(8)\fP.
+
+You should use the compat tools exactly the same way as you would use the
+corresponding original tool.
+
+Adding a rule will result in that rule being added to the nf_tables kernel
+subsystem instead.
+Listing the ruleset will use the nf_tables backend as well.
+
+When these tools were designed, the main idea was to replace each legacy binary
+with a symlink to the corresponding compat tool, for example:
+
+.nf
+	/sbin/iptables  --> /usr/sbin/iptables-compat
+	/sbin/ip6tables --> /usr/sbin/ip6tables-compat
+	/sbin/arptables --> /usr/sbin/arptables-compat
+	/sbin/ebtables  --> /usr/sbin/ebtables-compat
+.fi
+
+.SH EXAMPLES
+One basic example is creating the skeleton ruleset in nf_tables from the
+compat tools, in a fresh machine:
+
+.nf
+	root@machine:~# iptables-compat -L
+	[...]
+	root@machine:~# ip6tables-compat -L
+	[...]
+	root@machine:~# arptables-compat -L
+	[...]
+	root@machine:~# ebtables-compat -L
+	[...]
+	root@machine:~# nft list ruleset
+	table ip filter {
+		chain INPUT {
+			type filter hook input priority 0; policy accept;
+		}
+
+		chain FORWARD {
+			type filter hook forward priority 0; policy accept;
+		}
+
+		chain OUTPUT {
+			type filter hook output priority 0; policy accept;
+		}
+	}
+	table ip6 filter {
+		chain INPUT {
+			type filter hook input priority 0; policy accept;
+		}
+
+		chain FORWARD {
+			type filter hook forward priority 0; policy accept;
+		}
+
+		chain OUTPUT {
+			type filter hook output priority 0; policy accept;
+		}
+	}
+	table bridge filter {
+		chain INPUT {
+			type filter hook input priority -200; policy accept;
+		}
+
+		chain FORWARD {
+			type filter hook forward priority -200; policy accept;
+		}
+
+		chain OUTPUT {
+			type filter hook output priority -200; policy accept;
+		}
+	}
+	table arp filter {
+		chain INPUT {
+			type filter hook input priority 0; policy accept;
+		}
+
+		chain FORWARD {
+			type filter hook forward priority 0; policy accept;
+		}
+
+		chain OUTPUT {
+			type filter hook output priority 0; policy accept;
+		}
+	}
+.fi
+
+(please note that in fresh machines, listing the ruleset for the first time
+results in all tables an chain being created).
+
+To migrate your complete filter ruleset, in the case of \fBiptables(8)\fP,
+you would use:
+
+.nf
+	root@machine:~# iptables-save > myruleset		# reads from x_tables
+	root@machine:~# iptables-compat-restore myruleset	# writes to nf_tables
+.fi
+
+
+.SH LIMITATIONS
+You should use \fBLinux kernel >= 4.2\fP.
+
+Some (few) extensions may be not supported (or fully-supported) for whatever
+reason (for example, they were considered obsolete).
+
+To get up-to-date information about this, please head to
+\fBhttp://wiki.nftables.org/\fP.
+
+.SH AUTHORS
+The nftables framework was written by Patrick McHardy <kaber@trash.net> and
+Pablo Neira Ayuso <pablo@netfilter.og>.
+
+This manual page was written by Arturo Borrero Gonzalez
+<arturo.borrero.glez@gmail.com>.
+
+Please send bug reports to \fB<netfilter-devel@lists.netfilter.org>\fP.
+Subscription is required.
+
+This documentation is free/libre under the terms of the GPLv2+.

