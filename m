From: "Andrew Smith" <nfml@k1k2.com>
Subject: Re: performance issues (nat / conntrack)
Date: Thu, 27 Jun 2002 12:21:45 +1000 (EST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <38143.203.134.158.15.1025144505.squirrel@iw.k1k2.com>
References: <Pine.LNX.4.33.0206251548230.539-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
In-Reply-To: <Pine.LNX.4.33.0206251548230.539-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> On Tue, 25 Jun 2002, Jean-Michel Hemstedt wrote:
> 
>> > connections. As good as possible. If the conntrack table becomes
>> > full, there are two possibilities:
>> >
>> > - conntrack table size is underestimated for the real traffic
>> > flowing
>> >   trough. Get more RAM and increase the table size.
>> > - conntrack is under a (DoS) attack. Then protect conntrack by
>> > appropriate
>> >   rules using the recent/limit/psd etc modules.
>>
>> And what if, under load conditions, your table becomes full because
>> 90% of its entries, which are unused, are not aged because of
>> timeouts?
> 
> The only case when that might happen is a DoS. You did not consider the
> second point above.

<snip>

I've mentioned this before but since I'm not an actual developer
in the netfilter arena I assume it got ignored (and will again)
but I can suggest what appears to me to be a common cause of this
problem - online gaming.
The specific game that causes this the most is a game called
CounterStrike.
It is a mod of a game called Half-Life which is handled online by
Sierra.
When you want to play online your computer will talk to one of
the Sierra servers (there is 3 of them I think) that controls any
known games that are created via the same process and the Sierra
server will reply with a list of IP addresses of online game servers
- anywhere from about 5,000 to 20,000 during peak times (my guess
at an average would be around 10,000)
Your PC will then usually 'ping' each of the game servers (yes all
X thousand of them) as quickly as possible to determine the response
times you will get if you play on that server.
This 'ping' connection does end up in the conntack table
(I call it a 'ping' coz I've never bothered to check what it really
is and it doesn't matter anyway - it ends up in the conntrack table
is all that matters)
There are plenty of other similar games but CoutnerStrike is the most
popular and thus its numbers are larger than any other game but most
are only an order of magnitude smaller - e.g. QuakeI, II & III,
Tribes 2, Medal Of Honour etc.
The number of players online is usualy between 5 & 10 times the number
of game servers running.

This gives a good example when being able to set the timeout dependant
upon specific factors (e.g. port/protocol) would be good rather than a
global timeout that suits specific cases and does not match many cases
- and causes a severe problem for a limited set of cases

-- 
-Cheers
-Andrew

MS ... if only he hadn't been hang gliding!
