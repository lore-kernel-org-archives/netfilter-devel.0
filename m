From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] [kernel patch] fixed duration connection
Date: Sat, 22 Apr 2006 02:02:44 +0200
Message-ID: <444972A4.7060209@trash.net>
References: <1144139619.5186.24.camel@localhost.localdomain>	<4433CCBF.6060103@trash.net>
	<4436DF6B.4060208@inl.fr>	<4436E03E.9030402@inl.fr>
	<44381584.4020109@trash.net>	<20060412083835.GN31616@sunbeam.de.gnumonks.org>	<20060412104824.GU31616@sunbeam.de.gnumonks.org>	<443D4FCE.2030802@trash.net>	<56883.194.167.18.244.1144945066.squirrel@mail.inl.fr>	<444843CC.3070105@trash.net>
	<1145652794.5191.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	nufw-devel@nongnu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1145652794.5191.3.camel@localhost.localdomain>
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

Eric Leblond wrote:
> Le vendredi 21 avril 2006 =E0 04:30 +0200, Patrick McHardy a =E9crit :
>=20
>>Eric Leblond wrote:
>>Thanks. Now all I need is a Signed-off-by: line :)
>>Please send one for your ctnetlink fix as well.
>=20
>=20
> I attach it to the mail and I hope this is ok. I stupidly did not manag=
e
> to get an autmotic way to add the Signed-off-by ...

Applied, thanks. Both your patches had whitespace damage I
had to fix up manually though. Please try to avoid this
in the future.

(Stripping trailing CRs from patch.)
patching file include/linux/netfilter/nf_conntrack_common.h
(Stripping trailing CRs from patch.)
patching file net/ipv4/netfilter/ip_conntrack_core.c
(Stripping trailing CRs from patch.)
patching file net/netfilter/nf_conntrack_core.c

+    /* Connection has fixed timeout. */
^^^^ should be tab
+	IPS_FIXED_TIMEOUT_BIT =3D 10,

+	if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status)){
                                                         ^ missing space
