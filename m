From: Tom Eastep <teastep@shorewall.net>
Subject: Policy match with a bridge
Date: Sat, 14 Aug 2004 17:32:08 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <411EAF08.3000401@shorewall.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I'm seeing odd behavior of policy match when used with a bridge.

wookie:/backup # iptables -L -n -v
Chain INPUT (policy ACCEPT 12M packets, 1412M bytes)
~ pkts bytes target     prot opt in     out     source
destination

Chain FORWARD (policy ACCEPT 57181 packets, 12M bytes)
~ pkts bytes target     prot opt in     out     source
destination

Chain OUTPUT (policy ACCEPT 16M packets, 21G bytes)
~ pkts bytes target     prot opt in     out     source
destination

wookie:/backup # iptables -A OUTPUT -m policy --pol ipsec --dir out -j LOG

wookie:/backup # ping tipper
PING tipper.shorewall.net (192.168.1.8) 56(84) bytes of data.
64 bytes from tipper.shorewall.net (192.168.1.8): icmp_seq=1 ttl=64
time=4.45 ms
64 bytes from tipper.shorewall.net (192.168.1.8): icmp_seq=2 ttl=64
time=3.81 ms
64 bytes from tipper.shorewall.net (192.168.1.8): icmp_seq=3 ttl=64
time=3.48 ms
64 bytes from tipper.shorewall.net (192.168.1.8): icmp_seq=4 ttl=64
time=3.56 ms
64 bytes from tipper.shorewall.net (192.168.1.8): icmp_seq=5 ttl=64
time=4.16 ms
64 bytes from tipper.shorewall.net (192.168.1.8): icmp_seq=6 ttl=64
time=3.71 ms

- --- tipper.shorewall.net ping statistics ---
6 packets transmitted, 6 received, 0% packet loss, time 5010ms
rtt min/avg/max/mdev = 3.483/3.863/4.452/0.340 ms

wookie:/backup # setkey -D
192.168.1.3 192.168.1
~        esp mode=transport spi=170223379(0x0a256713) reqid=0(0x00000000)
~        E: 3des-cbc  7ebd7b0f a852467c ada833a2 3b5744fc 4ab0d47d b347e694
~        A: hmac-sha1  64872be1 24233626 6429e838 8dcb7a15 159bfb12
~        seq=0x00000000 replay=4 flags=0x00000000 state=mature
~        created: Aug 14 11:04:49 2004   current: Aug 14 17:19:23 2004
~        diff: 22474(s)  hard: 43200(s)  soft: 34560(s)
~        last: Aug 14 11:04:49 2004      hard: 0(s)      soft: 0(s)
~        current: 2416880(bytes) hard: 0(bytes)  soft: 0(bytes)
~        allocated: 8941 hard: 0 soft: 0
~        sadb_seq=1 pid=30723 refcnt=0
192.168.1.8 192.168.1.3
~        esp mode=transport spi=233099158(0x0de4cf96) reqid=0(0x00000000)
~        E: 3des-cbc  ce5a582a f621e4e5 84597866 ef941902 f4140957 01ada36d
~        A: hmac-sha1  3a9394f7 439b0f4e 4fed679a 74710c67 c658146e
~        seq=0x00000000 replay=4 flags=0x00000000 state=mature
~        created: Aug 14 11:04:49 2004   current: Aug 14 17:19:23 2004
~        diff: 22474(s)  hard: 43200(s)  soft: 34560(s)
~        last: Aug 14 11:04:49 2004      hard: 0(s)      soft: 0(s)
~        current: 1208740(bytes) hard: 0(bytes)  soft: 0(bytes)
~        allocated: 12222        hard: 0 soft: 0
~        sadb_seq=0 pid=30723 refcnt=0


wookie: /backup # iptables -L OUTPUT -n -v
Chain OUTPUT (policy ACCEPT 16M packets, 21G bytes)
~ pkts bytes target     prot opt in     out     source
destination
~    0     0 LOG        all  --  *      *       0.0.0.0/0
0.0.0.0/0           policy match dir out pol ipsec
LOG flags 0 level 4


wookie:/backup # brctl show
bridge name     bridge id               STP enabled     interfaces
br0             8000.0040d0073a1b       no              eth1
~                                                        eth0
~                                                        eth2

wookie:/backup # ip addr ls br0
6: br0: <BROADCAST,MULTICAST,NOTRAILERS,UP> mtu 1500 qdisc noqueue
~    link/ether 00:40:d0:07:3a:1b brd ff:ff:ff:ff:ff:ff
~    inet 192.168.1.3/24 brd 192.168.1.255 scope global br0
~    inet6 fe80::240:d0ff:fe07:3a1b/64 scope link
~       valid_lft forever preferred_lft forever


wookie:/backup # uname -a
Linux wookie 2.6.5-7.104-default #1 Wed Jul 28 16:42:13 UTC 2004 i586
i586 i386 GNU/Linux
wookie:/backup #

- -Tom
- --
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFBHq8IO/MAbZfjDLIRAvKSAJ94NFMjdEYBOFzZeh0Cg2LpCpLYZgCdHl/7
NTIe5dxB4jbSMfvSEu0Am7s=
=q4Ie
-----END PGP SIGNATURE-----
