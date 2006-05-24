From: "GuanYao Huang" <gyhuang@mail.ustc.edu.cn>
Subject: Problems with how to realise a simple myip6tables program
Date: Wed, 24 May 2006 11:49:05 +0800
Message-ID: <348442545.21384@ustc.edu.cn>
Reply-To: GuanYao Huang <gyhuang@mail.ustc.edu.cn>
Content-Type: text/plain
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

I am writting a myip6tables program to realize ROUTE and MARK target. (Of course I
shoule steal some codes from ip6tables). The ROUTE target is used to redirect a
flow to a ip6-ip6 tunnel.
After running my program I will see my ip6tables:
[root@gyhuang2 projectipv6]# ip6tables -t mangle -L -n
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
MARK       udp      2001:da8:d800:1234:1234::28/128  2001:da8:d800:1234::31/128udp
spts:1:65535 dpt:8080 MARK set 0x33
Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
ROUTE      udp      2001:da8:d800:1234:1234::28/128  2001:da8:d800:1234::31/128udp
spts:1:65535 dpt:8080 ROUTE oif:60804f817a

However, when using tcpdump, I can see there is no effect for my rules.

But, if I use the commads:
1, ip6tables -t mangle -I POSTROUTING -p udp -s 2001:da8:d800:1234:1234::28 -d
2001:da8:d800:1234::31 --sport 1:65535 --dport 8080 -j ROUTE --oif 60804f817a
2, ip6tables -t mangle -A FORWARD -p udp -s 2001:da8:d800:1234:1234::28 -d
2001:da8:d800:1234::31 --sport 1:65535 --dport 8080 -j MARK --set-mark 0x33
we can add two same rules(At least the same in ip6tables -t mangle -L -n). And
this time, we manage it.

[root@gyhuang2 projectipv6]# ip6tables -t mangle -L -n 
Chain PREROUTING (policy ACCEPT) 
target     prot opt source               destination
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
MARK       udp      2001:da8:d800:1234:1234::28/128  2001:da8:d800:1234::31/128udp
spts:1:65535 dpt:8080 MARK set 0x33
MARK       udp      2001:da8:d800:1234:1234::28/128  2001:da8:d800:1234::31/128udp
spts:1:65535 dpt:8080 MARK set 0x33
Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
ROUTE      udp      2001:da8:d800:1234:1234::28/128  2001:da8:d800:1234::31/128udp
spts:1:65535 dpt:8080 ROUTE oif:60804f817a
ROUTE      udp      2001:da8:d800:1234:1234::28/128  2001:da8:d800:1234::31/128udp
spts:1:65535 dpt:8080 ROUTE oif:60804f817a

It seems they are the same rules, however, no effect by my program.
I am wondering if someone else has done the same thing with me. I really do not
want to read the ip6tables source code. I used gdb to debug that this morning, but
it seems hard to manage in a short while.
