From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c and optimization
Date: Fri, 25 Jun 2004 09:53:50 +0000 (UTC)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <19040125165321.GA4640@obroa-skai.de.gnumonks.org>
References: <200406240404.NAA01264@toshiba.co.jp> <40DABA52.9070700@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
	netfilter-devel@lists.netfilter.org, kisza@securityaudit.hu,
	usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <40DABA52.9070700@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
Date: Mon, 25 Jan 1904 17:53:21 +0100
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 24, 2004 at 01:26:10PM +0200, Patrick McHardy wrote:
> Yasuyuki Kozakai wrote:
> >Hi, folks,
> >
> >In the current kernel, skb is linearized by skb_linearize() in=20
> >ip6_tables.c.
> >I suggest removing this, and this patch is the 1st step to do it.
> >
> >To remove skb_linearize(), this patch changes the API of match() like
> >ip_tables.h
>=20
> I'm not sure the way iptables does it is really the right way. We call
> skb_copy_bits for anything that needs to be matched after the ip_header.

yes.

> Think of 100 rules matching "-p tcp --dport X". We copy the tcp header
> 100 times, for a total of 2000 bytes.=20

but we're talking about local copies to the stack.  those copies are 20
byte copies to the cache, and most likely would never have to hit memory
at all. =20

> One call to skb_linearize would most likely be less expensive. I'm
> thinking about putting the copied protocol header in the control
> buffer, this would reduce this extensive copying a lot. We could also
> do some common preprocessing steps in one place, like converting
> things to host byte order.

yes, it would be only one copy... but to real memory..

> Comments anyone ?

Maybe we need some benchmarking on this.

> Regards
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
