From: Herve Eychenne <rv@wallfire.org>
Subject: Re: iptables-save counters on builtin chains not restored?
Date: Sun, 22 Aug 2004 22:14:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040822201430.GI4883@eychenne.org>
References: <20040817211821.GE23109@eychenne.org> <20040819101314.GD3921@sunbeam.de.gnumonks.org> <20040820143617.GD4883@eychenne.org> <Pine.LNX.4.61.0408210143150.8001@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0408210143150.8001@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, Aug 21, 2004 at 02:01:44AM +0200, Henrik Nordstrom wrote:

> On Fri, 20 Aug 2004, Herve Eychenne wrote:

> >The side effect of this change will be that dump files created by new
> >iptables-save command (without -c) won't be restorable with old
> >iptables-restore (without -c).

> Are you sure? From what I can see this should work. I never specify=20
> counters in my iptables-restore input from what I can tell.. not on=20
> policies, not in rules. And it works just fine.

Probably you missed my rectification (sorry again) :
dump files created by new iptables-save command (without -c) won't be
restorable with old iptables-restore -c
                                    ^^^^
So there is no problem for the case you describe, right.

> iptables-restore -c without having counters specified in policies or=20
> custom chains complains,

According to me, it does not only complain, it crashes, because we
did not check the return of strtok and tried to parse counters whether
they are actually present or not. I fixed it already in my tree
(patch will be sent soon).

> but I never use this so I don't care, and what would the point be?

> What would break is reading in output from new iptables-save (with or=20
> without -c) using old iptables-restore -c.

Yes.

> >One thing that puzzles me is that old iptables-restore -c used to
> >restore old iptables-save (without -c) dumps without any complaints
> >about missing counters (for rules, as counters for builtin-chains were
> >dumped anyway).

> This is due to the parser nor caring if -c is specified or not when=20
> parsing the rules. It always parse the counters if there is any (in_tab=
le=20
> block), it then discards the result if -c is not specified.

I'm talking about chain counters (not rules), and IIRC these counters
were only parsed if -c was specified (memset of the struct to 0 otherwise=
).
Like I said, the issue was more that counters were tried to be parsed
even if they were lacking (->coredump).
But there is not much point in discussing this very longer... :-)

> >So I guess new iptables-restore -c should act likewise, that is
> >restore new iptables-save dumps (without -c) without error, but should=
n't
> >it at least issue a warning about the lack of the expected counters?

> Why? Is there a problem with reading a missing counter as an implicit=20
> zero?

It depends on your personnal policies. When I specify something like -c,
it is hardly by chance, and I tend to consider that trying (on purpose)
to restore something that actually does not exist is at least strange.
So I would personally go for a warning message (median solution),
but that's only a matter of how rigorous you expect the tools to be.

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
