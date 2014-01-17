From: Andrew Smith <iamasmith.home@gmail.com>
Subject: xtables-addons implementation of XOR target
Date: Fri, 17 Jan 2014 11:14:45 +0000
Message-ID: <CADb65V4NB2a2XbrCsNmSKYuDekv3yMM8fizTmQHenA+LgEsSHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:48347 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaAQLOq convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jan 2014 06:14:46 -0500
Received: by mail-ve0-f170.google.com with SMTP id cz12so1546154veb.29
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jan 2014 03:14:45 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I had a requirement for some proof of concept work I was performing to
have a very simple layer 3 obfuscation so it was useful to me and
perhaps others to have the XOR target available. Tunnelling wasn't an
option since I needed to preserve some multicast discovery without
changing the component that was multicasting.

I've reimplemented the target for xtables and corrected some potential
buffer overrun code that I spotted. Diffs are attached for the 2.4 and
the 1.47.1 tags so that 2.6.x Kernel owners can use the target as well
as 3.x Kernel owners.

This has been tested with FC20 and with CentOS 6.5.

RedHat/CentOS on a 2.6.32 Kernel requires another tweak of course to
compat_xtables.c as unlike other 2.6.32 Kernels RedHat/CentOS require
the fragflg parameter to ipv6_find_hdr in xtnu_ipv6_find_hdr but I
guess that's a localising patch that anybody building for
RedHat/CentOS should introduce themselves as part of their .SPEC for
creating an RPM.

In my POC scenario I needed to use CentOS 6.5 but created the 2.4
version as well with minor changes from **pskb to *pskb and tested so
that there would be a target compatible with the project latest
version.

man xtables-addons has also been enhanced with a proper explanation of
the target and in particularly the --block-size parameter that always
lacked adequate explanation.


=46irstly the diff from the 2.4 tag..

diff --git a/extensions/Kbuild b/extensions/Kbuild
index c05d5c0..b6c6cff 100644
--- a/extensions/Kbuild
+++ b/extensions/Kbuild
@@ -10,6 +10,7 @@ obj-${build_CHAOS}       +=3D xt_CHAOS.o
 obj-${build_DELUDE}      +=3D xt_DELUDE.o
 obj-${build_DHCPMAC}     +=3D xt_DHCPMAC.o
 obj-${build_DNETMAP}     +=3D xt_DNETMAP.o
+obj-${build_XOR}     +=3D xt_XOR.o
 ifeq (${VERSION},3)
 obj-${build_ECHO}        +=3D xt_ECHO.o
 endif
diff --git a/extensions/Mbuild b/extensions/Mbuild
index 1176948..2fdcdc0 100644
--- a/extensions/Mbuild
+++ b/extensions/Mbuild
@@ -5,6 +5,7 @@ obj-${build_CHAOS}       +=3D libxt_CHAOS.so
 obj-${build_DELUDE}      +=3D libxt_DELUDE.so
 obj-${build_DHCPMAC}     +=3D libxt_DHCPMAC.so libxt_dhcpmac.so
 obj-${build_DNETMAP}     +=3D libxt_DNETMAP.so
+obj-${build_XOR} +=3D libxt_XOR.so
 obj-${build_ECHO}        +=3D libxt_ECHO.so
 obj-${build_IPMARK}      +=3D libxt_IPMARK.so
 obj-${build_LOGMARK}     +=3D libxt_LOGMARK.so
diff --git a/extensions/libxt_XOR.c b/extensions/libxt_XOR.c
new file mode 100644
index 0000000..a029547
--- /dev/null
+++ b/extensions/libxt_XOR.c
@@ -0,0 +1,110 @@
+/*
+ * "XOR" target extension for xtables-addons
+ * Copyright =A9 Andrew Smith, 2014
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License; either
+ * version 2 of the License, or any later version, as published by the
+ * Free Software Foundation.
+ */
+#include <netinet/in.h>
+#include <getopt.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <xtables.h>
+#include <linux/netfilter.h>
+#include "xt_XOR.h"
+#include "compat_user.h"
+
+enum {
+ FLAGS_KEY =3D 1 << 0,
+        FLAGS_BLOCK =3D 1 << 1,
+};
+
+static const struct option xor_opts[] =3D {
+ {.name =3D "key", .has_arg =3D true, .val =3D 'k'},
+        {.name =3D "block-size", .has_arg =3D true, .val =3D'b'},
+ {},
+};
+
+static void xor_help(void)
+{
+ printf(
+ "XOR target options:\n"
+ "    --key <string>\n"
+ "    --block-size <size>\n"
+ );
+}
+
+static int
+xor_parse(int c, char **argv, int invert, unsigned int *flags,
+                  const void *entry, struct xt_entry_target **target)
+{
+ struct xt_xor_info *info =3D (void *)(*target)->data;
+        unsigned long v;
+
+ switch (c) {
+ case 'k':
+                if (strlen(optarg) > sizeof(info->key))
+ xtables_error(PARAMETER_PROBLEM, "XOR: Maximum key size is
%zu",sizeof(info->key));
+ strncpy(info->key, optarg, sizeof(info->key));
+                *flags |=3D FLAGS_KEY;
+ return true;
+        case 'b':
+ if (!xtables_strtoul(optarg, NULL, &v, 1, 5))
+ xtables_param_act(XTF_BAD_VALUE, "XOR",
+ "--block-size", optarg);
+                info->block_size =3D v;
+                *flags |=3D FLAGS_BLOCK;
+                return true;
+ }
+ return false;
+}
+static void xor_check(unsigned int flags)
+{
+ if (!(flags & FLAGS_KEY))
+ xtables_error(PARAMETER_PROBLEM, "XOR: "
+ "\"--key\" is required.");
+ if (!(flags & FLAGS_BLOCK))
+ xtables_error(PARAMETER_PROBLEM, "XOR: "
+ "\"--block-size\" is required.");
+}
+
+static void
+xor_print(const void *entry, const struct xt_entry_target *target,
+                  int numeric)
+{
+ const struct xt_xor_info *info =3D (const void *)target->data;
+ printf("  --key %s --block-size %d ",info->key, info->block_size);
+}
+
+static void
+xor_save(const void *entry, const struct xt_entry_target *target)
+{
+ const struct xt_xor_info *info =3D (const void *)target->data;
+ printf("  --key %s --block-size %d ",info->key, info->block_size);
+}
+
+static struct xtables_target xor_reg[] =3D {
+ {
+ .version       =3D XTABLES_VERSION,
+ .name          =3D "XOR",
+ .revision      =3D 0,
+ .family        =3D NFPROTO_IPV4,
+ .size          =3D XT_ALIGN(sizeof(struct xt_xor_info)),
+ .userspacesize =3D XT_ALIGN(sizeof(struct xt_xor_info)),
+ .help          =3D xor_help,
+ .parse         =3D xor_parse,
+ .final_check   =3D xor_check,
+ .print         =3D xor_print,
+ .save          =3D xor_save,
+ .extra_opts    =3D xor_opts,
+ },
+};
+
+static void _init(void)
+{
+ xtables_register_targets(xor_reg,
+ sizeof(xor_reg) / sizeof(*xor_reg));
+}
diff --git a/extensions/libxt_XOR.man b/extensions/libxt_XOR.man
new file mode 100644
index 0000000..58502f9
--- /dev/null
+++ b/extensions/libxt_XOR.man
@@ -0,0 +1,46 @@
+The XOR target enables the user to encrypt TCP and UDP traffic using
a simple xor encryption.
+.PP
+Usage:
+.PP
+XOR takes two mandatory parameters
+.TP
+\fB\-\-key\fR \fIkeyvalue\fR
+where \fIkeyvalue\fR is a set of characters used in turn to xor with
packet payloads.
+.TP
+\fB\-\-block\-size\fR \fIblocksize\fR
+where \fIblocksize\fR indicates the run-count in the payload of bytes
to be encrypted before using the next character of the key.
+.PP
+Example use to use this target between hosts 1.2.3.5 and 1.2.3.4.
+.PP
+(on host A, 1.2.3.4)
+.br
+iptables \-t mangle \-A OUTPUT -d 1.2.3.5 \-j XOR \-\-key somekey
\-\-block\-size 3\r
+.br
+iptables \-t mangle \-A INPUT -s 1.2.3.4 \-j XOR \-\-key somekey
\-\-block\-size 3\r
+.PP
+iptables \-t mangle \-L
+.br
+Chain OUTPUT (policy ACCEPT)
+.br
+target     prot opt source               destination
+.br
+XOR        all  \-\-  anywhere             1.2.3.5            key:
somekey block\-size: 3
+.br
+XOR        all  \-\-  1.2.3.5              anywhere           key:
somekey block\-size: 3
+.PP
+(on host B, 1.2.3.5)
+iptables \-t mangle \-A OUTPUT \-d 1.2.3.4 \-j XOR \-\-key somekey
\-\-block\-size 3
+.br
+iptables \-t mangle \-A INPUT \-s 1.2.3.5 \-j XOR \-\-key somekey
\-\-block\-size 3
+.PP
+iptables \-t mangle \-L
+.br
+Chain OUTPUT (policy ACCEPT)
+.br
+target     prot opt source               destination
+.br
+XOR        all  \-\-  anywhere             1.2.3.4            key:
somekey block\-size: 3
+.br
+XOR        all  \-\-  1.2.3.4              anywhere           key:
somekey block\-size: 3
+.PP
+xtables\-addons implementation by Andrew Smith
<andrew.smith@appsense.com>, based upon the original module by Tim
Vandermeersch <Tim.Vandermeersch@pandora.be>
diff --git a/extensions/xt_XOR.c b/extensions/xt_XOR.c
new file mode 100644
index 0000000..d426ec3
--- /dev/null
+++ b/extensions/xt_XOR.c
@@ -0,0 +1,126 @@
+/* XOR target for xtables-addons
+ * original iptables implementation
+ * (C) 2000 by Tim Vandermeersch <Tim.Vandermeersch@pandora.be>
+ * Based on ipt_TTL.c
+ *
+ * xtables implementation
+ * (C) 2014 by Andrew Smith <andrew.smith@appsense.com>
+ * Version 1.1
+ *
+ * This software is distributed under the terms of GNU GPL
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <net/tcp.h>
+#include <net/checksum.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/x_tables.h>
+#include "compat_xtables.h"
+#include "xt_XOR.h"
+
+MODULE_AUTHOR("Andrew Smith <andrew.smith@appsense.com>");
+MODULE_DESCRIPTION("IP tables XOR module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_XOR");
+
+static unsigned int
+xt_xor_target(struct sk_buff *pskb, const struct xt_action_param *par)
+{
+ const struct xt_xor_info *info =3D par->targinfo;
+ struct iphdr *iph;
+ /* To avoid warnings */
+ struct tcphdr *tcph =3D 0;
+ struct udphdr *udph =3D 0;
+ int i, j, k;
+ char *buf_pos;
+ int data_len;
+
+ iph =3D ip_hdr(pskb);
+ /* All of the packet please */
+ if (!skb_make_writable(pskb, ntohs(iph->tot_len)))
+ return NF_DROP;
+
+ /* Writable =3D new pointers */
+ iph =3D ip_hdr(pskb);
+ /* Beginning of the packet */
+ buf_pos =3D pskb->data;
+ /* Advance over the ip header */
+ buf_pos +=3D iph->ihl*4;
+
+ /* Set up lengths and data positioning */
+ if (iph->protocol =3D=3D IPPROTO_TCP) {
+ tcph =3D (struct tcphdr *) buf_pos;
+ buf_pos +=3D tcph->doff*4;
+                data_len =3D ntohs(iph->tot_len) - iph->ihl*4 - tcph->=
doff*4;
+ } else if (iph->protocol =3D=3D IPPROTO_UDP) {
+ udph =3D (struct udphdr *) buf_pos;
+ buf_pos +=3D sizeof(struct udphdr);
+   data_len =3D ntohs(udph->len)-8;
+ } else {
+ /* If for some reason we it's not UDP or TCP let another layer handle=
 */
+ return XT_CONTINUE;
+ }
+ /* Apply the key */
+ for (i=3D0, j=3D0; i<data_len; ) {
+ for (k=3D0; k<=3Dinfo->block_size && i<data_len; k++) {
+ buf_pos[i] ^=3D info->key[j];
+ i++;
+ }
+ j++;
+ if (info->key[j] =3D=3D 0x00)
+ j =3D 0;
+ }
+ return XT_CONTINUE;
+}
+
+static int xt_xor_checkentry(const struct xt_tgchk_param *par)
+{
+ const struct xt_xor_info *info =3D par->targinfo;
+
+ if (strcmp(par->table, "mangle")) {
+ printk(KERN_WARNING "XOR: can only be called from"
+ "\"mangle\" table, not \"%s\"\n", par->table);
+ return -EINVAL;
+ }
+
+ if (!strcmp(info->key, "")) {
+ printk(KERN_WARNING "XOR: You must specify a key");
+ return -EINVAL;
+ }
+
+ if (info->block_size =3D=3D 0) {
+ printk(KERN_WARNING "XOR: You must specify a block-size");
+ return -EINVAL;
+ }
+
+ return 0;
+}
+
+static struct xt_target xt_xor =3D {
+ .name =3D "XOR",
+ .revision =3D 0,
+ .family =3D NFPROTO_IPV4,
+ .table =3D "mangle",
+ .target =3D xt_xor_target,
+        .targetsize =3D sizeof(struct xt_xor_info),
+ .checkentry =3D xt_xor_checkentry,
+ .me =3D THIS_MODULE,
+};
+
+static int __init xor_tg_init(void)
+{
+ return xt_register_target(&xt_xor);
+}
+
+static void __exit xor_target_exit(void)
+{
+ xt_unregister_target(&xt_xor);
+}
+
+module_init(xor_tg_init);
+module_exit(xor_target_exit);
diff --git a/extensions/xt_XOR.h b/extensions/xt_XOR.h
new file mode 100644
index 0000000..ed0c38d
--- /dev/null
+++ b/extensions/xt_XOR.h
@@ -0,0 +1,9 @@
+#ifndef _XT_XOR_H
+#define _XT_XOR_H
+
+struct xt_xor_info {
+ char key[30];
+ u_int8_t block_size;
+};
+
+#endif /* _XT_XOR_H */
diff --git a/mconfig b/mconfig
index 74ccd03..3f359dd 100644
--- a/mconfig
+++ b/mconfig
@@ -4,6 +4,7 @@ build_ACCOUNT=3Dm
 build_CHAOS=3Dm
 build_DELUDE=3Dm
 build_DHCPMAC=3Dm
+build_XOR=3Dm
 build_DNETMAP=3Dm
 build_ECHO=3Dm
 build_IPMARK=3Dm



And the diff from the 1.47.1 tag..



diff --git a/extensions/Kbuild b/extensions/Kbuild
index 81a8b30..6749814 100644
--- a/extensions/Kbuild
+++ b/extensions/Kbuild
@@ -9,6 +9,7 @@ obj-${build_ACCOUNT}     +=3D ACCOUNT/
 obj-${build_CHAOS}       +=3D xt_CHAOS.o
 obj-${build_CHECKSUM}    +=3D xt_CHECKSUM.o
 obj-${build_DELUDE}      +=3D xt_DELUDE.o
+obj-${build_XOR}         +=3D xt_XOR.o
 obj-${build_DHCPMAC}     +=3D xt_DHCPMAC.o
 obj-${build_DNETMAP}     +=3D xt_DNETMAP.o
 ifeq (${VERSION},3)
diff --git a/extensions/Mbuild b/extensions/Mbuild
index 1c76e34..ce9ca63 100644
--- a/extensions/Mbuild
+++ b/extensions/Mbuild
@@ -4,6 +4,7 @@ obj-${build_ACCOUNT}     +=3D ACCOUNT/
 obj-${build_CHAOS}       +=3D libxt_CHAOS.so
 obj-${build_CHECKSUM}    +=3D libxt_CHECKSUM.so
 obj-${build_DELUDE}      +=3D libxt_DELUDE.so
+obj-${build_XOR}         +=3D libxt_XOR.so
 obj-${build_DHCPMAC}     +=3D libxt_DHCPMAC.so libxt_dhcpmac.so
 obj-${build_DNETMAP}     +=3D libxt_DNETMAP.so
 obj-${build_ECHO}        +=3D libxt_ECHO.so
diff --git a/extensions/libxt_XOR.c b/extensions/libxt_XOR.c
new file mode 100644
index 0000000..a029547
--- /dev/null
+++ b/extensions/libxt_XOR.c
@@ -0,0 +1,110 @@
+/*
+ * "XOR" target extension for xtables-addons
+ * Copyright =A9 Andrew Smith, 2014
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License; either
+ * version 2 of the License, or any later version, as published by the
+ * Free Software Foundation.
+ */
+#include <netinet/in.h>
+#include <getopt.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <xtables.h>
+#include <linux/netfilter.h>
+#include "xt_XOR.h"
+#include "compat_user.h"
+
+enum {
+ FLAGS_KEY =3D 1 << 0,
+        FLAGS_BLOCK =3D 1 << 1,
+};
+
+static const struct option xor_opts[] =3D {
+ {.name =3D "key", .has_arg =3D true, .val =3D 'k'},
+        {.name =3D "block-size", .has_arg =3D true, .val =3D'b'},
+ {},
+};
+
+static void xor_help(void)
+{
+ printf(
+ "XOR target options:\n"
+ "    --key <string>\n"
+ "    --block-size <size>\n"
+ );
+}
+
+static int
+xor_parse(int c, char **argv, int invert, unsigned int *flags,
+                  const void *entry, struct xt_entry_target **target)
+{
+ struct xt_xor_info *info =3D (void *)(*target)->data;
+        unsigned long v;
+
+ switch (c) {
+ case 'k':
+                if (strlen(optarg) > sizeof(info->key))
+ xtables_error(PARAMETER_PROBLEM, "XOR: Maximum key size is
%zu",sizeof(info->key));
+ strncpy(info->key, optarg, sizeof(info->key));
+                *flags |=3D FLAGS_KEY;
+ return true;
+        case 'b':
+ if (!xtables_strtoul(optarg, NULL, &v, 1, 5))
+ xtables_param_act(XTF_BAD_VALUE, "XOR",
+ "--block-size", optarg);
+                info->block_size =3D v;
+                *flags |=3D FLAGS_BLOCK;
+                return true;
+ }
+ return false;
+}
+static void xor_check(unsigned int flags)
+{
+ if (!(flags & FLAGS_KEY))
+ xtables_error(PARAMETER_PROBLEM, "XOR: "
+ "\"--key\" is required.");
+ if (!(flags & FLAGS_BLOCK))
+ xtables_error(PARAMETER_PROBLEM, "XOR: "
+ "\"--block-size\" is required.");
+}
+
+static void
+xor_print(const void *entry, const struct xt_entry_target *target,
+                  int numeric)
+{
+ const struct xt_xor_info *info =3D (const void *)target->data;
+ printf("  --key %s --block-size %d ",info->key, info->block_size);
+}
+
+static void
+xor_save(const void *entry, const struct xt_entry_target *target)
+{
+ const struct xt_xor_info *info =3D (const void *)target->data;
+ printf("  --key %s --block-size %d ",info->key, info->block_size);
+}
+
+static struct xtables_target xor_reg[] =3D {
+ {
+ .version       =3D XTABLES_VERSION,
+ .name          =3D "XOR",
+ .revision      =3D 0,
+ .family        =3D NFPROTO_IPV4,
+ .size          =3D XT_ALIGN(sizeof(struct xt_xor_info)),
+ .userspacesize =3D XT_ALIGN(sizeof(struct xt_xor_info)),
+ .help          =3D xor_help,
+ .parse         =3D xor_parse,
+ .final_check   =3D xor_check,
+ .print         =3D xor_print,
+ .save          =3D xor_save,
+ .extra_opts    =3D xor_opts,
+ },
+};
+
+static void _init(void)
+{
+ xtables_register_targets(xor_reg,
+ sizeof(xor_reg) / sizeof(*xor_reg));
+}
diff --git a/extensions/libxt_XOR.man b/extensions/libxt_XOR.man
new file mode 100644
index 0000000..58502f9
--- /dev/null
+++ b/extensions/libxt_XOR.man
@@ -0,0 +1,46 @@
+The XOR target enables the user to encrypt TCP and UDP traffic using
a simple xor encryption.
+.PP
+Usage:
+.PP
+XOR takes two mandatory parameters
+.TP
+\fB\-\-key\fR \fIkeyvalue\fR
+where \fIkeyvalue\fR is a set of characters used in turn to xor with
packet payloads.
+.TP
+\fB\-\-block\-size\fR \fIblocksize\fR
+where \fIblocksize\fR indicates the run-count in the payload of bytes
to be encrypted before using the next character of the key.
+.PP
+Example use to use this target between hosts 1.2.3.5 and 1.2.3.4.
+.PP
+(on host A, 1.2.3.4)
+.br
+iptables \-t mangle \-A OUTPUT -d 1.2.3.5 \-j XOR \-\-key somekey
\-\-block\-size 3\r
+.br
+iptables \-t mangle \-A INPUT -s 1.2.3.4 \-j XOR \-\-key somekey
\-\-block\-size 3\r
+.PP
+iptables \-t mangle \-L
+.br
+Chain OUTPUT (policy ACCEPT)
+.br
+target     prot opt source               destination
+.br
+XOR        all  \-\-  anywhere             1.2.3.5            key:
somekey block\-size: 3
+.br
+XOR        all  \-\-  1.2.3.5              anywhere           key:
somekey block\-size: 3
+.PP
+(on host B, 1.2.3.5)
+iptables \-t mangle \-A OUTPUT \-d 1.2.3.4 \-j XOR \-\-key somekey
\-\-block\-size 3
+.br
+iptables \-t mangle \-A INPUT \-s 1.2.3.5 \-j XOR \-\-key somekey
\-\-block\-size 3
+.PP
+iptables \-t mangle \-L
+.br
+Chain OUTPUT (policy ACCEPT)
+.br
+target     prot opt source               destination
+.br
+XOR        all  \-\-  anywhere             1.2.3.4            key:
somekey block\-size: 3
+.br
+XOR        all  \-\-  1.2.3.4              anywhere           key:
somekey block\-size: 3
+.PP
+xtables\-addons implementation by Andrew Smith
<andrew.smith@appsense.com>, based upon the original module by Tim
Vandermeersch <Tim.Vandermeersch@pandora.be>
diff --git a/extensions/xt_XOR.c b/extensions/xt_XOR.c
new file mode 100644
index 0000000..23e2502
--- /dev/null
+++ b/extensions/xt_XOR.c
@@ -0,0 +1,126 @@
+/* XOR target for xtables-addons
+ * original iptables implementation
+ * (C) 2000 by Tim Vandermeersch <Tim.Vandermeersch@pandora.be>
+ * Based on ipt_TTL.c
+ *
+ * xtables implementation
+ * (C) 2014 by Andrew Smith <andrew.smith@appsense.com>
+ * Version 1.1
+ *
+ * This software is distributed under the terms of GNU GPL
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <net/tcp.h>
+#include <net/checksum.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/x_tables.h>
+#include "compat_xtables.h"
+#include "xt_XOR.h"
+
+MODULE_AUTHOR("Andrew Smith <andrew.smith@appsense.com>");
+MODULE_DESCRIPTION("IP tables XOR module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_XOR");
+
+static unsigned int
+xt_xor_target(struct sk_buff **pskb, const struct xt_action_param *par=
)
+{
+ const struct xt_xor_info *info =3D par->targinfo;
+ struct iphdr *iph;
+ /* To avoid warnings */
+ struct tcphdr *tcph =3D 0;
+ struct udphdr *udph =3D 0;
+ int i, j, k;
+ char *buf_pos;
+ int data_len;
+
+ iph =3D ip_hdr(*pskb);
+ /* All of the packet please */
+ if (!skb_make_writable(pskb, ntohs(iph->tot_len)))
+ return NF_DROP;
+
+ /* Writable =3D new pointers */
+ iph =3D ip_hdr(*pskb);
+ /* Beginning of the packet */
+ buf_pos =3D (*pskb)->data;
+ /* Advance over the ip header */
+ buf_pos +=3D iph->ihl*4;
+
+ /* Set up lengths and data positioning */
+ if (iph->protocol =3D=3D IPPROTO_TCP) {
+ tcph =3D (struct tcphdr *) buf_pos;
+ buf_pos +=3D tcph->doff*4;
+                data_len =3D ntohs(iph->tot_len) - iph->ihl*4 - tcph->=
doff*4;
+ } else if (iph->protocol =3D=3D IPPROTO_UDP) {
+ udph =3D (struct udphdr *) buf_pos;
+ buf_pos +=3D sizeof(struct udphdr);
+   data_len =3D ntohs(udph->len)-8;
+ } else {
+ /* If for some reason we it's not UDP or TCP let another layer handle=
 */
+ return XT_CONTINUE;
+ }
+ /* Apply the key */
+ for (i=3D0, j=3D0; i<data_len; ) {
+ for (k=3D0; k<=3Dinfo->block_size && i<data_len; k++) {
+ buf_pos[i] ^=3D info->key[j];
+ i++;
+ }
+ j++;
+ if (info->key[j] =3D=3D 0x00)
+ j =3D 0;
+ }
+ return XT_CONTINUE;
+}
+
+static int xt_xor_checkentry(const struct xt_tgchk_param *par)
+{
+ const struct xt_xor_info *info =3D par->targinfo;
+
+ if (strcmp(par->table, "mangle")) {
+ printk(KERN_WARNING "XOR: can only be called from"
+ "\"mangle\" table, not \"%s\"\n", par->table);
+ return -EINVAL;
+ }
+
+ if (!strcmp(info->key, "")) {
+ printk(KERN_WARNING "XOR: You must specify a key");
+ return -EINVAL;
+ }
+
+ if (info->block_size =3D=3D 0) {
+ printk(KERN_WARNING "XOR: You must specify a block-size");
+ return -EINVAL;
+ }
+
+ return 0;
+}
+
+static struct xt_target xt_xor =3D {
+ .name =3D "XOR",
+ .revision =3D 0,
+ .family =3D NFPROTO_IPV4,
+ .table =3D "mangle",
+ .target =3D xt_xor_target,
+        .targetsize =3D sizeof(struct xt_xor_info),
+ .checkentry =3D xt_xor_checkentry,
+ .me =3D THIS_MODULE,
+};
+
+static int __init xor_tg_init(void)
+{
+ return xt_register_target(&xt_xor);
+}
+
+static void __exit xor_target_exit(void)
+{
+ xt_unregister_target(&xt_xor);
+}
+
+module_init(xor_tg_init);
+module_exit(xor_target_exit);
diff --git a/extensions/xt_XOR.h b/extensions/xt_XOR.h
new file mode 100644
index 0000000..ed0c38d
--- /dev/null
+++ b/extensions/xt_XOR.h
@@ -0,0 +1,9 @@
+#ifndef _XT_XOR_H
+#define _XT_XOR_H
+
+struct xt_xor_info {
+ char key[30];
+ u_int8_t block_size;
+};
+
+#endif /* _XT_XOR_H */
diff --git a/mconfig b/mconfig
index 4fc664a..8f6b82c 100644
--- a/mconfig
+++ b/mconfig
@@ -4,6 +4,7 @@ build_ACCOUNT=3Dm
 build_CHAOS=3Dm
 build_CHECKSUM=3D
 build_DELUDE=3Dm
+build_XOR=3Dm
 build_DHCPMAC=3Dm
 build_DNETMAP=3Dm
 build_ECHO=3Dm
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
