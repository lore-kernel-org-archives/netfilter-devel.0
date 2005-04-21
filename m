From: Wang Jian <lark@linux.net.cn>
Subject: Re: A top 10 statistics module?
Date: Thu, 21 Apr 2005 13:25:20 +0800
Message-ID: <20050421115819.03C0.LARK@linux.net.cn>
References: <200504201804.j3KI4WJ19340@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200504201804.j3KI4WJ19340@isis.cs3-inc.com>
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

Hi Don Cohen,


On Wed, 20 Apr 2005 11:04:32 -0700, don-nfil1@isis.cs3-inc.com (Don Cohen) wrote:

> [not sent to list - that tends to lead to spam
>  so feel free to post contents but please leave my address out of it]
> 
>   I have a customer who needs functionality that list top 10 hosts 
> Top 10 in what sense?  Those that send the most packets?  Those that
> have the most connections?

For tc class, this usually means bytes sent.

> 
> My first suggestion is that this be generalized to allow specification
> of the key, i.e., you should be able to collect statistics on TOS or
> ip length, etc.
> This begins to lead to the slippery slope of more and more general
> languages, e.g., you might want to classify by ranges or combine
> several fields (classify by TOS + protocol ...).
> 

Yes, usually a solution for a special purpose can be generalized into
common solution lately.

> My second is to forget about the 10 - just classify and count the
> packets (maybe also bytes?) in each class.  Then let the user throw
> out the data he doesn't want.
> 

I know your meaning. But it is not enough in this case.

Actually, Getting this class traffic out can be done in user space by
re-interpreting iptables filters (which set nfmark) in tcpdump filter
syntax. And then, analysis of tcpdump output can give out top 10. But,
this is a little complicated for automation and integration.

And, the kernel has done this once. Do it again in userspace seems to be
a waste?

And, when you want to investigate two or more classes at the same time,
you have more trouble to do it.

>   (listener or talker). It normally done in userspace, but in this case,
> 
> I'm imagining here that you want to classify by source address and
> separately by destination address.  So if you really want to add the
> two together then you'd have two instances of the kernel module, and
> in user space you'd read the results for each, sort them and then add
> them together.
> 

No. A TOPHOST rule can specify how to classify, by source or by
destination address.

>   the 10 hosts is for a tc class. Moreover, it is expected that 2 or more
>   tc classes' top 10 are collected at the same time.
> 
>   So I think this is better handled in kernel space, because the classid
>   and/or nfmark is only seen in kernel space.
> 
> It wasn't obvious that you cared about class or nfmark.
> Of course, these could be recomputed (in most cases) in user space.
> 

It can be done in user space. But not convenient.

>   The idea is that a rule like
> 
>    -m mark --mark 0x1 -j TOPHOST --count 10 --name FILENAME
> 
> It came as a surprise to me that you would want to apply the
> statistics counter to only those packets that match some other
> pattern as above.  I'm curious about why this is required.
> If it's not then it seems to me that it would be easier to
> process tcpdump files or perhaps read raw sockets.
> 

This is definitely the original requirement. It can be done in user
space, but not convenient for automation.

>   will collect top10 IPs (using conntrack flow account) and export the
> I don't see what this has to do with conntrack.
> (Perhaps it has more if you only care about IP addresses.)

You catch me.

Forget this part. I wrote the mail when I was thinking. That was part of
my thought but it is wrong. I didn't delete it before I hit send.

> 
>   information under /proc/net/stat/top10/FILENAME based on the source
>   address. (You may need add -i to indicate the direction)
> 
>   Of course, the top10 can be used to match any other criteria beside the
>   nfmark. It can even collect top10 of all traffic.
> 
>   Top10 is used to monitor a while and then disabled. It could be expensive,
>   but is useful to investigate.
> 
>   I will implement it anyway to complete the task, but before I code, I am
>   willing to listen to any one who has comment and suggestion.
> ====
>   To be generally useful, the table must be bounded.  That will result in
>   inaccurate order statistics, but often that doesn't matter much, if the
>   table is an order of magnitude or two larger than the required order
>   statistic, (i.e., 100-1000 entries for estimating the top 10).
> 
> One question is whether you need the results in real time.
> If not, then the limited space seems not so important.
> 

It should be in realtime.

> For cases where there could be a very large number of entries you
> could do something like this:
> hash values to an index, for each index store the first value that
> hashes to that index, then one counter for that value and one counter
> for all others that hash to the same index.
> This loses some possibly valuable data, of course.  But you can change
> the hash at each time interval so that the same two values are
> unlikely to continually interfere.

This, may be good in overhead, but the counter is meaningless then.
Alghouth the top10 is not accurate, the counter should make sense.


-- 
  lark
