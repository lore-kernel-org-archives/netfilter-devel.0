From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: [PATCH] info file for ROUTE target
Date: Thu, 09 Dec 2004 15:43:00 +0100
Message-ID: <1102603380.7528.98.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-BvNmM6aIvkRjjjpu9XW0"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
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


--=-BvNmM6aIvkRjjjpu9XW0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

This little patch is to allow the ROUTE target to be applied by pom-ng
on kernel >= 2.6.0. The patch just removes the "Requires: linux < 2.6.0"
line from the ROUTE/info file.

Please apply ;)

Thanks,

Cedric


--=-BvNmM6aIvkRjjjpu9XW0
Content-Disposition: attachment; filename=ipt_ROUTE-info.patch
Content-Type: text/x-patch; name=ipt_ROUTE-info.patch; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by info.ucl.ac.be id
	iB9EeZgj014598

--- patch-o-matic-ng.orig/ROUTE/info	2004-02-20 00:11:50.000000000 +0100
+++ patch-o-matic-ng/ROUTE/info	2004-12-09 15:33:55.000000000 +0100
@@ -1,4 +1,3 @@
 Author: C=E9dric de Launois <delaunois@info.ucl.ac.be>
 Status: Experimental
 Repository: extra
-Requires: linux < 2.6.0

--=-BvNmM6aIvkRjjjpu9XW0--
