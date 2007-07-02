From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit 20070628 kernel
Date: Mon, 2 Jul 2007 21:53:12 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707022103400.28721@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>
	<467FA9CE.8000805@trash.net>
	<Pine.LNX.4.64.0706282121220.22579@fbirervta.pbzchgretzou.qr>
	<46840B9F.7080803@trash.net>
	<Pine.LNX.4.64.0706282130150.22579@fbirervta.pbzchgretzou.qr>
	<468410A9.70309@trash.net>
	<Pine.LNX.4.64.0706282150401.22579@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0706282155000.22579@fbirervta.pbzchgretzou.qr>
	<4684ECB5.9070402@trash.net>
	<Pine.LNX.4.64.0707011552500.15758@fbirervta.pbzchgretzou.qr>
	<4688EF45.7020200@trash.net>
	<Pine.LNX.4.64.0707021447200.15758@fbirervta.pbzchgretzou.qr>
	<46891C50.1020904@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46891C50.1020904@trash.net>
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


On Jul 2 2007 17:40, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Jul 2 2007 14:27, Patrick McHardy wrote:
>> > That didn't answer my question. Should IPv6 mapped IPv4 addresses be
>> > counted as the same address as the mapped IPv4 address or not?
>>
>> No. (It is not needed.)
>
> And why isn't it needed? The IPv4 address space is contained in IPv6,
> so it seems only logical to count real IPv4 addresses and mapped IPv6
> addresses as the same thing.


Each struct xt_connlimit_data is allowed to have a different hash 
function, as long as each function is injective.

A struct xt_connlimit_{info,data} is never fed both AF_INET and
AF_INET6 connections.
Hence it may use different hash functions for AF_INET and AF_INET6 
connections.

Does that help?

>> > You still have the addresses and port numbers to do a lookup.
>> > In fact the most reasonable place to use this match is in the raw table,
>> > before any resources are consumed. So it would make a lot of sense to
>> > simply use the values from the headers (or call the conntrack functions for
>> > tuple decoding if that makes it easier).
>> >
>> To look up what? I don't quite get what you are trying to tell me.
>
> To look up similar connections.

What do you mean by "similar"?

> Connections are identifier by their tuples, you can derive them 
> yourself and do a lookup based on that.

connlimit uses nf_ct_get(skb,...)->tuplehash[0].tuple to get at the 
tuple. nf_ct_get() can fail.
How else should I derive it?


Sorry if this sounds all stupid and basic, but I certainly do not want 
to parse the skb by hand to get at the source address.


	Jan
-- 
