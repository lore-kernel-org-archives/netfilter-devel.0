From: Chase Venters <cventers@tekvizion.com>
Subject: Problem building libnetfilter_conntrack
Date: Thu, 20 Oct 2005 12:00:51 -0500
Message-ID: <1129827673.29769.19.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello,
    I'm trying to do some experimentation with libnetfilter_conntrack. I
noticed 
that r4363 does not build, from what I can tell, for a few reasons:

1. libnetfilter_conntrack is the new name, but the process of renaming
the header file does not seem to be complete
(include/libnetfilter_conntrack contains libnfnetlink_conntrack.h but
Makefile.in says:

> pkginclude_HEADERS = libnetfilter_conntrack.h

and libnetfilter_conntrack.c says:

> #include <libnetfilter_conntrack/libnetfilter_conntrack.h>

Perhaps libnetfilter_conntrack.h was not checked in?

2. Even when fixing the above, I seem to run into build issues:

>  gcc -DPACKAGE_NAME=\"\" -DPACKAGE_TARNAME=\"\" -DPACKAGE_VERSION=
\"\" 
-DPACKAGE_STRING=\"\" -DPACKAGE_BUGREPORT=\"\" 
-DPACKAGE=\"libnetfilter_conntrack\" -DVERSION=\"0.0.20\"
-DSTDC_HEADERS=1 
-DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1
-DHAVE_STRING_H=1 
-DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1
-DHAVE_STDINT_H=1 
-DHAVE_UNISTD_H=1 -DHAVE_DLFCN_H=1 -DHAVE_LIBNFNETLINK=1 -I. -I.
-I../include 
-I/lib/modules/2.6.14-rc5/build/include -fPIC -Wall -g -O2 > 
-DLIBNETFILTER_CONNTRACK_DIR=\"/usr/local/lib/\" -c
libnetfilter_conntrack.c 
-MT libnetfilter_conntrack.lo -MD -MP
-MF .deps/libnetfilter_conntrack.TPlo  
-fPIC -DPIC -o .libs/libnetfilter_conntrack.o
> libnetfilter_conntrack.c: In function `callback_handler':
> libnetfilter_conntrack.c:44: error: dereferencing pointer to
incomplete type
> libnetfilter_conntrack.c:56: error: dereferencing pointer to
incomplete type
> libnetfilter_conntrack.c:59: error: dereferencing pointer to
incomplete type
> 
> ...

I've tried other revisions, and I seem to always run into problems with
struct nfct_msg_handler. I'm going to try poking around a bit more
myself to see if I can find anything obviously wrong, but I suspect that
Subversion may be missing an updated libnetfilter_conntrack.h (from what
I can tell, 
libnfnetlink_conntrack.h hasn't changed since at least before r4295).

Any advice? Please CC me as I'm not yet a member of netfilter-devel.

Thanks,
Chase

Chase Venters
Development Engineer
w: 214-242-5922
c: 972-679-0094
f: 214-242-5999
cventers@tekvizion.com
www.tekVizion.com
