From: "Indan Zupancic" <indan@nul.nu>
Subject: Re: 2.6.23-rc1: ipv4_get_l4proto: Frag of proto 17
Date: Thu, 26 Jul 2007 12:09:58 +0200 (CEST)
Message-ID: <47728.81.207.0.53.1185444598.squirrel@secure.samage.net>
References: <35590.81.207.0.53.1185382934.squirrel@secure.samage.net>
	<Pine.LNX.4.62.0707251912150.31124@wlug.westbo.se>
	<36349.81.207.0.53.1185385305.squirrel@secure.samage.net>
	<200707260127.l6Q1RPP6019173@toshiba.co.jp>
	<60467.81.207.0.53.1185443160.squirrel@secure.samage.net>
	<46A86E67.2050501@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org, gandalf@wlug.westbo.se,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46A86E67.2050501@trash.net>
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

On Thu, July 26, 2007 11:50, Patrick McHardy wrote:
> Indan Zupancic wrote:
>> On Thu, July 26, 2007 03:27, Yasuyuki KOZAKAI wrote:
>>
>>>I have one more question. Does that node receive ICMP error including
>>>fragmented packet in its body ? I made ICMP error handling call
>>>ipv4_get_l4proto in 2.6.23 tree.
>
>
> Good point, I initially missed that this affects the current -rc.
>
>> I don't know, how can I check that?
>
>
> iptables -t raw -I PREROUTING \
> 	-m icmp --icmp-type destination-unreachable -j LOG
>
> should log the packets.

So with this when I get a Frag of proto it should also log an ICMP error?

Considering that the errors happened with a near exact 1 second interval
and a 0.5s interval I think it's highly likely that it were retry packets to
an unreachable host. But why is the proto UDP and not ICMP?

Greetings,

Indan
