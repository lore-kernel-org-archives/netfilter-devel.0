From: "Andy Whitcroft" <APW@uk.ibm.com>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Thu, 6 Jun 2002 23:15:09 +0100
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <OF64B661D9.7EEB5DA1-ON80256BD0.0078584E@portsmouth.uk.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Torben Vinther Schmidt <mariachi@cs.auc.dk>,
	Mikkel Christiansen <mixxel@cs.auc.dk>,
	Mikkel Refsgaard Bech <mrb@cs.auc.dk>,
	netfilter-devel@lists.samba.org,
	netfilter-devel-admin@lists.samba.org,
	Carsten Stiborg <stiborg@cs.auc.dk>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Emmanuel Fleury <fleury@cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

If I understand correctly what is being said is that if
an ACK only packet passes the firewall for a connection
which is otherwise unknown a lost connection is assumed
and the connection will be reaquired, ie become valid
and allow reply packets to be treated as ESTABLISHED from
a contrack point of view.

Whilst this sounds dangerous, the key statement here is
that the ACK only packet is treated as NEW.  If you are
accepting state NEW you are allowing new connections
to pass the firewall in that direction anyhow, so the
firewall is 'open' in that direction.  So almost any
kind of port scan is likely to work in that direction.

Taking your example, this will occur because the packet
matches the NEW state match and is acceptable, note it
is not matching the ESTABLISHED state.

iptables -A FORWARD -p tcp -m state --state ESTABLISHED -j ACCEPT
iptables -A FORWARD -p tcp -m state --state NEW -j ACCEPT
iptables -A FORWARD -p tcp -j DROP

A more typical example would be something like below.
Here we only accept NEW packets from the LAN interface
(a safe and secure internal network).  In the case of
a loss of the connection (from a firewall reboot) we
will be getting ACK packets from both ends of the
connection.  However, the packets from the dangerous
end of the connection will not be compared to the
NEW state and so be dropped as expected.  The first
ACK from the secure internal network will reopen
the connection in the firewall and then the external
ACK's will start to be accepted as ESTABLISHED.

iptables -A FORWARD -i $WAN -o $LAN -p tcp \
      -m state --state ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $LAN -o $WAN -p tcp \
      -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -p tcp -j DROP

Assuming I understand this correctly this seems safe
as connection reaquire can only occur in the directions
through the firewall that we have already said
attempting to open connections is valid.

Cheers.

-apw
