From: Venkatesh Prasad Ranganath <vranganath@cox.net>
Subject: [Fwd: ACCEPT/DROP]
Date: Fri, 20 Dec 2002 07:54:38 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E03211E.20900@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

I was looking into the iptables implementation and was intrigued about 
how iptables would handle a situation in which we have identical rules 
except for their targets which are contradicting, say ACCEPT and DROP. 
 By looking at ipt_do_table() function it seems that the first 
non-IPT_RETURN  verdict from any standard target will end the traversal 
of a chain of a table, which seems to be a bit odd.  First, such 
conflicting rules must not be allowed.  Even beyond, this fails in the 
situation where you have a dropping rule added after an accepting rule.

For example, a packet from m.n.o.p to a.b.c.d would be accepted at 
a.b.c.d because of the first rule, although it had to be dropped 
according to the second rule.   And this would result because of the 
order in which the rules are added to the table.

iptables -A INPUT -d a.b.c.d -j ACCEPT
iptables -A INPUT -s m.n.o.p -j DROP

Is my understanding correct?  If so, I am curious to know how nf-hipac 
behaves in such situations?

waiting for reply,

-- 

Venkatesh Prasad Ranganath,
Dept. Computing and Information Science,
Kansas State University, US.
web: http://www.cis.ksu.edu/~rvprasad
