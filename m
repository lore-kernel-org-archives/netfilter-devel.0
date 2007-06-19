From: Andreas Lundin <lunde@dreamhosted.se>
Subject: ulogd large file support
Date: Tue, 19 Jun 2007 15:30:53 +0200
Message-ID: <20070619133053.GA27793@dreamhosted.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

ulogd seems to be missing large file support. Here is a simple patch
to make configure handle it, but there is a line that is commented in
Rules.make.in which will prevent the option to be used during compile
time (search for @DEFS@ in Rules.make.in).

I compiled ulogd-1.24 with -D_FILE_OFFSET_BITS=64 and it can now write
to log files larger than 2G on my system.

Regards
Andreas Lundin

This patch is for ulogd-1.24 but the patch is so trivial that it is
probably easier to apply with an editor :-)

--- configure.in 2005-11-25 20:58:27.000000000 +0100
+++ configure.in 2007-06-19 15:09:22.000000000 +0200
@@ -20,6 +20,7 @@
 AC_C_CONST
 AC_TYPE_SIZE_T
 AC_STRUCT_TM
+AC_SYS_LARGEFILE

 dnl Checks for library functions.
 AC_FUNC_VPRINTF
