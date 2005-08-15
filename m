From: Marcin Garski <mgarski@post.pl>
Subject: Patch for TTL target
Date: Mon, 15 Aug 2005 15:52:59 +0200
Message-ID: <200508151552.59571.mgarski@post.pl>
Reply-To: mgarski@post.pl
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_74JADJ6eK33nprg"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

--Boundary-00=_74JADJ6eK33nprg
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[Please CC me on replies, I am not subscribed to the list, thanks]

Hello,

Here is the patch that fix some C formatting issues (so source are more 
readable).

-- 
Best Regards
Marcin Garski

--Boundary-00=_74JADJ6eK33nprg
Content-Type: text/x-diff;
  charset="iso-8859-2";
  name="TTL-format.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="TTL-format.patch"

diff -ur patch-o-matic-ng-20050814-orig/patchlets/TTL/linux/net/ipv4/netfilter/ipt_TTL.c patch-o-matic-ng-20050814/patchlets/TTL/linux/net/ipv4/netfilter/ipt_TTL.c
--- patch-o-matic-ng-20050814-orig/patchlets/TTL/linux/net/ipv4/netfilter/ipt_TTL.c	2004-07-27 21:24:31.000000000 +0200
+++ patch-o-matic-ng-20050814/patchlets/TTL/linux/net/ipv4/netfilter/ipt_TTL.c	2005-08-15 15:31:13.000000000 +0200
@@ -26,7 +26,7 @@
 	const struct ipt_TTL_info *info = targinfo;
 	u_int16_t diffs[2];
 	int new_ttl;
-			 
+
 	switch (info->mode) {
 		case IPT_TTL_SET:
 			new_ttl = info->ttl;
@@ -51,9 +51,9 @@
 		iph->ttl = new_ttl;
 		diffs[1] = htons(((unsigned)iph->ttl) << 8);
 		iph->check = csum_fold(csum_partial((char *)diffs,
-						    sizeof(diffs),
-				 	            iph->check^0xFFFF));
-									                	(*pskb)->nfcache |= NFC_ALTERED;
+						sizeof(diffs),
+						iph->check^0xFFFF));
+		(*pskb)->nfcache |= NFC_ALTERED;
 	}
 
 	return IPT_CONTINUE;
@@ -71,8 +71,8 @@
 		printk(KERN_WARNING "TTL: targinfosize %u != %Zu\n",
 				targinfosize,
 				IPT_ALIGN(sizeof(struct ipt_TTL_info)));
-		return 0;	
-	}	
+		return 0;
+	}
 
 	if (strcmp(tablename, "mangle")) {
 		printk(KERN_WARNING "TTL: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
@@ -89,7 +89,7 @@
 		printk(KERN_WARNING "TTL: increment/decrement doesn't make sense with value 0\n");
 		return 0;
 	}
-	
+
 	return 1;
 }
 
diff -ur patch-o-matic-ng-20050814-orig/patchlets/TTL/linux-2.6/net/ipv4/netfilter/ipt_TTL.c patch-o-matic-ng-20050814/patchlets/TTL/linux-2.6/net/ipv4/netfilter/ipt_TTL.c
--- patch-o-matic-ng-20050814-orig/patchlets/TTL/linux-2.6/net/ipv4/netfilter/ipt_TTL.c	2004-07-27 21:24:31.000000000 +0200
+++ patch-o-matic-ng-20050814/patchlets/TTL/linux-2.6/net/ipv4/netfilter/ipt_TTL.c	2005-08-15 15:34:07.000000000 +0200
@@ -32,7 +32,7 @@
 		return NF_DROP;
 
 	iph = (*pskb)->nh.iph;
-			 
+
 	switch (info->mode) {
 		case IPT_TTL_SET:
 			new_ttl = info->ttl;
@@ -57,9 +57,9 @@
 		iph->ttl = new_ttl;
 		diffs[1] = htons(((unsigned)iph->ttl) << 8);
 		iph->check = csum_fold(csum_partial((char *)diffs,
-						    sizeof(diffs),
-				 	            iph->check^0xFFFF));
-									                	(*pskb)->nfcache |= NFC_ALTERED;
+						sizeof(diffs),
+						iph->check^0xFFFF));
+		(*pskb)->nfcache |= NFC_ALTERED;
 	}
 
 	return IPT_CONTINUE;
@@ -77,8 +77,8 @@
 		printk(KERN_WARNING "TTL: targinfosize %u != %Zu\n",
 				targinfosize,
 				IPT_ALIGN(sizeof(struct ipt_TTL_info)));
-		return 0;	
-	}	
+		return 0;
+	}
 
 	if (strcmp(tablename, "mangle")) {
 		printk(KERN_WARNING "TTL: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
@@ -95,7 +95,7 @@
 		printk(KERN_WARNING "TTL: increment/decrement doesn't make sense with value 0\n");
 		return 0;
 	}
-	
+
 	return 1;
 }
 

--Boundary-00=_74JADJ6eK33nprg--
