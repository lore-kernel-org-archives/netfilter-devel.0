From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] first conntrack ID must be 1 not 2
Date: Fri, 31 Mar 2006 03:11:02 +0200
Message-ID: <442C81A6.3040501@trash.net>
References: <43EFF1F0.1090701@netfilter.org>	<20060213112028.GU4601@sunbeam.de.gnumonks.org>	<43F438F5.8070607@trash.net>	<Pine.LNX.4.58.0602160943060.26770@blackhole.kfki.hu>	<43F43FA9.4000906@trash.net>	<Pine.LNX.4.58.0602161005450.26770@blackhole.kfki.hu>	<43F4426D.9060807@trash.net>	<Pine.LNX.4.58.0602161017590.26770@blackhole.kfki.hu>
	<43F4DBDF.9010008@trash.net> <442B9765.2020105@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <442B9765.2020105@ufomechanic.net>
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

Amin Azez wrote:
> Patrick McHardy wrote:
> 
>> Jozsef Kadlecsik wrote:
>>
>>> On Thu, 16 Feb 2006, Patrick McHardy wrote:
>>>
>>>
>>>>> (jiffies, tuples) would be unique even in that case.
>>>>
>>>>
>>>> Thats true. But what is the advantage over using the counter?
>>
>>
>>
>> Actually it would still not be unique if connections live
>> shorter than a jiffy and are resurrected.
> 
> 
> In which case would there be any harm in it not being unqiue, if it were
> the same connection resurrected, why try to avoid having the same id?

Besides solving an implementation problem, so ID was meant as a
long-term unique identifier. For the life-time of a connection
the tuples are already a unique identifier.

It's amazing, I've never had so many discussions about a single
32 bit field :)
