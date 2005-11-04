From: Eric Leblond <eric@inl.fr>
Subject: autogen.sh cleaning anq question on libnetfilter_queue
Date: Fri, 04 Nov 2005 01:26:50 +0100
Message-ID: <1131064011.11853.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-G4FfilNOJRYmKn2eN0lK"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Laforge@netfilter.org
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


--=-G4FfilNOJRYmKn2eN0lK
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

This is just a %s/-1\.6// on autogen.sh.

By the way, what is needed to be able to see the firt libnetfilter_queue
release ?

BR, 
-- 
Eric Leblond <eric@inl.fr>

--=-G4FfilNOJRYmKn2eN0lK
Content-Disposition: attachment; filename=netfilter_queue_autogen.patch
Content-Type: text/x-patch; name=netfilter_queue_autogen.patch;
	charset=us-ascii
Content-Transfer-Encoding: 7bit

==== Patch <netfilter_queue_autogen> level 1
Source: [No source]
Target: f6f8485a-58f1-0310-9e83-9cad51fe5e11:/netfilter/libnetfilter_queue:1217
Log:
suppress 1.6 explicit linking
=== autogen.sh
==================================================================
--- autogen.sh	(revision 1217)
+++ autogen.sh	(patch netfilter_queue_autogen level 1)
@@ -11,7 +11,8 @@
     fi
 }
 
-run aclocal-1.6
+run aclocal
+run libtoolize -f
 #run autoheader
-run automake-1.6 -a
+run automake -a
 run autoconf

==== BEGIN SVK PATCH BLOCK ====
Version: svk 1.04 (linux)

eJxdkcGO0zAQhntEvcETVMJ77DbjxE5SpKgXEBISQrBwjZx43FrrTYLjVLvIlz4Rr4idtAhxsTye
fz7PP/PBPrw7gK+qxBNI/Lcfn/b7L8K1p7sQEe5RatdbwrzBMxqSetMfSeY78YQh64Q9oqsqCMXF
Uvx+LrhBsshohOu7kZQzrHYWkYCnh9QfqA9nCCAk+wG72va9C3igkIdkHVtqTT9iHUujnEU5vcmV
Nhg1YnL9Ebv78TTDroA0AtgVILXFNnT2EhULac6KYTAvtcNnJ9E4MdNT6jkrGgqQYJFyKgFayIWQ
lJdtzlpsWsJ58Pt5tbp8vHx9tVtd3qx+v77kazt1G6Mb1/dG/8LNVq3fxqfY4AmFRLu+hU/iEQ/Z
vx4XN8v/kucllwmWjKpwaRQ0TdbkUjEFhcR89klLP07DYHEcN3DPN/g8GN1qFzroHnV3JDT1HbrA
dWjrnxNOWF9HVVXUE0qXnT3Ma9zvv3f6jHYU5o77MMRBuFPYuMVzCKZJy/jh7i9wF3z+R79OnqTc
K66KrGBiywoF2ySFZFuGYW7LVkgGChkC/AHzFNG0
==== END SVK PATCH BLOCK ====

--=-G4FfilNOJRYmKn2eN0lK--
