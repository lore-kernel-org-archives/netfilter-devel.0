From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] netfilter: implement TCPMSS target for IPv6
Date: Mon, 12 Feb 2007 17:33:11 +0100
Message-ID: <45D096C7.6050604@trash.net>
References: <20070114192011.GA6270@clipper.ens.fr>
	<200702121808.04643@auguste.remlab.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: David Madore <david.madore@ens.fr>, netfilter-devel@lists.netfilter.org
To: =?ISO-8859-15?Q?R=E9mi_Denis-Courmont?= <rdenis@simphalempin.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200702121808.04643@auguste.remlab.net>
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
> Le dimanche 14 janvier 2007 21:20, David Madore a =E9crit :
>=20
>>Implement TCPMSS target for IPv6 by shamelessly copying from
>>Marc Boucher's IPv4 implementation.
>=20
>=20
> Most of the code seems to be TCP- rather IPvXY- specific. Would it not=20
> make more sense to just write a xt_TCPMSS implementation to rule them=20
> all?

Thats what I did, its in the current -git tree.
