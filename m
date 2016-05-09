From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] uapi glibc compat: fix compile errors when glibc
 net/if.h included before linux/if.h
Date: Mon, 9 May 2016 23:35:35 +0200
Message-ID: <20160509213535.GA23623@salvia>
References: <1461512707-23058-1-git-send-email-mikko.rapeli@iki.fi>
 <CA+5PVA7eQLc1UGbaJg9B2BY-6L35Vx3Enpc6Ez9ySucGsY+o6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>,
	"David S. Miller" <davem@davemloft.net>,
	Zhang Shengju <zhangshengju@cmss.chinamobile.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
	Jan Engelhardt <jengelh@inai.de>,
	Waldemar Brodkorb <mail@waldemar-brodkorb.de>,
	Gabriel Laskar <gabriel@lse.epita.fr>,
	netfilter-devel@vger.kernel.org,
	libc-alpha <libc-alpha@sourceware.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Return-path: <libc-alpha-return-69464-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <CA+5PVA7eQLc1UGbaJg9B2BY-6L35Vx3Enpc6Ez9ySucGsY+o6A@mail.gmail.com>
List-Id: netfilter-devel.vger.kernel.org

On Mon, May 09, 2016 at 09:59:22AM -0400, Josh Boyer wrote:
> On Sun, Apr 24, 2016 at 11:45 AM, Mikko Rapeli <mikko.rapeli@iki.fi> wrote:
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
> > ./linux/if.h:99:21: error: redeclaration of enumerator ‘IFF_NOARP’
[...]
> >
> > The cases where linux/if.h is included before net/if.h need a similar fix in
> > the glibc side, or the order of include files can be changed userspace
> > code as a workaround.
> >
> > This change was tested in x86 userspace on Debian unstable with
> > scripts/headers_compile_test.sh:
> >
> > $ make headers_install && \
> >   cd usr/include && ../../scripts/headers_compile_test.sh -l -k
> > ...
> > cc -Wall -c -nostdinc -I /usr/lib/gcc/i586-linux-gnu/5/include -I /usr/lib/gcc/i586-linux-gnu/5/include-fixed -I . -I /home/mcfrisk/src/linux-2.6/usr/headers_compile_test_include.2uX2zH -I /home/mcfrisk/src/linux-2.6/usr/headers_compile_test_include.2uX2zH/i586-linux-gnu -o /dev/null ./linux/if.h_libc_before_kernel.h
> > PASSED libc before kernel test: ./linux/if.h
> >
> > Reported-by: Jan Engelhardt <jengelh@inai.de>
> > Reported-by: Josh Boyer <jwboyer@fedoraproject.org>
> > Reported-by: Stephen Hemminger <shemming@brocade.com>
> > Reported-by: Waldemar Brodkorb <mail@waldemar-brodkorb.de>
> > Cc: Gabriel Laskar <gabriel@lse.epita.fr>
> > Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
> 
> Bump.  Did this get lost in a queue somewhere?

It seems linux-netdev was not Cc'ed. I cannot find this in David's
patchwork [1].

@Mikko: Could you resubmit including netdev@vger.kernel.org? Thanks.

[1] http://patchwork.ozlabs.org/project/netdev/list/.
