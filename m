From: Pablo Neira <pablo@eurodev.net>
Subject: [IPTABLES] [PATCH] fix is_same with userspacesize != size in targets
Date: Sun, 06 Mar 2005 23:41:36 +0100
Message-ID: <422B8720.2000208@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050306050606010708050402"
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
--------------050306050606010708050402
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I've discovered a bug in same_is while fixing deletion in CLUSTERIP.

CLUSTERIP has to define a different userspacesize for the private target 
info because of the config pointer, this should be enough to fix rule 
deletion but the function same_is returns a wrong pointer to the 
comparation mask array since it doesn't add the size of ipt_entry. 
Because of that, target_same returns 0 and no rule matches.

Impact: This just affects rule deletion with targets that has 
userspacesize != size.

--
Pablo

--------------050306050606010708050402
Content-Type: text/x-patch;
 name="fix-del-with-userspacesize-target.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="fix-del-with-userspacesize-target.patch"

Index: libiptc/libip4tc.c
===================================================================
--- libiptc/libip4tc.c	(revision 3742)
+++ libiptc/libip4tc.c	(working copy)
@@ -210,6 +210,7 @@
 	mptr = matchmask + sizeof(STRUCT_ENTRY);
 	if (IPT_MATCH_ITERATE(a, match_different, a->elems, b->elems, &mptr))
 		return NULL;
+	mptr += IPT_ALIGN(sizeof(struct ipt_entry_target));
 
 	return mptr;
 }
Index: libiptc/libip6tc.c
===================================================================
--- libiptc/libip6tc.c	(revision 3742)
+++ libiptc/libip6tc.c	(working copy)
@@ -242,6 +242,7 @@
 	mptr = matchmask + sizeof(STRUCT_ENTRY);
 	if (IP6T_MATCH_ITERATE(a, match_different, a->elems, b->elems, &mptr))
 		return NULL;
+	mptr += IP6T_ALIGN(sizeof(struct ip6t_entry_target));
 
 	return mptr;
 }

--------------050306050606010708050402--
