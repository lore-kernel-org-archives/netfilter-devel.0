From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Devel] Re: [PATCH 1/2] iptables 32bit compat layer
Date: Tue, 21 Feb 2006 12:56:00 +0100
Message-ID: <200602211256.00846.arnd@arndb.de>
References: <200602201110.39092.dim@openvz.org> <200602201655.27093.arnd@arndb.de> <200602211204.50118.dim@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: devel@openvz.org, dev@openvz.org, Mishin Dmitry <dim@openvz.org>,
	akpm@osdl.org, netfilter-devel@lists.netfilter.org,
	rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932710AbWBUL4Z@vger.kernel.org>
To: Dmitry Mishin <dim@sw.ru>
In-Reply-To: <200602211204.50118.dim@sw.ru>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tuesday 21 February 2006 10:04, Dmitry Mishin wrote:
> On Monday 20 February 2006 18:55, Arnd Bergmann wrote:

> > Is CONFIG_COMPAT the right conditional here? If the code is only us=
ed
> > for architectures that have different aligments, it should not need=
 be
> > compiled in for the other architectures.
> So, I'll define ARCH_HAS_FUNNY_64_ALIGNMENT in x86_64 and ia64 code a=
nd will=20
> check it, as Andi suggested.
>=20

I think nowadays, unconditionally setting CONFIG_FUNNY_64_ALIGNMENT fro=
m
arch/{ia64,x86_64}/Kconfig would be the preferred way to a #define in
include/asm.

> > > =A0#define IPT_ALIGN(s) XT_ALIGN(s)
> > > +
> > > +#ifdef CONFIG_COMPAT
> > > +#include <net/compat.h>
> > > +
> > > +struct compat_ipt_getinfo
> > > +{
> > > +=A0=A0=A0=A0=A0=A0=A0char name[IPT_TABLE_MAXNAMELEN];
> > > +=A0=A0=A0=A0=A0=A0=A0compat_uint_t valid_hooks;
> > > +=A0=A0=A0=A0=A0=A0=A0compat_uint_t hook_entry[NF_IP_NUMHOOKS];
> > > +=A0=A0=A0=A0=A0=A0=A0compat_uint_t underflow[NF_IP_NUMHOOKS];
> > > +=A0=A0=A0=A0=A0=A0=A0compat_uint_t num_entries;
> > > +=A0=A0=A0=A0=A0=A0=A0compat_uint_t size;
> > > +};
> >
> > This structure looks like it does not need any
> > conversions. You should probably just use
> > struct ipt_getinfo then.
> I just saw compat_uint_t use in net/compat.c and thought, that it is =
a good=20
> style to use it. Does anybody know arch, where sizeof(compat_uint_t) =
!=3D 4?

No, the compat layer already heavily depends on the fact that compat_ui=
nt_t
is always the same as unsigned int.

> >
> > Dito
> Disagree, ipt_entry_match and ipt_entry_target contain pointers which=
 make=20
> their alignment equal 8 byte on 64bits architectures.

Ah, I see.=20

> > I would much rather have either an extra 'compat' argument to to
> > sock_setsockopt and proto_ops->setsockopt than to spread the use
> > of is_compat_task further.
> Another weak place in my code. is_compat_task() approach has one adva=
ntage -=20
> it doesn't require a lot of current code modifications.
> >
> > Is the FIXME above the only reason that the code needs to be change=
d?
> > What is the reason that you did not just address this in the
> > compat_sys_setsockopt implementation?
> Code above doesn't work. iptables with version >=3D 1.3 does alignmen=
t checks as=20
> well as kernel does. So, we can't simply put entries with 8 bytes ali=
gnment=20
> to userspace or with 4 bytes alignment to kernel - we need translate =
them=20
> entry by entry. So, I tried to do this the most correct way - that us=
erspace=20
> will hide its alignment from kernel and vice versa, with not only=20
> SET_REPLACE, but also GET_INFO, GET_ENTRIES and SET_COUNTERS translat=
ion.
> First implementation was exactly in compat_sys_setsockopt, but David =
asked me=20
> to do this in netfilter code itself.

Ok, I see the point there. It's probably best to push down all the conv=
ersions
from compat_sys_setsockopt down to the protocol specific parts, similar=
 to what
we do for the ioctl handlers.

I'm thinking of something like

int compat_sock_setsockopt(struct socket *sock, int level, int optname,
		    char __user *optval, int optlen)
{
	switch (optname) {
	case SO_ATTACH_FILTER:
		return do_set_attach_filter(fd, level, optname,
					    optval, optlen);
	case SO_SNDTIMEO:
		return do_set_sock_timeout(fd, level, optname,
					   optval, optlen);
	default:
		break;
	}
	return sock_setsockopt(sock, level, optname, optval, optlen);
}

asmlinkage long compat_sys_setsockopt(int fd, int level, int optname,
				char __user *optval, int optlen)
{
	int err;
	struct socket *sock;

	if (optlen < 0)
		return -EINVAL;
		=09
	if ((sock =3D sockfd_lookup(fd, &err))!=3DNULL)
	{
		err =3D security_socket_setsockopt(sock,level,optname);
		if (err) {
			sockfd_put(sock);
			return err;
		}

		if (level =3D=3D SOL_SOCKET)
			err =3D compat_sock_setsockopt(sock, level,
					optname, optval, optlen);
		else if (sock->ops->compat_setsockopt)
			err =3D sock->ops->compat_setsockopt(sock, level,
					optname, optval, optlen);
		else
			err =3D sock->ops->setsockopt(sock, level,
					optname, optval, optlen);
		sockfd_put(sock);
	}
	return err;
}

int tcp_setsockopt(struct sock *sk, int level, int optname, char __user=
 *optval, int optlen)
{
	int err =3D 0;

	err =3D ip_setsockopt(sk, level, optname, optval, optlen);

#ifdef CONFIG_NETFILTER
	if (err =3D -ENOPROTOOPT) {
		lock_sock(sk);
		err =3D nf_setsockopt(sk, PF_INET, optname, optval, optlen);
		release_sock(sk);
	}
#endif
	return err;
}

int compat_tcp_setsockopt(struct sock *sk, int level, int optname, char=
 __user *optval, int optlen)
{
	int err =3D 0;

	err =3D ip_setsockopt(sk, level, optname, optval, optlen);

#ifdef CONFIG_NETFILTER
	if (err =3D -ENOPROTOOPT) {
		lock_sock(sk);
		err =3D compat_nf_setsockopt(sk, PF_INET, optname, optval, optlen);
		release_sock(sk);
	}
#endif
	return err;
}

And the same for udp, raw, ipv6, decnet and each of those with getsocko=
pt.
It is a bigger change, but it puts all the handlers where they belong
and it is more extensible to other sockopt handlers if we find more
fsckup in some of them.

	Arnd <><
