From: Amin Azez <azez@ufomechanic.net>
Subject: Re: new ABI
Date: Tue, 15 Aug 2006 09:39:55 +0100
Message-ID: <44E1885B.5000300@ufomechanic.net>
References: <200608142312.41851.max@nucleus.it>
	<20060815000036.GF7194@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org
In-Reply-To: <20060815000036.GF7194@kriss.csbnet.se>
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

* Joakim Axelsson wrote, On 15/08/06 01:00:
> 2006-08-14 23:12:41+0200, Massimiliano Hofer <max@nucleus.it> ->
>> Hi,
>> I couldn't keep pace during the day with all the mail that has been written, 
>> so let me summarize what has been said.
>> Please forgive (and correct) me if I forget anything.
>>
>> First of all several people think that the current ABI has shortcomings and 
>> something has to be done.
>>
>> Regarding my proposal for priv_data (I'm obviously biased here, but I'll try 
>> to be objective):
>> - it offers the ability to store data out of reach to the userspace utilities 
>> (for whatever housekeeping any match/targets needs);
>> - it can't offer persistent data to matches/targets.
>>
>> <biased>
>> With this patch we can part with some really ugly tricks involving userspace 
>> structure fields and kernel pointers and it would let us have O(1) matches 
>> for quota, limit and any other match/target that needs cross match data.
>> </biased>
>>
> 
> O(1) can be done today as well. Just figure out the pointer in checkentry()
> and keep it. However, do this everytime. Don't trust userspace to not alter
> it. So its O(1) in match()/target() but not in checkentry(). Shouldn't be
> too bad.

I did this for layer7 matching to cache the compiled regex, however it
stopped deletion of rules by specification (not by index) because the
matchinfo struct no longer matched (the kernel based one had the pointer
but the userland based one that was being compared did not). I didn't
pin down the code doing the match which would need "teaching" not to
match the private bit, as time constraints were too tight.

> It would probably be nice to introduce more advanced pseudo data types. Like
> a rate type ( X / time ). IP-type. Netmask-type and so on. Common parser
> libraries for the userspace tool.
>
> Also, don't forget that people tend to think that iptables are way too
> complicated. I think people like BSD style of writing the rules to a file
> that is then "executed". The file syntax is more of writing sentences of
> what you want. I my self hate that way of configuring with "words" rather
> than parameters. But still, one thing to consider. 
> 
> A file only config somewhat solves the iptables vs iptables-save/restore
> syndrome. They are not always in sync. Also in comparation with switches
> like Cisco, configuration alterations are always saved. You work in a shell
> what changes the only config-file directly. This means that in our case,
> iptables and iptables-save are the same. iptables only alter the "only file"
> that iptables-save has. By introducing a file only will not nessesary make a
> full realod of all rules only to alter one rule. The rules, if having a
> state can get a state id which they can hook back on when reloading.
> 
> Also, try to move away from the small thinking or rules we have today. Try
> to see a bigger picture. What is a rule. What can it do? What is match or
> target? What is a module. I could basicly write myself a module today that
> does my entire firewall using only one iptables rule. 
> "iptables -A INPUT -m myhugefirewall".
> Try focus on the bigger modules like recent, ipset, accounting, conntrack.
> Not the small and simple ones as length, ttl and mport.

I have modified iptables-restore (as it is good at parsing iptables-save
format) to output an xml specification. In support of your comment here;
if iptables modules preserved semantics by making use of macro's or
function calls instead of printf when saving their rules, then it would
be easy to support various more readable representations of rule, which
would answer your suggestions mentioned here.

> Another way of doing firewall is to write your rules in some syntax in a
> file. Have a userspace program parse it into C-code. Have your gcc compiler
> compile it into a kernel module. Load it. This will optimize the firewall
> ALOT. Still again, states can be saved between reloads just using some ids
> and hooks for the rules that needs a state.
> 
> If you look at the work i began with ippool which was later finished in a
> much smaller version as ipset has no limits at all (well alot less atleast
> :-). The idea was to make three category of elements. Data structes, data
> interpreter and algorithms. Meaning we can have as data strcutes: array,
> bitmap, hash, rcu-list, priority queue. Data interpreter: ip-addresses,
> ipv6-addresses, port numbers, times/dates, ranges and so on. Algoritms:
> timeout, sorting, logging and more. You can then combine a data structure
> with a data interpreter, and possible with an algoritm or two. So to build
> recent you combine data structure hash with ip-addresses, might also add the
> algorithm timeout. To just match a single IP source address, combine the
> data structure 'single' with data interpreter 'IPv4 address' and algoritm
> 'source', or something like that. This would be impossible with the current
> API of iptables. But if you only add alter/change and dump this would be.
> Even better i can be integrated with new iptables-ng perhaps. Crazy idea and
> perhaps impossible to make it easy to use. But would be a really really nice
> professional tool.
> 
> Also remember that alot of firewall setups for routers handles several
> different destinations. Today no good way of grouping rules and/or trying to
> group which destinations belongs to which custumer exists.
> 
> Many crazy ideas, so keep your asbestos suit on :-P

These ideas arenot crazy and are very much relevant to me.
I'm moving to xml representation of rules because the abstraction allows
me to implement user requirements in various ways depending on the
current capability of iptables. iptables now supports a module appearing
more than once in a match, but not multiple targets. With a meaningful
xml representation (or any easily manipulatable representation) I can
render the users requirements as multiple iptables matches now, possibly
with extra chains, and have these reduced to a single rule in the future.

Sam

Sam
