From: Willem de Bruijn <willemb@google.com>
Subject: [PATCH] utils: bpf_compile
Date: Sun, 17 Feb 2013 22:44:01 -0500
Message-ID: <1361159041-9783-1-git-send-email-willemb@google.com>
References: <20130123185620.GA6251@1984>
Cc: Willem de Bruijn <willemb@google.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:51255 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab3BRDoG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Feb 2013 22:44:06 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so533087yen.4
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Feb 2013 19:44:05 -0800 (PST)
In-Reply-To: <20130123185620.GA6251@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
---
 Makefile.am         |  2 --
 configure.ac        |  8 ++++++++
 utils/Makefile.am   | 14 ++++++++++++--
 utils/bpf_compile.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+), 4 deletions(-)
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
index 27e0b10..fe40afe 100644
--- a/configure.ac
+++ b/configure.ac
@@ -50,6 +50,9 @@ AC_ARG_ENABLE([devel],
 	[enable_devel="$enableval"], [enable_devel="yes"])
 AC_ARG_ENABLE([libipq],
 	AS_HELP_STRING([--enable-libipq], [Build and install libipq]))
+AC_ARG_ENABLE([pcap],
+	AS_HELP_STRING([--enable-pcap], [Build libpcap dependencies]),
+	[want_pcap="yes"])
 AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
 	[Path to the pkgconfig directory [[LIBDIR/pkgconfig]]]),
 	[pkgconfigdir="$withval"], [pkgconfigdir='${libdir}/pkgconfig'])
@@ -93,6 +96,11 @@ PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0],
 	[nfnetlink=1], [nfnetlink=0])
 AM_CONDITIONAL([HAVE_LIBNFNETLINK], [test "$nfnetlink" = 1])
 
+if test "$want_pcap" == "yes"; then
+AC_CHECK_LIB(pcap, pcap_compile_nopcap, [have_libpcap="yes"])
+fi;
+AM_CONDITIONAL([HAVE_LIBPCAP], [test "$have_libpcap" = "yes"])
+
 regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
 	-Winline -pipe";
diff --git a/utils/Makefile.am b/utils/Makefile.am
index f1bbfc5..b05ff51 100644
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
+if HAVE_LIBPCAP
+sbin_PROGRAMS += bpf_compile
+bpf_compile_LDADD = -lpcap
+endif
diff --git a/utils/bpf_compile.c b/utils/bpf_compile.c
new file mode 100644
index 0000000..7b3e3c0
--- /dev/null
+++ b/utils/bpf_compile.c
@@ -0,0 +1,55 @@
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
+	return 0;
+}
+
-- 
1.8.1.3

