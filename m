From: "Alexandre Carlos" <alexandre@redes.unb.br>
Subject: IPtables
Date: Thu, 17 Oct 2002 20:25:30 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <053201c27634$7de19d30$1543a8c0@sanches>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
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

I have the following network


            B
          /  |  \
A1--A  |    C--C1
          \  |    /
             D

I wanto A1 to ping C1 through the following path a-b-c,
so i created the following rule in the nat table of iptable

iptable -t nat -A PREROUTING -s 10.1.1.0/24 -d 192.168.67.0/24 -p icmp -j
DNAT --to-destination 192.168.3.1

The network 10.1.1.0 representes A1, the network 192.168.67.0 C1 and the
address 192.168.3.1 is the interface that the packet shoulkd reach B.

But when i start the ping i can=B4t capture the packet using the sniffer =
and
when a turn down all the interfaces of B and D the ping don=B4t stop.

Can anyone help me please.

Regards,

Alex
