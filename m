From: Herve Eychenne <rv@wallfire.org>
Subject: Re: [PATCH] MASQUERADE handling of device events
Date: Wed, 24 Nov 2004 16:39:02 +0100
Message-ID: <20041124153902.GM2417@eychenne.org>
References: <20041107181825.GA3522@linuxace.com>
	<1101005908.18919.11.camel@localhost.localdomain>
	<20041123211623.GA20289@linuxace.com>
	<1101267454.6186.13.camel@localhost.localdomain>
	<Pine.LNX.4.61.0411241018270.15946@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0411241018270.15946@filer.marasystems.com>
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

On Wed, Nov 24, 2004 at 10:24:34AM +0100, Henrik Nordstrom wrote:

> On Wed, 24 Nov 2004, Rusty Russell wrote:

> >Drawing a link between point-to-point and addresses being static is
> >wrong, IMHO.

> Agreed.

> This discussion is equally important on Ethernet with dynamic IP=20
> assignment. Here the interface name is defenitely static.

> As already discussed very many times MASQUERADE is a best effort to han=
dle=20
> the common "dial up like" with dynamic Internet IP assignment scenarios=
 in=20
> an easy manner.  A multiple PPP situation is more of an exception than=20
> rule to this, and in addition userspace has the option of using statica=
lly=20
> reserved PPP devices for the connections in question to make the propos=
ed=20
> MASQUERADE fully predictable in such situations.

Being the guy who proposed the original change to Rusty during the
workshop 2003, I eventually step up to support this view. :-)
IMHO, the goal of the MASQUERADE target is trying to deal as
nicely as possible with the common cases.

I think it should be kept that way, no matter it may have some side effec=
t
for uncommon or obscur setups, as long as the potential corner cases are
clearly documented.
The more complex scenarios should always be able to use something
else than MASQUERADE.

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
