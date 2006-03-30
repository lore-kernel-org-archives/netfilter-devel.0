From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH 4/4] first conntrack ID must be 1 not 2
Date: Thu, 30 Mar 2006 09:31:33 +0100
Message-ID: <442B9765.2020105@ufomechanic.net>
References: <43EFF1F0.1090701@netfilter.org>	<20060213112028.GU4601@sunbeam.de.gnumonks.org>	<43F438F5.8070607@trash.net>	<Pine.LNX.4.58.0602160943060.26770@blackhole.kfki.hu>	<43F43FA9.4000906@trash.net>	<Pine.LNX.4.58.0602161005450.26770@blackhole.kfki.hu>	<43F4426D.9060807@trash.net>	<Pine.LNX.4.58.0602161017590.26770@blackhole.kfki.hu>
	<43F4DBDF.9010008@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43F4DBDF.9010008@trash.net>
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

Patrick McHardy wrote:
> Jozsef Kadlecsik wrote:
> 
>>On Thu, 16 Feb 2006, Patrick McHardy wrote:
>>
>>
>>>>(jiffies, tuples) would be unique even in that case.
>>>
>>>Thats true. But what is the advantage over using the counter?
> 
> 
> Actually it would still not be unique if connections live
> shorter than a jiffy and are resurrected.

In which case would there be any harm in it not being unqiue, if it were 
the same connection resurrected, why try to avoid having the same id?

Sam
