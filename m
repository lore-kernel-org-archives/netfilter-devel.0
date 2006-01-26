From: "Ethy H. Brito" <ethy.brito@inexo.com.br>
Subject: netfilter observation
Date: Thu, 26 Jan 2006 17:10:57 -0200
Message-ID: <20060126171057.7fb9632d.ethy.brito@inexo.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


Dear developer

I observed an "unusual" behavior when using NAT table that I consider
at least dangerous. Maybe it has already been corrected in newer
versions or this have to be discussed somewhere else. You tell me please.

Assumptions:
a) conntracking database is always mantained by kernel even in absence of netfilter rules;
b) a new NAT dataflow is only accepted if there exist a rule in NAT table that matches it;
c) remaining NAT dataflow may be ACCEPT'ed by a convenient ESTABLISHED FORWARD rule.

That said I wrote a set of rules that NAT an Internet request to an
internal server at a given BCP-5 IP address.

I can see the connection beeing updated in /proc/net/ip_conntrack
output. 

So far so good. 

The problem resides in the fact that if I want to interrupt this and
accept another NAT'ed data flow. If I flush all tables (NAT and TALBLE),
change the IP address for the internet client and run the script again,
the old data flow is not interrupted! The kernel continues to NAT
packets even if there is no NAT rules to them.

I suspect that due to (a) the old data flow is not deleted from the
database with the flush of NAT table. When I inserted the new rules (new
(b)), the old data stream is still forwarded due to (c) since its state
is ESTABLISHED. I then ended with two NAT'ed data flows (one unwanted
and one as requested)

This is leading to a non authorized dataflow beeing carried out
(remember that there is no old (b) anymore) without admin knoledge.

This is happening now to one of my machines (I did not inspect others). 
Does this make any sence to you?
Is this the expect behavior? How to "kill" the old data flow?

Or even worst: I completely get out of my mind and begun to see "hair in
eggs" (as we say in here).

Environment:
iptables -V reports iptables v1.2.11
Linux kernel 2.4.31 (no modules. ipt_* compiled hardwired)


Regards

-- 

Ethy H. Brito         /"\
InterNexo Ltda.       \ /  CAMPANHA DA FITA ASCII - CONTRA MAIL HTML
+55 (12) 3941-6860     X   ASCII RIBBON CAMPAIGN - AGAINST HTML MAIL
S.J.Campos - Brasil   / \ 
