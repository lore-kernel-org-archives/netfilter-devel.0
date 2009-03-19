From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Automatically load modules in iptables-save
Date: Thu, 19 Mar 2009 17:02:57 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903191701060.14674@fbirervta.pbzchgretzou.qr>
References: <20090316171014.GG31952@ralph.linux2go.dk> <20090319125532.GC20472@ralph.linux2go.dk> <49C24332.2020107@trash.net> <20090319135006.GD20472@ralph.linux2go.dk> <alpine.LSU.2.00.0903191452550.27642@fbirervta.pbzchgretzou.qr> <20090319142935.GE20472@ralph.linux2go.dk>
 <alpine.LSU.2.00.0903191530310.31487@fbirervta.pbzchgretzou.qr> <20090319154301.GF20472@ralph.linux2go.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Soren Hansen <soren@ubuntu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46344 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZCSQDA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:03:00 -0400
In-Reply-To: <20090319154301.GF20472@ralph.linux2go.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-03-19 16:43, Soren Hansen wrote:
>On Thu, Mar 19, 2009 at 03:31:25PM +0100, Jan Engelhardt wrote:
>>>How about the case where someone calls "iptables-save -t foo"? Should
>>>that just return an empty string and exit(0), should it attempt module
>>>load to see if that's even a valid table or something entirely
>>>different?
>> 
>> It should load x_tables.ko and the table... I have a suspicion
>> some unknown users might expect to see "*foo" when using -t.
>
>Alright. This patch should make everyone happy, then..
>
>Index: iptables-1.4.1.1/iptables-save.c

The one who has to merge it - not.
Here is a reworked version that also adds the missing IPv6
and manpage bits, pullable from the usual place at

 git://dev.medozas.de/iptables master

---8<---
iptables-save: module loading corrections

1. Ignore the absence of /proc/net/ip_tables_names, which happens
when x_tables.ko is not loaded. This is equivalent to having
x_tables.ko, but no tabe modules, loaded. As such, success should
be returned.

2. Load table when explicitly requested by the -t option. Users might
expect "*foo" etc. to be output when `iptables-save -t foo` is
executed. So do autoload x_tables.ko and the table in this case.

*. Do this for both iptables-save and ip6tables-save, and adjust
the manpages for the new -M (modprobe program location) option that
is introduced.

Based upon a patch by Soren Hansen.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables-save.8 |    6 +++++-
 ip6tables-save.c |   12 +++++++++---
 iptables-save.8  |    6 +++++-
 iptables-save.c  |   12 +++++++++---
 4 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/ip6tables-save.8 b/ip6tables-save.8
index c8b3e96..47eb44a 100644
--- a/ip6tables-save.8
+++ b/ip6tables-save.8
@@ -21,7 +21,7 @@
 .SH NAME
 ip6tables-save \- Save IPv6 Tables
 .SH SYNOPSIS
-.BR "ip6tables-save " "[-c] [-t table]"
+.BR "ip6tables-save " "[-M modprobe] [-c] [-t table]"
 .br
 .SH DESCRIPTION
 .PP
@@ -29,6 +29,10 @@ ip6tables-save \- Save IPv6 Tables
 is used to dump the contents of an IPv6 Table in easily parseable format
 to STDOUT. Use I/O-redirection provided by your shell to write to a file.
 .TP
+\fB\-M\fP \fImodprobe_program\fP
+Specify the path to the modprobe program. By default, iptables-save will
+inspect /proc/sys/kernel/modprobe to determine the executable's path.
+.TP
 \fB\-c\fR, \fB\-\-counters\fR
 include the current values of all packet and byte counters in the output
 .TP
diff --git a/ip6tables-save.c b/ip6tables-save.c
index 55010c4..97205c1 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -29,6 +29,7 @@ static const struct option options[] = {
 	{.name = "counters", .has_arg = false, .val = 'c'},
 	{.name = "dump",     .has_arg = false, .val = 'd'},
 	{.name = "table",    .has_arg = true,  .val = 't'},
+	{.name = "modprobe", .has_arg = true,  .val = 'M'},
 	{NULL},
 };
 
@@ -42,9 +43,7 @@ static int for_each_table(int (*func)(const char *tablename))
 
 	procfile = fopen("/proc/net/ip6_tables_names", "r");
 	if (!procfile)
-		xtables_error(OTHER_PROBLEM,
-			   "Unable to open /proc/net/ip6_tables_names: %s\n",
-			   strerror(errno));
+		return ret;
 
 	while (fgets(tablename, sizeof(tablename), procfile)) {
 		if (tablename[strlen(tablename) - 1] != '\n')
@@ -68,6 +67,10 @@ static int do_output(const char *tablename)
 		return for_each_table(&do_output);
 
 	h = ip6tc_init(tablename);
+	if (h == NULL) {
+		xtables_load_ko(xtables_modprobe_program, false);
+		h = ip6tc_init(tablename);
+	}
 	if (!h)
 		xtables_error(OTHER_PROBLEM, "Cannot initialize: %s\n",
 			   ip6tc_strerror(errno));
@@ -162,6 +165,9 @@ int main(int argc, char *argv[])
 			/* Select specific table. */
 			tablename = optarg;
 			break;
+		case 'M':
+			xtables_modprobe_program = optarg;
+			break;
 		case 'd':
 			do_output(tablename);
 			exit(0);
diff --git a/iptables-save.8 b/iptables-save.8
index f9c7d65..de5fd48 100644
--- a/iptables-save.8
+++ b/iptables-save.8
@@ -21,7 +21,7 @@
 .SH NAME
 iptables-save \- Save IP Tables
 .SH SYNOPSIS
-.BR "iptables-save " "[-c] [-t table]"
+.BR "iptables-save " "[-M modprobe] [-c] [-t table]"
 .br
 .SH DESCRIPTION
 .PP
@@ -29,6 +29,10 @@ iptables-save \- Save IP Tables
 is used to dump the contents of an IP Table in easily parseable format
 to STDOUT. Use I/O-redirection provided by your shell to write to a file.
 .TP
+\fB\-M\fP \fImodprobe_program\fP
+Specify the path to the modprobe program. By default, iptables-save will
+inspect /proc/sys/kernel/modprobe to determine the executable's path.
+.TP
 \fB\-c\fR, \fB\-\-counters\fR
 include the current values of all packet and byte counters in the output
 .TP
diff --git a/iptables-save.c b/iptables-save.c
index 55cfe6a..6000b49 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -28,6 +28,7 @@ static const struct option options[] = {
 	{.name = "counters", .has_arg = false, .val = 'c'},
 	{.name = "dump",     .has_arg = false, .val = 'd'},
 	{.name = "table",    .has_arg = true,  .val = 't'},
+	{.name = "modprobe", .has_arg = true,  .val = 'M'},
 	{NULL},
 };
 
@@ -40,9 +41,7 @@ static int for_each_table(int (*func)(const char *tablename))
 
 	procfile = fopen("/proc/net/ip_tables_names", "r");
 	if (!procfile)
-		xtables_error(OTHER_PROBLEM,
-			   "Unable to open /proc/net/ip_tables_names: %s\n",
-			   strerror(errno));
+		return ret;
 
 	while (fgets(tablename, sizeof(tablename), procfile)) {
 		if (tablename[strlen(tablename) - 1] != '\n')
@@ -66,6 +65,10 @@ static int do_output(const char *tablename)
 		return for_each_table(&do_output);
 
 	h = iptc_init(tablename);
+	if (h == NULL) {
+		xtables_load_ko(xtables_modprobe_program, false);
+		h = iptc_init(tablename);
+	}
 	if (!h)
 		xtables_error(OTHER_PROBLEM, "Cannot initialize: %s\n",
 			   iptc_strerror(errno));
@@ -162,6 +165,9 @@ main(int argc, char *argv[])
 			/* Select specific table. */
 			tablename = optarg;
 			break;
+		case 'M':
+			xtables_modprobe_program = optarg;
+			break;
 		case 'd':
 			do_output(tablename);
 			exit(0);
-- 
# Created with git-export-patch
