From: Fabian Thorns <fthorns@rooTH.DE>
Subject: dhcp-filtering
Date: Thu, 14 Nov 2002 12:49:53 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0211141238440.773-100000@neon.rooth.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

hi there,

i'm trying to filter dhcp-requests using iptables but it doesn't seem to
work. dhcp uses - as far as i know - udp port 68 to port 67. i blocked
these ports on the same machine my dhcp-server is running on but i didn't
work.

therefore i tried to temporarily block everything:
iptables -F
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -A INPUT -j LOG
iptables -A OUTPUT -j LOG

but even that didn't made my server stop answering dhcp-queries. the
syslog of the server shows that the udp-packages are blocked but the
dhcp-server handles the request nevertheless:
kernel: IN=eth0 OUT= MAC=ff:ff:ff:ff:ff:ff:00:00:e8:61:b4:26:08:00 SRC=0.0.0.0 DST=255.255.255.255 LEN=576 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP SPT=68 DPT=67 LEN=556
dhcpd: DHCPDISCOVER from 00:00:e8:61:b4:26 via eth0
dhcpd: DHCPOFFER on 192.168.207.210 to 00:00:e8:61:b4:26 via eth0
kernel: IN=eth0 OUT= MAC=ff:ff:ff:ff:ff:ff:00:00:e8:61:b4:26:08:00 SRC=0.0.0.0 DST=255.255.255.255 LEN=576 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP SPT=68 DPT=67 LEN=556
dhcpd: DHCPREQUEST for 192.168.207.210 (192.168.207.3) from 00:00:e8:61:b4:26 via eth0
dhcpd: DHCPACK on 192.168.207.210 to 00:00:e8:61:b4:26 via eth0

please note: i don't want to stop my dhcpd that way, i just came along
this problem by testing my dhcp-rules that allow dhcp-access.

i thing that it should be possible to filter dhcp-requests and since i
never heard of some special requirements needed for that propose it looks
like a bug or misbehavior to me.

regards

fabian
