From: Noman Liaquat <khankhn1@yahoo.com>
Subject: inline problem
Date: Mon, 26 Dec 2005 03:53:16 -0800 (PST)
Message-ID: <20051226115316.89734.qmail@web35913.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: khankhn1@yahoo.com, mbr@cipherdyne.org, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org, rob0@gmx.co.uk
Return-path: <netfilter-bounces@lists.netfilter.org>
To: rob@sterenborg.info
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


ROB-MESSAGE
------------------------------------------------------------------
Message: 5
Date: Sun, 25 Dec 2005 13:48:56 +0100 (CET)
From: "Rob Sterenborg" <rob@sterenborg.info>
Subject: Re: string replacement help
To: netfilter@lists.netfilter.org
Message-ID:

<16674.80.127.73.119.1135514936.squirrel@webmail.sterenborg.info>
Content-Type: text/plain;charset=iso-8859-1

On Sun, December 25, 2005 06:45, Noman Liaquat wrote:
> Hello Mike,
>
> I am using RedHat EnterPrise Linux version#4
> kernel.version=linux-2.6.14.4
> I am using the patch of
>
matic-nghttp://max.kellermann.name/projects/netfilter/h323.html
...
> its confirm that i got the option of string when i
did
>
> [root@mail lib]# iptables -m string -h
> STRING match v1.3.4 options:

As you can read, this is a string *match*.

> --from                       Offset to start
searching
> from
> --to                         Offset to stop
searching
> --algo                        Algorithm
> --string [!] string          Match a string in a
> packet
> --hex-string [!] string      Match a hex string in a
> packet
>
> but not showing the replacement option of
> --replace-string.

AFAIK you cannot alter things with match modules.

> i think there is need of patch but from which place
i
> can easily get the patch and how i can patch it.

Umm.. Soo.. What are you saying here ?
You want someone to create a patch that allows you to
alter strings
using Netfilter and put it online so you can download
it ?


Gr,
Rob

--------------------------------------------------------------------------

see below the errors of inline, libipq is installed
properly because my kernel and iptables modules are
working perfectly











[root@mail snort_inline-2.4.3-RC3]# ./configure
checking for a BSD-compatible install...
/usr/bin/install -c
checking whether build environment is sane... yes
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking whether to enable maintainer-specific
portions of Makefiles... no
checking for style of include used by make... GNU
checking for gcc... gcc
checking for C compiler default output file name...
a.out
checking whether the C compiler works... yes
checking whether we are cross compiling... no
checking for suffix of executables...
checking for suffix of object files... o
checking whether we are using the GNU C compiler...
yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ANSI C... none
needed
checking dependency style of gcc... gcc3
checking for ranlib... ranlib
checking for gcc... (cached) gcc
checking whether we are using the GNU C compiler...
(cached) yes
checking whether gcc accepts -g... (cached) yes
checking for gcc option to accept ANSI C... (cached)
none needed
checking dependency style of gcc... (cached) gcc3
checking build system type... i686-pc-linux-gnu
checking host system type... i686-pc-linux-gnu
checking whether byte ordering is bigendian... no
checking for sparc alignment... no
checking how to run the C preprocessor... gcc -E
checking for egrep... grep -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking for strings.h... (cached) yes
checking for string.h... (cached) yes
checking for stdlib.h... (cached) yes
checking for unistd.h... (cached) yes
checking sys/sockio.h usability... no
checking sys/sockio.h presence... no
checking for sys/sockio.h... no
checking paths.h usability... yes
checking paths.h presence... yes
checking for paths.h... yes
checking for inet_ntoa in -lnsl... yes
checking for socket in -lsocket... no
checking whether printf must be declared... no
checking whether fprintf must be declared... no
checking whether syslog must be declared... no
checking whether puts must be declared... no
checking whether fputs must be declared... no
checking whether fputc must be declared... no
checking whether fopen must be declared... no
checking whether fclose must be declared... no
checking whether fwrite must be declared... no
checking whether fflush must be declared... no
checking whether getopt must be declared... no
checking whether bzero must be declared... no
checking whether bcopy must be declared... no
checking whether memset must be declared... no
checking whether strtol must be declared... no
checking whether strcasecmp must be declared... no
checking whether strncasecmp must be declared... no
checking whether strerror must be declared... no
checking whether perror must be declared... no
checking whether socket must be declared... no
checking whether sendto must be declared... no
checking whether vsnprintf must be declared... no
checking whether snprintf must be declared... no
checking whether strtoul must be declared... no
checking for snprintf... yes
checking for strlcpy... no
checking for strlcat... no
checking for strerror... yes
checking for __FUNCTION__... yes
checking for floor in -lm... yes
checking for pcap_datalink in -lpcap... yes
checking pcre.h usability... yes
checking pcre.h presence... yes
checking for pcre.h... yes
checking for pcre_compile in -lpcre... yes
checking libipq.h usability... yes
checking libipq.h presence... yes
checking for libipq.h... yes
checking for ipq_set_mode in -lipq... no
 
   ERROR!  Libipq library/headers not found, go get it
from
   www.netfilter.org or use the --with-libipq-*
options,
   if you have it installed in unusual place



	
		
__________________________________ 
Yahoo! for Good - Make a difference this year. 
http://brand.yahoo.com/cybergivingweek2005/
