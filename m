From: "Shen Rong" <rshen@udtech.com.cn>
Subject: dynamic rule for bi-directional udp conversation
Date: Sun, 28 Sep 2003 21:44:56 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <039b01c385c6$b4449c40$e600a8c0@udtech.net>
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

Hi,

   Sorry for long mail.:)

   We use dnat & snat to dynamically maintain the
RTP stream between the hosts from the internal
network and external network. When the two parties'
IP address and UDP port is determined, our application
will create dnat & snat rules dynamically to masquerade
the internal IP address. Just like the following pic.

Host A       ------   gateway  -----    Host B
192.168.0.2  192.168.0.1   1.1.1.1      1.1.1.2

Say A will use the UDP 10000 as it's receiving port, and
use UDP 10001 as it's sending port(source port). B will
use the UDP 20000/20001 as it's receiving/sending port.
Since the RTP stream is bi-directional, we should dynamically
create two rules for the conversation:

iptables -t nat -A PREROUTING -d 1.1.1.1 -p udp \
         --destination-port 50000 -j DNAT \
         --to-destination 192.168.0.2:10000

iptables -t nat -A POSTROUTING -d 1.1.1.2 -p udp \
         --destination-port 20000 -j SNAT \
         --to-source 1.1.1.1:50000

We create the above two rules only with the dest. information
as match since we only know these information when creating
the rules. As you see, we want to use only one port (50000)
as the receiving/sending port on the gateway whatever A and
B use.

The problem is if the data packets come from the outside first,
they will match the DNAT rule, like that:
original pkt: dest. 1.1.1.1:50000       src 1.1.1.2:20001
DNATed pkt:   dest. 192.168.0.2:10000   src 1.1.1.2:20001

IIRC, the packets will leads to the following conntrack:
original:   dest. 1.1.1.1:50000   src 1.1.1.2:20001
reply:      dest. 1.1.1.2:20001   src 192.168.0.2:10000

But the packets from the internal network will use 10001 as source
port, so they won't match this conntrack, thus the IP Conntrack will
create another conntrack for them. It sounds ok, but in fact, after
the internal packets match the SNAT rule, they are all dropped, since
the NAT code can't find unique tuple (50000 is already used by the first
conntrack) for them as the SNAT rule says. Though I could use another
port (say 50001) to create the SNAT rule, but it will leads to two
un-replied conntrack, which may be filtered by stateful filter rule.

So far, I don't want to write a helper/expecter module for our application
since there are already ALG there. So, is there any other solution for
my problem? Thanks a lot.


--
Shenrong
