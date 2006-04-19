From: "David Vogt" <beunlovable@gmail.com>
Subject: Problem with compiling libnfnetlink
Date: Wed, 19 Apr 2006 13:01:31 +0200
Message-ID: <859616420604190401u11748b19r12b18558036c2afe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
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

Hi,

I downloaded the latest version of libnfnetlink from the subversion
trunk (revison 6582 that is), after running "./autogen.sh" and
"./configure --with-kernel=3D<PATH_TO_KERNEL_SRC>" (both of which seem
to work fine), "make" outputs

Making all in src
make[1]: Entering directory `/home/david/netfilter.org/libnfnetlink/src'
if /bin/sh ../libtool --mode=3Dcompile gcc -DPACKAGE_NAME=3D\"\"
-DPACKAGE_TARNAME=3D\"\" -DPACKAGE_VERSION=3D\"\" -DPACKAGE_STRING=3D\"\"
-DPACKAGE_BUGREPORT=3D\"\" -DPACKAGE=3D\"libnfnetlink\"
-DVERSION=3D\"0.0.16\" -DSTDC_HEADERS=3D1 -DHAVE_SYS_TYPES_H=3D1
-DHAVE_SYS_STAT_H=3D1 -DHAVE_STDLIB_H=3D1 -DHAVE_STRING_H=3D1
-DHAVE_MEMORY_H=3D1 -DHAVE_STRINGS_H=3D1 -DHAVE_INTTYPES_H=3D1
-DHAVE_STDINT_H=3D1 -DHAVE_UNISTD_H=3D1 -DHAVE_DLFCN_H=3D1  -I. -I.=20
-I../include   -fPIC -Wall -g -O2 -MT libnfnetlink.lo -MD -MP -MF
".deps/libnfnetlink.Tpo" \
  -c -o libnfnetlink.lo `test -f 'libnfnetlink.c' || echo './'`libnfnetlink=
.c; \
then mv -f ".deps/libnfnetlink.Tpo" ".deps/libnfnetlink.Plo"; \
else rm -f ".deps/libnfnetlink.Tpo"; exit 1; \
fi
mkdir .libs
 gcc -DPACKAGE_NAME=3D\"\" -DPACKAGE_TARNAME=3D\"\" -DPACKAGE_VERSION=3D\"\=
"
-DPACKAGE_STRING=3D\"\" -DPACKAGE_BUGREPORT=3D\"\"
-DPACKAGE=3D\"libnfnetlink\" -DVERSION=3D\"0.0.16\" -DSTDC_HEADERS=3D1
-DHAVE_SYS_TYPES_H=3D1 -DHAVE_SYS_STAT_H=3D1 -DHAVE_STDLIB_H=3D1
-DHAVE_STRING_H=3D1 -DHAVE_MEMORY_H=3D1 -DHAVE_STRINGS_H=3D1
-DHAVE_INTTYPES_H=3D1 -DHAVE_STDINT_H=3D1 -DHAVE_UNISTD_H=3D1
-DHAVE_DLFCN_H=3D1 -I. -I. -I../include -fPIC -Wall -g -O2 -MT
libnfnetlink.lo -MD -MP -MF .deps/libnfnetlink.Tpo -c libnfnetlink.c=20
-fPIC -DPIC -o .libs/libnfnetlink.o
In file included from libnfnetlink.c:40:
/usr/include/linux/netlink.h:22: error: syntax error before "__u32"
/usr/include/linux/netlink.h:28: error: syntax error before "__u32"
/usr/include/linux/netlink.h:30: error: syntax error before "nlmsg_flags"
/usr/include/linux/netlink.h:31: error: syntax error before "nlmsg_seq"
/usr/include/linux/netlink.h:32: error: syntax error before "nlmsg_pid"
/usr/include/linux/netlink.h:82: error: field `msg' has incomplete type

The kernel I use is 2.6.16. I've never built libnfnetlink from source,
so I am pretty sure I missed an important step. Any help would be
great.

David
