From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: difference of behavior between ip_tables.c and ip6_tables.c in
 kernel
Date: Mon, 14 Jun 2004 21:38:02 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200406141238.VAA11627@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org
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


Hi,

I found that ip6_packet_match() skips AH(Authentication Header) but
ip_packet_match() doesn't skip AH. Then "ip6tables -A INPUT -p tcp -j DROP"
matches AHed IPv6 packets but "iptables -A INPUT -p tcp -j DROP" doesn't match
AHed IPv4 packets.

I think these commands should be behave in the same way. But do you think
which behavior is better ?

If skipping AH, we can specify the inner protocol of AH/IPv4. But it is needed
to change more codes because tcp_match(), udp_match(), etc. assume that
protocol header is next of IPv4 header.

Otherwise, we'll just delete a few code from ip6_packet_match(). But we can't
specify inner protocol.

My ideal solution is the former. I think it is better that match() in matching
module has "int protoff" argument which points to transport protocol header. 

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
