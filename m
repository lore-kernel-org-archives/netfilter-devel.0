From: "Pascal C. Kocher" <pascal.kocher@netbeat.biz>
Subject: Link load balancing and failover
Date: Fri, 18 Oct 2002 14:17:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <08690CFFD361A946AE65793A726D276902DEE3@smirnoff.netbeat-security.ch>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello list!

I'm currently thinking about an easy way to enable failover internet
link loadbalancing without having to use BGP4 for outgoing
communication. For this the netfilter framework seems to be a good way
to go.

This idea is not about state sync between to netfilter machines, but
Internet link loadbalancing.

For this you would need 2 (or more) ISPs.
The idea is the following:
- A packet ist destined for a server on the Internet, and the rules let
the packet pass.
- The packet ist SNATted to the IP of ISP A and ISP B (packet
duplication necessary). Note that we must have two expectations in the
conntrack table. The packets are sent to the corresponding router.
- The first packet which resolves an expectation will be used for this
connection. The expectation for the later packet will be deleted.

This enables us to ensure that the connections always take the fastest
path and if a link goes down, it would still work.

Is there a way to do this in netfilter or am I way off? What would be
the implication on any protocol helpers (ftp, irc, etc.)?

Things to think about also are how to handle incoming connections to a
DMZ or similar. Currently I see only the way of multiple A-records in a
DNS server.

What do you guys think about this?

Greetings,
Pascal.
