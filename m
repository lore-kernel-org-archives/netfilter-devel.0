From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.4 0/6]: netfilter resync
Date: Mon, 01 Aug 2005 02:42:13 +0200
Message-ID: <42ED6FE5.3080809@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

Hi Dave,

the following patches contain a number of backported fixes for
2.4 to resync it with 2.6.

[NETFILTER]: Ignore PSH on SYN/ACK in ipt_unclean
[NETFILTER]: Fix deadlock with ip_queue/ip6_queue
[NETFILTER]: Restore netfilter assumption in IPv6 multicast
[NETFILTER]: Fix ip6t_LOG sit tunnel logging
[NETFILTER]: Fix potential memory corruption in NAT code (aka memory NAT)
[NETFILTER]: Use correct byteorder in ICMP NAT
