From: "Francisco Perea" <faperea@gmail.com>
Subject: Newbies questions compiling uClinux-dist-20070130 with
	m68k-uclinux-tools-20061214
Date: Fri, 25 May 2007 11:41:01 -0500
Message-ID: <6bc01b0f0705250941q445d1099m33d066d1272e2fe9@mail.gmail.com>
References: <6bc01b0f0705241228w3e37e968if4ea3c7fe5c261d0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
In-Reply-To: <6bc01b0f0705241228w3e37e968if4ea3c7fe5c261d0@mail.gmail.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm newbie in Linux land. I'm trying to build a small router for GPRS
applications and I downloaded last version of uclinux
(uClinux-dist-20070130) and m68k-tools (m68k-uclinux-tools-20061214)
for a M5272C3 EVB.

It compiles fine for default options, but when I set routing
functions, linker stage for libnfnetlink doesn't works.
Here it's output:

make[5]: Entering directory `/uClinux-dist/lib/libnfnetlink/build/src'
/bin/sh ../libtool --mode=link ucfront-gcc m68k-elf-gcc -m5307
-DCONFIG_COLDFIRE -fPIC -Wall -O2 -g -fomit-frame-pointer -pipe
-fno-common -fno-builtin -Wall   -DEMBED -msep-data -Dlinux
-D__linux__ -Dunix -D__uClinux__  -Wl,--fatal-warnings -Wl,-elf2flt
-Wl,-move-rodata -msep-data -Wl,--fatal-warnings -Wl,-elf2flt
-Wl,-move-rodata -msep-data -o libnfnetlink.la -rpath /lib
-Wc,-nostartfiles libnfnetlink.lo
rm -fr  .libs/libnfnetlink.so.0.0.0.elf .libs/libnfnetlink.so.0.0.0.elf2flt
ucfront-gcc m68k-elf-gcc -m5307 -DCONFIG_COLDFIRE -shared
.libs/libnfnetlink.o   -m5307 -msep-data -Wl,--fatal-warnings
-Wl,-elf2flt -Wl,-move-rodata -msep-data -Wl,--fatal-warnings
-Wl,-elf2flt -Wl,-move-rodata -msep-data -nostartfiles -Wl,-soname
-Wl,libnfnetlink.so.0 -o .libs/libnfnetlink.so.0.0.0
/usr/local/lib/gcc/m68k-uclinux/4.1.1/../../../../m68k-uclinux/bin/ld.real:
warning: cannot find entry symbol _start; defaulting to 00000000
.libs/libnfnetlink.so.0.0.0.elf2flt: In function `__uClibc_start_main':
: undefined reference to `main'
collect2: ld returned 1 exit status
make[5]: *** [libnfnetlink.la] Error 1
make[5]: Leaving directory `/uClinux-dist/lib/libnfnetlink/build/src'
make[4]: *** [all-recursive] Error 1
make[4]: Leaving directory `/uClinux-dist/lib/libnfnetlink/build'
make[3]: *** [all] Error 2
make[3]: Leaving directory `/uClinux-dist/lib/libnfnetlink'
make[2]: *** [libnfnetlink] Error 2
make[2]: Leaving directory `/uClinux-dist/lib'
make[1]: *** [all] Error 2
make[1]: Leaving directory `/uClinux-dist/lib'
make: *** [subdirs] Error 1
[root@localhost uClinux-dist]#

It didn't works for kernel 2.4 neither kernel 2.6
I also compile my own version of tools just to see if that solves the
problem, but it doesn't.
I guess all problem is a symbolink link to tell compiler where to
search for uClibc libraries. But problem is where to put symbolic
link?
I also have tried switching from uClibc to uC-lib and kernel and
libraries stages compile fine, but user apps won't compile.
By the way, uC-lib isn't to old now for user apps now?

I also change user to root, isn't the best practice, but I have to try! ;)
--
Francisco Perea
Ing. Electricista
