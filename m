From: Herve Eychenne <rv@wallfire.org>
Subject: Re: possible issues with blowing up struct ipt_log_info
Date: Mon, 4 Jul 2005 00:05:25 +0200
Message-ID: <20050703220525.GA3331@eychenne.org>
References: <42C2C053.3040707@tac.ch> <20050629154049.GA17717@oknodo.bof.de>
	<20050629160923.GF3331@eychenne.org>
	<20050703123650.GW3186@sunbeam.de.gnumonks.org>
Reply-To: Herve Eychenne <rv@wallfire.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Patrick Schaaf <bof@bof.de>,
	Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Roberto Nibali <ratz@tac.ch>
Content-Disposition: inline
In-Reply-To: <20050703123650.GW3186@sunbeam.de.gnumonks.org>
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

On Sun, Jul 03, 2005 at 02:36:50PM +0200, Harald Welte wrote:

> On Wed, Jun 29, 2005 at 06:09:23PM +0200, Herve Eychenne wrote:
> > On Wed, Jun 29, 2005 at 05:40:49PM +0200, Patrick Schaaf wrote:
> >=20
> > > > My question is, if anyone sees any problems with this, regarding =
performance
> > > > degradation on 32bit boxes or with caching problems?
> >=20
> > > The problem is compatibility with older versions of the LOG target,
> > > both Userlevel (iptables .so module), and Kernel.
> >=20
> > > You can either make this a new target, or look how the versioning
> > > infrastructure discussed here some months ago, worked out. (I don't
> > > know; maybe there's already a HOWTO, or you want to write one :)
> >=20
> > I remember saying here that it would be cool to have the log prefix l=
ength
> > tunable at kernel LOG module insertion, have it exported (read-only) =
to some
> > /proc entry, and have userspace (iptables, or any other upper-level
> > application) rely on the real-time extracted value.

> I really don't think that this is worth the complexity...

Trying to insert potentially many LOG rules to empirically determine
the maximum prefix length is far less complex, that's for sure. ;-)
For now, that's the only way an upper-level tool will produce valid
LOG rules in all cases.
Probably many of you won't care, but for this kind of upper-layers
(which I'm particularly concerned with) netfilter/iptables sometimes
makes it hard to turn "should work" into "will work".
That LOG thing is only one example, though probably not the best.

> I also don't really like using out-of-band interfaces such as /proc
> to determine how to communicate rules via {get,set}sockopt()

Maybe you don't like /proc, but the kernel still has to provide a way
to inform userspace about the fixed size of some of its data (as
kernelspace doesn't like dynamic things very much...). If you see a
better way, that's ok, but the need is still there.

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
