From: Peteris Krumins <newsgroups@lf.lv>
Subject: iptables icmp protocol match bug.
Date: Thu, 31 Jul 2003 22:47:10 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <54265908055.20030731224710@lf.lv>
Reply-To: Peteris Krumins <newsgroups@lf.lv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

 A quick bug report:

 iptables -A INPUT -p icmp --icmp-type 255 -i lo -j REJECT

 this rule also denies icmp ping and i think anything else of icmp.

 Works for me at least on 2.4.22-pre6 and patch-o-matic-20030714
 havent tried w/ newer versions.
 
 Does not work on base 2.4.20 and iptables 1.2.7a

proof:
--
z@xor:/[1032]# iptables -A INPUT -p icmp --icmp-type 255 -i lo -j REJECT
z@xor:/[1033]# ping localhost -c 5
PING localhost (127.0.0.1): 56 octets data

--- localhost ping statistics ---
5 packets transmitted, 0 packets received, 100% packet loss

z@xor:/[1034]# iptables -D INPUT -p icmp --icmp-type 255 -i lo -j REJECT
z@xor:/[1035]# ping localhost -c 5
PING localhost (127.0.0.1): 56 octets data
64 octets from 127.0.0.1: icmp_seq=0 ttl=128 time=0.3 ms
64 octets from 127.0.0.1: icmp_seq=1 ttl=128 time=0.3 ms
^C


P.Krumins







netfilter-devel@lists.netfilter.org
