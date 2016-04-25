From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH v2] uapi glibc compat: fix compile errors when glibc
 net/if.h included before linux/if.h
Date: Mon, 25 Apr 2016 15:13:35 +0300
Message-ID: <20160425121335.GL5160@lakka.kapsi.fi>
References: <1461512707-23058-1-git-send-email-mikko.rapeli@iki.fi>
 <571DFED1.1090601@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Zhang Shengju <zhangshengju@cmss.chinamobile.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>,
	Josh Boyer <jwboyer@fedoraproject.org>,
	Waldemar Brodkorb <mail@waldemar-brodkorb.de>,
	Gabriel Laskar <gabriel@lse.epita.fr>,
	netfilter-devel@vger.kernel.org, libc-alpha@sourceware.org,
	Rich Felker <dalias@libc.org>, nd <nd@arm.com>
To: Szabolcs Nagy <szabolcs.nagy@arm.com>
Return-path: <libc-alpha-return-69133-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <571DFED1.1090601@arm.com>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Apr 25, 2016 at 12:26:09PM +0100, Szabolcs Nagy wrote:
> On 24/04/16 16:45, Mikko Rapeli wrote:
> > glibc's net/if.h contains copies of definitions from linux/if.h and these
> > conflict and cause build failures if both files are included by application
> > source code. Changes in uapi headers, which fixed header file dependencies to
> > include linux/if.h when it was needed, e.g. commit 1ffad83d, made the
> > net/if.h and linux/if.h incompatibilities visible as build failures for
> > userspace applications like iproute2 and xtables-addons.
> > 
> > This patch fixes compile errors when glibc net/if.h is included before
> > linux/if.h:
> > 
> 
> there should be a way to turn the conflicting definitions
> off if a libc header is included first. (the other direction
> won't work in general because linux definitions can be wrong
> for user space.)
>
> currently the only way to avoid the conflict is to define
> __GLIBC__ and a handful of glibc include guard macros that
> are not part of any public api, so a libc implementation
> might not want to do this.
> 
> e.g. the kernel could turn off the potentially conflicting
> definitions if the libc defines __LIBC_WANTS_NO_UAPI_DEFS
> (it can use finer grain control, but there should be a
> non-glibc specific way to do this).

True. Maybe Linux kernel could allow non-glibc userspace headers to define
__UAPI_DEF's as they wish but fall back to a default 1 as in lines after:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/libc-compat.h#n118

But sometimes users run old libc's and want to use shiny features from newer
kernel and thus use kernel headers for some extra definitions to existing
libc headers and use them in system calls.

Driver specific ioctl's are a good example.

-Mikko
