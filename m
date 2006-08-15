From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: new ABI
Date: Tue, 15 Aug 2006 02:00:36 +0200
Message-ID: <20060815000036.GF7194@kriss.csbnet.se>
References: <200608142312.41851.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
Content-Disposition: inline
In-Reply-To: <200608142312.41851.max@nucleus.it>
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

2006-08-14 23:12:41+0200, Massimiliano Hofer <max@nucleus.it> ->
> Hi,
> I couldn't keep pace during the day with all the mail that has been written, 
> so let me summarize what has been said.
> Please forgive (and correct) me if I forget anything.
> 
> First of all several people think that the current ABI has shortcomings and 
> something has to be done.
> 
> Regarding my proposal for priv_data (I'm obviously biased here, but I'll try 
> to be objective):
> - it offers the ability to store data out of reach to the userspace utilities 
> (for whatever housekeeping any match/targets needs);
> - it can't offer persistent data to matches/targets.
> 
> <biased>
> With this patch we can part with some really ugly tricks involving userspace 
> structure fields and kernel pointers and it would let us have O(1) matches 
> for quota, limit and any other match/target that needs cross match data.
> </biased>
> 

O(1) can be done today as well. Just figure out the pointer in checkentry()
and keep it. However, do this everytime. Don't trust userspace to not alter
it. So its O(1) in match()/target() but not in checkentry(). Shouldn't be
too bad.

> People may expect the second feature too, but it's just not possible with the 
> current infrastructure. The same infrastructure, making extensive use of 
> arrays whose size is determined before we call any module hook function, 
> leaves us in the cold for a really flexible solution for other problems too.
> I've not yet read all the code involved, but, if we really need to, we may be 
> able to use a compat-like interface to maintain ABI compatibility with a new 
> netfilter core.
> 
> What people need from any new infrastructure:
> - cleaner interface with clearer separation between kernel and user data;
> - ability to dump internal state of matches/targets (this may not be in a 
> 1-to-1 relation, so it may be tricky, do we need module state dumping?);
> - ability to change chains/rules/matches without reinitializing everything;
> - ability to change matches' state or configuration without reinitializing 
> everything;
> - general infrastructure for common logic that is currently reinvented every 
> time (negation comes to mind, but I'm sure there are other things).
> 
> <biased>
> Regarding user influence over state, especially where the number of states 
> doesn't match the number of matches involved, I'm not totally opposed to a 
> file-like way of exposing it. I agree that /proc is in a sorry state, but 
> configfs is there precisely for this purpose. Of course not everything can be 
> done this way and I wouldn't like to have complex data passed and parsed this 
> way.

This isn't a bad idea. Can we make an iptablesfs that can be used in a smart
way? It will offer an obvious API for any userspace-program/script to use.
We wouldn't then need any explicit userspace-program at all to maintain.
Only kernel.

Perhaps we will push parsing functions into kernel then. Not good. But if we
could come up with an API for a iptablesfs the parsing would be minimal and
just in common fast functions.

> We may need a new set of commands in iptables (should I call it iptables-ng?) 
> just for keeping this kind of data (realms, quota groups, conditions, etc.). 
> If we had a general way to keep collections of configurations, I'll be glad 
> to conform and use it.
> </biased>
> 
> I think the current array oriented data structures won't allow us to add these 
> features. RCU lists come to mind. It sure is a step back in performance 
> (sparser access to memory and more memory fragmentation), but it may not be 
> that noticeable.
> I think every match/target should expode:
> - init;
> - destroy;
> - change;
> - dump;
> - restore.
> 

Don't forget the worker: match()/target().

> Depending on the API change, dump and restore may melt in a single function.
> 
> The kernel should let any match:
> - receive user supplied initialization data (mostly a rule definition) state 
> dumps (this calls for very careful planning and checking);
> - send state dumps to userspace;
> - keep private data for every match/target;
> - keep collections of configurations common to matches in a module (every 
> module may keep it without netfilter core help, but if it becomes part of the 
> infrastructure it may be handled through the userspace ABI).
> 
> 
> Am I forgetting anything?
> Do you think any of these features are bugs?
> Am I overseeing fatal difficulties related to what I wrote?
> Please reply with your opinions. I'll wear my asbestos suite for the next 
> couple of days. :)
> 

It would probably be nice to introduce more advanced pseudo data types. Like
a rate type ( X / time ). IP-type. Netmask-type and so on. Common parser
libraries for the userspace tool.

Also, don't forget that people tend to think that iptables are way too
complicated. I think people like BSD style of writing the rules to a file
that is then "executed". The file syntax is more of writing sentences of
what you want. I my self hate that way of configuring with "words" rather
than parameters. But still, one thing to consider. 

A file only config somewhat solves the iptables vs iptables-save/restore
syndrome. They are not always in sync. Also in comparation with switches
like Cisco, configuration alterations are always saved. You work in a shell
what changes the only config-file directly. This means that in our case,
iptables and iptables-save are the same. iptables only alter the "only file"
that iptables-save has. By introducing a file only will not nessesary make a
full realod of all rules only to alter one rule. The rules, if having a
state can get a state id which they can hook back on when reloading.

Also, try to move away from the small thinking or rules we have today. Try
to see a bigger picture. What is a rule. What can it do? What is match or
target? What is a module. I could basicly write myself a module today that
does my entire firewall using only one iptables rule. 
"iptables -A INPUT -m myhugefirewall".
Try focus on the bigger modules like recent, ipset, accounting, conntrack.
Not the small and simple ones as length, ttl and mport.

Another way of doing firewall is to write your rules in some syntax in a
file. Have a userspace program parse it into C-code. Have your gcc compiler
compile it into a kernel module. Load it. This will optimize the firewall
ALOT. Still again, states can be saved between reloads just using some ids
and hooks for the rules that needs a state.

If you look at the work i began with ippool which was later finished in a
much smaller version as ipset has no limits at all (well alot less atleast
:-). The idea was to make three category of elements. Data structes, data
interpreter and algorithms. Meaning we can have as data strcutes: array,
bitmap, hash, rcu-list, priority queue. Data interpreter: ip-addresses,
ipv6-addresses, port numbers, times/dates, ranges and so on. Algoritms:
timeout, sorting, logging and more. You can then combine a data structure
with a data interpreter, and possible with an algoritm or two. So to build
recent you combine data structure hash with ip-addresses, might also add the
algorithm timeout. To just match a single IP source address, combine the
data structure 'single' with data interpreter 'IPv4 address' and algoritm
'source', or something like that. This would be impossible with the current
API of iptables. But if you only add alter/change and dump this would be.
Even better i can be integrated with new iptables-ng perhaps. Crazy idea and
perhaps impossible to make it easy to use. But would be a really really nice
professional tool.

Also remember that alot of firewall setups for routers handles several
different destinations. Today no good way of grouping rules and/or trying to
group which destinations belongs to which custumer exists.

Many crazy ideas, so keep your asbestos suit on :-P

--
Joakim Axelsson
