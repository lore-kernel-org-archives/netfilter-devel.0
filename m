From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Rule optimization scheme openbsd-like
Date: Mon, 13 Oct 2003 10:25:00 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0310131004000.17633@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

someone on LKML writing in 'thoughts for 2.7' about netfilter development,
handed me a fistful of links related to openbsd's pf.

Out of them I only read one document so far:
http://www.benzedrine.cx/pf-paper.html

This document explains some pf's features, one of them is:

[... exerpt from the document ...]

2.8. Transparent rule set evaluation optimization

pf automatically optimizes the evaluation of the rule set. If a group of
consecutive rules all contain the same parameter, e.g., ``source address
equals 10.1.2.3,'' and a packet does not match this parameter when the
first rule of the group is evaluated, the whole group of rules is skipped,
as the packet can not possibly match any of the rules in the group.

[... exerpt from the document ...]

This feature would be really nice to have in Netfilter, any ruleset would
benefit from this without loss of performance against normal rule-by-rule
evaluation.

What do you think? Is anyone working on this

Also, I noticed that personally I am actually using an optimization like
this just by using a good ruleset. Consider a ruleset that would be
designed like so:

iptables -N tcpcheck
iptables -A tcpcheck -p tcp --syn --dport 80 -j ACCEPT
...
iptables -A tcpcheck -j REJECT

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -j tcpcheck
iptables -A INPUT -p icmp -j icmpcheck
iptables -A INPUT -p udp -j udpcheck
iptables -A INPUT -j LOG

This ruleset actually works similarily to 'skip-steps' mentioned in
the document thanks to the -p tcp -j tcpcheck rules. This sorts the rules
evalution into groups, and skips the rules that would not be matched for
sure. The parameter used is the protocol type.

It might be a good rule writing technique to add to the HOWTO or to write
a HOWTO on rule writing technique.


Regards,
Maciej
