From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: local NAT
Date: 11 Jun 2003 17:43:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1055346185.744.88.camel@elendil.intranet.cartel-securite.net>
References: <20030607215013.4F9B8444E8@service.i-think-future.de>
	 <20030611120649.GK32593@sunbeam.de.gnumonks.org>
	 <20030611140313.GB8055@balabit.hu>
	 <20030611145856.GT32593@sunbeam.de.gnumonks.org>
	 <20030611151922.GA15206@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
   Nils Radtke <Nils.Radtke@Think-Future.de>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <20030611151922.GA15206@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le mer 11/06/2003 =E0 17:19, Balazs Scheidler a =E9crit :
> I am talking about SNATing outgoing packets sent by local processes des=
tined
> _to_ a local process.

Afaik, you can SNAT them on OUTPUT chain without any problem.

> Is this the same case?

I don't think so.

--=20
C=E9dric Blancher  <blancher@cartel-securite.fr>
Consultant en s=E9curit=E9 des syst=E8mes et r=E9seaux - Cartel S=E9curit=
=E9
T=E9l: +33 (0)1 44 06 97 87 - Fax: +33 (0)1 44 06 97 99
PGP KeyID:157E98EE  FingerPrint:FA62226DA9E72FA8AECAA240008B480E157E98EE
