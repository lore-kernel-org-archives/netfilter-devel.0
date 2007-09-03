From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] libnl: add netfilter support
Date: Mon, 03 Sep 2007 12:53:33 +0200
Message-ID: <46DBE7AD.3020208@trash.net>
References: <46DB9716.1020400@snapgear.com> <46DB9776.8020209@snapgear.com>
	<46DBD8CD.9060804@trash.net>
	<20070903100148.GG18480@postel.suug.ch>
	<46DBDCBB.8080903@trash.net>
	<20070903101504.GI18480@postel.suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Philip Craig <philipc@snapgear.com>
To: Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070903101504.GI18480@postel.suug.ch>
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

Thomas Graf wrote:
> * Patrick McHardy <kaber@trash.net> 2007-09-03 12:06
> 
>>Thomas Graf wrote:
>>
>>>I think I can live with checking for the bit on the receiving side,
>>>the only problem it could cause is when the attribute type is used
>>>to encode information such as a port number. So if we are willing
>>>to take that risk the receiving path could be merged as well.
>>
>>
>>That kind of information should be stored as attribute value, no?
> 
> 
> Yes it should but we've already got code like this:
> for (i = 0; i < cnt; i++)
>         nla_put(skb, i, ....);


That looks pretty much like a list of attributes, but
using different attribute types. Just out of interest:
do you have a pointer to code doing this?


> It's only a matter of time until someone comes up with
> something like this:
> nla_put(skb, dstport, sizeof(port_info), &port_info);
> 
> Maybe we could put a WARN_ON(bit_set) in nla_put() on kernel side
> to make sure such behaviour is not being introduced by accident.


That sounds like a good idea. Anyone doing this is looking
for trouble since array-based attribute parsing would require
at least 2^31 elements :)
