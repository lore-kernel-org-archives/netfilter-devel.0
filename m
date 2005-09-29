From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [ANNOUNCE] Release of libnfnetlink, libnfnetlink_conntrack and
 conntrack
Date: Thu, 29 Sep 2005 10:29:44 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0509291021170.31974@bizon.gios.gov.pl>
References: <20050924215413.GD731@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1762610696-1127982584=:31974"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050924215413.GD731@sunbeam.de.gnumonks.org>
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

---187430788-1762610696-1127982584=:31974
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 24 Sep 2005, Netfilter Core Team wrote:

> Hi!
Hi,

> The netfilter project proudly presents:
>
> =09libnfnetlink-0.0.10
> =09libnfnetlink_conntrack-0.0.10
> =09conntrack-0.81

It seems that conntrack is not able to display properly counters=20
for incoming packets:

# conntrack -L
tcp      6 431999 ESTABLISHED src=3D192.168.0.33 dst=3D192.168.11.74 sport=
=3D33328 dport=3D22 packets=3D2025 bytes=3D292027 src=3D192.168.11.74 dst=
=3D192.168.0.33 sport=3D22 dport=3D33328 packets=3D0 bytes=3D0 [ASSURED] ma=
rk=3D0 use=3D1 id=3D42

# cat /proc/net/ip_conntrack
tcp      6 431999 ESTABLISHED src=3D192.168.0.33 dst=3D192.168.11.74 sport=
=3D33328 dport=3D22 packets=3D3106 bytes=3D218222 src=3D192.168.11.74 dst=
=3D192.168.0.33 sport=3D22 dport=3D33328 packets=3D2015 bytes=3D290691 [ASS=
URED] mark=3D0 use=3D1

BTW: Is it possible to use "id" to delete a conntrack?

Best regards,


 =09=09=09Krzysztof Ol=EAdzki
---187430788-1762610696-1127982584=:31974--
