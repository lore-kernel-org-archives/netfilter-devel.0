From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH V2 2/3] Remove VLAIS usage from gadget code
Date: Tue, 4 Dec 2012 23:24:38 +0100
Message-ID: <20121204222438.GA7624@breakpoint.cc>
References: <1351631937-21455-1-git-send-email-behanw@converseincode.com>
 <1351631937-21455-3-git-send-email-behanw@converseincode.com>
 <20121031132838.GQ10998@arwen.pp.htv.fi>
 <509144C0.8000601@converseincode.com>
 <20121101072116.GA32013@arwen.pp.htv.fi>
 <20121203115706.GA4760@breakpoint.cc>
 <50BCF61D.5000707@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Felipe Balbi <balbi@ti.com>, davem@davemloft.net,
	linux-usb@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Compiling the Linux Kernel with Clang/LLVM
	<llvmlinux@lists.linuxfoundation.org>
To: Behan Webster <behanw@converseincode.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50BCF61D.5000707@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Dec 03, 2012 at 07:57:33PM +0100, Behan Webster wrote:
> However, in order to approximate what gcc is doing in code, obviously
> some math is required. The thought was that macros would hide the
> worst of it, trying not to obfuscate what was actually being done.

Why hide? The thing that is done here is setting up pointers and keep t=
his
struct as a container. It is never used again, just freed. Therefore I =
would
suggest to remove and do something different.

> One of the project members came up with this alternative. How about
> something like this? Less math, though more string pasting. When
> compiled, the unused variables get optimized away. Otherwise the
> memory packing is identical to using VLAIS in gcc.
>=20
> #define vla_struct(structname) size_t structname##__##next =3D 0
> #define vla_struct_size(structname) structname##__##next
>=20
> #define vla_item(structname, type, name, n) \
>         type * structname##_##name; \
>         size_t structname##_##name##__##pad =3D \
>                 (structname##__##next & (__alignof__(type)-1)); \
>         size_t structname##_##name##__##offset =3D \
>                 structname##__##next + structname##_##name##__##pad; =
\
>         size_t structname##_##name##__##sz =3D n * sizeof(type); \
>         structname##__##next =3D structname##__##next + \
>                 structname##_##name##__##pad +
> structname##_##name##__##sz;
>=20
> #define vla_ptr(ptr,structname,name) structname##_##name =3D \
> (typeof(structname##_##name))&ptr[structname##_##name##__##offset]
>=20
>=20
> Then you can do something like this that looks vaguely struct-like:
>=20
>         vla_struct(foo);
>                 vla_item(foo, char,  vara, 1);
>                 vla_item(foo, short, varb, 10);
>                 vla_item(foo, int,   varc, 5);
>                 vla_item(foo, long,  vard, 3);
>         size_t total =3D vla_struct_size(foo);
>         char buffer[total];
>=20
>         vla_ptr(buffer, foo, varc);
>         foo_varc =3D 1;

I prefer to try to rewritte the code in the gadget in a different manne=
r
before using macro magic. I guess most people around here think that ex=
tensive
usage of macros equals giving a gun to a chimpanzee. It may work for a =
while
and may even look cute in the eye of the gun sponsor. However once it f=
ires=E2=80=A6

> I've been profiling some sample code around this implementation
> comparing it between compilers, and it approximates the code size and
> speed of using VLAIS in gcc (especially with -O2). It actually
> performs better than the previously proposed macros.

I'm not concerned about speed here. This is an one time setup.

> But certainly if anyone has a solution which works for everyone, then
> I'm more than happy to adopt it. The LLVM community has made quite a
> few changes in order to help get Linux working with clang. However,

That is nice to hear. Besides gcc there is the icc.

> VLAIS is not something they are willing to accept (for various
> reasons). There are other patches to LLVM that are still working
Is this not described in C99 6.7.2.1p16?

> their way upstream that are required to be able to compile Linux as
> well.

I hope the other are "simple" to get in :)

>=20
> Behan
>=20

Sebastian
