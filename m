From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: remove usage of __MOD_XXX_USAGE_COUNT and derivatives
Date: Sun, 12 Jan 2003 23:14:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301122314.17191.bdschuym@pandora.be>
References: <3E1DEF2D.4080703@fugmann.dhs.org> <3E1EE4EC.7010703@fugmann.dhs.org> <20030112163616.GA426@naboo.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>,
	Anders Fugmann <afu@fugmann.dhs.org>
In-Reply-To: <20030112163616.GA426@naboo.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sunday 12 January 2003 17:36, Harald Welte wrote:
> > Ok - I will split my answer up into two parts.
> > 1. It seems that we agree upon modules should not have their module
> > count increased because a new module is loaded. This is the current c=
ase.
>
> Well, I don't consider it important, if there is 'just' a module
> dependency, or an increased module usage count (or both, like now).  As
> long as it is assured that the system is in a consistent state.
>=20
> It's a minor (cosmetic) issue, that we do both right now... it doesn't
> even affect runtime performance in any noticeable way - how often are
> new matches/targets loaded?

Well, as is stated in Rusty's FAQ, a module doesn't need to increment its=
 own=20
usage count. Anyway, MOD_{INC,DEC}_USE_COUNT are deprecated in 2.5 now an=
d=20
even cause the module to be unable to be unloaded because "unsafe".

> > 2. If the general design goal is to have modules reflect all rules, I
> > guess that the sum of all module counts should be equal or greater th=
an
> > the total number of rules. If this is the case, then where which modu=
le
> > should be increased when inserting the rule "iptables -A INPUT". In
> > general - Should not iptables_filter's module count be incremented fo=
r
> > every inserted rule in the filter tabel (Same goes for NAT and MANGLE=
).
>
> iptable_filter usage count needs to be incremented.  Either per rule, o=
r
> increased to one as soon as there is >0 rules, and decreased to zero as
> soon as there is <1 rules.

Sorry if I misunderstand you, but the reason why the table modules don't =
need=20
to get an incremented usage count for every rule is because it's a featur=
e=20
that an rmmod iptable_filter removes all rules from the table before remo=
ving=20
the table module.
It's the usage count of match and target modules that needs to be increme=
nted=20
when they are used in a rule, and obviously that's being done.

inserting a rule "iptables -A INPUT" does not cause an increment in modul=
e=20
usage count. Module usage count is not a rule count.

> > I'm asking, as I'm willing to spend some time understanding the syste=
m,
> > and make patches for Netfilter.
>
> great, although I don't really see the need (see above).

There is a need.

--=20
cheers,
Bart
