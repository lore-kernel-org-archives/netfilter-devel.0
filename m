From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Drop expectation refcount after unlinking expectation
Date: Sat, 06 Aug 2005 16:29:31 +0200
Message-ID: <42F4C94B.4060405@trash.net>
References: <42F2B507.8070207@eurodev.net> <42F33D8C.5070904@trash.net>
	<20050805131721.GJ4245@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050805131721.GJ4245@rama.de.gnumonks.org>
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
> On Fri, Aug 05, 2005 at 12:21:00PM +0200, Patrick McHardy wrote:
> 
>>Pablo Neira wrote:
>>
>>>This patch comes from the following thread:
>>>
>>>[PATCH 6/7] Fix expectation creation
>>>
>>>In unlink_expect, the expectation is removed from the list so the
>>>refcount must be dropped as well.
>>
>>The patch is fine, but it leaves the somewhat broken function
>>__ip_ct_expect_unlink_destroy around. I'm not sure what the
>>intention of this function is, it looks like a lazy way of
>>killing conntracks without manually dropping the timer refcnt.
>>Anyway it invites people to use it in the wrong place and
>>should die IMO.
> 
> Ok, if it dies we'd have to export unlink_expect() for ctnetlink.
> 
> However, all places calling unlink_expect() also call expect_put()
> immediately after it - with one exception: find_expectation() :(
> 
> Getting back to your comment:  
> 
>>it looks like a lazy way of killing conntracks without manually
>>dropping the timer refcnt.
> 
> Sorry, I can't follow you: Did you mean something like 'lazy way of
> killing expects without manually expiring the timer' ?  
> 
> So your whole objection is to not have timer_del() inside
> __ip_ct_expect_unlink_destroy() ?   this can be changed easily.

My objection was the other way around, unlink_expect drops the
reference taken for the lists, as it should. 
__ip_ct_expect_unlink_destroy() additionally drops a reference
which I assume is the timer reference, but it doesn't delete
the timer. If the caller deletes the timer, he should be the
one to drop the reference. Your suggestion is of course perfectly
fine with me, if the timer is deleted within that function it
can also drop the reference.
