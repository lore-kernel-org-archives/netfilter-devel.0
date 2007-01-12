From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Patch 0/2] Avoid direct connections between NATed hosts
Date: Fri, 12 Jan 2007 18:20:55 +0100
Message-ID: <45A7C377.2060600@trash.net>
References: <1168621167.28615.14.camel@localhost.localdomain>
	<200701121911.48617@auguste.remlab.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?ISO-8859-15?Q?R=E9mi_Denis-Courmont?= <rdenis@simphalempin.com>
In-Reply-To: <200701121911.48617@auguste.remlab.net>
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

R=E9mi Denis-Courmont wrote:
> Le vendredi 12 janvier 2007 18:59, Eric Leblond a =E9crit :
>=20
>>Some algorithms can be used to established direct connections between
>>NATed hosts. Skype is one of the programs using this kind of
>>"feature".
>=20
>=20
> NAT are not *security* devices; NATs are meant to *improve* IP usabilit=
y=20
> by allowing as many protocols as possible to operate even though there=20
> are not enough public IP addresses. Making it more difficult for P2P=20
> apps to operate through is hence completely not only non-sensical, but=20
> a plain contradiction.
>=20
> NATs are sufficiently broken and annoying already to handle for softwar=
e=20
> development; please do not make them worst. Also, this patch goes=20
> completely against work-in-progress NAT standards.

Fully agreed.

> In this particular case, your approach is a completely associal=20
> short-term solution. In the long run, it will simply cause people with=20
> normal/correct NATs to have to relay even more traffic when they should=
=20
> not have to, because of people like you. And it certainly won't prevent=
=20
> Skype from running on your network either.

Port randomization would still be a useful feature, not to wilfully
break skype, but to make spoofing attacks harder. Currently we
undo randomization done by the operating system/application. Since
its optional I don't see real harm in it.
