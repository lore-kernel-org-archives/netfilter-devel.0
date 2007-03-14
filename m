From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: NF structural changes (was: dangerous?)
Date: Wed, 14 Mar 2007 22:41:04 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0703142207200.2643@bizon.gios.gov.pl>
References: <Pine.LNX.4.61.0703142148430.1199@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1576790977-1173908464=:2643"
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Hendrik Nordstrom <henrik@henriknordstrom.net>,
	Amin Azez <azez@ufomechanic.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0703142148430.1199@yvahk01.tjqt.qr>
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

---187430788-1576790977-1173908464=:2643
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 14 Mar 2007, Jan Engelhardt wrote:

> Hello Ccs,
>
>
> As a result of the "dangerous? Setting mark in nat table" thread, I have
> just drawn this idea of mine down, where:
>
> - filter and mangle tables are merged

Please don't. As you probably know "-j MARK" is not a terminating target,=
=20
so after a "-j MARK" you often need additional "-j ACCEPT". The same is=20
about TTL, SET, etc. But this ACCEPT does not mean that this packed is=20
going to be accepted, only that a mangling process is finished.

> - filtering comes early, even before nat
>   (so that, for example, packets do not needlessy be MARKed, mangled, etc=
=2E)

Hm, it is very useful to be able to filter packed based on a real=20
destignation, that is only known _after_ dnat.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1576790977-1173908464=:2643--
