From: Diego Woitasen <diegows@linux.org.ar>
Subject: Re: connbytes: wrong depends on Kconfig
Date: Sun, 04 Sep 2005 19:18:45 -0300
Message-ID: <1125872325.11932.8.camel@ceci.ws.ar>
References: <1125808606.32363.1.camel@ceci.ws.ar> <431B1A24.4000304@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <431B1A24.4000304@trash.net>
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

I used the yesterday svn snapshot of patch-o-matic and the error was
there.

what tree are you talking about?

El dom, 04-09-2005 a las 18:00 +0200, Patrick McHardy escribi=F3:
> Diego Woitasen wrote:
> > depends on IP_NF_CONNTRACK_ACCT && IP_NF_IPTABLES
> >=20
> > sould be replaced by
> >=20
> > depends on IP_NF_CT_ACCT && IP_NF_IPTABLES
> >=20
> > The first is not working in new kernels.
>=20
> The current tree already include the connbytes match and the
> correct dependency:
>=20
> config IP_NF_MATCH_CONNBYTES
>          tristate  'Connection byte/packet counter match support'
>          depends on IP_NF_CT_ACCT && IP_NF_IPTABLES
