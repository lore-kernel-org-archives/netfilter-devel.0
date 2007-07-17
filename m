From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: [PATCH 28/43] Unifies libip[6]t_tcp.c into libxt_tcp.c.
Date: Tue, 17 Jul 2007 08:45:55 +0200
Message-ID: <469C65A3.7050202@plouf.fr.eu.org>
References: <200707141811.l6EIBQma008773@toshiba.co.jp>	<Pine.LNX.4.64.0707142043430.25352@fbirervta.pbzchgretzou.qr>	<469AA37C.5080904@plouf.fr.eu.org>
	<200707170421.l6H4LwZO012092@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707170421.l6H4LwZO012092@toshiba.co.jp>
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

Yasuyuki KOZAKAI a =E9crit :
> From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
>>>
>>>Since SYN+FIN does not make much sense (unless the ipv6-tcp protocol _=
really_
>>>allowed that), libipt_tcp's definition should be used.
>>
>>IMHO it does not=20
>>matter whether SYN+FIN makes sense or not but whether it is a valid=20
>>combination or not per the RFCs. I have always believed that there is=20
>>some precedence among TCP flags, e.g. :
>>- RST has precedence over SYN and FIN ; if RST set, ignore SYN and FIN
>>- SYN has precedence over FIN ; if SYN set, ignore FIN
>>
>>Have I been wrong all this time ?
>=20
> IIRC RFC797 says nothing about the behavior when receiving such TCP
> flags.

I suppose you mean RFC973 ? Well, it says that SYN is handled before FIN.

> But I've found
>=20
> http://www.mail-archive.com/nanog@merit.edu/msg06112.html

I came across multiple similar discussions worrying about the so-called=20
SYN-FIN port scans. They all acknowledge that popular TCP/IP stack=20
implementations are "liberal" because they handle SYN+FIN as plain SYN.=20
But I do not agreed with them when they claim that packet filters which=20
unconditionally allow SYN+FIN through are "liberal" too. IMHO they are=20
not liberal but actually broken because they fail to identify SYN+FIN=20
either as plain SYN (which they should handle as such) or as an invalid=20
combination (which they should drop).

One of my concerns is that with the new conservative definition of=20
--syn, you cannot use it any more to drop SYN packets (e.g. to reject=20
incoming TCP connection attempts on a stateless packet filter) because=20
SYN+FIN won't match. Old rulesets which rely on --syn to detect and drop=20
packets become more permissive with the new definition.

However I agree that nowadays any decent packet filter should use TCP=20
connection tracking and not rely only on TCP flags. By the way, how does=20
the TCP connection tracking in ip_conntrack and nf_conntrack handle=20
"odd" flag combinations, i.e. more than one flag in RST, SYN and FIN set=20
at the same time ?
