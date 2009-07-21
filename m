From: Philip Craig <philipc@snapgear.com>
Subject: Re: Only use libdl when shared builds are enabled (was: Only build
 iptables-xml)
Date: Tue, 21 Jul 2009 10:22:29 +1000
Message-ID: <4A650A45.9070300@snapgear.com>
References: <alpine.LSU.2.00.0907201108470.27235@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:46439 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754101AbZGUAWd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2009 20:22:33 -0400
In-Reply-To: <alpine.LSU.2.00.0907201108470.27235@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hi Philip,
> 
> 
> try this one instead.

Doesn't work:

ucfront-gcc m68k-uclinux-gcc -m5307 -DCONFIG_COLDFIRE 
-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 -D_REENTRANT 
-Wall -Waggregate-return -Wmissing-declarations -Wmissing-prototypes 
-Wredundant-decls -Wshadow -Wstrict-prototypes -Winline -pipe 
-DXTABLES_LIBDIR=\"/libexec/xtables\" -DXTABLES_INTERNAL -I./include 
-I../include -Os -g -fomit-frame-pointer -pipe -fno-common -fno-builtin 
-Wall -DCONFIG_SECUREEDGE -DEMBED -msep-data -Dlinux -D__linux__ -Dunix 
-D__uClinux__ -Wl,-elf2flt -Wl,-move-rodata -msep-data -Wl,-elf2flt 
-Wl,-move-rodata -msep-data -o iptables-xml iptables-xml.o 
./.libs/libxtables.a
iptables-xml.elf2flt: In function `xtables_find_match':
/home/gerg/uClinux-dist/user/iptables/build/../xtables.c:579: undefined 
reference to `dlerror'
iptables-xml.elf2flt: In function `load_extension':
/home/gerg/uClinux-dist/user/iptables/build/../xtables.c:502: undefined 
reference to `dlopen'
/home/gerg/uClinux-dist/user/iptables/build/../xtables.c:511: undefined 
reference to `dlerror'
/home/gerg/uClinux-dist/user/iptables/build/../xtables.c:519: undefined 
reference to `dlopen'
/home/gerg/uClinux-dist/user/iptables/build/../xtables.c:526: undefined 
reference to `dlerror'
iptables-xml.elf2flt: In function `xtables_find_target':
/home/gerg/uClinux-dist/user/iptables/build/../xtables.c:633: undefined 
reference to `dlerror'
collect2: ld returned 1 exit status


The problem is that iptables-xml links against libxtables.la, and we never
build a version of libxtables.la that has -DNO_SHARED_LIBS=1.  This isn't
a problem for iptables-static because we build xtables.c separately for it,
rather than linking against libxtables.la.

Also we can't just add -DNO_SHARED_LIBS=1 to the cflags for libxtables.la
because that would break when both --enable-static and --enable-shared
are specified.


> parent efebafa0021f36f4547b7fcc47620274f333e001 (v1.4.4-2-gefebafa)
> commit 906025e7be97f760cd11cc0f93f769f827bf6f70
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Mon Jul 20 11:08:14 2009 +0200
> 
> build: only use libdl when shared builds are enabled
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  Makefile.am |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/Makefile.am b/Makefile.am
> index fd99098..5608bde 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -21,7 +21,10 @@ libiptc_libiptc_la_LDFLAGS = -version-info 0:0:0
>  lib_LTLIBRARIES      += libxtables.la
>  libxtables_la_SOURCES = xtables.c
>  libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage}
> -libxtables_la_LIBADD  = -ldl
> +libxtables_la_LIBADD  =
> +if ENABLE_SHARED
> +libxtables_la_LIBADD += -ldl
> +endif
>  
>  # iptables, dynamic
>  iptables_SOURCES          = iptables-standalone.c iptables.c

