From: "Eric Lauriault" <elauri@lacitec.on.ca>
Subject: Re: extra/string inital port to 2.6
Date: Mon, 29 Mar 2004 11:09:07 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <s068041a.004@email.lacitec.on.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi.

Here's the patch. Seems to work for me.



--- ipt_string-2.4.c    Mon Mar 29 06:00:23 2004
+++ ipt_string-2.6.c    Mon Mar 29 06:01:04 2004
@@ -3,6 +3,8 @@
  * Copyright (C) 2000 Emmanuel Roger  <winfield@freegates.be>
  * 
  * ChangeLog
+ *     24.03.2004: Eric Lauriault <elauri@lacitec.on.ca>
+ *             Initial 2.6 port
  *     19.02.2002: Gianni Tedesco <gianni@ecsc.co.uk>
  *             Fixed SMP re-entrancy problem using per-cpu data areas
  *             for the skip/shift tables.
@@ -18,6 +20,7 @@
  */
 
 #include <linux/smp.h>
+#include <linux/percpu.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/file.h>
@@ -29,12 +32,13 @@
 MODULE_LICENSE("GPL");
 
 struct string_per_cpu {
-       int *skip;
-       int *shift;
-       int *len;
+       int skip[BM_MAX_HLEN];
+       int shift[BM_MAX_HLEN];
+       int len[BM_MAX_HLEN];
 };
 
-struct string_per_cpu *bm_string_data=NULL;
+static DEFINE_PER_CPU(struct string_per_cpu, bm_string_data);
+
 
 /* Boyer Moore Sublinear string search - VERY FAST */
 char *search_sublinear (char *needle, char *haystack, int needle_len,
int haystack_len) 
@@ -45,14 +49,14 @@
        int *skip, *shift, *len;
        
        /* use data suitable for this CPU */
-       shift=bm_string_data[smp_processor_id()].shift;
-       skip=bm_string_data[smp_processor_id()].skip;
-       len=bm_string_data[smp_processor_id()].len;
+       shift=__get_cpu_var(bm_string_data).shift;
+       skip=__get_cpu_var(bm_string_data).skip;
+       len=__get_cpu_var(bm_string_data).len;
        
        /* Setup skip/shift tables */
        M1 = right_end = needle_len-1;
        for (i = 0; i < BM_MAX_HLEN; i++) skip[i] = needle_len;  
-       for (i = 0; needle[i]; i++) skip[needle[i]] = M1 - i;  
+       for (i = 0; needle[i]; i++) skip[(int)needle[i]] = M1 - i;
 
        for (i = 1; i < needle_len; i++) {   
                for (j = 0; j < needle_len && needle[M1 - j] ==
needle[M1 - i - j]; j++);  
@@ -77,7 +81,7 @@
                        return haystack+(right_end - M1);
                }
                
-               sk = skip[haystack[right_end - i]];  
+               sk = skip[(int)haystack[right_end - i]];  
                sh = shift[i];
                right_end = max(right_end - i + sk, right_end + sh);  
        }
@@ -100,15 +104,12 @@
        return NULL;
 }
 
-
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *hdr,
-      u_int16_t datalen,
       int *hotdrop)
 {
        const struct ipt_string_info *info = matchinfo;
@@ -158,61 +159,25 @@
        return 1;
 }
 
-void string_freeup_data(void)
-{
-       int c;
-       
-       if ( bm_string_data ) {
-               for(c=0; c<smp_num_cpus; c++) {
-                       if ( bm_string_data[c].shift )
kfree(bm_string_data[c].shift);
-                       if ( bm_string_data[c].skip )
kfree(bm_string_data[c].skip);
-                       if ( bm_string_data[c].len )
kfree(bm_string_data[c].len);
-               }
-               kfree(bm_string_data);
-       }
-}
+static struct ipt_match string_match = {
+    .name = "string",
+    .match = &match,
+    .checkentry = &checkentry,
+    .me = THIS_MODULE
+};
 
-static struct ipt_match string_match
-= { { NULL, NULL }, "string", &match, &checkentry, NULL, THIS_MODULE };
 
 static int __init init(void)
 {
-       int c;
-       size_t tlen;
-       size_t alen;
-
-       tlen=sizeof(struct string_per_cpu)*smp_num_cpus;
-       alen=sizeof(int)*BM_MAX_HLEN;
-       
-       /* allocate array of structures */
-       if ( !(bm_string_data=kmalloc(tlen,GFP_KERNEL)) ) {
-               return 0;
-       }
-       
-       memset(bm_string_data, 0, tlen);
-       
-       /* allocate our skip/shift tables */
-       for(c=0; c<smp_num_cpus; c++) {
-               if ( !(bm_string_data[c].shift=kmalloc(alen,
GFP_KERNEL)) )
-                       goto alloc_fail;
-               if ( !(bm_string_data[c].skip=kmalloc(alen, GFP_KERNEL))
)
-                       goto alloc_fail;
-               if ( !(bm_string_data[c].len=kmalloc(alen, GFP_KERNEL))
)
-                       goto alloc_fail;
-       }
-       
        return ipt_register_match(&string_match);
-
-alloc_fail:
-       string_freeup_data();
-       return 0;
 }
 
 static void __exit fini(void)
 {
        ipt_unregister_match(&string_match);
-       string_freeup_data();
 }
 
 module_init(init);
 module_exit(fini);
+
+






Eric Lauriault, eric@lacitec.on.ca
Analyste/Administrateur UNIX/telecom/reseau
La Cite collegiale
>>> Harald Welte <laforge@netfilter.org> 03/28/04 1:37 PM >>>
On Wed, Mar 24, 2004 at 01:49:34PM -0500, Eric Lauriault wrote:
> Hi,
> 
> Just did a quick and dirty port of ipt_string to 2.6 using rusty's
> comments from feb. Who should I submit it to?

This mailinglist ;)

> Thanks,

-- 
- Harald Welte <laforge@netfilter.org>            
http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
