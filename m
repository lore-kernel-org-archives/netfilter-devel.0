From: Gregor Maier <gregor@net.in.tum.de>
Subject: Re: [PATCH][RFC] Unifiy logging in netfilter using nf_log, take #1.1
Date: Thu, 9 Mar 2006 20:33:49 +0100
Message-ID: <20060309193349.GA20613@net.in.tum.de>
References: <20060304173815.GA12715@net.in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20060304173815.GA12715@net.in.tum.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

A small change to be applied on top of the take #1 patch. 

cu
Gregor


[PATCH] Add defines in xt_LOG.h, that are needed by the userspace iptables
program.

Signed-off-by: Gregor Maier <gregor@net.in.tum.de>
=====================================================================
diff -ur blubber/include/linux/netfilter/xt_LOG.h net-2.6.17/include/linux/netfilter/xt_LOG.h
--- blubber/include/linux/netfilter/xt_LOG.h	2006-03-09 19:57:08.000000000 +0100
+++ net-2.6.17/include/linux/netfilter/xt_LOG.h	2006-03-05 18:50:03.000000000 +0100
@@ -8,13 +8,30 @@
 #ifndef _XT_LOG_TARGET_H
 #define _XT_LOG_TARGET_H
 
-/* make sure not to change this without changing netfilter.h:NF_LOG_* (!) */
+/* make sure not to change this without changing netfilter.h:XT_LOG_* (!) */
+#define XT_LOG_BACKEND_SYSLOG	0x01
+#define XT_LOG_BACKEND_NFLOG	0x02
+#define XT_LOG_BACKEND_MASK (XT_LOG_BACKEND_SYSLOG|XT_LOG_BACKEND_NFLOG)
+
+/* make sure not to change this without changing netfilter.h:XT_LOG_* (!) */
 #define XT_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
 #define XT_LOG_TCPOPT		0x02	/* Log TCP options */
 #define XT_LOG_IPOPT		0x04	/* Log IP options */
 #define XT_LOG_UID		0x08	/* Log UID owning local socket */
 #define XT_LOG_MASK		0x0f
 
+#define IPT_LOG_TCPSEQ		XT_LOG_TCPSEQ	/* Log TCP sequence numbers */
+#define IPT_LOG_TCPOPT		XT_LOG_TCPOPT	/* Log TCP options */
+#define IPT_LOG_IPOPT		XT_LOG_IPOPT	/* Log IP options */
+#define IPT_LOG_UID		XT_LOG_UID	/* Log UID owning local socket */
+#define IPT_LOG_MASK		XT_LOG_MASK
+
+#define IP6T_LOG_TCPSEQ		XT_LOG_TCPSEQ	/* Log TCP sequence numbers */
+#define IP6T_LOG_TCPOPT		XT_LOG_TCPOPT	/* Log TCP options */
+#define IP6T_LOG_IPOPT		XT_LOG_IPOPT	/* Log IP options */
+#define IP6T_LOG_UID		XT_LOG_UID	/* Log UID owning local socket */
+#define IP6T_LOG_MASK		XT_LOG_MASK
+
 struct xt_log_info {
 	u_int16_t group;
 	unsigned char backends;
