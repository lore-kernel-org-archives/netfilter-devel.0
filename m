From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [PATCH 2/3][CONNTRACK] Introduce the pickup facilities to take
 over TCP connections
Date: Tue, 22 Aug 2006 00:15:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0608212359410.3014@bizon.gios.gov.pl>
References: <44E972E1.4080500@netfilter.org>
	<Pine.LNX.4.64.0608211214120.25230@bizon.gios.gov.pl>
	<44EA11C1.2090705@netfilter.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1466935629-1156198522=:3014"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44EA11C1.2090705@netfilter.org>
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

---187430788-1466935629-1156198522=:3014
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 21 Aug 2006, Pablo Neira Ayuso wrote:

> Krzysztof Oledzki wrote:
>>=20
>> On Mon, 21 Aug 2006, Pablo Neira Ayuso wrote:
>>=20
>>> This patch introduces a new flag called IPS_PICKUP that forces the=20
>>> protocol handler to pick up the window of valid TCP packets. Moreover,=
=20
>>> four new attributes to inject the window scale factor and enable SACK a=
re=20
>>> introduced.
>>>=20
>>> These new facilities provide the appropiate mechanisms to take over TCP=
=20
>>> connections in failover settings with TCP tracking enabled.
>>>=20
>> Are there any plans for active-active synchronization? This requires onl=
ine=20
>> TCP SEQ sync or to keep connections in IPS_PICKUP state forever, doesn't=
=20
>> it?
>
> Hm, you mean the active-active setting for conntrackd? The current=20
> architecture already supports it.

OK.

> You seem to be confused with the IPS_PICKUP flag: this flag must be set f=
or=20
> conntracks created from userspace via ctnetlink, thus the TCP window trac=
king=20
> knows that it has to take over the valid window of TCP sequences, once th=
at=20
> happens this flag is unset.

Hm, lets assume we have two firewalls for active-active configuration. How=
=20
does the second firewall know that it should accept/drop a packet with=20
specific seq number from connection that was previously handled by the=20
first one?

Plase excuse me if this is obvious, but I wasn't able to find any
information about how it was solved. All I found is the TODO file
with:

o support for TCP window tracking
         - at the moment you have to disable it:
         echo 1 > /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_be_liberal


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1466935629-1156198522=:3014--
