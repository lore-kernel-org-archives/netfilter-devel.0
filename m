From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: Security flaw in Stateful filtering ??????
Date: Thu, 06 Jun 2002 19:21:04 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3CFF9A00.2070805@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mikkel Christiansen <mixxel@cs.auc.dk>,
	Mikkel Refsgaard Bech <mrb@cs.auc.dk>,
	Torben Vinther Schmidt <mariachi@cs.auc.dk>,
	Carsten Stiborg <stiborg@cs.auc.dk>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I am co-supervising students in Aalborg university on a project
about firewalls (and more precisely about stateful firewalling)
in collaboration with Mikkel Christiansen.

Recently, they were testing some of their ideas to improve the
connection tracking module of Netfilter in the university lab
and they discovered some weird things in the behaviour of
Netfilter.

I am just quoting their mail here:

=====
....

The Setup:
----------
A classical client-filter-server setup (two different networks on each
end with a filter/gateway in between). The filter/gateway is configured
to route between the two nets and has the following rules in IP Tables
as suggested by the documentation (see:
http://netfilter.samba.org/documentation/HOWTO/packet-filtering-HOWTO-5.html):

iptables -A FORWARD -p tcp -m state --state ESTABLISHED -j ACCEPT
iptables -A FORWARD -p tcp -m state --state NEW -j ACCEPT
iptables -A FORWARD -p tcp -j DROP

These rules should indicate that we allow packets that create new
connections and packets that are a part of an established connection.
We then drop everything else. These are not good rules for a filter but
they illustrate the point.


The Problem:
------------
When sending an ACK packet, the packet is allowed through the filter.
Due to the second rule. This means that ACK packets are accepted as
being in the state NEW and does not create an entry in the state table.
So if any rule state that we allow NEW connections, this rule can be
used for port scanning.

The ACK packet and the corresponding RST packet were observed on every
machine, i.e. client, server and filter. And, actually, we were able to 
perform a complete ACK scan of the whole network through the filter by
using "nmap -sA".


A Solution:
-----------
As a temporary hack the following rule can be added as the second rule:

iptables -A FORWARD -p tcp --tcp-flags ACK ACK -j DROP

However, this is not a solid solution and the code should be modified,
as we see it, not to recognize ACK packets as being in the state NEW.

We were wondering if this is intentional due to some reason that we
cannot see or if it is a flaw as suggested ?

We have found something about it in the Iptables tutorial (1.1.8),
page 54 (Appendix B, "State NEW packets but no SYN bit set").
But, this is not really convincing.

Any idea ????

Regards,
Mikkel Refsgaard Bech
Torben Vinther Schmidt
Carsten Stiborg
=====

For short:
- ACK packets are classified as NEW (without opening a connection),
- Therefore, allowing NEW packets allow all the ACK packets to go
   through,
- And consequently, in this setting, you can perform ACK scanning
   if you just trust the documentation...

Actually, I don't know what to answer to them. Has somebody any clue to
explain this ?

Regards
-- 
Emmanuel

Maybe somebody should tell gcc maintainers about programmers
that know more than the compiler again.
   -- Linus Torvalds
