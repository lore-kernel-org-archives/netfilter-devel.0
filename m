From: Rolf Wuerdemann <rowue@crew-kg.de>
Subject: Re: New Target: ipt_ACCOUNT
Date: Mon, 6 Jan 2003 18:22:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301061722.h06HMsX01278@moonlight.crew-kg.de>
References: <200212161736.gBGHaPn01458@moonlight.crew-kg.de> <20030106132422.GJ9467@sunbeam.de.gnumonks.org>
Reply-To: rowue@crew-kg.de
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>, Rolf Wuerdemann <rowue@crew-kg.de>
In-Reply-To: <20030106132422.GJ9467@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am Montag, 6. Januar 2003 14:24 schrieb Harald Welte:
> On Mon, Dec 16, 2002 at 06:36:22PM +0100, Rolf Wuerdemann wrote:
> > Hi there ...
>
> Hi, sorry for my late reply.

Hi Harald (hope first name is o.k. ;) - no prob ;)
>
> > we've developed a new target for iptables: ipt_ACCOUNT.
> > This Target accounts Traffik on a packet-base on source and
> > target ip using netfilter (similar to nacctd - but using iptables).
> >
> > It's in use on our routers (app. 60MBit/s Bandwitdh) since three mont=
h
> > (app.) without any trouble and was tested with some DDoS-Tools before
> > use ;)
>
> great news.  A couple of comments:

Thank you ;)
>
>  I think this is the wrong approach, there are way too much data
> strucctures in non-swappable kernel momory allocated.  And kernel-OOM i=
s
> not something we should provoke.  A better architecture from my point o=
f
> view was: - use ULOG to copy the IP+TCP header of all packets to
> userspace [it is very efficient in doing so!!!] and then do all the
> accounting in userspace

I was aware of the OOM-Problem (so DDoS can kill your Router!), and thoug=
ht
about something like acctrack_max (simmilar to contrack_max) so you can
set an maximum of tracked connections. This is not an solve for the root=20
of the problem (to much data structures) - but an solve if you're afraid =
of
running OOM from this side. - Perhaps I'll do some tests using ULOG, but
from work with nacctd I know that copying packets from Kernel to User-Spa=
ce
takes much time (and time/speed was something I want to save ;)
>
> Leaving this personal view aside, I still dislike a couple of issues
> with your patch
>
> - It doesn't adhere to the kernel CodingStyle
> =09- german variables
> =09- C++ style comments
> =09- more than 80chars per line

*G* - no problem to fix (like some debug-messages, etc ;) - I've posted
the source before "cleanup" - so I can work in suggestions/comments with
the cleanup ;)=20

> - the kernel/userspace interface using a socket option

Yes - thinking about using /dev/accouning (fs i/o) to get the
data from kernel-space - /proc-fs seems to be unlikely (approx 2M
filesize) - any opinions?
>
> So if you want to contribute it into patch-o-matic, you will have to
> at least conform to the coding style, sorry.

Nothing to sorry ;) - Hwo should I post the changed version? Complete,
diff, link to ftp/cvs?

>
> > PS: We've developed it 'cause nacctd was
> > =09a) to much use of cpu
> > =09b) looses packets during kernel-problems with PF_PACKET
>
> I am (as a long time nacctd user and hacker) aware of those issues.  Bu=
t
> this doesn't mean that moving everything into the kernel is the right
> thing..

Hmmm ... If you want to gain speed it's one of the best solutions - accou=
nt=20
the packets at the lowest possible level ;)

Regard's

=09Rolf W=FCrdemann
=09Wieske's Crew KG
- --=20
               Security is an illusion - Datasecurity twice
  Rolf Wuerdemann  - Privat: rowue@digitalis.org - Office: rowue@crew-kg.=
de
  GnuPG-Key fingerprint: 7383 348F 67D1 CD27 C90F DDD0 86A3 31B6 67F0 D02=
F
    RSA-Key fingerprint:      CEBB 5086 9154 E8D8 7D0E CC4F 0F5E B9CC
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+GbtphqMxtmfw0C8RAsOHAJ9FNK1xJ6NLuSJkCYJwEh+cMJ0dLgCgqcPK
ehEfBQq8aavZ5KoyTMciqUk=3D
=3DTLx/
-----END PGP SIGNATURE-----
