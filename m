From: "Darius Tribandis" <sirijus@kobra.ktu.lt>
Subject: Re: -m limit problem
Date: Tue, 21 Sep 2004 11:20:47 +0300
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1ec901c49fb3$e5a9cf50$523e000a@sirijus>
References: <1e0e01c49f56$7f61b490$523e000a@sirijus>
	<Pine.LNX.4.61.0409202329180.18874@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Henrik Nordstrom" <hno@marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

hi,

Now i understand. I thing that counter resets just after i reload specific
rule, but if it resets each time i modify any of rules =- than it must by
trated as bug, because it lacks all funcionality of iptables limit match
module.

is it posible to owercome this "future" ? ;)

---
D. Tribandis
Kaunas University of Technology
Institute of Information Technology Development

----- Original Message ----- 
From: "Henrik Nordstrom" <hno@marasystems.com>
To: "Darius Tribandis" <sirijus@kobra.ktu.lt>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Tuesday, September 21, 2004 12:52 AM
Subject: Re: -m limit problem


> On Tue, 21 Sep 2004, Darius Tribandis wrote:
>
> > /usr/sbin/iptables -t nat -N httpinfo
> > /usr/sbin/iptables -t nat -A PREROUTING -p tcp -s USERIP -m
mac --mac-source
> > AA:AA:BB:BB:CC:CC -m multiport --destination-port 80,8080,3128 -j
httpinfo
> > /usr/sbin/iptables -t nat -A httpinfo -p tcp -s 10.5.4.14 -m
limit --limit
> > 1/day --limit-burst 1 -j DNAT --to LOCALIP:5454
> >
> > sometimes i nead some times per day do like this:
> >
> > /usr/sbin/iptables -t nat -F PREROUTING
> > /usr/sbin/iptables -t nat -A PREROUTING -p tcp -s USERIP -m
mac --mac-source
> > AA:AA:BB:BB:CC:CC -m multiport --destination-port 80,8080,3128 -j
httpinfo
> >
> > here problem begins.
> > i am not modifaing httpinfo table but i geting redirect after every
reload
> > like this.
>
> Due to the way limit stores it's counters the counters are reset each time
> you modify the ruleset in the same table (nat in your case).
>
> In theory it may be possible to modify the iptables kernel API to allow
> limit to keep it's counters while modifying the iptable, but in reality
> the best method is to modify limit to keep it's counters in a more sane
> place than within the iptable matchdata.. (or more realistic, write an
> alternative match implementation using separate counters).
>
> Regards
> Henrik
