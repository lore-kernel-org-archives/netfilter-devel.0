From: Robert Hardy <rhardy@webcon.ca>
Subject: Re: Optimizing rule loading, iptables-1.3.0 and iptables-batch
Date: Sun, 26 Sep 2004 15:24:31 -0400 (EDT)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409261514330.3762@vortex.int.webcon.net>
References: <Pine.LNX.4.61.0409070017220.23341@vortex.int.webcon.net>
	<Pine.LNX.4.61.0409071309410.23282@filer.marasystems.com>
	<Pine.LNX.4.61.0409072117010.11902@vortex.int.webcon.net>
	<20040908164942.GA19802@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ludwig Nussel <ludwig.nussel@suse.de>
In-Reply-To: <20040908164942.GA19802@suse.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 8 Sep 2004, Ludwig Nussel wrote:
> Robert Hardy wrote:
>> As a side note for the same ~30000 rules:
>> Time to load rules via iptables-batch using CIDR syntax: 23 mins 13 secs
>> Time to load rules via iptables-batch using IPRANGE syntax: 26 mins 36 secs
>> Time to load rules via iptables-restore (originally using CIDR syntax): 4
>> mins 25 secs
>>
>> The time to process the rules set isn't linear with size. In general if you
>> double a rule set it takes four times longer to load.
>>
>> At 30000 rules iptables-restore is still 5 times faster than iptables-batch.
>
> Wow, when I said 'lot' I for sure didn't think about that many :-) I
> was thinking in the order of like saving two seconds out of four
> when using the plain iptables command. The reason why iptables-batch
> takes longer most probably is because it commits after every rule
> whereas iptables-restore usually only does that once for each table.
> It can do so because rules are grouped by table and are not mixed.
> Maybe it's possible to reuse the handles in iptables-batch and do
> the commit at the end. I'll check that.

I thought I should point out that the improvements present in
iptables-1.3.0-20040925 totally rock! Good work!

I built up an i686 rpm based on that snapshot. Not only does it work well
(2004090x segfaulted on me), it is very fast.

I repeated my performance testing. On a P4 2.4GHz iptables-restore now takes
a couple of seconds to restore ~30000 rules. Even a 400MHz Celeron can
restore ~30K rules in 28 seconds.

This is a major improvement to say the least. It would awesome if you could
somehow harness this performance in iptables-batch.

Regards,
Rob

-- 
---------------------"Happiness is understanding."----------------------
Robert Hardy, B.Eng Computer Systems                  C.E.O. Webcon Inc.
rhardy <at> webcon <dot> ca    GPG Key available          (613) 276-7327
