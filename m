From: Henrik Nordstrom <hno@marasystems.com>
Subject: pending/63_getorigdst-tuple-zero syntax error
Date: Tue, 9 Sep 2003 11:19:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200309091104.19260@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_ZJWXNW84N3N510UJVHU1"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_ZJWXNW84N3N510UJVHU1
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit

Harald:

The current IP_CT_TUPLE_BLANK() macro expansion does not protect it's 
arguments, making a syntax error in ip_conntrack_core when the macro 
is used IP_CT_TUPLE_BLANK(&tuple);

This expands to &tuple->memberfield which is not what is expected.. 
(&tuple)->memberfield or tuple.memberfield would work.

The attached patch adds the required parantesis around the macro 
argument expansions giving (&tuple)->member in the expansion.

Regards
Henrik


--------------Boundary-00=_ZJWXNW84N3N510UJVHU1
Content-Type: text/x-diff;
  charset="us-ascii";
  name="63_getorigdst-tuple-zero-parantesis.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="63_getorigdst-tuple-zero-parantesis.patch"

Index: pending/63_getorigdst-tuple-zero.patch
===================================================================
RCS file: /cvspublic/netfilter/patch-o-matic/pending/63_getorigdst-tuple-zero.patch,v
retrieving revision 1.2
diff -u -w -p -r1.2 63_getorigdst-tuple-zero.patch
--- pending/63_getorigdst-tuple-zero.patch	5 Sep 2003 15:13:15 -0000	1.2
+++ pending/63_getorigdst-tuple-zero.patch	9 Sep 2003 08:58:16 -0000
@@ -9,8 +9,8 @@ diff -Nru --exclude .depend --exclude '*
 + * really care about is the  source/destination unions */
 +#define IP_CT_TUPLE_BLANK(tuple) 				\
 +	do {							\
-+		tuple->src.u.all = 0;				\
-+		tuple->dst.u.all = 0;				\
++		(tuple)->src.u.all = 0;				\
++		(tuple)->dst.u.all = 0;				\
 +	} while (0)
 +
  enum ip_conntrack_dir

--------------Boundary-00=_ZJWXNW84N3N510UJVHU1--
