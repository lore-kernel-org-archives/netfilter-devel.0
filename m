From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Netfilter state table sync status?
Date: Wed, 19 May 2004 15:13:28 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040519121328.GM1775@edu.joroinen.fi>
References: <20040513121639.GK1775@edu.joroinen.fi> <20040517134545.GE11060@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040517134545.GE11060@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, May 17, 2004 at 03:45:45PM +0200, Harald Welte wrote:
> On Thu, May 13, 2004 at 03:16:39PM +0300, Pasi K=E4rkk=E4inen wrote:
> > Hi,
> >=20
> > What's the current state of the Netfilter state table sync code? Is i=
t
> > already functional?=20
>=20
> It's working, at least sort-of.  There are three currently known bugs
> that I'm hunting down.
>=20

OK. Mind to comment what are these bugs?

> > I would like to synchronize the state tables of two different Netfilt=
er
> > boxes.
>=20
> The current code is in CVS (netfilter-ha/ct_sync).  There are no
> 'easy-to-apply' patches yet.
>=20
> the code has dependencies on nfnetlink-ctnetlink and l2netfilter from
> pom-ng.
>=20

I'll try to play with these and see if I can get them working.

If you have time to post some kind of short help that would be nice :)

-- Pasi K=E4rkk=E4inen
      =20
                                   ^
                                .     .
                                 Linux
                              /    -    \
                             Choice.of.the
                           .Next.Generation.
