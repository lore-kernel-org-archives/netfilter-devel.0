From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 1/4] RFC: fast string matching infrastrure for netfilter
Date: Mon, 10 Jan 2005 00:19:00 +0100
Message-ID: <41E1BBE4.9010104@eurodev.net>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41E1B9F1.7010106@trash.net>
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

Hi Patrick,

Patrick McHardy wrote:

>> I've finished a first usable version of a infrastructure to look for 
>> matchings in a packet. Features:
>>
>> * A library consisting in three public functions: constructor, 
>> destructor and searching.
>> * Boyer-moore algorithm to perform fast matchings.
>> * Brute force search on the edges of two fragments to look for 
>> fragmented matches, that is O(m) searchs where m is the size of the 
>> pattern, it's not that bad for small pattern I think. It's fragment 
>> aware by means of rusty's skb_iter functions.
>
>
> Looks good. A problem is that it's only in-tree user is part of 
> ip_conntrack.
> I have actually given up keeping nf_conntrack up to date currently, but
> I hope we can now really put ip_conntrack in maintenance mode and 
> concentrate
> on nf_conntrack. Any chance you want to base this on the nf_conntrack 
> patch ?


Sure, I don't mind about porting this to nf_conntrack. Expect a patch in 
next days.

>> Comments welcome.
>
>
> See below.


I'll fix those leaks, thanks for those good catches. The module_init and 
exit stuff is because I've compiling this as module and AFAIK I need them.

--
Pablo
