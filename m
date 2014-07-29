From: Willem de Bruijn <willemb@google.com>
Subject: [PATCH nf-next] include: add linux/filter.h
Date: Tue, 29 Jul 2014 18:19:02 -0400
Message-ID: <1406672342-4306-1-git-send-email-willemb@google.com>
Cc: Willem de Bruijn <willemb@google.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:62095 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaG2WZ7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:25:59 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so147163oif.4
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2014 15:25:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt_bpf.h includes linux/filter.h for the definition of sock_filter.
add that file to the repository

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/filter.h | 139 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 139 insertions(+)
 create mode 100644 include/linux/filter.h

diff --git a/include/linux/filter.h b/include/linux/filter.h
new file mode 100644
index 0000000..a9ae93c
--- /dev/null
+++ b/include/linux/filter.h
@@ -0,0 +1,139 @@
+/*
+ * Linux Socket Filter Data Structures
+ */
+
+#ifndef __LINUX_FILTER_H__
+#define __LINUX_FILTER_H__
+
+
+#include <linux/types.h>
+
+
+/*
+ * Current version of the filter code architecture.
+ */
+#define BPF_MAJOR_VERSION 1
+#define BPF_MINOR_VERSION 1
+
+/*
+ *	Try and keep these values and structures similar to BSD, especially
+ *	the BPF code definitions which need to match so you can share filters
+ */
+ 
+struct sock_filter {	/* Filter block */
+	__u16	code;   /* Actual filter code */
+	__u8	jt;	/* Jump true */
+	__u8	jf;	/* Jump false */
+	__u32	k;      /* Generic multiuse field */
+};
+
+struct sock_fprog {	/* Required for SO_ATTACH_FILTER. */
+	unsigned short		len;	/* Number of filter blocks */
+	struct sock_filter *filter;
+};
+
+/*
+ * Instruction classes
+ */
+
+#define BPF_CLASS(code) ((code) & 0x07)
+#define         BPF_LD          0x00
+#define         BPF_LDX         0x01
+#define         BPF_ST          0x02
+#define         BPF_STX         0x03
+#define         BPF_ALU         0x04
+#define         BPF_JMP         0x05
+#define         BPF_RET         0x06
+#define         BPF_MISC        0x07
+
+/* ld/ldx fields */
+#define BPF_SIZE(code)  ((code) & 0x18)
+#define         BPF_W           0x00
+#define         BPF_H           0x08
+#define         BPF_B           0x10
+#define BPF_MODE(code)  ((code) & 0xe0)
+#define         BPF_IMM         0x00
+#define         BPF_ABS         0x20
+#define         BPF_IND         0x40
+#define         BPF_MEM         0x60
+#define         BPF_LEN         0x80
+#define         BPF_MSH         0xa0
+
+/* alu/jmp fields */
+#define BPF_OP(code)    ((code) & 0xf0)
+#define         BPF_ADD         0x00
+#define         BPF_SUB         0x10
+#define         BPF_MUL         0x20
+#define         BPF_DIV         0x30
+#define         BPF_OR          0x40
+#define         BPF_AND         0x50
+#define         BPF_LSH         0x60
+#define         BPF_RSH         0x70
+#define         BPF_NEG         0x80
+#define		BPF_MOD		0x90
+#define		BPF_XOR		0xa0
+
+#define         BPF_JA          0x00
+#define         BPF_JEQ         0x10
+#define         BPF_JGT         0x20
+#define         BPF_JGE         0x30
+#define         BPF_JSET        0x40
+#define BPF_SRC(code)   ((code) & 0x08)
+#define         BPF_K           0x00
+#define         BPF_X           0x08
+
+/* ret - BPF_K and BPF_X also apply */
+#define BPF_RVAL(code)  ((code) & 0x18)
+#define         BPF_A           0x10
+
+/* misc */
+#define BPF_MISCOP(code) ((code) & 0xf8)
+#define         BPF_TAX         0x00
+#define         BPF_TXA         0x80
+
+#ifndef BPF_MAXINSNS
+#define BPF_MAXINSNS 4096
+#endif
+
+/*
+ * Macros for filter block array initializers.
+ */
+#ifndef BPF_STMT
+#define BPF_STMT(code, k) { (unsigned short)(code), 0, 0, k }
+#endif
+#ifndef BPF_JUMP
+#define BPF_JUMP(code, k, jt, jf) { (unsigned short)(code), jt, jf, k }
+#endif
+
+/*
+ * Number of scratch memory words for: BPF_ST and BPF_STX
+ */
+#define BPF_MEMWORDS 16
+
+/* RATIONALE. Negative offsets are invalid in BPF.
+   We use them to reference ancillary data.
+   Unlike introduction new instructions, it does not break
+   existing compilers/optimizers.
+ */
+#define SKF_AD_OFF    (-0x1000)
+#define SKF_AD_PROTOCOL 0
+#define SKF_AD_PKTTYPE 	4
+#define SKF_AD_IFINDEX 	8
+#define SKF_AD_NLATTR	12
+#define SKF_AD_NLATTR_NEST	16
+#define SKF_AD_MARK 	20
+#define SKF_AD_QUEUE	24
+#define SKF_AD_HATYPE	28
+#define SKF_AD_RXHASH	32
+#define SKF_AD_CPU	36
+#define SKF_AD_ALU_XOR_X	40
+#define SKF_AD_VLAN_TAG	44
+#define SKF_AD_VLAN_TAG_PRESENT 48
+#define SKF_AD_PAY_OFFSET	52
+#define SKF_AD_RANDOM	56
+#define SKF_AD_MAX	60
+#define SKF_NET_OFF   (-0x100000)
+#define SKF_LL_OFF    (-0x200000)
+
+
+#endif /* __LINUX_FILTER_H__ */
-- 
2.0.0.526.g5318336

