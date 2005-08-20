From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Question, my modifed -j LOG
Date: Sat, 20 Aug 2005 22:01:53 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0508202154050.18226@yvahk01.tjqt.qr>
References: <20050820172824.GE5638@aaricia.csbnet.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20050820172824.GE5638@aaricia.csbnet.se>
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


>The --log-prefix is way to short only allowing 30 characters. I have a huge
>firewall with over 10000 rules (of couse not every packet using every rule).

>From a FW designer's POV, I would say you have got too much rules. I have like 
what... `iptables -L -v | wc -l` == 63, and I am sure you can reduce it too.

>Its impossible to keep track on where the packet is unless i supply the
>table (filter,nat,mangle,raw) and the chain name in --log-prefix. Even if i
>try to keep this short there is very little, if no room, left for a reason
>to fit in --log-prefix. Simple solution for me is to modify -j LOG to handle
>a longer --log-prefix.

There is a -j TRACK, but I have not used it yet. (I apparently forgot to patch 
it in, and now I am too lazy to touch my kernel again for some weeks.)

>Mind that i'm also thinking of (yes wrongly) making my new -j LOG into a -m
>log. A match that always matches. This will reduce the number of chains i
>need alot. I can see that match->checkentry is given the struct ipt_entry.

Interestingly enough, ebtables follows exactly this approach - i.e. there are 
no "non-terminating targets", but ebtable's -j only has absolute verdicts and 
everything else is kinda "by the way", e.g.
  ebtables -A INPUT -j CONTINUE --log (the only non-terminating thing is 
  CONTINUE)

OTOH, I find the iptables way better with -j LOG. To reduce the number of 
chains, you should really look into the goto target. It's awesome (see AS_IPFW 
soon).

>To explain why i want to make it a match is because i very often have these
>protectors in my firewall:
>
>iptables -N chain_tcpsyn
>iptables -A chain_tcpsyn -m limit --limit 1000/s -j RETURN
>iptables -A chain_tcpsyn -m limit 1/s -j LOG --log-prefix "FW raw chain_tcpsyn"
>iptables -A chain_tcpsyn -j DROP

This chain is ok..

>iptables -N chain
>iptables -A chain -p tcp --syn -j chain_tcpsyn
>iptables -A chain -p tcp --syn -j RETURN
>iptables -A chain -p tcp -j chain_tcp
>iptables -A chain -p tcp -j RETURN

You would benefit from goto. See:

ipt -A chain -p tcp --syn -g chain_tcpsyn
ipt -A chain -p tcp -g chain_tcp
ipt -A chain -p udp -g chain_udp
ipt -A chain -p icmp -g chain_icmp
ipt -A chain -j LOG --log-prefix "what a protocol is that?"
ipt -A chain -j DROP

to give an example...

>This gives me alot of chains and alot of rules. Mind also that i have _alot_
>of interface on this router and even more of these limiters to keep the
>machine alive during DDoSes. (I use a perl-script to generete a file which
>can be loaded with iptables-restore.)

Do not make yourself a favorable DDOS target.
(And try hashlimit if you need something spicy single-host-based.)

>I have reduced the above by making a better and more accurate limit match
>called only 'lim'. This lim can invert the match and only match those
>packets that overlimits. Along with a possbile -m log (that in it self

Uh huh, you could have done that also with another chain

  ipt -A chain -p tcp -m lim --lim-packets 1000/s -j RETURN
  ipt -A chain -j LOG --log-prefix "uhoh, too much packets"

of course, this would work against your trying to reduce chains/rules. And if 
you're already coding the "!" of -m lim, why not modify -m limit to support 
"!" instead of creating yet another match module?

>limits the logger so kernel wont be flooded with logging messages) i could
>reduce the above to:
>
>iptables -N chain
>iptables -A chain -p tcp --syn \
>                  -m lim --lim-packets ! 1000/s \
>                  -m log --log-lim 1/s --log-prefix "FW raw chain tcpsyn" \
>                  -j DROP
>iptables -A chain -p tcp --syn -j RETURN
>...
>
>I havn't figured a way to nicely remove that last -j RETURN. But it will
>aleast save alot of rules and chains by the above idea.


Jan Engelhardt
-- 
| Alphagate Systems, http://alphagate.hopto.org/
