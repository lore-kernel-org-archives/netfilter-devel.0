From: Herve Eychenne <rv@wallfire.org>
Subject: Re: iptables-save counters on builtin chains not restored?
Date: Fri, 20 Aug 2004 16:36:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040820143617.GD4883@eychenne.org>
References: <20040817211821.GE23109@eychenne.org> <20040819101314.GD3921@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
        Netfilter Development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20040819101314.GD3921@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Aug 19, 2004 at 12:13:14PM +0200, Harald Welte wrote:

> On Tue, Aug 17, 2004 at 11:18:21PM +0200, Herve Eychenne wrote:

> > When fed with the result of iptables-save -c, iptables-restore -c
> > does not seem to restore counters on chains (I'm not talking about
> > rules), as I simply cannot find any parsing code for that.
> >=20
> > Note that it would make sense only on builtin chains, but not
> > user-chains, because only builtin chains have a policy, and the
> > counters are about packets that hit the policy.
> >=20
> > Anyway, it doesn't seem to be restored at all, and I suspect an
> > omission, so... a bug. Can someone confirm?

> Yes, now that you say it, I don't remember having written that code ;)

Did you ask your pet as well? ;-)

> Please put it in bugzilla... and patches are obviously always welcome.

I'm currently writing it, at least partly:
- for now iptables-save (with or without -c) used to dump counters for
  builtin-chains, which is wrong (useless when not called with -c).
  I'll fix that.
- iptables-save (also with or without -c) used to dump dummy counters
  (always [0:0]) for user-chains, which is also wrong (never needed,
  as it makes no sense for user-chains, right?). I'll fix that too.

The side effect of this change will be that dump files created by new
iptables-save command (without -c) won't be restorable with old
iptables-restore (without -c). But i think it's acceptable, as:
- people should not want to do that, as they should use
  iptables-restore.new, then
- if people really have to use iptables-restore.old, they can use
  iptables-save.new dumps, but with -c
- a very simple sed line fixes that

One thing that puzzles me is that old iptables-restore -c used to
restore old iptables-save (without -c) dumps without any complaints
about missing counters (for rules, as counters for builtin-chains were
dumped anyway).
So I guess new iptables-restore -c should act likewise, that is
restore new iptables-save dumps (without -c) without error, but shouldn't
it at least issue a warning about the lack of the expected counters?

Thanks for commenting everything above.

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
