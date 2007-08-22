From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: conntrack: Connection close event?
Date: Wed, 22 Aug 2007 21:10:13 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708222103450.16690@bizon.gios.gov.pl>
References: <004501c7e4e6$74509e80$1700a8c0@xcony13>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1735328661-1187809813=:16690"
Cc: netfilter-devel@lists.netfilter.org
To: Cedrix <netfilter@cedrix.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <004501c7e4e6$74509e80$1700a8c0@xcony13>
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

---187430788-1735328661-1187809813=:16690
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 22 Aug 2007, Cedrix wrote:

> Hi,
>
> this is my first request. I checked google, nf-faqs and conntrack-homepag=
e=20
> without sufficient results for this problem:
>
> In Short: I need to know when a connection (TCP or UDP) gets closed. I wa=
nt=20
> to use conntrack, because I can track UDP more easily.
>
> My thoughts so far: The /proc/net/ip_conntrack reacts very quick when a c=
lose=20
> happens, but it's not conveniant to check in my C/C++ application. So, in=
=20
> further reading I 've seen in the source some kind of "event-handling".=
=20
> (Listening Event for new connection, etc.)
>
> My question: What's the best method to see if a connection gets closed.=
=20
> (Also, connection opened).
>
> Btw: I use iptables -I FORWARD -m -state --NEW -m --LOG -log-prefix "New=
=20
> Connection established: " to log established connections, so it would be =
nice=20
> (but not necessary) if I can use the LOG for closing-connections, too - O=
R=20
> alternatively - use a conntrack-event for detecting NEW connections, too.
>
> Any help or comment is appreciated! Thanks.

Something like nfnetlink & "conntrack -E --event-mask NEW,DESTROY -o timest=
amp"?:

[1187809641.802599]     [DESTROY] udp      17 src=3D192.168.194.11 dst=3D19=
2.168.194.255 sport=3D138 dport=3D138 packets=3D1 bytes=3D233 src=3D192.168=
=2E194.255 dst=3D192.168.194.11 sport=3D138 dport=3D138 packets=3D0 bytes=
=3D0
[1187809641.963684]     [DESTROY] tcp      6 src=3D192.168.50.13 dst=3D192.=
168.50.21 sport=3D40153 dport=3D80 packets=3D5 bytes=3D679 src=3D192.168.50=
=2E21 dst=3D192.168.50.13 sport=3D80 dport=3D40153 packets=3D3 bytes=3D1332
[1187809642.134908]     [DESTROY] tcp      6 src=3D192.168.50.13 dst=3D192.=
168.50.21 sport=3D40154 dport=3D80 packets=3D5 bytes=3D519 src=3D192.168.50=
=2E21 dst=3D192.168.50.13 sport=3D80 dport=3D40154 packets=3D3 bytes=3D591
[1187809642.192142]     [DESTROY] tcp      6 src=3D192.168.50.13 dst=3D192.=
168.50.21 sport=3D40155 dport=3D80 packets=3D5 bytes=3D515 src=3D192.168.50=
=2E21 dst=3D192.168.50.13 sport=3D80 dport=3D40155 packets=3D3 bytes=3D583
[1187809642.254526]     [DESTROY] udp      17 src=3D192.168.148.3 dst=3D192=
=2E168.148.13 sport=3D36258 dport=3D137 packets=3D1 bytes=3D78 src=3D192.16=
8.148.13 dst=3D192.168.148.3 sport=3D137 dport=3D36258 packets=3D1 bytes=3D=
90

I'm not sure if it is possible just to grab udp events, if not you can=20
filter it in an application.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1735328661-1187809813=:16690--
