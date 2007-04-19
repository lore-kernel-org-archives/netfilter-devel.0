From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Subject: [PATCH] xx_nat_proto_gre: gre_key returns wrong pointer
Date: Thu, 19 Apr 2007 18:18:35 +0200
Message-ID: <00c501c7829e$6209edd0$061010ac@intranet.dti2.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

    Hi,

    While porting some changes of the 2.6.21-rc7 pptp/proto_gre conntrack 
and nat modules to a 2.4.32 kernel I noticed that the gre_key function 
returns a wrong pointer to the GRE key of a version 0 packet. I fixed it the 
way below but I don't know if it is right way. The gre_csum function seems 
to have the same problem. If the problem is real and the solution right I 
can resend with a signed-off line.

---  
linux-2.6.21-rc7.orig/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h 
2007-04-19 17:54:26.000000000 +0200
+++ linux-2.6.21-rc7/include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h 
2007-04-19 17:55:11.000000000 +0200
@@ -97,8 +97,8 @@
  if (!greh->key)
   return NULL;
  if (greh->csum || greh->routing)
-  return (__be32 *) (greh+sizeof(*greh)+4);
- return (__be32 *) (greh+sizeof(*greh));
+  return (__be32 *) ((void *)greh+sizeof(*greh)+4);
+ return (__be32 *) ((void *)greh+sizeof(*greh));
 }

 /* get pointer ot gre csum, if present */
@@ -106,7 +106,7 @@
 {
  if (!greh->csum)
   return NULL;
- return (__sum16 *) (greh+sizeof(*greh));
+ return (__sum16 *) ((void *)greh+sizeof(*greh));
 }

 #endif /* __KERNEL__ */

    -Jorge

==============================================================
Jorge Boncompte - Ingenieria y Gestion de RED
DTI2 - Desarrollo de la Tecnologia de las Comunicaciones
--------------------------------------------------------------
C/ Abogado Enriquez Barrios, 5   14004 CORDOBA (SPAIN)
Tlf: +34 957 761395 / FAX: +34 957 450380
==============================================================
- Sin pistachos no hay Rock & Roll...
- Without wicker a basket cannot be made.
==============================================================
