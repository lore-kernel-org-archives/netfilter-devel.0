From: "Eric Leblond" <eric@inl.fr>
Subject: [PATCH 3/3] ulogd2 update
Date: Wed, 11 Oct 2006 00:01:15 +0200 (CEST)
Message-ID: <4295.83.156.0.70.1160517675.squirrel@mail.inl.fr>
References: <2289.83.156.0.70.1160517260.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20061011000115_77100"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <2289.83.156.0.70.1160517260.squirrel@mail.inl.fr>
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

------=_20061011000115_77100
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi,

This patch fixes a trivial typo in ULOG plugin code.

BR,
--
Eric Leblond
INL : http://www.inl.fr
NuFW, Now User Filtering Works (http://www.nufw.org)
------=_20061011000115_77100
Content-Type: text/x-patch; name="ulogd2-typo.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="ulogd2-typo.patch"

=== input/packet/ulogd_inppkt_ULOG.c
==================================================================
--- input/packet/ulogd_inppkt_ULOG.c	(revision 4623)
+++ input/packet/ulogd_inppkt_ULOG.c	(revision 4624)
@@ -13,7 +13,7 @@
 #define ULOGD_NLGROUP_DEFAULT	32
 #endif
 
-/* Size of the socket recevive memory.  Should be at least the same size as the
+/* Size of the socket receive memory.  Should be at least the same size as the
  * 'nlbufsiz' module loadtime parameter of ipt_ULOG.o
  * If you have _big_ in-kernel queues, you may have to increase this number.  (
  * --qthreshold 100 * 1500 bytes/packet = 150kB  */
------=_20061011000115_77100--
