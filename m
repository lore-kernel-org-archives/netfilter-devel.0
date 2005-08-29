From: Nikolai Malykh <nmalykh@ieee.org>
Subject: Updated source code for tbf match
Date: Mon, 29 Aug 2005 21:55:34 +0400
Message-ID: <43134C16.6050308@ieee.org>
Reply-To: nmalykh@ieee.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

Updated source code for tbf match availiable at 
http://www.nmalykh.org/work/tbf.tar.gz

new source code is compatible with new kernel 2.6.13

You can see short info about this match below

----------------------------------------------------
This adds an iptables match which allows you to create packet rate 
threshold per any combination srcip, srcport, dstip, dstport. In 
`nothing' mode this match works like `limit' match (excluding inversion 
option supported tbf). In other modes tbf works like `hashlimit' match 
(excluding inversion supported tbf).
Inversion flag allow you to change matching for whole iptables rule 
(match/dont match).

Examples:

# allow up to 3 new SSH connections per hour for each client host. 4th 
client per hour will be rejected with icmp-admin-prohibited message
iptables -A INPUT -p tcp --dport ssh -m state --state NEW -m tbf ! \ 
--tbf 3/h --tbf-deep 1 --tbf-mode srcip --tbf-name SSH -j REJECT \ 
--reject-with icmp-admin-prohibited

# Log up to 10 pps for your DNS servers per server address:
iptables -A INPUT -p udp --dport domain -m tbf --tbf 10 --tbf-deep 2 \
  --tbf-mode dstip --tbf-name DNS -j LOG --log-prefix "IPTABLES-DNS: "

# Syn-flood attack protection per source
iptables -A INPUT -p tcp --syn -m tbf ! --tbf 10 --tbf-mode srcip \
--tbf-htable-name SYN -j DROP

# or drop scan packets from any source (like `limit')
iptables -A INPUT -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m tbf \
! --tbf 1/s --tbf-burst 2 --tbf-mode nothing --tbf-name Scan -j DROP

-- 
Nikolai Malykh
nmalykh@ieee.org

phone +7 (812) 449 0770
ICQ UIN 30741141
