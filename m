From: "David Vogt" <beunlovable@gmail.com>
Subject: Re: Problem with compiling libnfnetlink
Date: Thu, 20 Apr 2006 13:05:37 +0200
Message-ID: <859616420604200405k595368ex2e3a97aa979614e@mail.gmail.com>
References: <859616420604190401u11748b19r12b18558036c2afe@mail.gmail.com>
	<44475A7D.6020305@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Amin Azez" <azez@ufomechanic.net>
In-Reply-To: <44475A7D.6020305@ufomechanic.net>
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

2006/4/20, Amin Azez <azez@ufomechanic.net>:
> If I recall correctly this is beause you specified a wrong path to your
> kernel source and so netlink.h was included from /usr/include/linux
> instead of from your kernel source.
>
> I'm possibly not the only one troubled by the existance of
> /usr/include/linux, to me the whole thing smacks of presumtion and troubl=
e.
>
> You might want to:
>
>   find /path/to/kernel/src -name netlink.h
>
> and see if there is even one there.
There _is_ a file netlink.h in /usr/src/linux-2.6/include/linux

> It would be helpful if you could include the output of gcc when
> compiling (not linking) so we can check the -I paths to see what kernel
> path it is including.
The output I have previously posted is all the output I get, right
after typing make, so shouldn't there be a compilatition?

It seems, calling
> gcc -DPACKAGE_NAME=3D\"\" -DPACKAGE_TARNAME=3D\"\"
> -DPACKAGE_VERSION=3D\"\"
> -DPACKAGE_STRING=3D\"\" -DPACKAGE_BUGREPORT=3D\"\"
> -DPACKAGE=3D\"libnfnetlink\" -DVERSION=3D\"0.0.16\" -DSTDC_HEADERS=3D1
> -DHAVE_SYS_TYPES_H=3D1 -DHAVE_SYS_STAT_H=3D1 -DHAVE_STDLIB_H=3D1
> -DHAVE_STRING_H=3D1 -DHAVE_MEMORY_H=3D1 -DHAVE_STRINGS_H=3D1
> -DHAVE_INTTYPES_H=3D1 -DHAVE_STDINT_H=3D1 -DHAVE_UNISTD_H=3D1
> -DHAVE_DLFCN_H=3D1 -I. -I. -I../include -fPIC -Wall -g -O2 -MT
> libnfnetlink.lo -MD -MP -MF .deps/libnfnetlink.Tpo -c libnfnetlink.c

causes the problem, and the include options in fact do not seem to
point to the correct path. Now, I am not sure how to change that? I
thought "./configure --with-kernel=3D/usr/src/linux-2.6" should have had
the include options fixed.

David

David
