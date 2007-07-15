From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: [PATCH 28/43] Unifies libip[6]t_tcp.c into libxt_tcp.c.
Date: Mon, 16 Jul 2007 00:45:16 +0200
Message-ID: <469AA37C.5080904@plouf.fr.eu.org>
References: <200707141811.l6EIBQma008773@toshiba.co.jp>
	<Pine.LNX.4.64.0707142043430.25352@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707142043430.25352@fbirervta.pbzchgretzou.qr>
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

Hello,

Jan Engelhardt a =E9crit :
>=20
> On Jul 15 2007 03:11, Yasuyuki KOZAKAI wrote:
>=20
>>Note: libipt_tcp handled '--syn' as '--flags SYN,RST,ACK,FIN SYN', but
>>     libip6t_tcp handled it as '--flags SYN,RST,ACK SYN'. I keep this
>>     difference for now.
>=20
> Since SYN+FIN does not make much sense (unless the ipv6-tcp protocol _r=
eally_
> allowed that), libipt_tcp's definition should be used.

I just asked about this difference - and the reason why the FIN check=20
was not originally present in libiptc_tcp but added later, in 1.3.2 - in=20
the netfilter user list a few days ago. No reply yet. IMHO it does not=20
matter whether SYN+FIN makes sense or not but whether it is a valid=20
combination or not per the RFCs. I have always believed that there is=20
some precedence among TCP flags, e.g. :
- RST has precedence over SYN and FIN ; if RST set, ignore SYN and FIN
- SYN has precedence over FIN ; if SYN set, ignore FIN

Have I been wrong all this time ?
