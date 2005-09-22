From: Max Kellermann <max@duempel.org>
Subject: [PATCH nfsim] port nfsim to Linux 2.6.14-rc2
Date: Thu, 22 Sep 2005 10:18:13 +0200
Message-ID: <20050922081813.GA21617@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

this patch makes nfsim compile with Linux 2.6.14-rc2.  It uses #ifdefs
to keep it compatible with the older kernels.  The changes were mostly
copy+paste from the original kernel headers to core/core.h etc.

With 2.6.14-rc2, a lot of header code was moved around, creating the
new files net/ipv[46]/netfilter.c, and removing the file
net/core/netfilter.c.  My fixes for that need a bit of cleanup,
because the current nfsim structure cannot import net/ipv[46]/*.c in a
clean way, it only knows net/ipv[46]/netfilter/*.c.  There should
probably be a more generic approach to importing Linux sources into
the nfsim tree, no matter which original subdirectory they came from.

Max


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nfsim-port_to_2.6.14-alpha2.patch"

Thu Sep 22 10:13:41 CEST 2005  max@duempel.org
  * port to Linux 2.6.14-rc2 II
diff -rN -u old-nfsim-0/.links new-nfsim-0/.links
--- old-nfsim-0/.links	2005-09-22 10:14:13.000000000 +0200
+++ new-nfsim-0/.links	2005-09-22 10:12:07.000000000 +0200
@@ -53,6 +53,7 @@
 ./asm/softirq.h
 ./asm/statfs.h
 ./asm/page.h
+./asm/types.h
 ./net/tcp.h
 ./net/checksum.h
 ./net/route.h
diff -rN -u old-nfsim-0/configure new-nfsim-0/configure
--- old-nfsim-0/configure	2005-09-22 10:14:13.000000000 +0200
+++ new-nfsim-0/configure	2005-09-22 10:12:59.000000000 +0200
@@ -71,9 +71,25 @@
 rm -f Makefile.import
 
 [ -d netfilter/$TYPE ] ||  mkdir -p netfilter/$TYPE
-echo "netfilter/core/netfilter.c: $KERNELDIR/net/core/netfilter.c" >> Makefile.import
-echo '	@sed -f netfilter.c.sed $^ > $@ && chmod a-w $@' >> Makefile.import
-echo "import: netfilter/core/netfilter.c" >> Makefile.import
+if [ -f $KERNELDIR/net/core/netfilter.c ]; then
+    # < Linux 2.6.14
+    echo "netfilter/core/netfilter.c: $KERNELDIR/net/core/netfilter.c" >> Makefile.import
+    echo '	@sed -f netfilter.c.sed $^ > $@ && chmod a-w $@' >> Makefile.import
+    echo "import: netfilter/core/netfilter.c" >> Makefile.import
+else
+    # >= Linux 2.6.14
+    for i in core.c nf_log.c nf_queue.c nf_sockopt.c nf_internals.h; do
+        echo "netfilter/$i: $KERNELDIR/net/netfilter/$i" >> Makefile.import
+        echo '	@sed -f netfilter.c.sed $^ > $@ && chmod a-w $@' >> Makefile.import
+        echo "import: netfilter/$i" >> Makefile.import
+    done
+    # XXX this one imports net/ipv4/netfilter.c to
+    # netfilter/core/netfilter.c... this is actually wrong, and will be
+    # corrected in a later patch
+    echo "netfilter/core/netfilter.c: $KERNELDIR/net/$TYPE/netfilter.c" >> Makefile.import
+    echo '	@sed -f netfilter.c.sed $^ > $@ && chmod a-w $@' >> Makefile.import
+    echo "import: netfilter/core/netfilter.c" >> Makefile.import
+fi
 
 files=$(cd $KERNELDIR/net/$TYPE/netfilter/; \
 	find . -name '*.[ch]' ! -name '*.mod.c' | grep -vE '/(SCCS|RCS)/')
@@ -101,6 +117,17 @@
     echo '	@cp $^ $@ && chmod a-w $@' >> Makefile.import
     echo "import: netfilter/include/linux/netfilter_$TYPE/$f" >> Makefile.import
 done
+if [ -d $KERNELDIR/include/linux/netfilter ]; then
+    # present in Linux 2.6.14+
+    files=$(cd $KERNELDIR/include/linux/netfilter; \
+	find . -name '*.[ch]' | grep -vE '/(SCCS|RCS)/')
+    for f in $files; do
+        mkdir -p $(dirname netfilter/include/linux/netfilter/$f)
+        echo "netfilter/include/linux/netfilter/$f":"$KERNELDIR/include/linux/netfilter/$f" >> Makefile.import
+        echo '	@cp $^ $@ && chmod a-w $@' >> Makefile.import
+        echo "import: netfilter/include/linux/netfilter/$f" >> Makefile.import
+    done
+fi
 echo "netfilter/include/linux/netfilter_$TYPE.h":"$KERNELDIR/include/linux/netfilter_$TYPE.h" >> Makefile.import
 echo '	@cp $^ $@ && chmod a-w $@' >> Makefile.import
 echo "import: netfilter/include/linux/netfilter_$TYPE.h" >> Makefile.import
diff -rN -u old-nfsim-0/core/core.c new-nfsim-0/core/core.c
--- old-nfsim-0/core/core.c	2005-09-22 10:14:13.000000000 +0200
+++ new-nfsim-0/core/core.c	2005-09-22 10:12:18.000000000 +0200
@@ -127,6 +127,13 @@
 
 	return 0;
 }
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,14)
+static struct nf_queue_handler enqueue_packet_h = {
+	.outfn = enqueue_packet,
+	.data = NULL,
+	.name = "core.c:enqueue_packet",
+};
+#endif
 
 /* We want logging for every hook */
 unsigned int call_elem_hook(struct nf_hook_ops *ops,
@@ -485,7 +492,11 @@
 	if (load_modules && !load_all_modules())
 		barf("Module loading failed\n");
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,14)
+	nf_register_queue_handler(PF_INET, &enqueue_packet_h);
+#else
 	nf_register_queue_handler(PF_INET, enqueue_packet, NULL);
+#endif
 	
 	nfsim_log(LOG_UI, "initialisation done");
 
diff -rN -u old-nfsim-0/core/core.h new-nfsim-0/core/core.h
--- old-nfsim-0/core/core.h	2005-09-22 10:14:13.000000000 +0200
+++ new-nfsim-0/core/core.h	2005-09-22 10:12:18.000000000 +0200
@@ -84,6 +84,18 @@
 #define NF_MAX_VERDICT NF_REPEAT
 #endif
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,14)
+/* we overload the higher bits for encoding auxiliary data such as the queue
+ * number. Not nice, but better than additional function arguments. */
+#define NF_VERDICT_MASK 0x0000ffff
+#define NF_VERDICT_BITS 16
+
+#define NF_VERDICT_QMASK 0xffff0000
+#define NF_VERDICT_QBITS 16
+
+#define NF_QUEUE_NR(x) (((x << NF_VERDICT_QBITS) & NF_VERDICT_QMASK) | NF_QUEUE)
+#endif
+
 #define NF_MAX_HOOKS 8
 
 
@@ -184,15 +196,65 @@
 int nf_setsockopt(struct sock *sk, int pf, int val, char *opt, int len);
 int nf_getsockopt(struct sock *sk, int pf, int val, char *opt, int *len);
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,14)
+/* those NF_LOG_* defines and struct nf_loginfo are legacy definitios that will
+ * disappear once iptables is replaced with pkttables.  Please DO NOT use them
+ * for any new code! */
+#define NF_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
+#define NF_LOG_TCPOPT		0x02	/* Log TCP options */
+#define NF_LOG_IPOPT		0x04	/* Log IP options */
+#define NF_LOG_UID		0x08	/* Log UID owning local socket */
+#define NF_LOG_MASK		0x0f
+
+#define NF_LOG_TYPE_LOG		0x01
+#define NF_LOG_TYPE_ULOG	0x02
+
+struct nf_loginfo {
+	u_int8_t type;
+	union {
+		struct {
+			u_int32_t copy_len;
+			u_int16_t group;
+			u_int16_t qthreshold;
+		} ulog;
+		struct {
+			u_int8_t level;
+			u_int8_t logflags;
+		} log;
+	} u;
+};
+
+typedef void nf_logfn(unsigned int pf,
+		      unsigned int hooknum,
+		      const struct sk_buff *skb,
+		      const struct net_device *in,
+		      const struct net_device *out,
+		      const struct nf_loginfo *li,
+		      const char *prefix);
+
+struct nf_logger {
+	struct module	*me;
+	nf_logfn 	*logfn;
+	char		*name;
+};
+
+#else
 typedef void nf_logfn(unsigned int hooknum,
 		      const struct sk_buff *skb,
 		      const struct net_device *in,
 		      const struct net_device *out,
 		      const char *prefix);
+#endif
 
 /* Function to register/unregister log function. */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,14)
+int nf_log_register(int pf, struct nf_logger *logger);
+int nf_log_unregister_pf(int pf);
+void nf_log_unregister_logger(struct nf_logger *logger);
+#else
 int nf_log_register(int pf, nf_logfn *logfn);
 void nf_log_unregister(int pf, nf_logfn *logfn);
+#endif
 
 /* Calls the registered backend logging function */
 void nf_log_packet(int pf,
@@ -200,6 +262,9 @@
 		   const struct sk_buff *skb,
 		   const struct net_device *in,
 		   const struct net_device *out,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,14)
+		   struct nf_loginfo *li,
+#endif
 		   const char *fmt, ...);
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12)
@@ -231,15 +296,46 @@
 #endif
 
 /* Packet queuing */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,14)
+struct nf_queue_handler {
+	int (*outfn)(struct sk_buff *skb, struct nf_info *info,
+		     unsigned int queuenum, void *data);
+	void *data;
+	char *name;
+};
+extern int nf_register_queue_handler(int pf, 
+                                     struct nf_queue_handler *qh);
+#else
 typedef int (*nf_queue_outfn_t)(struct sk_buff *skb, 
                                 struct nf_info *info, void *data);
 extern int nf_register_queue_handler(int pf, 
                                      nf_queue_outfn_t outfn, void *data);
+#endif
 extern int nf_unregister_queue_handler(int pf);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,14)
+extern void nf_unregister_queue_handlers(struct nf_queue_handler *qh);
+#endif
 extern void nf_reinject(struct sk_buff *skb,
 			struct nf_info *info,
 			unsigned int verdict);
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,14)
+struct nf_queue_rerouter {
+	void (*save)(const struct sk_buff *skb, struct nf_info *info);
+	int (*reroute)(struct sk_buff **skb, const struct nf_info *info);
+	int rer_size;
+};
+
+#define nf_info_reroute(x) ((void *)x + sizeof(struct nf_info))
+extern int nf_register_queue_rerouter(int pf, struct nf_queue_rerouter *rer);
+extern int nf_unregister_queue_rerouter(int pf);
+
+#ifdef CONFIG_PROC_FS
+#include <linux/proc_fs.h>
+extern struct proc_dir_entry *proc_net_netfilter;
+#endif
+#endif
+
 /* Like alloc_skb, but never fails even when failtest on. */
 struct sk_buff *alloc_skb_internal(unsigned int size, int gfp_mask, const char *loc);
 
diff -rN -u old-nfsim-0/kernelenv/include/kernelenv.h new-nfsim-0/kernelenv/include/kernelenv.h
--- old-nfsim-0/kernelenv/include/kernelenv.h	2005-09-22 10:14:13.000000000 +0200
+++ new-nfsim-0/kernelenv/include/kernelenv.h	2005-09-22 10:12:18.000000000 +0200
@@ -181,6 +181,9 @@
 #define num_possible_cpus() 1
 #define for_each_cpu(cpu) for ((cpu) = 0; (cpu) < 1; (cpu)++)
 #define  SMP_CACHE_BYTES (1<<7)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,14)
+#define __read_mostly
+#endif
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 #define cpu_possible(cpu)	((cpu) == 0)
 #endif
diff -rN -u old-nfsim-0/netfilter/Makefile new-nfsim-0/netfilter/Makefile
--- old-nfsim-0/netfilter/Makefile	2005-09-22 10:14:13.000000000 +0200
+++ new-nfsim-0/netfilter/Makefile	2005-09-22 10:12:18.000000000 +0200
@@ -1,7 +1,12 @@
 
 all: dummy.o modules netfilter.o 
 
-netfilter.o: $(TYPE)/$(TYPE).o core/netfilter.o
+# XXX a hack to see if we're >= 2.6.14 - please rewrite
+ifeq ($(shell ls nf_queue.c 2>/dev/null),nf_queue.c)
+MORE_OBJ = core.o nf_log.o nf_queue.o nf_sockopt.o
+endif
+
+netfilter.o: $(TYPE)/$(TYPE).o core/netfilter.o $(MORE_OBJ)
 	ld -r -o $@ $^
 
 $(TYPE)/$(TYPE).o: $(TYPE)/


--ZGiS0Q5IWpPtfppv--
