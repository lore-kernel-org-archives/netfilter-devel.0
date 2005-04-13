From: Filip Sneppe <filip.sneppe@gmail.com>
Subject: Re: REJECT target / need-fragment ?
Date: Wed, 13 Apr 2005 13:32:01 +0200
Message-ID: <9151ac2a05041304326389f0e4@mail.gmail.com>
References: <20050314125747.GA18233@paradigm.rfc822.org>
	<42373578.8060806@trash.net>
	<20050406113859.GA5335@paradigm.rfc822.org>
	<20050410203008.GP9155@sunbeam.de.gnumonks.org>
	<20050411223144.GA13620@paradigm.rfc822.org>
Reply-To: Filip Sneppe <filip.sneppe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Florian Lohoff <flo@rfc822.org>
In-Reply-To: <20050411223144.GA13620@paradigm.rfc822.org>
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

On 4/12/05, Florian Lohoff <flo@rfc822.org> wrote:
> On Sun, Apr 10, 2005 at 10:30:08PM +0200, Harald Welte wrote:
> >
> > thanks, looks fine to me.  I've applied the userspace part and put the
> > kernel part into my list of pending patches.
> >
>=20
> The kernel part needs an intialization in _v1 for the pmtu value -
> Otherwise we leak the short pmtu as it gets used uninitialized.
> Probably 1500 is a good value.
>=20
Hi Florian,

FYI, You may want to check the compilation of svn iptables against
a 2.4 kernel.

By applying the 2.6 kernel patch you mailed in this thread to 2.4 and
fixing up the two rejects, it's possible to compile iptables svn against
a 2.4 kernel, but the 2.4 kernel ipt_REJECT target compile fails because
2.4 doesn't have a revision field in ipt_target.

Removing the .revision initialization lines from ipt_REJECT.c gets the
module to compile, but still with warnings:

gcc -D__KERNEL__ -I/home/debby/kernel/linux-2.4.30/include -Wall
-Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing
-fno-common -fomit-frame-pointer -pipe -mpreferred-stack-boundary=3D2
-march=3Di686  -DMODULE -DMODVERSIONS -include
/home/debby/kernel/linux-2.4.30/include/linux/modversions.h  -nostdinc
-iwithprefix include -DKBUILD_BASENAME=3Dipt_REJECT  -c -o ipt_REJECT.o
ipt_REJECT.c
ipt_REJECT.c:481: warning: initialization from incompatible pointer type
ipt_REJECT.c:488: warning: initialization from incompatible pointer type

I don't know what the correct fix is for 2.4.

Regards,
Filip
