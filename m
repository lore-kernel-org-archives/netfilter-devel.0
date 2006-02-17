From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] first conntrack ID must be 1 not 2
Date: Fri, 17 Feb 2006 09:50:54 +0100
Message-ID: <43F58E6E.2010608@trash.net>
References: <43EFF1F0.1090701@netfilter.org>
	<20060213112028.GU4601@sunbeam.de.gnumonks.org>
	<43F438F5.8070607@trash.net>
	<Pine.LNX.4.58.0602160943060.26770@blackhole.kfki.hu>
	<43F43FA9.4000906@trash.net>
	<Pine.LNX.4.58.0602161005450.26770@blackhole.kfki.hu>
	<43F4426D.9060807@trash.net>
	<Pine.LNX.4.58.0602161017590.26770@blackhole.kfki.hu>
	<43F4DBDF.9010008@trash.net>
	<Pine.LNX.4.58.0602170907001.29301@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0602170907001.29301@blackhole.kfki.hu>
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
>>Actually it would still not be unique if connections live
>>shorter than a jiffy and are resurrected.
> 
> 
> I can imagine such a situation only when the conntrack table is full and
> we are forced to drop unassured connections - when we are in trouble
> anyway.

I guess it depends on how fast the everything is. Someone at the
workshop made the point that given how fast speed increases, it
will probably be a realistic problem at some point. But I was
never convinced of the current half-assed approach to a unique ID
anyway, its either unique or its not. So in my opinion, we could
eliminate it if we find a better solution for the dumping problem.

>>>Some clever solution should only be found to spread the expectations
>>>over multiple, separatedly locked buckets...
>>
>>I've talked to Harald about this and as a start we can start by
>>allowing masks only for the source part of the tuple. That
>>means we can hash by destinations.
> 
> 
> That's actually fine! Now I should complete that hashtrie/hashtable
> testing I have been planning...

I wanted to work on the expectation lookup thing soon, I'll let you
know once I have something working.
