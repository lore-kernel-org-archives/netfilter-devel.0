From: "Daniel Chemko" <dchemko@smgtec.com>
Subject: RE: Routing decision?
Date: Mon, 15 Sep 2003 13:10:33 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <7C9884991ADAE0479C14F10C858BCDF5122E38@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: <netfilter-devel@lists.netfilter.org>,
	<pieter@able.be>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Class: urn:content-classes:message
To: "Henrik Nordstrom" <hno@marasystems.com>,
	"Wim Ceulemans" <wim.ceulemans@able.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I am trying to do something very similarly. I am having a heck of a time
managing to get this all working properly.=20

Setup:
Two interfaces: eth0(default), eth2

# Add routing table entries for eth2
ip route add default via <my isp gw> src <myip> dev eth2 table 100
ip rule add fwmark 1 table 100

# Add rule to forward to ISP #2
iptables -t mangle -A OUTPUT -p tcp --dport 80 -m state --state NEW -j
MARK --set-mark 1

The traffic is getting routed out of eth2, but any ARP requests sent out
of eth2 has the respond to field set too the IP address mapped to eth0.
Is there an ARP source address flag that isn't getting set right, or is
it just my wacky configuration?

I am using this with squid in userspace, and I am unaware of any way to
get squid to bind its outbound interface. If I could bind to just an IP
address which is normally the case, I still can't function without
hacking because the interfaces are on DHCP.

Sorry for the question in devel, but Netfilter general didn't come up
with a solution.


-----Original Message-----
From: Henrik Nordstrom [mailto:hno@marasystems.com]=20
Sent: Monday, September 15, 2003 12:49 PM
To: Wim Ceulemans
Cc: netfilter-devel@lists.netfilter.org; pieter@able.be
Subject: Re: Routing decision?

On Mon, 15 Sep 2003, Wim Ceulemans wrote:

> Here's why: if you want to mark packets in the OUTPUT chain that are
> http traffic, based on the destination port. And then based on that
mark
> send the packets to another routing table added with the ip command.

Then do so. iptables will make the needed re-routing of the packet when=20
the nfmark is modified.

But you can't use this to select the source IP address as this has
already
been done and must be done before the packet is constructed (and sent to
iptables), however you can use NAT to rewrite the source IP address if
not
assigned suitably or alternaively (preferred) have the application use a
suitable source IP address to begin with.

Regards
Henrik
