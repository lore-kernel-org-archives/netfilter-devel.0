From: Herve Eychenne <rv@wallfire.org>
Subject: Re: [PATCH 13/18] Netfilter: Multiport revision with port ranges
	(replaces "mport")
Date: Sat, 8 Jan 2005 04:42:05 +0100
Message-ID: <20050108034205.GK8756@eychenne.org>
References: <1104896159.20582.79.camel@localhost.localdomain>
	<20050105043027.GA23546@linuxace.com>
	<1104904015.20582.91.camel@localhost.localdomain>
	<20050108020322.GA11903@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
Content-Disposition: inline
In-Reply-To: <20050108020322.GA11903@linuxace.com>
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

On Fri, Jan 07, 2005 at 06:03:22PM -0800, Phil Oester wrote:

> On Wed, Jan 05, 2005 at 04:46:54PM +1100, Rusty Russell wrote:

> > > While I agree the above is a useful change, why not also add invers=
ion
> > > to multiport in the process -- as long as you're making a new revis=
ion?
> > > Or should that be done in revision 2?

> > If you put it in before 2.6.11 is released, it can go in the current
> > revision, otherwise we want a new one (where do we put the invert
> > flags?).

> OK, how about the below which adds inversion?

> (note: didn't update manpage, but then again, wasn't updated with previ=
ous
> changes)

Maybe because no one stated what the manpage policy regarding the
new revision system would be?...
When adding every successive revision documentation of every
match/target to the manpage, wouldn't it become severly bloated in the
end?

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
