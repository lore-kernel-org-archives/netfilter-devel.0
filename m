From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: where to find newnat modules?
Date: 04 Jun 2003 21:37:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1054755292.828.11.camel@elendil.intranet.cartel-securite.net>
References: <200306041950.39365.alessio.caprari@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Alessio Caprari <alessio.caprari@libero.it>
In-Reply-To: <200306041950.39365.alessio.caprari@libero.it>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le mer 04/06/2003 =E0 19:50, Alessio Caprari a =E9crit :
> Hello, I read some messages about the development of a new NAT module, =
where=20
> can I find it?
> Does it contain any IPv6 support or it is related only to IPv4?

For sure, as IPv6 does not have conntrack support, IPv6 won't support
NAT for now (btw, there's no nat table for IPv6). So newnat is IPv4
only.

Afaik, newnat is part of stock kernel since 2.4.19 or can be found
within patch-o-matic for older kernels.

--=20
C=E9dric Blancher  <blancher@cartel-securite.fr>
Consultant en s=E9curit=E9 des syst=E8mes et r=E9seaux - Cartel S=E9curit=
=E9
T=E9l: +33 (0)1 44 06 97 87 - Fax: +33 (0)1 44 06 97 99
PGP KeyID:157E98EE  FingerPrint:FA62226DA9E72FA8AECAA240008B480E157E98EE
