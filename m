From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 07 Jun 2002 10:15:26 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D006B9E.1040809@cs.auc.dk>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

Rusty Russell wrote:
> 
> 	I disagree.  Consider the original complaint: that --state NEW
> allowed TCP ACK packets through, which allowed an ack scan.  This
> surprised the observers, who then blocked acks.

Precisely.

Actually, my exact complain is now that the documentation is not
making you awared of what you are exactly doing...

Somehow, this is dangerous and can lead you to have a flaw in your
firewall without being awared of it.

Moreover, most of the papers, articles, and web pages about Netfilter
are wrong about this.

Just as an example, the following (very nice) documentation about
Netfilter (http://www.knowplace.org/netfilter/index.html), state
that:

"Note: An ACK packet is a TCP packet with the ACK flag set only. The 
important thing to note here is that after the three-way handshake is 
completed, and the connection is complete, every packet that is part of 
this TCP connection will always have the ACK bit set.

This is also the reason why connection tracking is so important. Without 
connection tracking, there is no way for your firewall to know whether 
an arriving ACK packet is really a part of an established connection. 
When simple packet filters (and Ipchains) receives a packet with the ACK 
flag set, it simply allows the packet through (does this sound like a 
good idea?). When a stateful firewall received an ACK packet, it'll 
consult a connection table to see if the packet belongs to an 
established connection. If it does not, the packet is dropped."

See: http://www.knowplace.org/netfilter/ip_overview.html

Which is obviously wrong in respect of what we were discussing...

I think that this is due (as Rusty said) to a confusion between the
TCP protocol's states and the connection tracking module's states
which are different.

This should definitely be emphased in the documentation (IMHO).


The other points are more about the policy you want to apply for
the development of Netfilter. I mean, should it be left up to
the user to patch this in the ruleset or fixed in the code...

This could be discussed forever without any result.
Therefore, it makes no point to just keep going on this way.


It appears, also, to me that you are focusing more on an
"advanced NAT", than on real "stateful inspection". You agreed
on loosing some stateful key features to increase the connectivity
because as you are using stateful inspection to do NAT, the features
that you loose does not affect so much the security of your network.
But loosing this feature prevent you to use Netfilter as a real
stateful inspection firewall (I'll explain this point later in this
post).

Actually, this discussion start to make aware of the difference
between "connection tracking" and "stateful inspection". :-)


> 	Of course, you can still use SYNs to scan the network, so they
> haven't actually won anything here, except that if their firewall
> reboots, established connections will die.

Well, if you consider a full implementation of a stateful inspection
firewall, you should be able to "hide" a network from outside without
using NAT.

For example, you can make up the following ruleset:

o DENY SYN from outside -> inside
o Allow NEW, ESTABLISHED, RELATED

                       +-----------+
+--------+    +--+    | Hidden Net|
|Internet|----|FW|----| w/o NAT   |
+--------+    +--+    +-----------+

On this configuration, you allow all the computers of your hidden net
to have their own IP address and you disallow any sort of scan from
outside. You can even imagine to have a web server somewhere in your
hidden network (you just have to add as first rule that you allow
all the traffic on the port 80 to this precise IP address).

This configuration can't be done with Netfilter because you are doing
what we could call "connection tracking" and not "stateful inspection".


> 	The confusion here comes from the "TCP connection" vs
> "connection tracking connection" distinction, which is subtle and
> usually harmless.

Harmless if you are running NAT. But, if you are trying to use Netfilter
as a complete stateful inspection firewall, then you are in trouble
(IMHO).

> Hope that helps,

Yes. Thanks. :-)

Regards
-- 
Emmanuel

Security is a process, not a product.
   -- Bruce Schneier (Crypto-gram, February 15, 2002)
