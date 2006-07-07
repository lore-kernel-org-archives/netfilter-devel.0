From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: 2.6.17.1 compile error with a netfilter module
Date: Fri, 7 Jul 2006 10:19:09 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A206F79A@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Cc: Torsten Luettgert <t.luettgert@pressestimmen.de>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Patrick McHardy" <kaber@trash.net>,
	"Krzysztof Oledzki" <olenf@ans.pl>
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

Let me try to test it in the field next week.  I am buried all day
today.=20

- Greg

-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Thursday, July 06, 2006 11:14 PM
To: Krzysztof Oledzki
Cc: Greg Scott; Torsten Luettgert; netfilter-devel@lists.netfilter.org
Subject: Re: 2.6.17.1 compile error with a netfilter module

Krzysztof Oledzki wrote:
> OK, I prepared external repository with correct (I hope!) time and=20
> ipp2p extensions, TARPIT and connlimit are going to be fixed soon.=20
> Before I submit this to Patrick I need to be sure that it works. If=20
> you would like to test it, please:
>=20
>  - remove "time" and "ipp2p" directories from extracted pom-ng
>=20
>  - add this to the sources.list:
>=20
> # ipp2p and time maintained by Krzysztof Oledzki <ole@ans.pl>=20
> http://people.netfilter.org/ole/pom/
>=20
>  - run "./runme --download"
>=20
>  - patch & recompile kernel as always
>=20
>  - tell me if it works (or not).
>=20
> Both extensions should work with both 2.6.16 and 2.6.17 kernels if I=20
> done everything properly.

Thanks Krzysztof, seems to work fine (didn't tried patching, but the
rest). I've added it to the sources.list now.
