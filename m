From: Joakim Axelsson <gozem@gozem.se>
Subject: Question, my modifed -j LOG
Date: Sat, 20 Aug 2005 19:28:24 +0200
Message-ID: <20050820172824.GE5638@aaricia.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

In my effort to try to make my router's firewall some what better i have
been thinking of modifying -j LOG in some ways:

The --log-prefix is way to short only allowing 30 characters. I have a huge
firewall with over 10000 rules (of couse not every packet using every rule).
Its impossible to keep track on where the packet is unless i supply the
table (filter,nat,mangle,raw) and the chain name in --log-prefix. Even if i
try to keep this short there is very little, if no room, left for a reason
to fit in --log-prefix. Simple solution for me is to modify -j LOG to handle
a longer --log-prefix.

Then i was thinking of another solution. Perhaps i could add one or two
options which beside the user supplied --log-prefix also prints the table
name and the chain name. It's easy to find the table name. Just store it in
userdata when the checkentry code runs. However, i havn't found a way to get
the chain name.

Mind that i'm also thinking of (yes wrongly) making my new -j LOG into a -m
log. A match that always matches. This will reduce the number of chains i
need alot. I can see that match->checkentry is given the struct ipt_entry.
But i can't figure out how to get the chain name for there.

To explain why i want to make it a match is because i very often have these
protectors in my firewall:

iptables -N chain_tcpsyn
iptables -A chain_tcpsyn -m limit --limit 1000/s -j RETURN
iptables -A chain_tcpsyn -m limit 1/s -j LOG --log-prefix "FW raw chain_tcpsyn"
iptables -A chain_tcpsyn -j DROP

iptables -N chain
iptables -A chain -p tcp --syn -j chain_tcpsyn
iptables -A chain -p tcp --syn -j RETURN
iptables -A chain -p tcp -j chain_tcp
iptables -A chain -p tcp -j RETURN
... udp icmp ...
iptables -A chain -j chain_otherprotocols


This gives me alot of chains and alot of rules. Mind also that i have _alot_
of interface on this router and even more of these limiters to keep the
machine alive during DDoSes. (I use a perl-script to generete a file which
can be loaded with iptables-restore.)

I have reduced the above by making a better and more accurate limit match
called only 'lim'. This lim can invert the match and only match those
packets that overlimits. Along with a possbile -m log (that in it self
limits the logger so kernel wont be flooded with logging messages) i could
reduce the above to:

iptables -N chain
iptables -A chain -p tcp --syn \
                  -m lim --lim-packets ! 1000/s \
                  -m log --log-lim 1/s --log-prefix "FW raw chain tcpsyn" \
                  -j DROP
iptables -A chain -p tcp --syn -j RETURN
...

I havn't figured a way to nicely remove that last -j RETURN. But it will
aleast save alot of rules and chains by the above idea.

Thx for any reply.

-- 
/Joakim Axelsson A.K.A Gozem@EFnet
