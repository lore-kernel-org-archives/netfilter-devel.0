From: Patrick McHardy <kaber@trash.net>
Subject: Re: nfsim on amd64: va_list incompatible type error
Date: Fri, 07 Jan 2005 01:30:16 +0100
Message-ID: <41DDD818.3090104@trash.net>
References: <20050106235748.GA23714@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030004070303090908080700"
Cc: Rusty Russell <rusty@rustcorp.com.au>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20050106235748.GA23714@roonstrasse.net>
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

This is a multi-part message in MIME format.
--------------030004070303090908080700
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Max Kellermann wrote:

>gcc -Wmissing-prototypes -Wstrict-prototypes -Wunused -Wall -g -Wa,-W
>-I. -I/home/max/svn/nfsim/core -I/home/max/svn/nfsim/kernelenv/include
>-I/home/max/svn/nfsim/netfilter/include  -c -o core/talloc.o
>core/talloc.c
>core/talloc.c: In function `talloc_vasprintf':
>core/talloc.c:862: error: incompatible types in assignment
>core/talloc.c:868: error: incompatible types in assignment
>core/talloc.c: In function `talloc_vasprintf_append':
>core/talloc.c:906: error: incompatible types in assignment
>core/talloc.c:918: error: incompatible types in assignment
>
>both gcc 1:3.3.5-5 and 3.4.3-6 (Debian) are affected. I found several
>references to this behaviour on the net, one is a gcc bug report:
>
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=8262
>
>.. but I fail to understand how to go around this limitation. When I
>defined HAVE_VA_COPY as a workaround, the error went away. Where is
>HAVE_VA_COPY meant to be defined?
>
I used the same workaround, but this patch should be better. In
samba HAVE_VA_COPY is probably defined by autoconf, but nfsim
doesn't use autoconf.

Regards
Patrick


--------------030004070303090908080700
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05.diff"

Index: Makefile.in
===================================================================
--- Makefile.in	(revision 3579)
+++ Makefile.in	(working copy)
@@ -5,8 +5,9 @@
 BINDIR=%BINDIR%
 LIBDIR=%LIBDIR%
 BASEDIR=%BASEDIR%
+VA_COPY=%VA_COPY%
 
-CFLAGS   = -Wmissing-prototypes -Wstrict-prototypes -Wunused -Wall -g -Wa,-W
+CFLAGS   = -Wmissing-prototypes -Wstrict-prototypes -Wunused -Wall -g -Wa,-W $(VA_COPY)
 CPPFLAGS = -I. -I$(shell pwd)/core -I$(shell pwd)/kernelenv/include \
 	   -I$(shell pwd)/netfilter/include
 
Index: configure
===================================================================
--- configure	(revision 3579)
+++ configure	(working copy)
@@ -38,8 +38,19 @@
 [ -n "$BINDIR" ] || BINDIR="$PREFIX"/bin/
 [ -n "$LIBDIR" ] || LIBDIR="$PREFIX"/lib/
 
-SUB='s@%GCOVFLAGS%@'$GCOVFLAGS'@;s@%TYPE%@'$TYPE'@;s@%VERSION%@'$VERSION'@;s@%GCOV%@'$GCOV'@;s@%CC%@'$CC'@;s@%LIBDIR%@'$LIBDIR'@;s@%BINDIR%@'$BINDIR'@;s@%BASEDIR%@'$BASEDIR'@'
+echo "
+#include <stdarg.h>
+int main(int argc, char **argv)
+{
+	va_list ap1, ap2;
+	va_copy(ap1, ap2);
+	exit(0);
+}" >.va_copy.c
+gcc .va_copy.c -o /dev/null 2>/dev/null && VA_COPY="-DHAVE_VA_COPY"
+rm .va_copy.c
 
+SUB='s@%GCOVFLAGS%@'$GCOVFLAGS'@;s@%TYPE%@'$TYPE'@;s@%VERSION%@'$VERSION'@;s@%GCOV%@'$GCOV'@;s@%CC%@'$CC'@;s@%LIBDIR%@'$LIBDIR'@;s@%BINDIR%@'$BINDIR'@;s@%BASEDIR%@'$BASEDIR'@;s@%VA_COPY%@'$VA_COPY'@'
+
 [ -d $KERNELDIR/net/$TYPE/netfilter ] ||
 	barf No netfilter directory found in $KERNELDIR
 

--------------030004070303090908080700--
