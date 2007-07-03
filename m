From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070628 kernel
Date: Tue, 03 Jul 2007 13:14:25 +0200
Message-ID: <468A2F91.3040002@trash.net>
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
	<Pine.LNX.4.64.0707022103400.28721@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707022103400.28721@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> Each struct xt_connlimit_data is allowed to have a different hash 
> function, as long as each function is injective.
> 
> A struct xt_connlimit_{info,data} is never fed both AF_INET and
> AF_INET6 connections.
> Hence it may use different hash functions for AF_INET and AF_INET6 
> connections.
> 
> Does that help?


Not really, you described the situation that led me to this question.
I can see that you're not using the same hash for both and I question
that. Anyway, lets drop this question, I don't care that much.

>>>>You still have the addresses and port numbers to do a lookup.
>>>>In fact the most reasonable place to use this match is in the raw table,
>>>>before any resources are consumed. So it would make a lot of sense to
>>>>simply use the values from the headers (or call the conntrack functions for
>>>>tuple decoding if that makes it easier).
>>>>
>>>
>>>To look up what? I don't quite get what you are trying to tell me.
>>
>>To look up similar connections.
> 
> 
> What do you mean by "similar"?


Same source tuple.

>>Connections are identifier by their tuples, you can derive them 
>>yourself and do a lookup based on that.
> 
> 
> connlimit uses nf_ct_get(skb,...)->tuplehash[0].tuple to get at the 
> tuple. nf_ct_get() can fail.
> How else should I derive it?
> 
> 
> Sorry if this sounds all stupid and basic, but I certainly do not want 
> to parse the skb by hand to get at the source address.


Use the conntrack tuple if one is available, otherwise use
nf_ct_get_tuple().
