From: Pawel Hadam <Pawel.Hadam@imag.fr>
Subject: Outgoing interface selection by source address
Date: Thu, 27 Nov 2003 14:51:23 +0100 (MET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.33.0311271440290.5552-100000@horus.imag.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
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

Hi all

I have 2 local interfaces (eth0 & eth1) and thus 2 IPv6 addresses (src0 &
src1).

I have an SCTP/IPv6 application that binds to one of the addresses
(let's say src0) and sends packets to some destination (dst). But
according to the classical routing policy, all packets in this
connection (src0, dst) are routed via eth1. And I would like them to be
routed via interface eth0, as src0 is the address of eth0 not eth1.
Is it possible to do it with netfilter for IPv6 ? I mean, is it possible
to route the packets via the proper outgoing interface by theirs source
address, like this:

if (src = src0) then send via eth0
if (src = src1) then send via eth1
if (src = other) do whatever

Could anybody give any ideas how to solve my problem, please?

I am using linux-2.6.0-testXX versions.

With best regards
Pawel
