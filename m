From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: Problem accessing https://my.procurve.com/profile/index.aspx
 (ACK is over the upper bound)
Date: Sun, 1 Jul 2007 03:04:26 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707010255010.13212@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0707010207490.13212@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-308880064-1183251866=:13212"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707010207490.13212@bizon.gios.gov.pl>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-308880064-1183251866=:13212
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 1 Jul 2007, Krzysztof Oledzki wrote:

> Hello,
>
> My colleague have just reported that he is unable to access "REGISTER HER=
E"=20
> page from the https://my.procurve.com/profile/index.aspx. Short debuging=
=20
> shows that his connection was dropped by the netfilter code running on fw=
/nat=20
> host:
<CUT>
> AFAIK netfilter is supposed to drop such packet (without sending a RST),=
=20
> isn't it? So why the RST packet was sent?

OK, this was easy. The RST was sent simply because the packed was not=20
dropped but instead delivered to the local IP - there was no=20
valid tuple to change (unnat) the packed destination. Setting:

iptables -I PREROUTING -m conntrack --ctstate INVALID -j DROP

make no more RSTs, only retransmisions from the 216.34.143.7. And yes, I=20
have a patched kernel so I'm able to filter packets in a PREROUTING=20
chain.

The rest of the question remains:

> Setting net.ipv4.netfilter.ip_conntrack_tcp_be_liberal solves the problem=
,=20
> but this is not a right fix and now the main question is: was this ACK re=
ally=20
> over the upper bound since when=20
> net.ipv4.netfilter.ip_conntrack_tcp_be_liberal is enabled it is possible =
to=20
> access this page (of course with many netfilter warnings that "ACK is ove=
r=20
> the upper bound").
>
> root@fw1:~# uname -r
> 2.6.20.11


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-308880064-1183251866=:13212--
