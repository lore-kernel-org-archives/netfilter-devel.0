From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [patch] conntrack tool: Fix loading of protocol helpers
Date: Fri, 16 Mar 2007 17:51:08 +0100
Message-ID: <200703161751.08498.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8rs+FULfOrgwDzH"
To: netfilter-devel@lists.netfilter.org
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

--Boundary-00=_8rs+FULfOrgwDzH
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

the pkgconfig changes from August 2006 broke the loading of the protocol 
helpers as dlopen() doesn't search for symbols in the main executable.
As a result the protocol helpers can't find register_proto().

Attached patch fixes the problem.

Does anyone have a short example how to use the -G functionality of the tool?

Have a nice weekend,
Thomas

--Boundary-00=_8rs+FULfOrgwDzH
Content-Type: text/x-diff; charset="iso-8859-1";
	name="conntrack-dlopen-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="conntrack-dlopen-fix.patch"

diff -u -r -p conntrack-20070315/src/Makefile.am conntrack.fixed/src/Makefile.am
--- conntrack-20070315/src/Makefile.am	Thu Aug  3 12:37:00 2006
+++ conntrack.fixed/src/Makefile.am	Fri Mar 16 17:39:46 2007
@@ -3,5 +3,5 @@ LIBS = @CONNTRACK_LIBS@
 
 sbin_PROGRAMS = conntrack
 conntrack_SOURCES = conntrack.c
-#conntrack_LDFLAGS = $(all_libraries) -rdynamic
+conntrack_LDFLAGS = -rdynamic
  

--Boundary-00=_8rs+FULfOrgwDzH--
