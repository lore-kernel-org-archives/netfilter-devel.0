From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: Problem accessing https://my.procurve.com/profile/index.aspx
 (ACK is over the upper bound)
Date: Mon, 2 Jul 2007 21:06:08 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707022058240.25153@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0707010207490.13212@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707010255010.13212@bizon.gios.gov.pl>
	<4688FC41.5070403@trash.net>
	<Pine.LNX.4.64.0707021537390.32643@blackhole.kfki.hu>
	<46890846.90907@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-374839545-1183403168=:25153"
Cc: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46890846.90907@trash.net>
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

---187430788-374839545-1183403168=:25153
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 2 Jul 2007, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
>> On Mon, 2 Jul 2007, Patrick McHardy wrote:
>>
>>> Krzysztof Oledzki wrote:
>>>
>>>>
>>>> OK, this was easy. The RST was sent simply because the packed was not
>>>> dropped but instead delivered to the local IP - there was no valid tup=
le
>>>> to change (unnat) the packed destination. Setting:
>>>>
>>>> iptables -I PREROUTING -m conntrack --ctstate INVALID -j DROP
>>>
>>>
>>> We should really document that with window tracking and NAT you
>>> must drop INVALID packets to avoid them getting delivered locally
>>> and causing a RST.
>>
>>
>> Couldn't we do it in NAT itself? I.e drop the packet by NAT if
>> ip_conntrack_tcp_be_liberal is unset and the packet is INVALID.
>
>
> I'm a bit sceptical about NAT core caring about TCP conntrack
> specific sysctls, I'd prefer an unconditional drop.
>
>> It'd be backward-incompatible as it'd change the current behaviour but
>> were more safer (saner) than the present approach.
>
>
> Yes, for this case it definitely makes sense. I'm just wondering
> whether we'll break anything. Tools like nmap come to mind ..

I think it may be better to drop it with iptables. Before drop it is=20
possible to log (-j LOG/ULOG/...) such packets - this is what I'm doing=20
for example. It is often worth to know about dropped packets with INVALID=
=20
state.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-374839545-1183403168=:25153--
