From: Sven Wegener <sven.wegener@stealer.net>
Subject: Re: [PATCH] Change default KERNEL_DIR location and add KBUILD_OUTPUT
Date: Sun, 15 Jul 2007 18:01:37 +0200
Message-ID: <20070715160136.GB24365@titan.stealer.net>
References: <20070714201513.GA9970@titan.stealer.net>
	<469A3070.7030506@trash.net>
	<20070715153145.GA24365@titan.stealer.net>
	<469A3E5E.2010507@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FCuugMFkClbJLl1L"
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <469A3E5E.2010507@trash.net>
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


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 15, 2007 at 05:33:50PM +0200, Patrick McHardy wrote:
> I don't see why not. A short comment in the Makefile explaining the
> situation would be nice though.

Updated patch attached.

--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables-kbuild-output.patch"

Index: Makefile
===================================================================
--- Makefile	(revision 6905)
+++ Makefile	(working copy)
@@ -11,9 +11,15 @@
 # Standard part of Makefile for topdir.
 TOPLEVEL_INCLUDED=YES
 
+# For recent kernels we only need the source in KERNEL_DIR to build. Older
+# kernels have a bug, where linux/netfilter_ipv4.h includes linux/config.h,
+# which includes linux/autoconf.h, which is placed into KBUILD_OUTPUT.
 ifndef KERNEL_DIR
-KERNEL_DIR="/lib/modules/$(shell uname -r)/build"
+KERNEL_DIR="/lib/modules/$(shell uname -r)/source"
 endif
+ifndef KBUILD_OUTPUT
+KBUILD_OUTPUT="/lib/modules/$(shell uname -r)/build"
+endif
 IPTABLES_VERSION:=1.3.8
 OLD_IPTABLES_VERSION:=1.3.7
 
@@ -37,7 +43,7 @@
 endif
 
 COPT_FLAGS:=-O2
-CFLAGS:=$(COPT_FLAGS) -Wall -Wunused -I$(KERNEL_DIR)/include -Iinclude/ -DIPTABLES_VERSION=\"$(IPTABLES_VERSION)\" #-g -DDEBUG #-pg # -DIPTC_DEBUG
+CFLAGS:=$(COPT_FLAGS) -Wall -Wunused -I$(KBUILD_OUTPUT)/include -I$(KERNEL_DIR)/include -Iinclude/ -DIPTABLES_VERSION=\"$(IPTABLES_VERSION)\" #-g -DDEBUG #-pg # -DIPTC_DEBUG
 
 ifdef NO_SHARED_LIBS
 CFLAGS += -DNO_SHARED_LIBS=1

--FCuugMFkClbJLl1L--
