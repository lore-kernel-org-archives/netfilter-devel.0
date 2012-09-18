From: aft <aftnix@gmail.com>
Subject: [PATCH 2/2] Added userspace plugin for xt_OBSF.c
Date: Tue, 18 Sep 2012 20:25:22 +0600
Message-ID: <1347978322.11478.4.camel@kernel-host-rh6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55951 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab2IROZk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:25:40 -0400
Received: by pbbrr13 with SMTP id rr13so83258pbb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Sep 2012 07:25:40 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

TODO:

1) add a print function
2) add a save function


Signed-off-by: Arif Hossain <aftnix@gmail.com>
---
 extensions/Mbuild       |    1 +
 extensions/libxt_OBSF.c |  150 +++++++++++++++++++++++++++++++++++++++++++++++
 extensions/xt_OBSF.c    |   43 ++++++++------
 extensions/xt_OBSF.h    |    3 +-
 4 files changed, 176 insertions(+), 21 deletions(-)
 create mode 100644 extensions/libxt_OBSF.c

diff --git a/extensions/Mbuild b/extensions/Mbuild
index 1c76e34..f4e5e17 100644
--- a/extensions/Mbuild
+++ b/extensions/Mbuild
@@ -26,3 +26,4 @@ obj-${build_pknock}      += pknock/
 obj-${build_psd}         += libxt_psd.so
 obj-${build_quota2}      += libxt_quota2.so
 obj-${build_gradm}       += libxt_gradm.so
+obj-${build_OBSF}        += libxt_OBSF.so
\ No newline at end of file
diff --git a/extensions/libxt_OBSF.c b/extensions/libxt_OBSF.c
new file mode 100644
index 0000000..e94c91d
--- /dev/null
+++ b/extensions/libxt_OBSF.c
@@ -0,0 +1,150 @@
+#include <stdio.h>
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+
+#include "xt_OBSF.h"
+#include "compat_user.h"
+
+enum {
+	O_OBSF_ENC_KEY,
+	O_OBSF_ENC_KEYLEN,
+	O_OBSF_ENC_TYPE,
+	O_OBSF_ENC_ENC_DEC,
+	O_OBSF_PAD_ENABLE,
+	O_OBSF_PAD_TYPE,
+	O_OBSF_PAD_START,
+	O_OBSF_PAD_STOP,
+};
+
+enum {
+	F_OBSF_ENC_KEY = 1 << O_OBSF_ENC_KEY,
+	F_OBSF_ENC_TYPE = 1 << O_OBSF_ENC_TYPE,
+	F_OBSF_PAD_TYPE = 1 << O_OBSF_PAD_TYPE,
+	F_OBSF_PAD_START = 1 << O_OBSF_PAD_START,
+	F_OBSF_PAD_STOP = 1 << O_OBSF_PAD_STOP,
+};
+
+static void OBSF_help(void)
+{
+	printf(
+		"OBSF target obtions\n"
+		"  --key key --enc-type type aes/arc4 --dec"
+			"key is <32 byte valued"
+			"default is encryption, --dec for decryption"
+			"  --pad to enable padding --pad-type static/random --start start value ---end end value"
+			"start/end value 0-255"
+			"start > end"
+		""
+		);
+}
+
+
+static const struct xt_option_entry OBSF_opts[] = {
+		{
+				.name = "key",
+				.id = O_OBSF_ENC_KEY,
+				.type = XTTYPE_STRING,
+				.flags = XTOPT_PUT,
+				XTOPT_POINTER(struct xt_OBSF_tginfo,key),
+		},
+		{
+				.name = "enc_type",
+				.id = O_OBSF_ENC_TYPE,
+				.type = XTTYPE_STRING,
+		},
+		{
+				.name = "dec",
+				.id = O_OBSF_ENC_ENC_DEC,
+				.type = XTTYPE_NONE,
+		},
+		{
+				.name = "pad",
+				.id = O_OBSF_PAD_ENABLE,
+				.type = XTTYPE_NONE,
+		},
+		{
+				.name = "pad-type",
+				.id = O_OBSF_PAD_TYPE,
+				.type = XTTYPE_STRING,
+		},
+		{
+				.name = "start",
+				.id = O_OBSF_PAD_START,
+				.type = XTTYPE_UINT8,
+				.flags = XTOPT_PUT,
+				XTOPT_POINTER(struct xt_OBSF_tginfo,start),
+		},
+		{
+				.name = "end",
+				.id = O_OBSF_PAD_STOP,
+				.type = XTTYPE_UINT8,
+				.flags = XTOPT_PUT,
+				XTOPT_POINTER(struct xt_OBSF_tginfo,end)
+		},
+		XTOPT_TABLEEND,
+};
+
+static void OBSF_parse(struct xt_option_call *cb)
+{
+	struct xt_OBSF_tginfo *info = cb->data;
+	xtables_option_parse(cb);
+
+	switch(cb->entry->id) {
+	case O_OBSF_ENC_KEY:
+		info->key_len = (__u8)strlen(cb->arg);
+		break;
+	case O_OBSF_ENC_TYPE:
+		if ((strcmp(cb->arg,"arc4")) == 0)
+			info->flags |= XT_OBSF_ENC_ARC4;
+		else if ((strcmp(cb->arg,"aes")) == 0)
+			info->flags |= XT_OBSF_ENC_AES;
+		break;
+	case O_OBSF_ENC_ENC_DEC:
+		info->flags |= XT_OBSF_ENC_DEC;
+		break;
+	case O_OBSF_PAD_ENABLE:
+		info->flags |= XT_OBSF_PAD_ENABLED;
+		break;
+	case O_OBSF_PAD_TYPE:
+		if ((strcmp(cb->arg,"static")) == 0)
+			info->flags |= XT_OBSF_PAD_STATIC;
+		else if ((strcmp(cb->arg,"random")) == 0)
+			info->flags |= XT_OBSF_PAD_RANDOM;
+		break;
+	}
+	if (!(info->flags & XT_OBSF_ENC_DEC))
+		info->flags |= XT_OBSF_ENC_ENC;
+
+	/* padding addition, removal will be dealt in target considering from which
+	 * hook the packet arrived, same can be done for ENC/DEC
+	 */
+
+
+}
+
+
+static void OBSF_print(const void *ip,
+		       const struct xt_entry_target *target, int numeric)
+{
+}
+
+
+static void OBSF_save(const void *ip, const struct xt_entry_target *target)
+{
+}
+
+
+static struct xtables_target obsf_target = {
+				.family  = NFPROTO_UNSPEC,
+				.name    = "OBSF",
+				.version = XTABLES_VERSION,
+				.size    = XT_ALIGN(sizeof(struct xt_OBSF_tginfo)),
+				.userspacesize = XT_ALIGN(sizeof(struct xt_OBSF_tginfo) - sizeof(struct xt_obsf_priv *)),
+				.help = OBSF_help,
+				.print = OBSF_print,
+				.save = OBSF_save,
+				.x6_options = OBSF_opts,
+};
diff --git a/extensions/xt_OBSF.c b/extensions/xt_OBSF.c
index b997133..8fdf6e9 100644
--- a/extensions/xt_OBSF.c
+++ b/extensions/xt_OBSF.c
@@ -7,7 +7,7 @@
 
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_OBSF.h>
+#include "xt_OBSF.h"
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
 
@@ -62,28 +62,33 @@ static unsigned int obsf_tg(struct sk_buff *skb, const struct xt_action_param *p
 
 		if (info->flags & XT_OBSF_ENC_DEC)
 			crypto_blkcipher_decrypt(&desc, &sg, &sg, data_len);
-	}	
+	}
 
-	if (info->flags & XT_OBSF_PAD_STATIC) {
-		if (info->flags & XT_OBSF_PAD_ADD) {
-			/* Add flase bytes */
-		}
+	/* using hook to determine whether to add or remove false bytes */
 
-		if (info->flags & XT_OBSF_PAD_REM) {
-			/* Remove false bytes */
+	if (info->flags & XT_OBSF_PAD_ENABLED) {
+		if (info->flags & XT_OBSF_PAD_STATIC) {
+			if ((par->hooknum) == NF_INET_PRE_ROUTING ) {
+				/* remove padding */
+			}
+			else if ((par->hooknum) == NF_INET_LOCAL_OUT) {
+				/* add padding */
+			}
 		}
-	}
+		else if (info->flags & XT_OBSF_PAD_RANDOM) {
+			if ((par->hooknum) == NF_INET_PRE_ROUTING ) {
 
-	if (info->flags & XT_OBSF_PAD_RANDOM) {
-		if (info->flags & XT_OBSF_PAD_ADD) {
-					/* Add flase bytes */
-		}
+				/* remove padding */
+
+			}
+			else if ((par->hooknum) == NF_INET_LOCAL_OUT) {
+
+				/* add padding */
+			}
 
-		if (info->flags & XT_OBSF_PAD_REM) {
-					/* Remove false bytes */
 		}
-	}
 
+	}
 
 	return NF_ACCEPT;
 }
@@ -119,9 +124,9 @@ static int obsf_tg_check(const struct xt_tgchk_param *par)
 	if ((info->flags & XT_OBSF_PAD_STATIC) && (info->flags & XT_OBSF_PAD_RANDOM))
 		return -EINVAL;
 
-	if ((info->flags & XT_OBSF_PAD_ADD) & (info->flags & XT_OBSF_PAD_REM))
-		return -EINVAL;
-
+	if ((info->flags & XT_OBSF_PAD_ENABLED))
+		if (((info->flags & XT_OBSF_PAD_STATIC)) | ((info->flags & XT_OBSF_PAD_RANDOM)))
+			return -EINVAL;
 	return 0;
 
 	/* failover */
diff --git a/extensions/xt_OBSF.h b/extensions/xt_OBSF.h
index 9d68c72..e99c048 100644
--- a/extensions/xt_OBSF.h
+++ b/extensions/xt_OBSF.h
@@ -9,8 +9,7 @@ enum {
 	XT_OBSF_PAD_RANDOM = 1 << 3,
 	XT_OBSF_ENC_ENC = 1 << 4,
 	XT_OBSF_ENC_DEC = 1 << 5,
-	XT_OBSF_PAD_ADD = 1 << 6,
-	XT_OBSF_PAD_REM = 1 << 7
+	XT_OBSF_PAD_ENABLED = 1 << 6,
 };
 

-- 
1.7.1


