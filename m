From: Kuba Wroniecki <kuba@stansat.pl>
Subject: balanced SNAT
Date: Sun, 27 Apr 2003 23:27:24 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0304272302270.7613-100000@gateway.stansat.pl>
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

This is my first post here, so please be gentle...

ehem...

I have a question regarding the following rule:

iptables -A POSTROUTING -s x.x.x.x/m -j SNAT --to-source 1.2.3.4 
--to-source 3.4.5.6 --to-source 5.6.7.8

I have recently used this rule, hoping it would in some way evenly divide 
the outgoing traffic between the 3 addresses. It didnt, and from what I 
understood from the sources, it wasn't designed to. Instead, the choice of 
the address to use is based on the number of connections with the same 
(dst,src,proto). (Why?)

So my question is: does it make any sense to modify the nat code, to make 
it possible to use the SNAT target to evenly distribute traffic between a 
number of addresses? 
perhaps something like:
iptables -A POSTROUTING -j SNAT --balance-to 1.2.3.4 --balance-to 3.4.5.6 
.....
?


-- 
Regards,
Kuba Wroniecki

"I love deadlines. I especially like the whooshing sound they make as they 
go flying by." (Dilbert's School of Thoughts)
