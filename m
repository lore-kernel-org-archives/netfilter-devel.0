From: Nagaraj G <gnraj@teneoris.com>
Subject: Help needed on standalone nat for opening new ports inside the code
Date: Sat, 14 Feb 2004 16:20:24 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1076755824.13168.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
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

Hello,

I am writing a new netfilter application module where-in I have to
mangle each and every packet. So, I have made the module as a standalone
NAT with NAT_ALWAYS flag defined.

I am using linux 2.4.10 kernel and the related files.

Masquerading is enabled.

My protocol behaves like this.

1. A packet destined to the well-known port comes to the netfilter from
an internal host. This packet gets mangled via the Nat_Help routine
registered via the register_nat_helper.

2. The reply for the above packet does not come on the same connection.
The reply comes in on the same well-known port from the remote
ip-address.

For the above case, I don't want to define a "iptables" rule hard-coded
as I don't know who is coming in and when.

So, I want to create the connection dynamically to open the well-known
port only for the remote ip-address.

I tried doing ip_conntrack_expect_related(). But it fails with -16
(EBUSY).

I don't get the reply back from the remote ip-address unless I create
the port-forwarding rule manually.

How do I achieve the functionality required in case of standalone-nat?

Thanks in advance for the great reply.

Best Regards,

GNRaj
