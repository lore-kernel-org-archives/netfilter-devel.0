From: "Michael Varga" <mike.varga@cavium.com>
Subject: crash using netfilter for ipsec when processing icmp packets
Date: Mon, 24 Jan 2005 20:01:19 -0800
Message-ID: <096901c50292$8ad6f070$a610a8c0@niche>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hello:

I have written an Ipsec module that uses netfilter to capture packets. =
These packets
are then sent to a hardware crypto device which after finishing, it's =
driver calls a callback, which
then calls either an ip_rcv (inbound/decrypt) or an ip_send =
(outbound/encrypt) to deliver the
packet.

When netfilter captures icmp packets which are destined to the machine =
for=20
which the Ipsec module is running on, I get kernel crashes.=20

It only crashes when the icmp traffic is >=3D 10Mbits/sec.

Are there some unpublished rules when processing icmp with Netfilter?
Does anyone have some suggestions/recommendations?

thanks
Mike
