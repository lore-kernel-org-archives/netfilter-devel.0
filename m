From: Tom Eastep <teastep@shorewall.net>
Subject: Re: Policy match with a bridge
Date: Sun, 15 Aug 2004 08:04:39 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <411F7B87.7060303@shorewall.net>
References: <411EAF08.3000401@shorewall.net> <411F5D5E.4000001@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <411F5D5E.4000001@trash.net>
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

Patrick McHardy wrote:
| Tom Eastep wrote:
|
|> -----BEGIN PGP SIGNED MESSAGE-----
|> Hash: SHA1
|>
|> I'm seeing odd behavior of policy match when used with a bridge.
|>
|> wookie:/backup # uname -a
|> Linux wookie 2.6.5-7.104-default #1 Wed Jul 28 16:42:13 UTC 2004 i586
|> i586 i386 GNU/Linux
|
|
| Have you applied the ipsec+netfilter patches ? Without them, packets are
| only seen encrypted in the OUTPUT chain.
|
Yes -- the ipsec+netfilter patches are applied. Here is the same test
with the bridge removed and the local ip address transfered to one of
the network cards:

wookie:~ # iptables -L -n -v
Chain INPUT (policy ACCEPT 137 packets, 18014 bytes)
~ pkts bytes target     prot opt in     out     source
destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
~ pkts bytes target     prot opt in     out     source
destination

Chain OUTPUT (policy ACCEPT 100 packets, 14110 bytes)
~ pkts bytes target     prot opt in     out     source
destination
wookie:~ # iptables -A OUTPUT -m policy --pol ipsec --dir out -j ACCEPT
wookie:~ # ping tipper
PING tipper.shorewall.net (192.168.1.8) 56(84) bytes of data.
64 bytes from tipper.shorewall.net (192.168.1.8): icmp_seq=1 ttl=64
time=4.19 ms
64 bytes from tipper.shorewall.net (192.168.1.8): icmp_seq=2 ttl=64
time=3.45 ms
64 bytes from tipper.shorewall.net (192.168.1.8): icmp_seq=3 ttl=64
time=3.49 ms
64 bytes from tipper.shorewall.net (192.168.1.8): icmp_seq=4 ttl=64
time=3.32 ms

- --- tipper.shorewall.net ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3002ms
rtt min/avg/max/mdev = 3.327/3.617/4.195/0.339 ms
wookie:~ # iptables -L -n -v
Chain INPUT (policy ACCEPT 482 packets, 50100 bytes)
~ pkts bytes target     prot opt in     out     source
destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
~ pkts bytes target     prot opt in     out     source
destination

Chain OUTPUT (policy ACCEPT 269 packets, 36010 bytes)
~ pkts bytes target     prot opt in     out     source
destination
~   28  3376 ACCEPT     all  --  *      *       0.0.0.0/0
0.0.0.0/0           policy match dir out pol ipsec

wookie:~ #

- -Tom
- --
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFBH3uHO/MAbZfjDLIRAvIhAJ4x6l+LJ7pSp/vnrqHlSeOidn0oAACgrZv6
Xrm70xeiqgHYKOle8YSce14=
=ZChs
-----END PGP SIGNATURE-----
