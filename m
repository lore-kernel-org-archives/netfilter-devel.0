From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Use gcc to build shared objects
Date: Sat, 15 Jul 2006 12:25:08 -0700
Message-ID: <20060715192508.GA14699@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As suggested by Dmitry Levin and included in Fedora Core releases,
use gcc instead of ld to link shared objects.  Fedora rpm notes
refer to this fixing a plugin problem, but does not offer specifics.
But in any event, 'gcc -dumpspecs' does show gcc will pass a number
of parameters which in theory it thinks are better.

Compile tested both with and without NO_SHARED_LIBS.

Closes bug #454.

Phil



--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-iptableslink

diff -ru ipt-orig/include/iptables_common.h ipt-new/include/iptables_common.h
--- ipt-orig/include/iptables_common.h	2006-06-19 09:53:03.000000000 -0700
+++ ipt-new/include/iptables_common.h	2006-07-15 12:02:59.000000000 -0700
@@ -33,8 +33,10 @@
 extern const char *program_name, *program_version;
 extern char *lib_dir;
 
+#define _init __attribute__((constructor)) my_init
 #ifdef NO_SHARED_LIBS
 # ifdef _INIT
+#  undef _init
 #  define _init _INIT
 # endif
   extern void init_extensions(void);
diff -ru ipt-orig/Makefile ipt-new/Makefile
--- ipt-orig/Makefile	2006-07-11 14:55:05.000000000 -0700
+++ ipt-new/Makefile	2006-07-15 12:15:23.000000000 -0700
@@ -67,7 +67,7 @@
 		# The kernel is 64-bit, even though userspace is 32.
 		CFLAGS+=-DIPT_MIN_ALIGN=8 -DKERNEL_64_USERSPACE_32
 	else
-		EXT_LDFLAGS=-m elf64_sparc
+		EXT_LDFLAGS+=-Wl,-m,elf64_sparc
 	endif
 endif
 
diff -ru ipt-orig/Rules.make ipt-new/Rules.make
--- ipt-orig/Rules.make	2006-05-24 09:11:58.000000000 -0700
+++ ipt-new/Rules.make	2006-07-15 12:02:59.000000000 -0700
@@ -31,7 +31,7 @@
 	    sed -e 's@^.*\.o:@$*.d $*_sh.o:@' > $@
 
 $(SHARED_LIBS): %.so : %_sh.o
-	$(LD) -shared $(EXT_LDFLAGS) -o $@ $<
+	$(CC) -shared $(EXT_LDFLAGS) -o $@ $<
 
 $(SHARED_SE_LIBS:%.so=%.d): %.d: %.c
 	@-$(CC) -M -MG $(CFLAGS) $< | \

--azLHFNyN32YCQGCU--
