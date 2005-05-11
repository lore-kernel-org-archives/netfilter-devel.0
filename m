From: Max Kellermann <max@duempel.org>
Subject: Re: nfsim for Linux 2.6.12-rc4?
Date: Wed, 11 May 2005 23:52:17 +0200
Message-ID: <20050511215217.GA15481@roonstrasse.net>
References: <20050511195652.GA14386@roonstrasse.net> <428265DF.70300@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <428265DF.70300@trash.net>
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


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2005/05/11 22:06, Patrick McHardy <kaber@trash.net> wrote:
> I have this patch, but I can't recall if it worked correctly with it or
> not. It needs at least a couple #if KERNEL_VERSION > ... before it can
> be committed.

Now here is a patch which replaces yours, with the correct
#ifs. Tested on both 2.6.11 and 2.6.12. Note that the previous patch I
posted this evening (nfsim-2.6.12-defs.patch) is still required.

Max


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nfsim-2.6.12-api.patch"

Wed May 11 23:48:01 CEST 2005  max@duempel.org
  * 2.6.11 corrections for patrick's patch
Wed May 11 22:41:47 CEST 2005  max@duempel.org
  * Patrick's 2.6.12 patch
diff -rN -u old-nfsim-12/core/core.h new-nfsim-12/core/core.h
--- old-nfsim-12/core/core.h	2005-05-11 23:52:20.000000000 +0200
+++ new-nfsim-12/core/core.h	2005-05-11 23:51:19.000000000 +0200
@@ -196,7 +196,11 @@
 		   const struct net_device *out,
 		   const char *fmt, ...);
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12)
+int nf_hook_slow(int pf, unsigned int hook, struct sk_buff **skb,
+#else
 int nf_hook_slow(int pf, unsigned int hook, struct sk_buff *skb,
+#endif
 		 struct net_device *indev,
 		 struct net_device *outdev,
 		 int (*okfn)(struct sk_buff *)
@@ -206,8 +210,16 @@
 		 );
 
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-#define NF_HOOK(pf, hook, skb, indev, outdev, okfn)			\
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12)
+#define NF_HOOK(pf, hook, skb, indev, outdev, okfn)				\
+({ int _ret;									\
+  _ret = nf_hook_slow((pf), (hook), &(skb), (indev), (outdev), (okfn), INT_MIN); \
+  if (_ret == 1)								\
+	_ret = (okfn)(skb);							\
+  _ret;										\
+})
+#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+#define NF_HOOK(pf, hook, skb, indev, outdev, okfn)                    \
  nf_hook_slow((pf), (hook), (skb), (indev), (outdev), (okfn), INT_MIN)
 #else
 #define NF_HOOK(pf, hook, skb, indev, outdev, okfn)			\
diff -rN -u old-nfsim-12/kernelenv/include/kernelenv.h new-nfsim-12/kernelenv/include/kernelenv.h
--- old-nfsim-12/kernelenv/include/kernelenv.h	2005-05-11 23:52:20.000000000 +0200
+++ new-nfsim-12/kernelenv/include/kernelenv.h	2005-05-11 23:51:19.000000000 +0200
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
@@ -929,8 +941,13 @@
 
 };
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12)
+u32 dst_metric(struct dst_entry *dst, int metric);
+u32 dst_mtu(struct dst_entry *dst);
+#else
 u32 dst_path_metric(struct dst_entry *dst, int metric);
 u32 dst_pmtu(struct dst_entry *dst);
+#endif
 
 #define dst_release(x)
 #define dst_hold(x)
diff -rN -u old-nfsim-12/kernelenv/kernelenv.c new-nfsim-12/kernelenv/kernelenv.c
--- old-nfsim-12/kernelenv/kernelenv.c	2005-05-11 23:52:20.000000000 +0200
+++ new-nfsim-12/kernelenv/kernelenv.c	2005-05-11 23:51:19.000000000 +0200
@@ -583,16 +583,28 @@
 #endif
 }
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12)
+u32 dst_metric(struct dst_entry *dst, int metric)
+#else
 u32 dst_path_metric(struct dst_entry *dst, int metric)
+#endif
 {
 	return 1500;
 /*	return dst->path->metrics[metric-1]; */
 }
 
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12)
+u32 dst_mtu(struct dst_entry *dst)
+#else
 u32 dst_pmtu(struct dst_entry *dst)
+#endif
 {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12)
+	u32 mtu = dst_metric(dst, RTAX_MTU);
+#else
 	u32 mtu = dst_path_metric(dst, RTAX_MTU);
+#endif
 	/* Yes, _exactly_. This is paranoia. */
 	barrier();
 	return mtu;


--vkogqOf2sHV7VnPd--
