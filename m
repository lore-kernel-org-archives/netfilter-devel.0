From: Patrick McHardy <kaber@trash.net>
Subject: Re: Deadlocks
Date: Thu, 17 Jun 2004 18:20:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40D1C4BF.8070605@trash.net>
References: <20040609180909.GA11445@linuxace.com> <1087156709.11287.8.camel@ws> <20040615044723.GA16891@linuxace.com> <40CE95DE.9090703@trash.net> <20040617155946.GA28564@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040617155946.GA28564@linuxace.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:
> Yes, my statement was not clear at all.  What I meant was something like:
> 
> cpu 1:
>   conntrack helper calls ip_conntrack_expect_related
> 
> cpu 2:
>   nat helper calls ip_conntrack_change_expect
> 
> CPU 2 ends up causing a duplicate expectation, because the nat helper
> changed the expectation to match the one created by cpu 1.

This can't happen because ip_conntrack_change_expect in is called under
read_locked ip_conntrack_lock and checks for duplicates and
ip_conntrack_expect_related write_locks ip_conntrack_lock and checks
for duplicates. ip_conntrack_change_expect additionally write_locks
ip_conntrack_expect_tuple_lock so it won't race with itself on another
CPU.

> 
> I do see duplicate expectations occasionally:
> 
> # grep EXP /proc/net/ip_conntrack 
> EXPECTING: - use=1 proto=6 src=10.20.116.197 dst=10.20.153.248 sport=0 dport=4309 
> EXPECTING: - use=1 proto=6 src=10.20.116.197 dst=10.20.153.248 sport=0 dport=4309 
> 
> which may or may not be related to the above.

Probably not, unless I missed something. I'm going to see if I can find
something else.

> 
> In any event, I have applied your patch to 2.6.7, and am running it.  Typically
> the box would not last more than a couple days, so I'll let you know what 
> happens.

Great, I'm really interested ..

Regards
Patrick

> 
> Phil
> 
