From: Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>
Subject: I see wrong ip on icmp_need_fragment. MASQUERADE+less_than_1500_MTU_link+nfs
Date: Thu, 14 Aug 2003 16:17:35 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200308141317.h7EDHad01974@Port.imtp.ilyichevsk.odessa.ua>
Reply-To: vda@port.imtp.ilyichevsk.odessa.ua
Mime-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8bit
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

Hi folks,

Please CC me, I'm not on the list.

I think I see a bug.
I have a network with one segment going through cipe
tunnel which has MTU < 1500. There is a box at the end
of a tunnel which MASQUERADE everything:

                                 |
me===(1500)===router===(<1500)===|masq===(1500)===server
                                 |

MTU is in (), vertical bar depicts firewall.
Server does not see anything except masq box.
At least in theory.

When I try to mount NFS shares on server from my box,
NFS traffic halts after some ~30 seconds.

tcpdump revealed the problem. Unfortunately I didn't
save that dump, I'll resort to describing it.

This is a masq box. It has two ip addrs:
tunnel ip and ethernet ip:

             |
..====== t_ip|MASQ e_ip ====..
             |

This is what I see on the wire:

masq <--------- server sends almost 1500 byte NFS udp packet
		to the masq ip addr. Packet has DF set

masq sees that it won't fit into smaller MTU of a cipe tunnel.

masg sends 'icmp fragmentation required' ---------> server
but source ip is t_ip instead of e_ip!

server naturally ignores this icmp packet

Is this a known problem?
--
vda
