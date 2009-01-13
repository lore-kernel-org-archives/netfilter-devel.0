From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables manpage and ICMP type/code
Date: Tue, 13 Jan 2009 15:30:50 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901131521430.23531@fbirervta.pbzchgretzou.qr>
References: <200901131508.06692.vstinner@inl.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Victor Stinner <vstinner@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53370 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbZAMOaw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:30:52 -0500
In-Reply-To: <200901131508.06692.vstinner@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-01-13 15:08, Victor Stinner wrote:
>iptables supports ICMP code filtering, but it's not documented in the manpage.
>Attached patch fixes the manpage, [...]:
>-       --icmp-type [!] typename
>+       --icmp-type [!] type[/code]|typename
>              This allows specification of the ICMP type, which can be a
>              the command
>               iptables -p icmp -h
>
>It changes also the text style: keywords are underlined.

Actually \fI is italic (it's "I" for a reason); it's just that,
now that you mention it, there seems to be a glitch in `man`
that causes it to be displayed as underline.

>-[\fB!\fP] \fB\-\-icmp\-type\fP \fItypename\fP
>+\fB\-\-icmp\-type\fP [\fB!\fP] \fItype\fP[\fB/\fP\fIcode\fP]|\fItypename\fP

This is old syntax.

> This allows specification of the ICMP type, which can be a numeric
>-ICMP type, or one of the ICMP type names shown by the command
>+ICMP
>+.IR type ,
>+.IR type
>+and
>+.IR code ,

'type' did not refer to the placeholder, but the type in general,
hence it was not italic to begin with. I think this should not
change, either.



parent 3e95daeb83446a61afa86914c9f1a03fa257537d (v1.4.3-rc1-19-g3e95dae)
commit aa171d33c6d86940a057db2bd037f2f0106f1221
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jan 13 15:30:10 2009 +0100

doc: augment ICMP manpage by type/code syntax

The ICMP match module also allows numeric type/code as in
"--icmp-type type/code". Document it.

Based upon a patch by Victor Stinner <vstinner@inl.fr>.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_icmp.c   |    2 +-
 extensions/libipt_icmp.man |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index d0b7bb3..fa5a540 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -102,7 +102,7 @@ static void icmp_help(void)
 	printf(
 "icmp match options:\n"
 "[!] --icmp-type typename	match icmp type\n"
-"				(or numeric type or type/code)\n");
+"[!] --icmp-type type[/code]	(or numeric type or type/code)\n");
 	print_icmptypes();
 }
 
diff --git a/extensions/libipt_icmp.man b/extensions/libipt_icmp.man
index 8c1bdbe..1039704 100644
--- a/extensions/libipt_icmp.man
+++ b/extensions/libipt_icmp.man
@@ -1,9 +1,9 @@
 This extension can be used if `\-\-protocol icmp' is specified. It
 provides the following option:
 .TP
-[\fB!\fP] \fB\-\-icmp\-type\fP \fItypename\fP
+[\fB!\fP] \fB\-\-icmp\-type\fP {\fItype\fP[\fB/\fP\fIcode\fP]|\fItypename\fP}
 This allows specification of the ICMP type, which can be a numeric
-ICMP type, or one of the ICMP type names shown by the command
+ICMP type, type/code pair, or one of the ICMP type names shown by the command
 .nf
  iptables \-p icmp \-h
 .fi
-- 
# Created with git-export-patch
