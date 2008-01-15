From: Peter Warasin <peter@endian.com>
Subject: Re: [PATCH v2] Fix CONNMARK mask value demolition
Date: Tue, 15 Jan 2008 12:45:11 +0100
Message-ID: <478C9CC7.30902@endian.com>
References: <4780454E.3050803@endian.com> <478C5B0A.0@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010702000707000601010008"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:40378 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYAOLpR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 06:45:17 -0500
In-Reply-To: <478C5B0A.0@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010702000707000601010008
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi Patrick

Patrick McHardy wrote:
> Good catch, but don't we also need set the mask for --save-mark
> and --restore-mark? I would suggest to move the initialzation
> to a ->init() function.

Oh, yes. That's necessary.
Here's the revised patch with the init() function.

peter

-- 
:: e n d i a n
:: open source - open minds

:: peter warasin
:: http://www.endian.com   :: peter@endian.com

--------------010702000707000601010008
Content-Type: text/x-patch;
 name="fix_CONNMARK_mask_demolition.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix_CONNMARK_mask_demolition.patch"

Fix CONNMARK mask initialisation

This patch fixes the problem that the CONNMARK mask value
has been set to 0 whenever the CONNMARK target options were
not the last options to be processed.
It initalizes the mask value rather than setting it for
each parse.

Signed-off-by: Peter Warasin <peter@endian.com>

---
 extensions/libxt_CONNMARK.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: iptables/extensions/libxt_CONNMARK.c
===================================================================
--- iptables.orig/extensions/libxt_CONNMARK.c	2008-01-06 03:08:18.000000000 +0100
+++ iptables/extensions/libxt_CONNMARK.c	2008-01-15 12:40:54.000000000 +0100
@@ -64,8 +64,6 @@
 	struct xt_connmark_target_info *markinfo
 		= (struct xt_connmark_target_info *)(*target)->data;
 
-	markinfo->mask = 0xffffffffUL;
-
 	switch (c) {
 		char *end;
 	case '1':
@@ -188,6 +186,14 @@
 	}
 }
 
+static void CONNMARK_init(struct xt_entry_target *t)
+{
+	struct xt_connmark_target_info *markinfo
+		= (struct xt_connmark_target_info *)t->data;
+
+	markinfo->mask = 0xffffffffUL;
+}
+
 static struct xtables_target connmark_target = {
 	.family		= AF_INET,
 	.name		= "CONNMARK",
@@ -195,6 +201,7 @@
 	.size		= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.help		= CONNMARK_help,
+	.init           = CONNMARK_init,
 	.parse		= CONNMARK_parse,
 	.final_check	= CONNMARK_check,
 	.print		= CONNMARK_print,
@@ -209,6 +216,7 @@
 	.size		= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.help		= CONNMARK_help,
+	.init           = CONNMARK_init,
 	.parse		= CONNMARK_parse,
 	.final_check	= CONNMARK_check,
 	.print		= CONNMARK_print,

--------------010702000707000601010008
Content-Type: text/x-vcard; charset=utf-8;
 name="peter.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="peter.vcf"

begin:vcard
fn:Peter Warasin
n:;Peter Warasin
org:Endian GmbH/Srl
adr:;;Pillhof 47;Frangart/Frangarto;BZ;I-39010;Italien/Italia
email;internet:peter@endian.com
tel;work:+39 0471 631763
tel;fax:+39 0471 631764
x-mozilla-html:FALSE
url:http://www.endian.com
version:2.1
end:vcard


--------------010702000707000601010008--
