From: Brian Deep <brian_deep@yahoo.com>
Subject: Netfilter Inconsistency?
Date: Thu, 15 May 2003 10:49:51 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030515174951.32627.qmail@web20002.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

I am running into some netfilter inconsistency in
developing an application that uses libiptc to add and
remove SNAT rules.

 I can add and delete rules fine and open up
connections correctly using the SNAT rules, but if I
change the source IP address on the SNAT rule I run
into problems.  The SNAT rule is added correctly and
verified using iptables userspace, but when the
connection actually gets NAT'd, it gets the source IP
address of the SNAT rule I had in previous.  I have
tried manually inserting and appending  SNAT rules,
but the connection is still NAT'd with the previous
rule source IP.  At some point, this rule "time's out"
and I am able to correctly add my SNAT rule in.

So,
iptables -t nat -A POSTROUTING -p tcp --sport 1040
--dport 80 -j SNAT --to-source 1.1.1.1 
is added using libiptc.  Connections work fine.
iptables -t nat -D POSTROUTING -p tcp --sport 1040
--dport 80 -j SNAT --to-source 1.1.1.1
is executed to remove the rule using libiptc and
verfied with iptables.
Next, 
iptables -t nat -A POSTROUTING -p tcp --sport 1040
--dport 80 -j SNAT --to-source 1.1.1.2
is added via libiptc and verified using iptables.
However, any connections going out are SNAT'd to
1.1.1.1

If the connection goes out on a different source port,
everything works fine.  Using iptables v1.2.7a. 
Kernel v 2.4.18

Anyone have any thoughts?  And why the he** would it
timeout after several minutes?

Thanks,
-- Brian

__________________________________
Do you Yahoo!?
The New Yahoo! Search - Faster. Easier. Bingo.
http://search.yahoo.com
