From: Mario <netfilter@mail.bg>
Subject: TTL Target DOESN'T work with kernel 2.6.x!
Date: Mon, 23 Feb 2004 07:56:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200402230756.53183.netfilter@mail.bg>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I've tried the latest pom-ng.The patch applies successful.
I precompile the kernel 2.6.3 after that iptables 1.2.9.
I insert PREROUTING rules in the mangle table to set incoming TTL.

iptables -A PREROUTING -i eth0 -p tcp -j TTL --ttl-set 65 (from internal net)
iptables -A PREROUTING -i eth1 -j TTL --ttl-set 64 (from external)

Chain PREROUTING (policy ACCEPT 18M packets, 15G bytes)
 pkts bytes target     prot opt in     out     source              destination
 344K   21M TTL        tcp  --  eth0   any     anywhere             anywhere 
TTL set to 65
3445K 3209M TTL        all  --  eth1   any     anywhere             anywhere            
TTL set to 64

No erros. I'm pinging some hosts but there ttl wasn't set. Using
tcpdump i saw that ttl was changed (may be) it looks like that.

ftp.bs.spnet.net is from external net (eth1) TTL shoud be set to 64!!!

root@darkstar:~$ tcpdump -v -i eth1 dst 172.16.111.111
07:44:44.954151 ftp.bs.spnet.net > 172.16.111.111: icmp: echo reply (DF) [tos 
0x60]  (ttl 64, id 0, len 84)

but 

root@darkstar:~$ ping ftp.bs.spnet.net
PING debian.bs.spnet.net (212.50.0.39) 56(84) bytes of data.
64 bytes from ftp.bs.spnet.net (212.50.0.39): icmp_seq=1 ttl=1 time=2.40 ms

Local programs show me the real ttl, not the set one. I tried to route to
my other pc it doesn't work (my ISP sets incoming ttl to 1)...my linux box 
sends time exceeded to the gateway.so whats the 
point? This patch doesn't work correctrly or maybe i'm wrong.
Does anybody know where the problem is? Did anybody test?

Mario

kernel 2.6.3 stable
iptables 1.2.9
patch-o-matic-ng-2004022 (CVS) TTL Target patch ONLY
