From: "Huy Vu Pham" <markoflinux@gmail.com>
Subject: SIP NAT CONTRACK Module with Netfilter in kernel 2.4.x
Date: Thu, 2 Mar 2006 18:12:05 +0700
Message-ID: <cb81d4010603020312q3309cd70w27fd5862744eb09f@mail.gmail.com>
References: <cb81d4010603020310x1f865d2dhf14088682952108@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <cb81d4010603020310x1f865d2dhf14088682952108@mail.gmail.com>
Content-Disposition: inline
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

Dear Netfilter Devel list,
I got problem very strange with Netfilter in linux kernel 2.4.x.

I apply contrack/nat SIP protocol
(http://openwrt.alphacore.net/patches/buildroot/317-netfilter-nat-sip
)  with HELPER module to capture all RTP packets.
(
#Out from WAN site: eth1
iptables -t mangle -A POSTROUTING -o eth1 -p UDP -m helper --helper
sipd00 -j MARK --set-mark 0x20
#Out from LAN site: eth0
iptables -t mangle -A POSTROUTING -o eth0 -p UDP -m helper --helper
sipd00 -j MARK --set-mark 0x21
)

My test case like this:
SIP PHONE A (Outside NAT) ----- NAT BOX (Have SIP ALG) ------- SIP
PHONE B (Inside NAT).

1. Reboot NAT BOX, A call B. SIP MODULE can capture all RTP packets,
Before RTP timeout, I make the call from B to A also OK.

2. Reboot NAT BOX, B call A. SIP MODULE "CAN NOT" capture any RTP packets.
Before RTP timeout, I make the call from A to B also got the same problem.

What is difference between case (1) and case(2)?

I already tested with kernel from 2.4.20 to 2.4.32. The problem is the same=
.

Thanks,
