From: Patrick McHardy <kaber@trash.net>
Subject: Re: Problems with Kernel 2.6.22.1
Date: Wed, 25 Jul 2007 17:35:18 +0200
Message-ID: <46A76DB6.5030303@trash.net>
References: <46A6FD02.6050805@inf.tu-dresden.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter@lists.netfilter.org
To: =?ISO-8859-15?Q?=22Thomas_B=2E_Preu=DFer=22?=
 <tp14@inf.tu-dresden.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46A6FD02.6050805@inf.tu-dresden.de>
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

Thomas B. Preu=DFer wrote:
> Hello,
>=20
> having updated my kernel from 2.6.19.2 to 2.6.22.1 both taken as vanill=
a
> source from kernel.org, I now receive errors when trying to insert rule=
s
> using the state or conntrack modules. I expect other extensions to fail
> as well. The produced error messages suggest some incompatibility
> between the kernel and the userspace iptables:
>=20
> # iptables -v -A FORWARD -j ACCEPT -m state --state RELATED,ESTABLISHED
> ACCEPT  all opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  state
> RELATED,ESTABLISHED
> iptables: Invalid argument
>=20
> # iptables -v -A FORWARD -j ACCEPT -m conntrack --ctstate
> RELATED,ESTABLISHED
> ACCEPT  all opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  ctstate
> RELATED,ESTABLISHED
> iptables: Invalid argument
>=20
> This problem occurs with both the iptables v1.3.6 coming with Debian an=
d
> a self-compiled iptables v1.3.8 from the netfilter.org download page.
>=20
> Is any such issue known? May there be any non-automatic dependencies in
> the kernel configuration going beyond:
>=20
> CONFIG_NETFILTER_NETLINK=3Dy
> CONFIG_NF_CONNTRACK_ENABLED=3Dy
> CONFIG_NF_CONNTRACK=3Dy
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=3Dy
> CONFIG_NETFILTER_XT_MATCH_STATE=3Dy


Do you also have CONFIG_NF_CONNTRACK_IPV4 enabled?
