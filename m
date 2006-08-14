From: Patrick McHardy <kaber@trash.net>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 17:14:06 +0200
Message-ID: <44E0933E.5060905@trash.net>
References: <44E07BCD.8030206@trash.net> <200608141557.35918.max@nucleus.it>
	<44E08AC7.2050204@trash.net> <200608141702.50753.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200608141702.50753.max@nucleus.it>
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

Massimiliano Hofer wrote:
> On Monday 14 August 2006 4:37 pm, you wrote:
> 
>>Hmm .. recent does a table lookup during runtime and the table could be
>>cached. That would improve things a bit, but in my opinion not enough
>>to justify this patch. Same for hashlimit. What data would condition
>>store exactly?
> 
> 
> I need a pointer to per condition data, so that multiple rules with the same 
> name refer to the same flag.
> I can break userspace compatibility and store a pointer in the userspace 
> structure. I just thought this could be useful to everyone (and let me 
> maintain userspace compatibility along the way).


That looks like the only valid type of usage. Which means your initial
implementation, which just provided space for a pointer to the
individual instances, might have been the better way. I need to think
about this some more and look at the modules that could make use of
this again.

>>Its actually quite clear what is needed. We want a userspace interface
>>built on netlink, that acts on individual rules, not entire rulesets.
>>There are a few more ideas, like handling negation centrally, allowing
>>userspace to specify whether a target is terminal or not, allow multiple
>>non-terminal targets in a row, etc, but nothing really fundamental.
> 
> 
> I thought the current way of doing things was specifically designed to 
> minimize softirq locking (especially with arbitarily long chains and 
> arbitrary initialization code). We could switch to RCU lists, though...


Yes, it should be possible to do lockless ruleset evaluation (at least
on the ruleset level, some modules will still need locking).
