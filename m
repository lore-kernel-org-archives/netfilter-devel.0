From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] conntrack-mms / keep hook private.
Date: Tue, 03 May 2005 20:01:28 +0200
Message-ID: <4277BC78.9080207@trash.net>
References: <200505030928.16263.pluto@pld-linux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080503010905030508070002"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pawel Sikora <pluto@pld-linux.org>
In-Reply-To: <200505030928.16263.pluto@pld-linux.org>
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
--------------080503010905030508070002
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Pawel Sikora wrote:
> Hi All,
> 
> IMHO the hook should be a private part of a kernel
> (similar to other conntrack modules).
> Attached patch hide the mms hook from userland.

I agree, but in fact nothing of the entire file should be
visible, so I've applied this patch instead.

--------------080503010905030508070002
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_mms.h
===================================================================
--- linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_mms.h	(Revision 3890)
+++ linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_mms.h	(Arbeitskopie)
@@ -15,7 +15,6 @@
 #define MMS_SRV_CHUNKLENLV_OFFSET        16
 #define MMS_SRV_CHUNKLENLM_OFFSET        32
 #define MMS_SRV_MESSAGELENGTH_OFFSET     8
-#endif
 
 /* This structure is per expected connection */
 struct ip_ct_mms_expect {
@@ -34,5 +33,5 @@
 				       enum ip_conntrack_info ctinfo,
 				       const struct ip_ct_mms_expect *exp_mms_info,
 				       struct ip_conntrack_expect *exp);
-
+#endif
 #endif /* _IP_CONNTRACK_MMS_H */

--------------080503010905030508070002--
