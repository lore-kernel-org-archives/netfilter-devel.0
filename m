From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 28/43] Unifies libip[6]t_tcp.c into libxt_tcp.c.
Date: Tue, 17 Jul 2007 13:21:56 +0900 (JST)
Message-ID: <200707170421.l6H4LwZO012092@toshiba.co.jp>
References: <200707141811.l6EIBQma008773@toshiba.co.jp>
	<Pine.LNX.4.64.0707142043430.25352@fbirervta.pbzchgretzou.qr>
	<469AA37C.5080904@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: pascal.mail@plouf.fr.eu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <469AA37C.5080904@plouf.fr.eu.org>
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
Date: Mon, 16 Jul 2007 00:45:16 +0200

> Hello,
> =

> Jan Engelhardt a =E9crit :
> > =

> > On Jul 15 2007 03:11, Yasuyuki KOZAKAI wrote:
> > =

> >>Note: libipt_tcp handled '--syn' as '--flags SYN,RST,ACK,FIN SYN', =
but
> >>     libip6t_tcp handled it as '--flags SYN,RST,ACK SYN'. I keep th=
is
> >>     difference for now.
> > =

> > Since SYN+FIN does not make much sense (unless the ipv6-tcp protoco=
l _really_
> > allowed that), libipt_tcp's definition should be used.
> =

> I just asked about this difference - and the reason why the FIN check=
 =

> was not originally present in libiptc_tcp but added later, in 1.3.2 -=
 in =

> the netfilter user list a few days ago. No reply yet. IMHO it does no=
t =


I don't know Harald's intention for that change correctly, sorry.

> matter whether SYN+FIN makes sense or not but whether it is a valid =

> combination or not per the RFCs. I have always believed that there is=
 =

> some precedence among TCP flags, e.g. :
> - RST has precedence over SYN and FIN ; if RST set, ignore SYN and FI=
N
> - SYN has precedence over FIN ; if SYN set, ignore FIN
> =

> Have I been wrong all this time ?

IIRC RFC797 says nothing about the behavior when receiving such TCP
flags. But I've found

http://www.mail-archive.com/nanog@merit.edu/msg06112.html

-- Yasuyuki Kozakai
