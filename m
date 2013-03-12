From: Willem de Bruijn <willemb@google.com>
Subject: [PATCH next] utils: bpf_compile
Date: Tue, 12 Mar 2013 11:44:12 -0400
Message-ID: <1363103052-5529-1-git-send-email-willemb@google.com>
References: <51262486.40905@redhat.com>
Cc: Willem de Bruijn <willemb@google.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	dborkman@redhat.com, zenczykowski@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:54654 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab3CLPof (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:44:35 -0400
Received: by mail-vb0-f74.google.com with SMTP id r6so436659vbi.1
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2013 08:44:34 -0700 (PDT)
In-Reply-To: <51262486.40905@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

V2
- update build process to
  - succeed without bpf_compiler when --enable-bpf-compiler is not set
  - succeed with bpf_compiler when this flag is set and libpcap is found
  - fail when this flag is set but libpcap is absent
- release memory allocated by pcap on exit

A BPF compiler to convert tcpudmp expressions to the decimal format accepted
by the libxt_bpf.

Generate a file and pass that to iptables:

  bpf_compile RAW 'udp dst port 9000' > test.bpf
  iptables -A OUTPUT -m bpf --bytecode-file test.bpf -j LOG

Or pass the output directly to iptables using backticks:

  iptables -A INPUT -m bpf --bytecode \
      "`./bpf_compile RAW 'udp dst port 9000' | tr '\n' ','`" -j LOG

This utility depends on libpcap. The library is only compiled if the option
--enable-pcap is explicitly passed to ./configure and libpcap is found.

Tested (for review: to be removed before merging):

- compilation always succeeds.
  - utils/bpf_compile is only built when enable_pcap is true and libpcap is found
  - utils/nfnl_osf is (still) only built when nfnetlink library is found

- execution
  - tested the above two expressions and verified dmesg output

- logging
  - iptables -L INPUT
"
LOG        all  --  anywhere             anywhere            match bpf 48 0 0
0,84 0 0 240,21 0 4 96,48 0 0 6,21 0 13 17,40 0 0 42,21 10 11 9000,48 0 0 0,84
0 0 240,21 0 8 64,48 0 0 9,21 0 6 17,40 0 0 6,69 4 0 8191,177 0 0 0,72 0 0
  2,21 0 1 9000,6 0 0 65535,6 0 0 0, LOG level warning
"

  - iptables-save
"
-A INPUT -m bpf --bytecode "19,48 0 0 0,84 0 0 240,21 0 4 96,48 0 0 6,21 0
13 17,40 0 0 42,21 10 11 9000,48 0 0 0,84 0 0 240,21 0 8 64,48 0 0 9,21 0
6 17,40 0 0 6,69 4 0 8191,177 0 0 0,72 0 0 2,21 0 1 9000,6 0 0 65535,6
0 0 0," -j LOG
"

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 Makefile.am         |  2 --
 configure.ac        |  4 ++++
 utils/Makefile.am   | 14 ++++++++++++--
 utils/bpf_compile.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 72 insertions(+), 4 deletions(-)
 create mode 100644 utils/bpf_compile.c

diff --git a/Makefile.am b/Makefile.am
index 6400ba4..c38d360 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -10,9 +10,7 @@ endif
 if ENABLE_LIBIPQ
 SUBDIRS         += libipq
 endif
-if HAVE_LIBNFNETLINK
 SUBDIRS         += utils
-endif
 # Depends on libxtables:
 SUBDIRS         += extensions
 # Depends on extensions/libext.a:
diff --git a/configure.ac b/configure.ac
index 27e0b10..e5cfb12 100644
--- a/configure.ac
+++ b/configure.ac
@@ -50,6 +50,9 @@ AC_ARG_ENABLE([devel],
 	[enable_devel="$enableval"], [enable_devel="yes"])
 AC_ARG_ENABLE([libipq],
 	AS_HELP_STRING([--enable-libipq], [Build and install libipq]))
+AC_ARG_ENABLE([bpf-compiler],
+	AS_HELP_STRING([--enable-bpf-compiler], [Build bpf compiler]),
+	[enable_bpfc="yes"])
 AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
 	[Path to the pkgconfig directory [[LIBDIR/pkgconfig]]]),
 	[pkgconfigdir="$withval"], [pkgconfigdir='${libdir}/pkgconfig'])
@@ -88,6 +91,7 @@ AM_CONDITIONAL([ENABLE_IPV6], [test "$enable_ipv6" = "yes"])
 AM_CONDITIONAL([ENABLE_LARGEFILE], [test "$enable_largefile" = "yes"])
 AM_CONDITIONAL([ENABLE_DEVEL], [test "$enable_devel" = "yes"])
 AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" = "yes"])
+AM_CONDITIONAL([ENABLE_BPFC], [test "$enable_bpfc" = "yes"])
 
 PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0],
 	[nfnetlink=1], [nfnetlink=0])
diff --git a/utils/Makefile.am b/utils/Makefile.am
index f1bbfc5..8b510d6 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -4,7 +4,17 @@ AM_CFLAGS = ${regular_CFLAGS}
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include \
               -I${top_srcdir}/include ${libnfnetlink_CFLAGS}
 
-sbin_PROGRAMS = nfnl_osf
-pkgdata_DATA = pf.os
+sbin_PROGRAMS =
+pkgdata_DATA =
+
+if HAVE_LIBNFNETLINK
+sbin_PROGRAMS += nfnl_osf
+pkgdata_DATA += pf.os
 
 nfnl_osf_LDADD = -lnfnetlink
+endif
+
+if ENABLE_BPFC
+sbin_PROGRAMS += bpf_compile
+bpf_compile_LDADD = -lpcap
+endif
diff --git a/utils/bpf_compile.c b/utils/bpf_compile.c
new file mode 100644
index 0000000..81b59a4
--- /dev/null
+++ b/utils/bpf_compile.c
@@ -0,0 +1,56 @@
+/*
+ * BPF program compilation tool
+ *
+ * Generates decimal output, similar to `tcpdump -ddd ...`.
+ * Unlike tcpdump, will generate for any given link layer type.
+ *
+ * There is no makefile:
+ * compile with `gcc -Wall -o bpf2decimal bpf2decimal.c -lpcap` or similar.
+ *
+ * Written by Willem de Bruijn (willemb@google.com)
+ * Copyright Google, Inc. 2013
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
+		fprintf(stderr, "Usage:    %s [link] '<program>'\n\n"
+				"          link is a pcap linklayer type:\n"
+				"          one of EN10MB, RAW, SLIP, ...\n\n"
+				"Examples: %s RAW 'tcp and greater 100'\n"
+				"          %s EN10MB 'ip proto 47'\n'",
+				argv[0], argv[0], argv[0]);
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
+	if (pcap_compile_nopcap(65535, dlt, &program, argv[argc - 1], 1,
+				PCAP_NETMASK_UNKNOWN)) {
+		fprintf(stderr, "Compilation error\n");
+		return 1;
+	}
+
+	printf("%d\n", program.bf_len);
+	ins = program.bf_insns;
+	for (i = 0; i < program.bf_len; ++ins, ++i)
+		printf("%u %u %u %u\n", ins->code, ins->jt, ins->jf, ins->k);
+
+	pcap_freecode(&program);
+	return 0;
+}
+
-- 
1.8.1.3

