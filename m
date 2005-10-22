From: Norman Rasmussen <norman@rasmussen.co.za>
Subject: Re: [PATCH] owner-socketlookup update for 2.6.10
Date: Sun, 23 Oct 2005 00:22:03 +0200
Message-ID: <5b698f5a0510221522s51c9d579q45c7afa3a92f8a31@mail.gmail.com>
References: <4211F586.7020106@niksula.hut.fi>
	<20050216133807.GW3829@sunbeam.de.gnumonks.org>
	<5b698f5a0510201037k3a246f09g4cb92eb83b1910ca@mail.gmail.com>
	<43581A61.4020103@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <43581A61.4020103@outerspace.dyndns.org>
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

I tried changing (in udp.h):

extern struct sock *udp_v4_lookup

to

extern static struct sock *udp_v4_lookup

but now gcc tells me:

include/net/udp.h:77: error: multiple storage classes in declaration specif=
iers

:-(

any tips on getting an __inline__ function to be recognised
externally, or are they mutually exclusive?

On 10/21/05, Jonas Berlin <xkr47@outerspace.dyndns.org> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: RIPEMD160
>
> Quoting Norman Rasmussen on 2005-10-20 17:37 UTC:
> > The owner-socketlookup patch has once more broken between 2.6.10 and 2.=
6.12.
> >
> > It seems that udp_v4_lookup is now static, so I've changed the header
> > in the patch and I'll see if it helps.
> >
> > Otherwise, Jonas you did such a good job on the previous attempt, if I
> > can't get it to work, do you have time to have a look and see if you
> > can tweak the patch to make it work against 2.6.12?
>
> If I find spare time, certainly :)
>
> - --
> - - xkr47
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.2 (GNU/Linux)
>
> iD8DBQFDWBpdxyF48ZTvn+4RAxczAKCKeYqjvLtr9rGiLo/eCnWM5Jsa5wCfYxdR
> J3Xp3CAgF7bJfU1vQP1iGSQ=3D
> =3DTMrr
> -----END PGP SIGNATURE-----
>


--
- Norman Rasmussen
 - Email: norman@rasmussen.co.za
 - Home page: http://norman.rasmussen.co.za/
