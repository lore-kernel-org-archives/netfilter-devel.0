From: Patrick McHardy <kaber@trash.net>
Subject: Re: nfsim for Linux 2.6.12-rc4?
Date: Wed, 11 May 2005 22:06:55 +0200
Message-ID: <428265DF.70300@trash.net>
References: <20050511195652.GA14386@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090600060406050309070808"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20050511195652.GA14386@roonstrasse.net>
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

This is a multi-part message in MIME format.
--------------090600060406050309070808
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Max Kellermann wrote:
> is anyone already working on the Linux 2.6.12 port of nfsim?  If not,
> I'll do it.

I have this patch, but I can't recall if it worked correctly with it or
not. It needs at least a couple #if KERNEL_VERSION > ... before it can
be committed.

Regards
Patrick

--------------090600060406050309070808
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: core/core.h
===================================================================
--- core/core.h	(Revision 3887)
+++ core/core.h	(Arbeitskopie)
@@ -196,7 +196,7 @@
 		   const struct net_device *out,
 		   const char *fmt, ...);
 
-int nf_hook_slow(int pf, unsigned int hook, struct sk_buff *skb,
+int nf_hook_slow(int pf, unsigned int hook, struct sk_buff **skb,
 		 struct net_device *indev,
 		 struct net_device *outdev,
 		 int (*okfn)(struct sk_buff *)
@@ -207,8 +207,13 @@
 
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-#define NF_HOOK(pf, hook, skb, indev, outdev, okfn)			\
- nf_hook_slow((pf), (hook), (skb), (indev), (outdev), (okfn), INT_MIN)
+#define NF_HOOK(pf, hook, skb, indev, outdev, okfn)				\
+({ int _ret;									\
+  _ret = nf_hook_slow((pf), (hook), &(skb), (indev), (outdev), (okfn), INT_MIN); \
+  if (_ret == 1)								\
+	_ret = (okfn)(skb);							\
+  _ret;										\
+})
 #else
 #define NF_HOOK(pf, hook, skb, indev, outdev, okfn)			\
  nf_hook_slow((pf), (hook), (skb), (indev), (outdev), (okfn))
Index: kernelenv/include/kernelenv.h
===================================================================
--- kernelenv/include/kernelenv.h	(Revision 3887)
+++ kernelenv/include/kernelenv.h	(Arbeitskopie)
@@ -183,6 +183,7 @@
 #define cpu_possible(cpu)	((cpu) == 0)
 #endif
 #define smp_processor_id()	0
+#define num_possible_cpus()	1
 #define PAGE_SHIFT      12
 #define PAGE_SIZE	(1UL << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
@@ -244,6 +245,17 @@
 
 extern unsigned long jiffies;
 
+static inline unsigned long msecs_to_jiffies(const unsigned int m)
+{
+#if HZ <= 1000 && !(1000 % HZ)
+        return (m + (1000 / HZ) - 1) / (1000 / HZ);
+#elif HZ > 1000 && !(HZ % 1000)
+        return m * (HZ / 1000);
+#else
+        return (m * HZ + 999) / 1000;
+#endif
+}
+
 #define typecheck(type,x) \
 ({	type __dummy; \
 	typeof(x) __dummy2; \
@@ -929,8 +941,8 @@
 
 };
 
-u32 dst_path_metric(struct dst_entry *dst, int metric);
-u32 dst_pmtu(struct dst_entry *dst);
+u32 dst_metric(struct dst_entry *dst, int metric);
+u32 dst_mtu(struct dst_entry *dst);
 
 #define dst_release(x)
 #define dst_hold(x)
Index: kernelenv/kernelenv.c
===================================================================
--- kernelenv/kernelenv.c	(Revision 3887)
+++ kernelenv/kernelenv.c	(Arbeitskopie)
@@ -583,16 +583,16 @@
 #endif
 }
 
-u32 dst_path_metric(struct dst_entry *dst, int metric)
+u32 dst_metric(struct dst_entry *dst, int metric)
 {
 	return 1500;
 /*	return dst->path->metrics[metric-1]; */
 }
 
 
-u32 dst_pmtu(struct dst_entry *dst)
+u32 dst_mtu(struct dst_entry *dst)
 {
-	u32 mtu = dst_path_metric(dst, RTAX_MTU);
+	u32 mtu = dst_metric(dst, RTAX_MTU);
 	/* Yes, _exactly_. This is paranoia. */
 	barrier();
 	return mtu;

--------------090600060406050309070808--
