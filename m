From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: {get|set}sockopt compat layer
Date: Tue, 7 Mar 2006 16:05:38 +0100
Message-ID: <200603071605.39177.arnd@arndb.de>
References: <200602201110.39092.dim@openvz.org> <200602211256.00846.arnd@arndb.de> <200603071707.19138.dim@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: devel@openvz.org, dev@openvz.org, akpm@osdl.org,
	netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750772AbWCGPGP@vger.kernel.org>
To: Dmitry Mishin <dim@openvz.org>
In-Reply-To: <200603071707.19138.dim@openvz.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tuesday 07 March 2006 15:07, Dmitry Mishin wrote:
> Sorry for such delay, was on vacancy. Here is a patch, introducing=20
> compat_(get|set)sockopt handlers, as you proposed.

Looks pretty good to me, just a few nits I like to pick:

> --- ./include/linux/net.h.compat=A0=A0=A0=A0=A0=A0=A0=A02006-03-07 11=
:22:27.000000000 +0300
> +++ ./include/linux/net.h=A0=A0=A0=A0=A0=A0=A02006-03-07 11:20:07.000=
000000 +0300
> @@ -149,6 +149,12 @@ struct proto_ops {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0int optname, char __user *optval=
, int optlen);
> =A0=A0=A0=A0=A0=A0=A0=A0int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(*g=
etsockopt)(struct socket *sock, int level,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0int optname, char __user *optval=
, int __user *optlen);
> +#ifdef CONFIG_COMPAT
> +=A0=A0=A0=A0=A0=A0=A0int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(*com=
pat_setsockopt)(struct socket *sock, int level,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0int optname, char __user *optval, i=
nt optlen);
> +=A0=A0=A0=A0=A0=A0=A0int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(*com=
pat_getsockopt)(struct socket *sock, int level,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0int optname, char __user *optval, i=
nt __user *optlen);
> +#endif
> =A0=A0=A0=A0=A0=A0=A0=A0int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(*s=
endmsg) =A0 (struct kiocb *iocb, struct socket *sock,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0struct msghdr *m, size_t total_l=
en);
> =A0=A0=A0=A0=A0=A0=A0=A0int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(*r=
ecvmsg) =A0 (struct kiocb *iocb, struct socket *sock,

=46or the compat_ioctl stuff, we don't have the function pointer inside=
 an
#ifdef, the overhead is relatively small since there is only one of the=
se
structures per module implementing a protocol, but it avoids having to
rebuild everything when changing CONFIG_COMPAT.

It's probably not a big issue either way, maybe davem has a stronger op=
inion
on it either way.

> --- ./include/linux/netfilter.h.compat=A0=A02006-03-06 12:06:34.00000=
0000 +0300
> +++ ./include/linux/netfilter.h=A02006-03-07 15:00:14.000000000 +0300
> @@ -2,6 +2,7 @@
> =A0#define __LINUX_NETFILTER_H
> =A0
> =A0#ifdef __KERNEL__
> +#include <linux/config.h>
> =A0#include <linux/init.h>
> =A0#include <linux/types.h>
> =A0#include <linux/skbuff.h>

You don't need to add new <linux/config.h> includes any more, these are
automatic now.

> @@ -80,10 +81,18 @@ struct nf_sockopt_ops
> =A0=A0=A0=A0=A0=A0=A0=A0int set_optmin;
> =A0=A0=A0=A0=A0=A0=A0=A0int set_optmax;
> =A0=A0=A0=A0=A0=A0=A0=A0int (*set)(struct sock *sk, int optval, void =
__user *user, unsigned int len);
> +#ifdef CONFIG_COMPAT
> +=A0=A0=A0=A0=A0=A0=A0int (*compat_set)(struct sock *sk, int optval,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
void __user *user, unsigned int len);
> +#endif
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0int get_optmin;
> =A0=A0=A0=A0=A0=A0=A0=A0int get_optmax;
> =A0=A0=A0=A0=A0=A0=A0=A0int (*get)(struct sock *sk, int optval, void =
__user *user, int *len);
> +#ifdef CONFIG_COMPAT
> +=A0=A0=A0=A0=A0=A0=A0int (*compat_get)(struct sock *sk, int optval,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
void __user *user, int *len);
> +#endif
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0/* Number of users inside set() or get(). */
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned int use;

see above, same for some more of these.

> @@ -816,6 +826,12 @@ extern int sock_common_recvmsg(struct ki
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 =A0 =A0 =A0 struct msghdr *msg, size_t size, int flags);
> =A0extern int sock_common_setsockopt(struct socket *sock, int level, =
int optname,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0char __user *optval, int optlen);
> +#ifdef CONFIG_COMPAT
> +extern int compat_sock_common_getsockopt(struct socket *sock, int le=
vel,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int optname, char __use=
r *optval, int __user *optlen);
> +extern int compat_sock_common_setsockopt(struct socket *sock, int le=
vel,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int optname, char __use=
r *optval, int optlen);
> +#endif
> =A0
> =A0extern void sk_common_release(struct sock *sk);
> =A0

Declarations don't belong inside #ifdef.

	Arnd <><
