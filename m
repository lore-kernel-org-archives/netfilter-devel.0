From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 3/4] skip sizechecking when not specified
Date: Thu, 10 Nov 2005 02:04:11 +0100
Message-ID: <43729C8B.5010504@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070403000800090808090402"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------070403000800090808090402
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch applies to nfnetlink. Skip sizecheck if the size of the
attribute wasn't specified, ie. zero.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------070403000800090808090402
Content-Type: text/plain;
 name="06-check-bad-size.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06-check-bad-size.patch"

Skip sizecheck if the size of the attribute wasn't specified, ie. zero.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/include/linux/netfilter/nfnetlink.h
===================================================================
--- netfilter-2.6.14.git.orig/include/linux/netfilter/nfnetlink.h	2005-11-06 19:31:06.000000000 +0100
+++ netfilter-2.6.14.git/include/linux/netfilter/nfnetlink.h	2005-11-06 19:31:28.000000000 +0100
@@ -154,11 +154,14 @@ extern void nfattr_parse(struct nfattr *
 
 #define nfattr_bad_size(tb, max, cta_min)				\
 ({	int __i, __res = 0;						\
- 	for (__i=0; __i<max; __i++) 					\
+ 	for (__i=0; __i<max; __i++) {					\
+ 		if (!cta_min[__i])					\
+ 			continue;					\
  		if (tb[__i] && NFA_PAYLOAD(tb[__i]) < cta_min[__i]){	\
  			__res = 1;					\
  			break;						\
  		}							\
+ 	}								\
  	__res;								\
 })
 

--------------070403000800090808090402--
