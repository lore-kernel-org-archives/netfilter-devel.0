From: "Indan Zupancic" <indan@nul.nu>
Subject: Re: 2.6.23-rc1: ipv4_get_l4proto: Frag of proto 17
Date: Thu, 26 Jul 2007 13:17:18 +0200 (CEST)
Message-ID: <49914.81.207.0.53.1185448638.squirrel@secure.samage.net>
References: <35590.81.207.0.53.1185382934.squirrel@secure.samage.net>
	<Pine.LNX.4.62.0707251912150.31124@wlug.westbo.se>
	<36349.81.207.0.53.1185385305.squirrel@secure.samage.net>
	<200707260127.l6Q1RPP6019173@toshiba.co.jp>
	<60467.81.207.0.53.1185443160.squirrel@secure.samage.net>
	<46A86E67.2050501@trash.net>
	<47728.81.207.0.53.1185444598.squirrel@secure.samage.net>
	<46A875C8.8030902@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org, gandalf@wlug.westbo.se,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46A875C8.8030902@trash.net>
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

On Thu, July 26, 2007 12:22, Patrick McHardy wrote:
> Indan Zupancic wrote:
>> On Thu, July 26, 2007 11:50, Patrick McHardy wrote:
>>
>>>iptables -t raw -I PREROUTING \
>>>	-m icmp --icmp-type destination-unreachable -j LOG
>>>
>>>should log the packets.
>>
>>
>> So with this when I get a Frag of proto it should also log an ICMP error?
>
>
> Exactly.
>
>> Considering that the errors happened with a near exact 1 second interval
>> and a 0.5s interval I think it's highly likely that it were retry packets to
>> an unreachable host. But why is the proto UDP and not ICMP?
>
>
> Its the inner packet that is parsed by nf_ct_get_tuplepr.
>

Reading the comment in icmp.c iph->frag_off & htons(IP_OFFSET)
being true means that it's a fragment, but not the first one.

So what's happening is that the host sends a big UDP packet, it gets
fragmentated, but never reaches its destination. ICMP error packets
are generated. Conntrack drops the latter ones thanks to the check in
ipv4_get_l4proto.

So the question is whether those latter ICMP packets should be forwarded
or not. If not, the code is fine and the warning message could be removed.
If they should, then it might be hard for the current conntrack code know
where to send the packet, as the UDP header is missing.

Greetings,

Indan
