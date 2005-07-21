From: "Marek Sirdak" <marek@nevision.net>
Subject: (Probably) it's a bug
Date: Thu, 21 Jul 2005 21:49:22 +0200
Message-ID: <20050721194841Z1186111-31917+1237@kps8.test.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
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

Dear Netfilter developers:

 I'm using iptables to protect my company network. My Kernel version is
2.6.12 and iptables 1.3.2. Today I noticed that iptables cannot control
broadcast traffic. For example I'm using DHCPd (version 3.0.2). 
 Every computer in my network has it own entry in dhcpd.conf. There are no
IP range specified - for security reasons. If I set policy of chains INPUT,
FORWARD and OUTPUT to DROP (table: filter) with no entries in them, traffic
should be completly dropped. But I noticed that if computer from my network
will send DHCP-REQUEST he will recive DHCP-REPLY with address and he receive
his address despite iptables is set to DROP all of the traffic !!! I have
read from DHCPd readme file that on some systems above behaviour is normal,
but i think it isn't normal, because we say: "block all of the traffic" and
all traffic should be dropped. We know that first packets of DHCP requests
are broadcasts and renewal are unicast (unicast packets are dropped).

Please turn attention on it. I'm not an extra developer, but I think that
somebody can write some broadcast request that could violate server
security.

Greetings
Marek Sirdak
