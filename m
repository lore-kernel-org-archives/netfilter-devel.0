From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Problem with compiling libnfnetlink
Date: Thu, 20 Apr 2006 10:55:09 +0100
Message-ID: <44475A7D.6020305@ufomechanic.net>
References: <859616420604190401u11748b19r12b18558036c2afe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <859616420604190401u11748b19r12b18558036c2afe@mail.gmail.com>
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

If I recall correctly this is beause you specified a wrong path to your 
kernel source and so netlink.h was included from /usr/include/linux 
instead of from your kernel source.

I'm possibly not the only one troubled by the existance of 
/usr/include/linux, to me the whole thing smacks of presumtion and trouble.

You might want to:

  find /path/to/kernel/src -name netlink.h

and see if there is even one there.

It would be helpful if you could include the output of gcc when 
compiling (not linking) so we can check the -I paths to see what kernel 
path it is including.

Sam

David Vogt wrote:
> Hi,
> 
> I downloaded the latest version of libnfnetlink from the subversion
> trunk (revison 6582 that is), after running "./autogen.sh" and
> "./configure --with-kernel=<PATH_TO_KERNEL_SRC>" (both of which seem
> to work fine), "make" outputs
> 
> Making all in src
> make[1]: Entering directory `/home/david/netfilter.org/libnfnetlink/src'
> if /bin/sh ../libtool --mode=compile gcc -DPACKAGE_NAME=\"\"
> -DPACKAGE_TARNAME=\"\" -DPACKAGE_VERSION=\"\" -DPACKAGE_STRING=\"\"
> -DPACKAGE_BUGREPORT=\"\" -DPACKAGE=\"libnfnetlink\"
> -DVERSION=\"0.0.16\" -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1
> -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1
> -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1
> -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_DLFCN_H=1  -I. -I. 
> -I../include   -fPIC -Wall -g -O2 -MT libnfnetlink.lo -MD -MP -MF
> ".deps/libnfnetlink.Tpo" \
>   -c -o libnfnetlink.lo `test -f 'libnfnetlink.c' || echo './'`libnfnetlink.c; \
> then mv -f ".deps/libnfnetlink.Tpo" ".deps/libnfnetlink.Plo"; \
> else rm -f ".deps/libnfnetlink.Tpo"; exit 1; \
> fi
> mkdir .libs
>  gcc -DPACKAGE_NAME=\"\" -DPACKAGE_TARNAME=\"\" -DPACKAGE_VERSION=\"\"
> -DPACKAGE_STRING=\"\" -DPACKAGE_BUGREPORT=\"\"
> -DPACKAGE=\"libnfnetlink\" -DVERSION=\"0.0.16\" -DSTDC_HEADERS=1
> -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1
> -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1
> -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1
> -DHAVE_DLFCN_H=1 -I. -I. -I../include -fPIC -Wall -g -O2 -MT
> libnfnetlink.lo -MD -MP -MF .deps/libnfnetlink.Tpo -c libnfnetlink.c 
> -fPIC -DPIC -o .libs/libnfnetlink.o
> In file included from libnfnetlink.c:40:
> /usr/include/linux/netlink.h:22: error: syntax error before "__u32"
> /usr/include/linux/netlink.h:28: error: syntax error before "__u32"
> /usr/include/linux/netlink.h:30: error: syntax error before "nlmsg_flags"
> /usr/include/linux/netlink.h:31: error: syntax error before "nlmsg_seq"
> /usr/include/linux/netlink.h:32: error: syntax error before "nlmsg_pid"
> /usr/include/linux/netlink.h:82: error: field `msg' has incomplete type
> 
> The kernel I use is 2.6.16. I've never built libnfnetlink from source,
> so I am pretty sure I missed an important step. Any help would be
> great.
> 
> David
> 
> 
