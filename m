From: =?big5?q?tin=20man=20chan?= <chantinman40@yahoo.com.hk>
Subject: Problem in NAT between ipsec gateway and ipsec client
Date: Wed, 27 Nov 2002 17:58:30 +0800 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021127095830.4906.qmail@web41010.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: 8bit
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

I have setup the following network and wish the ipsec
client behind a Linux NAT box can connect to ipsec
gateway.

----------        ---------        -----------
| IPSec  |  LAN1  | Linux |  LAN2  | IPSec   |
|        |--------| NAT   |--------|         |
| client |        | Box   |        | Gateway |
----------        ---------        -----------

In the Linux box, I type the following command to
enable NAT

echo "1" > /proc/sys/net/ipv4/ip_forward
iptables -A FORWARD -i $INT -j ACCEPT
iptables -t nat -A POSTROUTING -o $EXT -j MASQUERADE

The client can connect to any pc behind NAT but it
cannot make a ipsec tunnel to ipsec gateway. I have
used tcpdump to check that there are udp packets
(dport 500) coming from IPSec client via NAT to IPSec
gateway but the gateway does not response to the
packets. Of course, the IPSec client and gateway can
work when there is no NAT between.

Any idea or comment? Do I need to patch iptables or
kernel? If yes, where can I get the patch? Thanks a
lot.

William

_________________________________________________________
人氣交友熱線#9351 話「友」就有
http://hk.yahoo.com/promotions/personals/9351
