From: Pawel Sikora <pluto@pld-linux.org>
Subject: [PATCH] conntrack-mms / gcc4 fix.
Date: Tue, 3 May 2005 09:22:33 +0200
Message-ID: <200505030922.34134.pluto@pld-linux.org>
References: <200504282149.08554.pluto@pld-linux.org>
	<4271707A.5060603@trash.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_6aydCTpX4YilxkN"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <4271707A.5060603@trash.net>
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

--Boundary-00=_6aydCTpX4YilxkN
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All,

During build with gcc4 I get:

  CC [M]  net/ipv4/netfilter/ip_conntrack_mms.o
          net/ipv4/netfilter/ip_conntrack_mms.c:55:
  error: static declaration of 'ip_nat_mms_hook'
  follows non-static declaration
  include/linux/netfilter_ipv4/ip_conntrack_mms.h:37:
  error: previous declaration of 'ip_nat_mms_hook' was here

Attached patch fixes it and should be applied.

Regards,
Pawel.

-- 
The only thing necessary for the triumph of evil
  is for good men to do nothing.
                                           - Edmund Burke

--Boundary-00=_6aydCTpX4YilxkN
Content-Type: text/x-diff; charset="iso-8859-1";
	name="mms_conntrack-gcc4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="mms_conntrack-gcc4.patch"

--- mms-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_mms.c	(revision 3889)
+++ mms-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_mms.c	(working copy)
@@ -49,10 +49,10 @@
 static char mms_buffer[65536];
 static DECLARE_LOCK(mms_buffer_lock);
 
-static unsigned int (*ip_nat_mms_hook)(struct sk_buff **pskb,
-				       enum ip_conntrack_info ctinfo,
-				       const struct ip_ct_mms_expect *exp_mms_info,
-				       struct ip_conntrack_expect *exp);
+unsigned int (*ip_nat_mms_hook)(struct sk_buff **pskb,
+				enum ip_conntrack_info ctinfo,
+				const struct ip_ct_mms_expect *exp_mms_info,
+				struct ip_conntrack_expect *exp);
 EXPORT_SYMBOL(ip_nat_mms_hook);
 
 #if 0 

--Boundary-00=_6aydCTpX4YilxkN--
