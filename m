From: Oskar Andreasson <blueflux@koffein.net>
Subject: Re: tcp-window-tracking.patch question
Date: Fri, 20 Sep 2002 12:42:53 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0209201028410.1754-100000@laptop1.agatha>
References: <Pine.LNX.4.33.0209200839370.21253-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jay Schulist <jschulist@bivio.net>, Harald Welte <laforge@gnumonks.org>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0209200839370.21253-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi,

On Fri, 20 Sep 2002, Jozsef Kadlecsik wrote:

> Hi,
> 
> On Thu, 19 Sep 2002, Oskar Andreasson wrote:
> 
<snip>
> 
> However, the problem encountered on kashyyyk (long mail delays due to
> packets marked as out of window) must be sorted out before considering a
> submission.

Ah, I see the problem. I hope this gets resolved sometime soon.


<snip>
> 
> Jay Schulist has just submitted a patch ('User defined udp and tcp
> conntrack state timeouts') which implements the same feature but he keeps
> the new knobs in /proc/net/ipv4/.
> 
> A decision should be taken on the systcl interface of netfilter.

That's actually why I brought it up, just didn't want to point it out too 
heavily:). I hope no offense was taken by anyone. 

So... a few thoughts from a users point of view. Before I say anything 
further, I should note that I am already "skewed" in one direction.

* First off, I think the decision to create a new netfilter directory is a
good idea (easier to find the knobs).

* Jozsef's patch (tcp-window-tracking) has already been around for a 
rather long time, hence a lot of people may have already grown used to it, 
and written scripts based on those premises.

* The tcp-window-tracking values are much much easier to understand as
well, since they are clearly labelled and should not take too much time to
actually get to understand to anyone (I think...?). In any way, 
tcp-window-tracking should be easier to understand than the "user defined 
udp and tcp conntrack state timeouts" patch, which contains several values 
in a single entry. 

* The patch provided by Jay Schulist is more error prone(from user
perspective, of course), all values are put into one single long line
which is harder to remember the order of, as well as easier to 
accidentally scramble up.

* Also, Jay's patch seems to have no additions for ICMP tuning, though
this is what I experience from just a really quick lookover. Correct me if
I'm wrong.

Just a few thoughts. As I said, I am already "skewed", so forgive me for 
only taking one side of the story. I simply like the tcp-window-tracking 
patch better:).

----
Oskar Andreasson
http://www.frozentux.net
http://iptables-tutorial.frozentux.net
http://ipsysctl-tutorial.frozentux.net
mailto:blueflux@koffein.net
