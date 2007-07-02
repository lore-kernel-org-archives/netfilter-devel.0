From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070628 kernel
Date: Mon, 02 Jul 2007 17:40:00 +0200
Message-ID: <46891C50.1020904@trash.net>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>	<467BAF07.6020502@trash.net>	<Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>	<467FA9CE.8000805@trash.net>	<Pine.LNX.4.64.0706282121220.22579@fbirervta.pbzchgretzou.qr>	<46840B9F.7080803@trash.net>	<Pine.LNX.4.64.0706282130150.22579@fbirervta.pbzchgretzou.qr>	<468410A9.70309@trash.net>	<Pine.LNX.4.64.0706282150401.22579@fbirervta.pbzchgretzou.qr>	<Pine.LNX.4.64.0706282155000.22579@fbirervta.pbzchgretzou.qr>	<4684ECB5.9070402@trash.net>	<Pine.LNX.4.64.0707011552500.15758@fbirervta.pbzchgretzou.qr>	<4688EF45.7020200@trash.net>
	<Pine.LNX.4.64.0707021447200.15758@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707021447200.15758@fbirervta.pbzchgretzou.qr>
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
> On Jul 2 2007 14:27, Patrick McHardy wrote:
>> That didn't answer my question. Should IPv6 mapped IPv4 addresses be
>> counted as the same address as the mapped IPv4 address or not?
>
> No. (It is not needed.)


And why isn't it needed? The IPv4 address space is contained in IPv6,
so it seems only logical to count real IPv4 addresses and mapped IPv6
addresses as the same thing.

>   
>>>> And hotdropping is quite unfriendly, it seems that as long as
>>>> you're able to read the addresses (which you're always), you can still
>>>> count the other connections.
>>>>         
>>> This is nf_ct_get that can fail. Without a connection, we can't figure
>>> anything.
>>>       
>> You still have the addresses and port numbers to do a lookup.
>> In fact the most reasonable place to use this match is in the raw 
>> table, before any resources are consumed. So it would make a lot of 
>> sense to simply use the values from the headers (or call the conntrack 
>> functions for tuple decoding if that makes it easier).
>>
>>     
> To look up what? I am sorry I don't quite get what you are trying to 
> tell me.
>   

To look up similar connections. Connections are identifier by their
tuples, you can derive them yourself and do a lookup based on that.
