From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] entry_data
Date: Tue, 20 Jun 2006 03:39:08 +0200
Message-ID: <449751BC.6050808@trash.net>
References: <200606050029.08602.max@nucleus.it>
	<200606132256.10384.max@nucleus.it>
	<4495EC8E.6030006@netfilter.org>
	<200606190902.09597.max@nucleus.it> <44973529.50600@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44973529.50600@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Massimiliano Hofer wrote:
> 
>> You're right, but I modified the kernel side of a union and I was
>> careful not to change the total size. This union is never really used
>> by both sides simultaneously.
> 
> 
> Indeed, you're right, I can't see any problem with your patch at this
> moment. Although apart from the out of tree xt_condition match, there is
> no other clients for entry_data. I'd like to know what Patrick thinks
> about this.

Actually there are quite a few things that can benefit from this
(see also my other mail to netfilter-devel). Stateful matches like
limit, quota, statistic can store their state in externally allocated
memory and remove all the state and the pointers from the structure
shared with userspace. hashlimit, recent and other matches that lookup
global state can just keep a reference to it without affecting
userspace visible structures. Besides it is in my opinion a major
limitation of the iptables API that it doesn't cleanly support
per-instance state, so I'm quite supportive of this patch :)
