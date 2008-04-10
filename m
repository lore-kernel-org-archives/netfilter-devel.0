From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 07/13] libxt_recent: add IPv6 support
Date: Thu, 10 Apr 2008 09:38:12 +0200
Message-ID: <70a2d845890f2472eabfa4b89bbc92bc33618ae4.1207813085.git.jengelh@computergmbh.de>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50178 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbYDJHiV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:38:21 -0400
In-Reply-To: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
In-Reply-To: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 extensions/libxt_recent.c   |   17 +++++
 extensions/libxt_recent.man |  119 +++++++++++++++++------------------
 2 files changed, 76 insertions(+), 60 deletions(-)

diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 2fc5dca..92b66b4 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -224,7 +224,24 @@ static struct xtables_match recent_match = {
     .extra_opts    = recent_opts,
 };
 
+static struct xtables_match recent_mt6_reg = {
+	.version       = IPTABLES_VERSION,
+	.name          = "recent",
+	.revision      = 0,
+	.family        = AF_INET6,
+	.size          = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
+	.help          = recent_help,
+	.init          = recent_init,
+	.parse         = recent_parse,
+	.final_check   = recent_check,
+	.print         = recent_print,
+	.save          = recent_save,
+	.extra_opts    = recent_opts,
+};
+
 void _init(void)
 {
 	xtables_register_match(&recent_match);
+	xtables_register_match(&recent_mt6_reg);
 }
diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index 25be677..f0dc3f4 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -1,93 +1,92 @@
-Allows you to dynamically create a list of IP addresses and then match
-against that list in a few different ways.
-
-For example, you can create a `badguy' list out of people attempting
-to connect to port 139 on your firewall and then DROP all future
-packets from them without considering them.
+Allows you to dynamically create a list of IP addresses and then match against
+that list in a few different ways.
+.PP
+For example, you can create a "badguy" list out of people attempting to connect
+to port 139 on your firewall and then DROP all future packets from them without
+considering them.
 .TP
-.BI "--name " "name"
-Specify the list to use for the commands. If no name is given then 'DEFAULT'
-will be used.
+\fB--name\fR \fIname\fR
+Specify the list to use for the commands. If no name is given then
+\fBDEFAULT\fR will be used.
 .TP
 [\fB!\fR] \fB--set\fR
-This will add the source address of the packet to the list. If the
-source address is already in the list, this will update the existing
-entry. This will always return success (or failure if `!' is passed
-in).
+This will add the source address of the packet to the list. If the source
+address is already in the list, this will update the existing entry. This will
+always return success (or failure if \fB!\fR is passed in).
 .TP
 [\fB!\fR] \fB--rcheck\fR
-Check if the source address of the packet is currently in
-the list.
+Check if the source address of the packet is currently in the list.
 .TP
 [\fB!\fR] \fB--update\fR
 Like \fB--rcheck\fR, except it will update the "last seen" timestamp if it
 matches.
 .TP
 [\fB!\fR] \fB--remove\fR
-Check if the source address of the packet is currently in the list and
-if so that address will be removed from the list and the rule will
-return true. If the address is not found, false is returned.
+Check if the source address of the packet is currently in the list and if so
+that address will be removed from the list and the rule will return true. If
+the address is not found, false is returned.
 .TP
 [\fB!\fR] \fB--seconds \fIseconds\fR
 This option must be used in conjunction with one of \fB--rcheck\fR or
-\fB--update\fR. When used, this will narrow the match to only happen
-when the address is in the list and was seen within the last given
-number of seconds.
+\fB--update\fR. When used, this will narrow the match to only happen when the
+address is in the list and was seen within the last given number of seconds.
 .TP
 [\fB!\fR] \fB--hitcount \fIhits\fR
 This option must be used in conjunction with one of \fB--rcheck\fR or
-\fB--update\fR. When used, this will narrow the match to only happen
-when the address is in the list and packets had been received greater
-than or equal to the given value. This option may be used along with
-\fB--seconds\fR to create an even narrower match requiring a certain
-number of hits within a specific time frame.
+\fB--update\fR. When used, this will narrow the match to only happen when the
+address is in the list and packets had been received greater than or equal to
+the given value. This option may be used along with \fB--seconds\fR to create
+an even narrower match requiring a certain number of hits within a specific
+time frame.
 .TP
 \fB--rttl\fR
 This option must be used in conjunction with one of \fB--rcheck\fR or
-\fB--update\fR. When used, this will narrow the match to only happen
-when the address is in the list and the TTL of the current packet
-matches that of the packet which hit the \fB--set\fR rule. This may be
-useful if you have problems with people faking their source address in
-order to DoS you via this module by disallowing others access to your
-site by sending bogus packets to you.
-.P
+\fB--update\fR. When used, this will narrow the match to only happen when the
+address is in the list and the TTL of the current packet matches that of the
+packet which hit the \fB--set\fR rule. This may be useful if you have problems
+with people faking their source address in order to DoS you via this module by
+disallowing others access to your site by sending bogus packets to you.
+.PP
 Examples:
 .IP
-# iptables -A FORWARD -m recent --name badguy --rcheck --seconds 60 -j DROP
-
-# iptables -A FORWARD -p tcp -i eth0 --dport 139 -m recent --name badguy --set -j DROP
-.P
-Official website (http://snowman.net/projects/ipt_recent/) also has
+iptables -A FORWARD -m recent --name badguy --rcheck --seconds 60 -j DROP
+.IP
+iptables -A FORWARD -p tcp -i eth0 --dport 139 -m recent --name badguy --set -j DROP
+.PP
+Steve's ipt_recent website (http://snowman.net/projects/ipt_recent/) also has
 some examples of usage.
-
-/proc/net/ipt_recent/* are the current lists of addresses and information
+.PP
+\fB/proc/net/xt_recent/*\fR are the current lists of addresses and information
 about each entry of each list.
-
-Each file in /proc/net/ipt_recent/ can be read from to see the current list
-or written two using the following commands to modify the list:
+.PP
+Each file in \fB/proc/net/xt_recent/\fR can be read from to see the current
+list or written two using the following commands to modify the list:
 .TP
-echo xx.xx.xx.xx > /proc/net/ipt_recent/DEFAULT
-to Add to the DEFAULT list
+\fBecho +\fR\fIaddr\fR\fB >/proc/net/xt_recent/DEFAULT\fR
+to add \fIaddr\fR to the DEFAULT list
 .TP
-echo -xx.xx.xx.xx > /proc/net/ipt_recent/DEFAULT
-to Remove from the DEFAULT list
+\fBecho -\fR\fIaddr\fR\fB >/proc/net/xt_recent/DEFAULT\fR
+to remove \fIaddr\fR from the DEFAULT list
 .TP
-echo clear > /proc/net/ipt_recent/DEFAULT
-to empty the DEFAULT list.
-.P
+\fBecho / >/proc/net/xt_recent/DEFAULT\fR
+to flush the DEFAULT list (remove all entries).
+.PP
 The module itself accepts parameters, defaults shown:
 .TP
-.BI "ip_list_tot=" "100"
-Number of addresses remembered per table
+\fBip_list_tot\fR=\fI100\fR
+Number of addresses remembered per table.
+.TP
+\fBip_pkt_list_tot\fR=\fI20\fR
+Number of packets per address remembered.
 .TP
-.BI "ip_pkt_list_tot=" "20"
-Number of packets per address remembered
+\fBip_list_hash_size\fR=\fI0\fR
+Hash table size. 0 means to calculate it based on ip_list_tot, default: 512.
 .TP
-.BI "ip_list_hash_size=" "0"
-Hash table size. 0 means to calculate it based on ip_list_tot, default: 512
+\fBip_list_perms\fR=\fI0644\fR
+Permissions for /proc/net/xt_recent/* files.
 .TP
-.BI "ip_list_perms=" "0644"
-Permissions for /proc/net/ipt_recent/* files
+\fBip_list_uid\fR=\fI0\fR
+Numerical UID for ownership of /proc/net/xt_recent/* files.
 .TP
-.BI "debug=" "0"
-Set to 1 to get lots of debugging info
+\fBip_list_gid\fR=\fI0\fR
+Numerical GID for ownership of /proc/net/xt_recent/* files.
-- 
1.5.5.rc3

