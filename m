From: Herve Eychenne <rv@wallfire.org>
Subject: Re: #263154: iptables: segfault with multiple ip hostnames
Date: Fri, 20 Aug 2004 18:09:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040820160959.GF4883@eychenne.org>
References: <20040803220350.GA5223@ljlane.net> <4110110E.40904@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: "Laurence J. Lane" <ljlane@nontoxic.org>,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4110110E.40904@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Aug 04, 2004 at 12:26:22AM +0200, Patrick McHardy wrote:

> Laurence J. Lane wrote:

> >http://bugs.debian.org/263154
> >
> >iptables 1.2.11 segfaults when given a domain name that resolves=20
> >to multiple ip addresses. The situation is the same for kernel=20
> >versions 2.4.26 and 2.6.7.
> >
> >As an example:
> >
> > # iptables -I INPUT -s google.com -j DROP
> > free(): invalid pointer 0x8055a4c!
> > Segmentation fault
> >=20
> >
> Already fixed in CVS:

> http://cvs.netfilter.org/iptables/iptables.c?r1=3D1.68&r2=3D1.69

Does this change make sense for ip6tables as well? If so, were the
equivalent changes committed as well?

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
