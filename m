From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH/RFC 0/5] bridge-netfilter
Date: Tue, 30 Mar 2010 16:15:37 +0200
Message-ID: <4BB20789.7030307@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:53197 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab0C3OPk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:15:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The following patches incorporate some cleanup and fixes for
bridge-netfilter. Please comment or apply.

[1/5] cleanup br_netfilter.c:
  - remove some of the graffiti at the head of br_netfilter.c
  - remove __br_dnat_complain()
  - remove KERN_INFO messages when CONFIG_NETFILTER_DEBUG is defined

[2/5] update a comment in br_forward.c about ip_fragment()
ip_refrag isn't used anymore in the bridge-netfilter code

[3/5] simplify IP DNAT and fix IP DNAT on encapsulated packets
  - Add some code in br_device.c::br_dev_xmit() which enables the
removal of br_netfilter.c::br_nf_local_out(). The function
br_nf_local_out() was needed because the PF_BRIDGE::LOCAL_OUT hook could
be called when IP DNAT happens on to-be-bridged traffic. The new scheme
eliminates this mess.
  - Speed up IP DNAT. To obtain the correct destination MAC address,
neigh_hh_output() or dst->neighbour->output() is called. In both cases
this results in the queueing of the packet. However, if dst->hh is
available, we already know the MAC address so we can just copy it
instead, removing the need for neigh_hh_output(). This MAC address is
copied in the new function neigh_hh_bridge().
  - fix IP DNAT on vlan- or pppoe-encapsulated traffic: The functions
neigh_hh_output() or dst->neighbour->output() overwrite the complete
Ethernet header, although we only need the destination MAC address. For
encapsulated packets, they ended up overwriting the encapsulating
header. The new code copies the Ethernet source MAC address and protocol
number before calling dst->neighbour->output(). The Ethernet source MAC
and protocol number are copied back in place in
br_nf_pre_routing_finish_bridge_slow(). This also makes the IP DNAT more
transparent because in the old scheme the source MAC of the bridge was
copied into the source address in the Ethernet header. We also let
skb->protocol equal ETH_P_IP resp. ETH_P_IPV6 during the execution of
the PF_INET resp. PF_INET6 hooks.

[4/5] fix refragmenting IP traffic encapsulated in PPPoE traffic:
The MTU for IP traffic encapsulated inside PPPoE traffic is smaller than
the MTU of the Ethernet device (1500). Connection tracking gathers all
IP packets and sometimes will refragment them in ip_fragment(). We then
need to subtract the length of the encapsulating header from the mtu
used in ip_fragment(). The check in br_nf_dev_queue_xmit() which
determines if ip_fragment() has to be called is also updated for the
PPPoE-encapsulated packets. nf_bridge_copy_header() is also updated to
make sure the PPPoE data length field has the correct value.

[5/5] use the vlan id as part of the connection tracking tuple for
bridged traffic:
Currently connection tracking isn't aware of the vlan id that bridged
encapsulated IP packets belong to. Since it's possible to enable
filtering of bridged IP traffic encapsulated in a vlan header, we have a
security risk if an overlapping IP network range is used on different
vlan networks. By making the connection tracking code use the vlan id as
part of the tuple, we eliminate this security risk. Something similar
could be done for IP traffic encapsulated in PPPoE, but I'm not sure
it's worth the effort.

 include/linux/netfilter_bridge.h           |   20 +-
 include/net/neighbour.h                    |   14 +
 include/net/netfilter/nf_conntrack_tuple.h |    9 -
 net/bridge/br_device.c                     |   15 +
 net/bridge/br_forward.c                    |    2
 net/bridge/br_netfilter.c                  |  250
+++++++++--------------------
 net/ipv4/ip_output.c                       |    4
 net/netfilter/nf_conntrack_core.c          |    9 +
 8 files changed, 144 insertions(+), 179 deletions(-)

Bart De Schuymer (5):
bridge-netfilter: cleanup br_netfilter.c
bridge-netfilter: update a comment in br_forward.c about ip_fragment()
bridge-netfilter: simplify IP DNAT and fix IP DNAT on encapsulated packets
bridge-netfilter: fix refragmenting IP traffic encapsulated in PPPoE traffic
bridge-netfilter: use the vlan id as part of the connection tracking
tuple for bridged traffic

-- 
Bart De Schuymer
www.artinalgorithms.be

