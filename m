From: William Stearns <wstearns@pobox.com>
Subject: Re: iptables 1.2.6a
Date: Thu, 10 Oct 2002 17:39:02 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0210101737280.15495-100000@sparrow>
References: <046301c270a4$d62e9640$1543a8c0@sanches>
Reply-To: William Stearns <wstearns@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Alexandre Carlos <alexandre@redes.unb.br>
In-Reply-To: <046301c270a4$d62e9640$1543a8c0@sanches>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Good day, Alexandre,

On Thu, 10 Oct 2002, Alexandre Carlos wrote:

> i want to add a rule to the iptable as follow
>=20
> iptables -t nat -A PREROUTONG -s 10.1.1.2 -d 192.168.67.91 -p tcp -dpor=
t
> 23 -j DNAT --to-destination 192.168.1.1
>=20
> but i=B4m receiving the following error message multiple -d flags not a=
llowed.

	This needs to be --dport (note two dashes).
	BTW, was "PREROUTONG" a cut-and-paste error, or was that the=20
actual text you used in the command?  It should be "PREROUTING".
	Cheers,
	- Bill

-------------------------------------------------------------------------=
--
        "Democracy is three wolves and a sheep voting on what's for
dinner."
(Courtesy of "D'Arcy J.M. Cain" <darcy@druid.net>)
-------------------------------------------------------------------------=
-
William Stearns (wstearns@pobox.com).  Mason, Buildkernel, named2hosts,=20
and ipfwadm2ipchains are at:                        http://www.stearns.or=
g
-------------------------------------------------------------------------=
-
