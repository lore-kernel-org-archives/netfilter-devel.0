From: Marian Stagarescu <marian@ti.com>
Subject: PPTP conntrack w/out DEBUG is broken ???
Date: Wed, 25 Sep 2002 16:48:42 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200209251648.42936.marian@ti.com>
References: <87d6r9jaa4.fsf@sensi.yemanja.net> <1032690651.9594.13.camel@tux>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
   Netfilter <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>,
   =?iso-8859-15?q?C=E9dric=20Rivard?= <cedric@yemanja.net>
In-Reply-To: <1032690651.9594.13.camel@tux>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

i run into one problem with PPTP conntrack:

run it with debug on: works
run it w/out debug on: does not.

i also turned on the patch below and configure the CONFIG_NETFILTER_DEBUG=
:
compile ip_conntrack_pptp with debug on: all ok
compile ip_conntrack_pptp w/out debug: does not even print the ASSERT rea=
dlock=20
statements from CONFIG_NETFILTER_DEBUG, PPTP connection is not establishe=
d.

this debug issue was tracked down to a single printk statement in=20
ip_conntrack_pptp.c: line 244,245:

DEBUGP("%s, CID=3D%X, PCID=3D%X\n", strMName[msg]                 =20
                     ntohs(*cid), ntohs(*pcid));

i run this on a 2.4.17 mips little endian, single proc, latest pptp ALG f=
iles=20
from netfilter, newnat13.

how this can be ?=20

thanks for any input,
marian



On Sunday 22 September 2002 06:30 am, Martin Josefsson wrote:
> On Fri, 2002-09-20 at 11:11, C=E9dric Rivard wrote:
> > Hi all,
> >
> > As I've already reported, there is a problem with the PPTP conntrack
> > module of pom. It can't be built with the option CONFIG_NETFILTER_DEB=
UG.
> > And I still receive questions about the first thread I started on thi=
s
> > problem but without pointing the cause. I hope that everyone is now a=
ware
> > of this issue.
>
> This issue came to my attention in the end of August, I produced a patc=
h
> and I never heard from that person again. The patch is quite ugly but i=
t
> does solve this specific problem. I was waiting for some more input fro=
m
> other developers before submitting it to cvs but now I've given up on
> that and I've submitted it. patch-o-matic in cvs now works with
> debugging enabled.
>
> or you can apply this patch on your kernel after patching with the
> patch-o-matic you are currently using:
>
> http://www.netfilter.org/~gandalf/patches/ip_conntrack_proto_gre.c-lock=
fix
