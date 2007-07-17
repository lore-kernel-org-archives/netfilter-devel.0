From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 28/43] Unifies libip[6]t_tcp.c into libxt_tcp.c.
Date: Tue, 17 Jul 2007 16:48:33 +0900 (JST)
Message-ID: <200707170748.l6H7mY08001340@toshiba.co.jp>
References: <469AA37C.5080904@plouf.fr.eu.org>
	<200707170421.l6H4LwZO012092@toshiba.co.jp>
	<469C65A3.7050202@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
To: pascal.mail@plouf.fr.eu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <469C65A3.7050202@plouf.fr.eu.org>
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

From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>

> Yasuyuki KOZAKAI a =E9crit :
> > From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
> >>>
> >>>Since SYN+FIN does not make much sense (unless the ipv6-tcp protoc=
ol _really_
> >>>allowed that), libipt_tcp's definition should be used.
> >>
> >>IMHO it does not =

> >>matter whether SYN+FIN makes sense or not but whether it is a valid=
 =

> >>combination or not per the RFCs. I have always believed that there =
is =

> >>some precedence among TCP flags, e.g. :
> >>- RST has precedence over SYN and FIN ; if RST set, ignore SYN and =
FIN
> >>- SYN has precedence over FIN ; if SYN set, ignore FIN
> >>
> >>Have I been wrong all this time ?
> > =

> > IIRC RFC797 says nothing about the behavior when receiving such TCP=

> > flags.
> =

> I suppose you mean RFC973 ? Well, it says that SYN is handled before =
FIN.

No, RFC793 :) Sorry.


> > But I've found
> > =

> > http://www.mail-archive.com/nanog@merit.edu/msg06112.html
> =

> I came across multiple similar discussions worrying about the so-call=
ed =

> SYN-FIN port scans. They all acknowledge that popular TCP/IP stack =

> implementations are "liberal" because they handle SYN+FIN as plain SY=
N. =

> But I do not agreed with them when they claim that packet filters whi=
ch =

> unconditionally allow SYN+FIN through are "liberal" too. IMHO they ar=
e =

> not liberal but actually broken because they fail to identify SYN+FIN=
 =

> either as plain SYN (which they should handle as such) or as an inval=
id =

> combination (which they should drop).
> =

> One of my concerns is that with the new conservative definition of =

> --syn, you cannot use it any more to drop SYN packets (e.g. to reject=
 =

> incoming TCP connection attempts on a stateless packet filter) becaus=
e =

> SYN+FIN won't match. Old rulesets which rely on --syn to detect and d=
rop =

> packets become more permissive with the new definition.

Yes, so I think we'd better to add some texts about this change in
the announcement of next version.

And if users want to handle match SYN+FIN, they can use '--tcp-flags'.

> However I agree that nowadays any decent packet filter should use TCP=
 =

> connection tracking and not rely only on TCP flags. By the way, how d=
oes =

> the TCP connection tracking in ip_conntrack and nf_conntrack handle =

> "odd" flag combinations, i.e. more than one flag in RST, SYN and FIN =
set =

> at the same time ?

From=20nf_conntrack_proto_tcp.c, =


/* table of valid flag combinations - PUSH, ECE and CWR are always vali=
d */
static u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_ACK|TH_URG) + 1] =3D=

{
        [TH_SYN]                        =3D 1,
        [TH_SYN|TH_URG]                 =3D 1,
        [TH_SYN|TH_ACK]                 =3D 1,
        [TH_RST]                        =3D 1,
        [TH_RST|TH_ACK]                 =3D 1,
        [TH_FIN|TH_ACK]                 =3D 1,
        [TH_FIN|TH_ACK|TH_URG]          =3D 1,
        [TH_ACK]                        =3D 1,
        [TH_ACK|TH_URG]                 =3D 1,
}; =


-- Yasuyuki Kozakai
