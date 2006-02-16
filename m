From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] first conntrack ID must be 1 not 2
Date: Thu, 16 Feb 2006 21:09:03 +0100
Message-ID: <43F4DBDF.9010008@trash.net>
References: <43EFF1F0.1090701@netfilter.org>
	<20060213112028.GU4601@sunbeam.de.gnumonks.org>
	<43F438F5.8070607@trash.net>
	<Pine.LNX.4.58.0602160943060.26770@blackhole.kfki.hu>
	<43F43FA9.4000906@trash.net>
	<Pine.LNX.4.58.0602161005450.26770@blackhole.kfki.hu>
	<43F4426D.9060807@trash.net>
	<Pine.LNX.4.58.0602161017590.26770@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0602161017590.26770@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> On Thu, 16 Feb 2006, Patrick McHardy wrote:
> 
>>>(jiffies, tuples) would be unique even in that case.
>>
>>Thats true. But what is the advantage over using the counter?

Actually it would still not be unique if connections live
shorter than a jiffy and are resurrected.

> Currently nothing :-).
> 
> However, the counter poses an internal bottleneck in the overall system
> when one attempts to replace the hashtable by hashtrie. (What I really
> like about hashtrie is that it naturally implements the 'region locking'
> suggested by Patrick Schaaf, compared to the 'brute force' per bucket
> locking.)
> 
> As I see, we have got three bottlenecks in conntrack in SMP systems:
> the hashtable approach, the id and the expectation list. The first two
> could be eliminated by hashtrie and jiffies as ids.
> 
> Some clever solution should only be found to spread the expectations
> over multiple, separatedly locked buckets...

I've talked to Harald about this and as a start we can start by
allowing masks only for the source part of the tuple. That
means we can hash by destinations.
