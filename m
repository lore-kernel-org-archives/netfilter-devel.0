From: Herve Eychenne <rv@wallfire.org>
Subject: Re: [PATCH 13/18] Netfilter: Multiport revision with port ranges
	(replaces "mport")
Date: Tue, 11 Jan 2005 02:47:40 +0100
Message-ID: <20050111014740.GP18211@eychenne.org>
References: <1104896159.20582.79.camel@localhost.localdomain>
	<20050105043027.GA23546@linuxace.com>
	<1104904015.20582.91.camel@localhost.localdomain>
	<20050108020322.GA11903@linuxace.com>
	<20050108034205.GK8756@eychenne.org> <41E1B162.2010104@eurodev.net>
	<1105323851.22093.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <1105323851.22093.2.camel@localhost.localdomain>
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

On Mon, Jan 10, 2005 at 01:24:11PM +1100, Rusty Russell wrote:

> On Sun, 2005-01-09 at 23:34 +0100, Pablo Neira wrote:
> > bonjour,
> >=20
> > Herve Eychenne wrote:
> >=20
> > >>(note: didn't update manpage, but then again, wasn't updated with p=
revious
> > >>changes)
> > >>   =20
> > >>
> > >
> > >Maybe because no one stated what the manpage policy regarding the
> > >new revision system would be?...
> > >When adding every successive revision documentation of every
> > >match/target to the manpage, wouldn't it become severly bloated in t=
he
> > >end?

> You should add the new feature to the manpage.

Yes, let's just hope there won't be too many revisions over time,
because that would certainly confuse the users.  So, we shouln't add
revisions too often as Pablo said, or at least think before doing so.

> The extension should
> then fail with an appropriate message if the version of the kernel does
> not support the option used.

Yes, and add a mecanism in iptables command enabling to know in advance
(before actually trying) if a given revision will work (for third party
software), as well as the list of usable revisions (for third
party again) _and_ available (whether they would actually
work with current kernel or not) revisions (for the user, this time),
ideally.

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
