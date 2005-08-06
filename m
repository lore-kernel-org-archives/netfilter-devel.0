From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Drop expectation refcount after unlinking expectation
Date: Sat, 06 Aug 2005 16:24:32 +0200
Message-ID: <42F4C820.7020209@trash.net>
References: <42F2B507.8070207@eurodev.net> <42F342B8.7010001@trash.net>
	<20050805130803.GI4245@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050805130803.GI4245@rama.de.gnumonks.org>
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

Harald Welte wrote:
> On Fri, Aug 05, 2005 at 12:43:04PM +0200, Patrick McHardy wrote:
> 
>>Pablo Neira wrote:
>>
>>>OK, my question is: why do we need to increase the master conntrack
>>>refcount for expectations, if they are always killed first? Actually I
>>>think that the master conntrack refcount should be increased once the
>>>expectation is confirmed but not in ip_conntrack_expect_alloc.
>>
>>Only outstanding expectations are removed by remove_expectations().
>>The fullfilled ones need the reference for stuff like
>>ip_nat_follow_master.
> 
> So Pablo's argument stil upholds... in theory it would be sufficient to
> increase the master refcount when expectation is fulfilled(confirmed)
> instead of allocation time.  Or am I missing something?

No, it is possible, but we do take a reference in expect_alloc, and I
don't see the point of obscuring the reference counting by increasing
the count at a later point in time.
