From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables: add --line-numbers short option
Date: Thu, 31 Oct 2013 13:51:01 -0700
Message-ID: <20131031205101.GB1304@home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:62837 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab3JaUvE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Oct 2013 16:51:04 -0400
Received: by mail-pb0-f48.google.com with SMTP id mc17so3308842pbc.7
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2013 13:51:03 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Internally, -0 is used as a short option to represent --line-numbers.  This
causes confusion, however, when using --line-numbers with a command which
does not support it.  For instance:

    # /usr/local/iptables/sbin/ip6tables -S --line-numbers
    ip6tables v1.4.20: Illegal option `-0' with this command

Fix this by enabling and documenting -0 as a short option for --line-numbers.

Signed-off-by: Phil Oester <kernel@linuxace.com>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ipt-linenums

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 76de367..21f2354 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -259,7 +259,7 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
 "  --wait	-w		wait for the xtables lock\n"
-"  --line-numbers		print line numbers when listing\n"
+"  --line-numbers -0		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 /*"[!] --fragment	-f		match second or further fragments only\n"*/
 "  --modprobe=<command>		try to insert modules using this command\n"
@@ -1332,7 +1332,7 @@ int do_command6(int argc, char *argv[], char **table,
 
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvwnt:m:xc:g:46",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvwnt:m:xc:g:046",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 155c97e..64a1542 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -381,7 +381,7 @@ instead of only the rounded number in K's (multiples of 1000)
 M's (multiples of 1000K) or G's (multiples of 1000M).  This option is
 only relevant for the \fB\-L\fP command.
 .TP
-\fB\-\-line\-numbers\fP
+\fB\-0\fP, \fB\-\-line\-numbers\fP
 When listing rules, add line numbers to the beginning of each rule,
 corresponding to that rule's position in the chain.
 .TP
diff --git a/iptables/iptables.c b/iptables/iptables.c
index d3899bc..fc01536 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -253,7 +253,7 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
 "  --wait	-w		wait for the xtables lock\n"
-"  --line-numbers		print line numbers when listing\n"
+"  --line-numbers -0		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 "[!] --fragment	-f		match second or further fragments only\n"
 "  --modprobe=<command>		try to insert modules using this command\n"
@@ -1328,7 +1328,7 @@ int do_command4(int argc, char *argv[], char **table,
 
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvwnt:m:xc:g:46",
+	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvwnt:m:xc:g:046",
 					   opts, NULL)) != -1) {
 		switch (cs.c) {
 			/*

--+QahgC5+KEYLbs62--
