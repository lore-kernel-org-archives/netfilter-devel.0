From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: x_tables userspace
Date: Mon, 16 Jan 2006 14:25:37 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0601161422590.387@bizon.gios.gov.pl>
References: <333e1ca10601160212g4a9f21e8p78c26fd113197a60@mail.gmail.com>
	<43CB93C4.4060500@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-2116710440-1137417937=:387"
Cc: Michal Rokos <michal.rokos@gmail.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <43CB93C4.4060500@eurodev.net>
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

---187430788-2116710440-1137417937=:387
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 16 Jan 2006, Pablo Neira Ayuso wrote:

> Michal Rokos wrote:
>> now when x_tables are merged one question has to come:
>>
>> Is there any userspace prog that can manage x_tables? Something like ip4=
6tables?
>
> No, this does not suppose any change from userspace side. It's just part
> of the ipv4-ipv6 code reunification.
>
>> (All I really want is to finally use ipv6 stateful netfilter. And when
>> iptables and ip6tables are already merged somewhere it would be
>> great!)
>
> Stateful ipv6 went into 2.6.15, so you can give it a try in this -rc1.
> Just check the following boxes:
>
> Network packet filtering (replaces ipchains) ---> Core Netfilter
> Configuration  --->  Layer 3 Independent Connection tracking (EXPERIMENTA=
L)
>
> And then add support for IPv4 and IPv6:
>
> Network packet filtering (replaces ipchains) ---> IP: Netfilter
> Configuration --->  IPv4 support for new connection tracking (EXPERIMENTA=
L)
>
> Network packet filtering (replaces ipchains) ---> IPv6: Netfilter
> Configuration (EXPERIMENTAL)  --->  IPv6 support for new connection
> tracking (EXPERIMENTAL)
>
> Previously, don't forget to uncheck the old connection tracking support.
> Otherwise the IPv6 support won't be available.

But for stateful ipv6 you also need userland (iptables) support which is=20
still AFAIK not available. And if you enable Layer 3 ICT you will loose=20
SNAT/DNAT support for IPv4.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-2116710440-1137417937=:387--
