From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit 20070628 kernel
Date: Mon, 2 Jul 2007 17:38:29 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707021447200.15758@fbirervta.pbzchgretzou.qr>
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
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4688EF45.7020200@trash.net>
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


On Jul 2 2007 14:27, Patrick McHardy wrote:
>
>That didn't answer my question. Should IPv6 mapped IPv4 addresses be
>counted as the same address as the mapped IPv4 address or not?

No. (It is not needed.)

>>>And hotdropping is quite unfriendly, it seems that as long as
>>>you're able to read the addresses (which you're always), you can still
>>>count the other connections.
>> 
>> This is nf_ct_get that can fail. Without a connection, we can't figure
>> anything.
>
>You still have the addresses and port numbers to do a lookup.
>In fact the most reasonable place to use this match is in the raw 
>table, before any resources are consumed. So it would make a lot of 
>sense to simply use the values from the headers (or call the conntrack 
>functions for tuple decoding if that makes it easier).
>
To look up what? I am sorry I don't quite get what you are trying to 
tell me.
I do recognize that -t raw -A CHAIN -p tcp --syn -m connlimit
--connlimit-above X -j ACTION is something to keep resources minimal.


	Jan
