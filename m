From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 7 Jun 2002 12:11:16 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206071211.16173.hno@marasystems.com>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au> <200206071105.42881.hno@marasystems.com> <3D007D73.9030609@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org,
	Emmanuel Fleury <fleury@cs.auc.dk>
In-Reply-To: <3D007D73.9030609@cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Emmanuel Fleury wrote:
> Henrik Nordstrom wrote:
> > This configuration can be done just fine with iptables as demonstrated in
> > my earlier message, but here we go again (but slightly different):
> >
> > # Allow existing connections
> > iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
> > # Allow hidden net to initiate new connections (including connection
> > pickup) iptables -A FORWARD -i eth0 -j ACCEPT
> > # Drop anything else
> > iptables -A FORWARD -j DROP
>
> Sorry, I don't understand something ! :-/
>
> Does that mean that you DROP all the ACKs, even those which are valid ?

Valid ACKs (including SYN,ACK, ICMP errors etc) are matched by the first rule 
as these will be ESTABLISHED.

Hidden network sends SYN, this gets state NEW in the firewall and do not match 
the first rule. The second rule then picks up the packet and allows it to be 
sent out as it is sent from the trusted network (eth0), thereby allowing the 
conntrack entry to be created.

SYN+ACK received from the called server, matching the conntrack entry created 
by the SYN and gets matched as ESTABLISHED in the first rule.

Future ACK's matching this conntrack gets matched by the first rule as 
ESTABLISHED.


Now, lets assume the firewall reboots or other action causing the conntrack 
entry to disappear from the netfilter connection tracking table.


Server (external / eth1) sends ACK. As there is no conntrack entry this gets 
state NEW and is NOT matched by the first rule, and as it is not initiated 
from your hidden network (eth0) it is NOT allowed by the second rule and gets 
denied by the third rule. As the packet is not allowed no conntrack entry 
gets ceated here.

Client (internal / eth0) sends ACK. As there is no conntrack entry this is a 
NEW packet and is not accepted by the first rule. But as the second rule 
allows anything from the inside the packet is accepted, allowing the 
conntrack entry to be created.

Server sends ACK after receiving the client ACK. This matches the conntrack 
entry created above and will be matched as ESTABLISHED by the first rule and 
the connection tracking state has been fully restored.

Regards
Henrik
