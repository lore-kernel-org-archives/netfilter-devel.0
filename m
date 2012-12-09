From: Willem de Bruijn <willemb@google.com>
Subject: [PATCH] [rfc] a bpf compilation tool for xt_bpf
Date: Sun,  9 Dec 2012 17:52:38 -0500
Message-ID: <1355093558-27931-1-git-send-email-willemb@google.com>
References: <1355082854-31853-1-git-send-email-willemb@google.com>
Cc: Willem de Bruijn <willemb@google.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:35489 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934578Ab2LIWwr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2012 17:52:47 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so133988bkc.1
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Dec 2012 14:52:45 -0800 (PST)
In-Reply-To: <1355082854-31853-1-git-send-email-willemb@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

An example tool to convert textual BPF into the instructions
acceptable by xt_bpf. This is mostly boilerplate around existing
pcap calls.

I do not intend this for submission as is. It adds a dependency
on pcap, which would at the least have to be optional and detected
by autoconf.
---
 utils/Makefile.am   |    3 ++-
 utils/bpf_compile.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 1 deletions(-)
 create mode 100644 utils/bpf_compile.c

diff --git a/utils/Makefile.am b/utils/Makefile.am
index f1bbfc5..4c67292 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -4,7 +4,8 @@ AM_CFLAGS = ${regular_CFLAGS}
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include \
               -I${top_srcdir}/include ${libnfnetlink_CFLAGS}
 
-sbin_PROGRAMS = nfnl_osf
+sbin_PROGRAMS = nfnl_osf bpf_compile
 pkgdata_DATA = pf.os
 
 nfnl_osf_LDADD = -lnfnetlink
+bpf_compile_LDADD = -lpcap
diff --git a/utils/bpf_compile.c b/utils/bpf_compile.c
new file mode 100644
index 0000000..62f7bc8
--- /dev/null
+++ b/utils/bpf_compile.c
@@ -0,0 +1,47 @@
+/*
+ * BPF program compilation tool
+ *
+ * Written by Willem de Bruijn (willemb@google.com)
+ * Copyright Google, Inc. 2012
+ * Licensed under the GNU General Public License version 2 (GPLv2)
+*/
+
+#include <pcap.h>
+#include <stdio.h>
+
+int main(int argc, char **argv)
+{
+	struct bpf_program program;
+	struct bpf_insn *ins;
+	int i, dlt = DLT_RAW;
+
+	if (argc < 2 || argc > 3) {
+		fprintf(stderr, "Usage: %s [linktype] <program>\n"
+				"       linktype is one of EN10MB, RAW, ...\n"
+				"       program must be one parameter\n",
+				argv[0]);
+		return 1;
+	}
+
+	if (argc == 3) {
+		dlt = pcap_datalink_name_to_val(argv[1]);
+		if (dlt == -1) {
+			fprintf(stderr, "Unknown datalinktype: %s\n", argv[1]);
+			return 1;
+		}
+	}
+
+	printf("Using datalinktype %s\n", pcap_datalink_val_to_name(dlt));
+	if (pcap_compile_nopcap(65535, dlt, &program, argv[argc - 1], 1, 0)) {
+		fprintf(stderr, "Compilation error\n");
+		return 1;
+	}
+
+	printf("%d\n", program.bf_len);
+	ins = program.bf_insns;
+	for (i = 0; i < program.bf_len; ++ins, ++i)
+		printf("%u %u %u %u\n", ins->code, ins->jt, ins->jf, ins->k);
+
+	return 0;
+}
+
-- 
1.7.7.3

