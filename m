From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: ACK is NEW: Conclusion ? (was:Re: Security flaw in Stateful filtering
 ??????)
Date: Sat, 08 Jun 2002 11:07:46 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D01C962.1060309@cs.auc.dk>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au> <3D006B9E.1040809@cs.auc.dk> <20020607220256.GT28055@titanium.brain.org>
Reply-To: netfilter-devel@lists.samba.org
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

Hi all,

Ok, let's conclude this thread.

What was the initial problem ?:
-------------------------------

FAQ: Some invalid ACK packets are going through my firewall !!!

   By reading the current documentation, most of the people are assuming
that there is a perfect match between the states of the TCP protocol
and the states of the connection tracking module (NEW, ESTABLISHED,
RELATED and INVALID).

   This is wrong !

   For example, the state NEW of the connection tracking module is
matching much more than the three way handshake initiating a TCP
connection. Actually, all the ACK packets which are not part of a
registered connection are matched as NEW and will create a new
entry in the table. In the same way, the FIN and RST packets which are
not part of any existing connection will create a new entry.

   This behaviour is _not_ a bug of Netfilter, it is intended in order
to avoid to shut down the pending connections after a reboot of the
firewall.

   The solution to fix this behaviour in the ruleset is to write:

# Disallow INVALID packets (must be in first position)
iptables -A FORWARD -m state --state INVALID -j DROP
# Allow existing connections
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
...

   For more details, the precise behaviour of the state machine of the
connection tracking module can be found in: ip_conntrack_proto_tcp.c.



Some pending questions:
-----------------------

1) How to Define NEW and INVALID ?

   Well, actually, the NEW and INVALID states does not exist, except
in a user point of view (where is the definition of those states in the
code ?). They are both matching the NO state which can probably be
defined as:

            All the packets which are not part of a connection.


   Therefore, it is difficult for me to define NEW and INVALID precisely.
If somebody can make this point clear, I would be pleased.


2) What documentation to fix ?

   I would say that this feature require at least an entry in the FAQ
(the first part of this post can probably be used for this, I already
agree on every necessary modification of this text).

   If a clear definition of what NEW and INVALID states are matching can
be done, the packet-filtering-HOWTO should be modified in consequence.

   Moreover, this behaviour should be recalled as often as possible
in order to avoid the confusion between the states of the connection
tracking module and the states of the TCP protocol.


Hope this help.
-- 
Emmanuel

The real fun of living wisely is that you get to be smug about it.
   -- Calvin & Hobbes (Bill Waterson)
