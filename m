From: "Aaron Stavens" <aaron.stavens@nmwco.com>
Subject: Proxy ARP doesn't seem to be working. Please assist.
Date: Mon, 31 Jan 2005 10:38:36 -0800
Message-ID: <68B9548ED9F8A341B21CDB320655D613F54E4D@mercury.nmwco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
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

Martijn Lievaart over on the netfilter list suggested I post my query
here. I am trying to set up proxy ARP. As far as he can tell, I'm doing
it right, but it is working for neither him nor me. Martijn claims this
method used to work in the 2.2 kernel. Has something changed?

On the proxy arp machine I issue:

    arp -i eth0 -s 10.128.240.1 00:c0:4f:68:ab:e6 pub

and

    arp -i eth0 -Ds 10.128.240.2 eth0 pub

"arp -a" then reports:

    ? (10.128.1.1) at 00:06:53:02:F8:51 [ether] on eth0
    ? (10.128.240.1) at * PERM PUP on eth0
    ? (10.128.240.2) at * PERM PUP on eth0

The "*" instead of eth0's MAC address bothers me, but maybe that is
normal. I don't know.

On a separate machine I then

    ping 10.128.240.1

and

    ping 10.128.240.2

while sniffing the network. In the network trace I see the ARP requests
go out for the two different IP addresses, but not ARP responses come
back. I do not understand why there is no response. Does what I am doing
appear reasonable? Is there some kernel configuration option I must,
well, configure? Is there a /proc setting I need to tweak? What am I
missing?

Martijn also suggested that the proxy ARP server will only respond when
it has a route to the associated IP address. However, he says he tried
it and that didn't work either.

I am using RedHat 9 with a 2.4.23 kernel. I do not know what Martijn is
using.

Thanks,
Aaron Stavens
