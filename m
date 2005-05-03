From: Pawel Sikora <pluto@pld-linux.org>
Subject: [PATCH] conntrack-mms / keep hook private.
Date: Tue, 3 May 2005 09:28:15 +0200
Message-ID: <200505030928.16263.pluto@pld-linux.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_QgydC+GZRUssHen"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
	netfilter-devel@lists.netfilter.org
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

--Boundary-00=_QgydC+GZRUssHen
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All,

IMHO the hook should be a private part of a kernel
(similar to other conntrack modules).
Attached patch hide the mms hook from userland.

Regards,
Pawel.

-- 
The only thing necessary for the triumph of evil
  is for good men to do nothing.
                                           - Edmund Burke

--Boundary-00=_QgydC+GZRUssHen
Content-Type: text/x-diff; charset="utf-8";
	name="mms-conntrack-keep_hook_private.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="mms-conntrack-keep_hook_private.patch"

Index: mms-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_mms.h
===================================================================
--- mms-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_mms.h	(revision 3889)
+++ mms-conntrack-nat/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_mms.h	(working copy)
@@ -30,9 +30,11 @@
 };
 
 struct ip_conntrack_expect;
+#ifdef __KERNEL__
 extern unsigned int (*ip_nat_mms_hook)(struct sk_buff **pskb,
 				       enum ip_conntrack_info ctinfo,
 				       const struct ip_ct_mms_expect *exp_mms_info,
 				       struct ip_conntrack_expect *exp);
+#endif
 
 #endif /* _IP_CONNTRACK_MMS_H */

--Boundary-00=_QgydC+GZRUssHen--
