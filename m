From: "Amir Khandani" <amirk@broadcom.com>
Subject: Multicast, IGMP, and NAT
Date: Mon, 8 Jul 2002 18:39:54 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <NEBBLANGHHJHJJOGHIJGAECACCAA.amirk@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

This may not be very relevant to the type of discussions done via this
mailing list but doesn't heart to ask anyway. So here it goes:

I have a laptop running linux and configure as the gateway between a local
subnet and the our corporate network. I will call this the "Linux Gateway"
from this point on. The "Linux Gateway" runs iptables and NATs for all
traffics between the private subnet and corporate network.

I have developed two simple java applications for sending and receiving
multicast traffic. I have a computer connected to the corporate networking
generating multicast traffic. Another computer on the private subnet ,behind
the "Linux Gateway", receiving that multicast traffic. However, with the
current configuration of my linux box I am not able to get the multicast
traffic through to the private side.

This is actually what I expected because there must be some software on the
"Linux Gateway" that understand the IGMP requests and takes care of group
management. I guess I can configure my the "Linux Gateway" to route
multicast traffic and that will probabaly solve this problem. But this is
not what I really want to do because I have heard that multicast routing
protocols are just too complicated. I am looking for the simpliest possile
soluation to solve this problem. In some ways, I need a piece of software
that "Proxies" the IGMP messages.

thanks for any insight,

Regards,

Amir Khandani
Broadband Systems Engineering
Broadcom
