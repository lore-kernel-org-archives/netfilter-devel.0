From: Szabolcs Nagy <szabolcs.nagy@arm.com>
Subject: Re: [PATCH v2] uapi glibc compat: fix compile errors when glibc net/if.h
 included before linux/if.h
Date: Mon, 25 Apr 2016 12:26:09 +0100
Message-ID: <571DFED1.1090601@arm.com>
References: <1461512707-23058-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Jan Engelhardt <jengelh@inai.de>, Josh Boyer <jwboyer@fedoraproject.org>,
	Waldemar Brodkorb <mail@waldemar-brodkorb.de>, Gabriel Laskar
	<gabriel@lse.epita.fr>, <netfilter-devel@vger.kernel.org>,
	<libc-alpha@sourceware.org>, Rich Felker <dalias@libc.org>, nd <nd@arm.com>
To: Mikko Rapeli <mikko.rapeli@iki.fi>, "David S. Miller"
	<davem@davemloft.net>, Zhang Shengju <zhangshengju@cmss.chinamobile.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	<linux-kernel@vger.kernel.org>
Return-path: <libc-alpha-return-69131-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <1461512707-23058-1-git-send-email-mikko.rapeli@iki.fi>
List-Id: netfilter-devel.vger.kernel.org

On 24/04/16 16:45, Mikko Rapeli wrote:
> glibc's net/if.h contains copies of definitions from linux/if.h and these
> conflict and cause build failures if both files are included by applicati=
on
> source code. Changes in uapi headers, which fixed header file dependencie=
s to
> include linux/if.h when it was needed, e.g. commit 1ffad83d, made the
> net/if.h and linux/if.h incompatibilities visible as build failures for
> userspace applications like iproute2 and xtables-addons.
>=20
> This patch fixes compile errors when glibc net/if.h is included before
> linux/if.h:
>=20

there should be a way to turn the conflicting definitions
off if a libc header is included first. (the other direction
won't work in general because linux definitions can be wrong
for user space.)

currently the only way to avoid the conflict is to define
__GLIBC__ and a handful of glibc include guard macros that
are not part of any public api, so a libc implementation
might not want to do this.

e.g. the kernel could turn off the potentially conflicting
definitions if the libc defines __LIBC_WANTS_NO_UAPI_DEFS
(it can use finer grain control, but there should be a
non-glibc specific way to do this).
