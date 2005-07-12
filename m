From: Kaupo Arulo <kaups@linux.ee>
Subject: Re: (no subject)
Date: Tue, 12 Jul 2005 22:50:45 +0300
Message-ID: <200507122250.45949.kaups@linux.ee>
References: <20050710124100.D643673691@tux.linux.ee>
Reply-To: kaups@linux.ee
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050710124100.D643673691@tux.linux.ee>
Content-Disposition: inline
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

=C3=9Chel kenal p=C3=A4eval (p=C3=BChap=C3=A4ev, 10. juuli 2005 15:40) kirj=
utas =E6=A8=8A=E4=BA=AE:
> netfilter-devel:
>
> 	Our demand is like this now, a linux gateway, two network cards, one(eth=
0)
> is Intranet's  address 192. 168. 85. 1, the other
>
> (eth1) is extranet's address 202. 116. 93. 66, has tied 202 . 116. 83.
> 80-93 so many real address, Intranet is 192.168. 85.
>
> 10-23 so many timid address, require oneself write one netfilter module,
> make sure timid address and real address one-to-one
>
> correspondence. because in future  we will use ip address pool(about 4096
> ipaddresses) to assign real ip for user dynamicly,
>
> so we can't use systematic nat function.

I'm not sure, if I understood you correctly, but it seems that netmap patch=
=20
from POM should help you.

=2D-=20
Kaupo Arulo
