From: giorgio.nicole@arcor.de
Subject: Aw: Re: [PATCH] autotools conversion: include the header 'config.h'
 in every C source file.
Date: Thu, 10 Jul 2014 17:37:54 +0200 (CEST)
Message-ID: <470271942.477219.1405006674668.JavaMail.ngmail@webmail23.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:33842 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114AbaGJPh4 convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:37:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

----- Original Nachricht ----
Von:     Pablo Neira Ayuso <pablo@netfilter.org>
An:      Giorgio Dal Molin <giorgio.nicole@arcor.de>
Datum:   10.07.2014 16:54
Betreff: Re: [PATCH] autotools conversion: include the header 'config.h' in
 every C source file.

> On Thu, Jul 10, 2014 at 04:08:08PM +0200, Giorgio Dal Molin wrote:
> > Added an #include <config.h> to all the C source files so that the
> results
> > of the tests in the configure script are available to all the compilation
> > units.
> 
> I think we can avoid this by passing the configuration options to the
> compiler via -D instead of via config.h file.
> 
> https://www.gnu.org/software/autoconf/manual/autoconf-2.65/html_node/Configu
> ration-Headers.html
> 
> Any reason not to do it that way?
> 

Hi,

the link you send:

https://www.gnu.org/software/autoconf/manual/autoconf-2.65/html_node/Configuration-Headers.html

actually discourages not to use the header file config.h because you would get very long gcc command lines.

I've tried it and here is an example of the output:

# ./configure --prefix=/usr --enable-pdf --disable-assert
....
# make V=1 all
...
Making all in src
make[1]: Entering directory '/tmp/nftables_autotooled/src'
test -f scanner.c || /bin/sh ../ylwrap scanner.l lex.yy.c scanner.c -- flex  
updating scanner.c
test -f yacc_parser.c || /bin/sh ../ylwrap yacc_parser.y y.tab.c yacc_parser.c y.tab.h `echo yacc_parser.c | sed -e s/cc$/hh/ -e s/cpp$/hpp/ -e s/cxx$/hxx/ -e s/c++$/h++/ -e s/c$/h/` y.output yacc_parser.output -- bison -y -d 
updating yacc_parser.h
make  all-am
make[2]: Entering directory '/tmp/nftables_autotooled/src'
gcc -DPACKAGE_NAME=\"nftables\" -DPACKAGE_TARNAME=\"nftables\" -DPACKAGE_VERSION=\"0.3\" -DPACKAGE_STRING=\"nftables\ 0.3\" -DPACKAGE_BUGREPORT=\"netfilter-devel@vger.kernel.org\" -DPACKAGE_URL=\"\" -DPACKAGE=\"nftables\" -DVERSION=\"0.3\" -DRELEASE_NAME=\"Support\ Edward\ Snowden\" -DDEFAULT_INCLUDE_PATH=\"\" -D_GNU_SOURCE=/\*\*/ -D_STDC_FORMAT_MACROS=/\*\*/ -DYYTEXT_POINTER=1 -DHAVE_LIBGMP=1 -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_LIBREADLINE=1 -DHAVE_READLINE_READLINE_H=1 -DHAVE_READLINE_HISTORY=1 -DHAVE_READLINE_HISTORY_H=1 -DSTDC_HEADERS=1 -DNDEBUG=1 -DHAVE_ARPA_INET_H=1 -DHAVE_FCNTL_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_LIBINTL_H=1 -DHAVE_
 LIMITS_H=1 -DHAVE_MALLOC_H=1 -DHAVE_NETDB_H=1 -DHAVE_NETINET_IN_H=1 -DHAVE_NETINET_IP_H=1 -DHAVE_NETINET_IP6_H=1 -DHAVE_NETINET_TCP_H=1 -DHAVE_NETINET_UDP_H=1 -DHAVE_NETINET_IP_ICMP_H=1 -DHAVE_STDDEF_H=1 -DHAVE_STDINT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_UNISTD_H=1 -DHAVE__BOOL=1 -DHAVE_STDBOOL_H=1 -DHAVE_MEMMOVE=1 -DHAVE_MEMSET=1 -DHAVE_STRCHR=1 -DHAVE_STRDUP=1 -DHAVE_STRERROR=1 -DHAVE_STRTOULL=1 -I.  -I./../include     -fno-strict-aliasing -Wall -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wdeclaration-after-statement -Wsign-compare -Winit-self -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute -Wcast-align -Wundef -Wbad-function-cast -Waggregate-return -Wunused -Wwrite-strings  -O2 -march=native -MT nft-main.o -MD -MP -MF .deps/nft-main.Tpo 
 -c -o nft-main.o `test -f 'main.c' || echo './'`main.c
mv -f .deps/nft-main.Tpo .deps/nft-main.Po
gcc -DPACKAGE_NAME=\"nftables\" -DPACKAGE_TARNAME=\"nftables\" -DPACKAGE_VERSION=\"0.3\" -DPACKAGE_STRING=\"nftables\ 0.3\" -DPACKAGE_BUGREPORT=\"netfilter-devel@vger.kernel.org\" -DPACKAGE_URL=\"\" -DPACKAGE=\"nftables\" -DVERSION=\"0.3\" -DRELEASE_NAME=\"Support\ Edward\ Snowden\" -DDEFAULT_INCLUDE_PATH=\"\" -D_GNU_SOURCE=/\*\*/ -D_STDC_FORMAT_MACROS=/\*\*/ -DYYTEXT_POINTER=1 -DHAVE_LIBGMP=1 -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_LIBREADLINE=1 -DHAVE_READLINE_READLINE_H=1 -DHAVE_READLINE_HISTORY=1 -DHAVE_READLINE_HISTORY_H=1 -DSTDC_HEADERS=1 -DNDEBUG=1 -DHAVE_ARPA_INET_H=1 -DHAVE_FCNTL_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_LIBINTL_H=1 -DHAVE_
 LIMITS_H=1 -DHAVE_MALLOC_H=1 -DHAVE_NETDB_H=1 -DHAVE_NETINET_IN_H=1 -DHAVE_NETINET_IP_H=1 -DHAVE_NETINET_IP6_H=1 -DHAVE_NETINET_TCP_H=1 -DHAVE_NETINET_UDP_H=1 -DHAVE_NETINET_IP_ICMP_H=1 -DHAVE_STDDEF_H=1 -DHAVE_STDINT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_UNISTD_H=1 -DHAVE__BOOL=1 -DHAVE_STDBOOL_H=1 -DHAVE_MEMMOVE=1 -DHAVE_MEMSET=1 -DHAVE_STRCHR=1 -DHAVE_STRDUP=1 -DHAVE_STRERROR=1 -DHAVE_STRTOULL=1 -I.  -I./../include     -fno-strict-aliasing -Wall -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wdeclaration-after-statement -Wsign-compare -Winit-self -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute -Wcast-align -Wundef -Wbad-function-cast -Waggregate-return -Wunused -Wwrite-strings  -O2 -march=native -MT nft-cli.o -MD -MP -MF .deps/nft-cli.Tpo -c
  -o nft-cli.o `test -f 'cli.c' || echo './'`cli.c
mv -f .deps/nft-cli.Tpo .deps/nft-cli.Po
gcc -DPACKAGE_NAME=\"nftables\" -DPACKAGE_TARNAME=\"nftables\" -DPACKAGE_VERSION=\"0.3\" -DPACKAGE_STRING=\"nftables\ 0.3\" -DPACKAGE_BUGREPORT=\"netfilter-devel@vger.kernel.org\" -DPACKAGE_URL=\"\" -DPACKAGE=\"nftables\" -DVERSION=\"0.3\" -DRELEASE_NAME=\"Support\ Edward\ Snowden\" -DDEFAULT_INCLUDE_PATH=\"\" -D_GNU_SOURCE=/\*\*/ -D_STDC_FORMAT_MACROS=/\*\*/ -DYYTEXT_POINTER=1 -DHAVE_LIBGMP=1 -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_LIBREADLINE=1 -DHAVE_READLINE_READLINE_H=1 -DHAVE_READLINE_HISTORY=1 -DHAVE_READLINE_HISTORY_H=1 -DSTDC_HEADERS=1 -DNDEBUG=1 -DHAVE_ARPA_INET_H=1 -DHAVE_FCNTL_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_LIBINTL_H=1 -DHAVE_
 LIMITS_H=1 -DHAVE_MALLOC_H=1 -DHAVE_NETDB_H=1 -DHAVE_NETINET_IN_H=1 -DHAVE_NETINET_IP_H=1 -DHAVE_NETINET_IP6_H=1 -DHAVE_NETINET_TCP_H=1 -DHAVE_NETINET_UDP_H=1 -DHAVE_NETINET_IP_ICMP_H=1 -DHAVE_STDDEF_H=1 -DHAVE_STDINT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_UNISTD_H=1 -DHAVE__BOOL=1 -DHAVE_STDBOOL_H=1 -DHAVE_MEMMOVE=1 -DHAVE_MEMSET=1 -DHAVE_STRCHR=1 -DHAVE_STRDUP=1 -DHAVE_STRERROR=1 -DHAVE_STRTOULL=1 -I.  -I./../include     -fno-strict-aliasing -Wall -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wdeclaration-after-statement -Wsign-compare -Winit-self -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute -Wcast-align -Wundef -Wbad-function-cast -Waggregate-return -Wunused -Wwrite-strings  -O2 -march=native -MT nft-rule.o -MD -MP -MF .deps/nft-rule.Tpo 
 -c -o nft-rule.o `test -f 'rule.c' || echo './'`rule.c
rule.c: In function 'do_command':
rule.c:924:1: warning: control reaches end of non-void function [-Wreturn-type]
 }
 ^
rule.c: In function 'do_command_delete':
rule.c:673:1: warning: control reaches end of non-void function [-Wreturn-type]
 }
 ^
mv -f .deps/nft-rule.Tpo .deps/nft-rule.Po
...



As you can see all the preprocessor definitions goes directly on the gcc command line making it very long,
possibly too long if you add enough configure tests.
Obviously, if you only build with a simple make, without setting the verbose mode (V=1) you do not
notice any difference but sometime, for debugging reasons, it is useful to see the commands actually
issued by make.


Moreover, in the special case of 'nftables' there is another problem: when compiling the generated file 'src/scanner.c' this way
it fails because of the variable VERSION being defined twice: once by the configure script itself on the command line: -DVERSION=\"0.3\"
and once by the generated file 'src/yacc_parser.h': #define VERSION 336:


...
gcc -DPACKAGE_NAME=\"nftables\" -DPACKAGE_TARNAME=\"nftables\" -DPACKAGE_VERSION=\"0.3\" -DPACKAGE_STRING=\"nftables\ 0.3\" -DPACKAGE_BUGREPORT=\"netfilter-devel@vger.kernel.org\" -DPACKAGE_URL=\"\" -DPACKAGE=\"nftables\" -DVERSION=\"0.3\" -DRELEASE_NAME=\"Support\ Edward\ Snowden\" -DDEFAULT_INCLUDE_PATH=\"\" -D_GNU_SOURCE=/\*\*/ -D_STDC_FORMAT_MACROS=/\*\*/ -DYYTEXT_POINTER=1 -DHAVE_LIBGMP=1 -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_LIBREADLINE=1 -DHAVE_READLINE_READLINE_H=1 -DHAVE_READLINE_HISTORY=1 -DHAVE_READLINE_HISTORY_H=1 -DSTDC_HEADERS=1 -DNDEBUG=1 -DHAVE_ARPA_INET_H=1 -DHAVE_FCNTL_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_LIBINTL_H=1 -DHAVE_
 LIMITS_H=1 -DHAVE_MALLOC_H=1 -DHAVE_NETDB_H=1 -DHAVE_NETINET_IN_H=1 -DHAVE_NETINET_IP_H=1 -DHAVE_NETINET_IP6_H=1 -DHAVE_NETINET_TCP_H=1 -DHAVE_NETINET_UDP_H=1 -DHAVE_NETINET_IP_ICMP_H=1 -DHAVE_STDDEF_H=1 -DHAVE_STDINT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_UNISTD_H=1 -DHAVE__BOOL=1 -DHAVE_STDBOOL_H=1 -DHAVE_MEMMOVE=1 -DHAVE_MEMSET=1 -DHAVE_STRCHR=1 -DHAVE_STRDUP=1 -DHAVE_STRERROR=1 -DHAVE_STRTOULL=1 -I.  -I./../include     -fno-strict-aliasing -Wall -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wdeclaration-after-statement -Wsign-compare -Winit-self -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute -Wcast-align -Wundef -Wbad-function-cast -Waggregate-return -Wunused -Wwrite-strings  -O2 -march=native -MT nft-scanner.o -MD -MP -MF .deps/nft-scanne
 r.Tpo -c -o nft-scanner.o `test -f 'scanner.c' || echo './'`scanner.c
<command-line>:0:9: error: expected identifier before string constant
yacc_parser.h:127:5: note: in expansion of macro 'VERSION'
     VERSION = 336,
     ^
In file included from scanner.l:23:0:
yacc_parser.h:316:0: warning: "VERSION" redefined [enabled by default]
 #define VERSION 336
 ^
<command-line>:0:0: note: this is the location of the previous definition
scanner.l: In function 'scanner_push_buffer':
scanner.l:596:18: warning: variable 'b' set but not used [-Wunused-but-set-variable]
 
                  ^
Makefile:754: recipe for target 'nft-scanner.o' failed
make[2]: *** [nft-scanner.o] Error 1
make[2]: Leaving directory '/tmp/nftables_autotooled/src'
Makefile:331: recipe for target 'all' failed
make[1]: *** [all] Error 2
make[1]: Leaving directory '/tmp/nftables_autotooled/src'
Makefile:347: recipe for target 'all-recursive' failed
make: *** [all-recursive] Error 1

giorgio
