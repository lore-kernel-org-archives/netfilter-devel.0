From: Herve Eychenne <rv@wallfire.org>
Subject: Re: [iptables 1.3.0 / libiptc patch] sort chains by hooknum/names
Date: Sat, 5 Mar 2005 03:07:25 +0100
Message-ID: <20050305020725.GC30982@eychenne.org>
References: <20050304212114.130e2a7c@coruscant>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: Olaf Rempel <razzor@kopf-tisch.de>
Content-Disposition: inline
In-Reply-To: <20050304212114.130e2a7c@coruscant>
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

On Fri, Mar 04, 2005 at 09:21:14PM +0100, Olaf Rempel wrote:

> hi list

> >From 1.3.0 all chain names were alphabetically sorted when listing tab=
les.
> A user-defined chain 'AAA' is listed before the buildin chain "INPUT", =
and=20
> "FORWARD" is listed before "INPUT".

> I've created two patches to revert it to the "old" behavior:
> first buildin chains, sorted by hooknum, than userdefined chains, sorte=
d by name.

Appart from the fact that it restores the old behavior (and avoids
breakage of some badly written scripts or apps), can you give a
single reason why the listing should be sorted?

Why not sort the output of a lot of commands (like lsof, netstat, ps,
etc.) then?  Hint: probably because there is no interest in wasting CPU
time for this.

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
