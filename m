From: "Colin Paton" <cozzarp@hotmail.com>
Subject: Netfilter/PPTP/GRE weirdness - only when used with 'tap' device
Date: Tue, 15 Jun 2004 14:30:46 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BAY22-F4x5ElptLnpp000050866@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

Hi all,

I am experiencing an strange problem when using netfilter with a 'tap' 
network device.  The problem seems to relate specifically to GRE/PPTP 
connection tracking.

I have a test set-up of a Windows laptop, going through a Linux NAT gateway 
to a Windows PPTP server.  The Linux gateway is deliberately set up in a 
rather strange way, which I will explain...

Packets from the laptop arrive on the physical eth1.6 network interface, 
which has no IP address. They are passed through a user-space program which 
opens a socket on eth1.6 in raw mode, and logs certain packets. This passes 
the packets back into a 'tap' network device, created by the user-space app.

The 'tap' device is configured with the static IP address 10.6.0.1. Packets 
then flow through netfilter, and are NATted as normal, and most things work 
OK.

However, there appears to be an issue with PPTP/GRE connections. The server 
has the modules

ip_conntrack_pptp
ip_conntrack_proto_gre
ip_nat_pptp
ip_nat_proto_gre

...compiled into the kernel.

When these modules are not loaded then GRE traffic traverses through the tun 
interface and is NATted correctly, but obviously no connection tracking is 
performed.

When the modules are loaded, however, the problem occurs.

The PPTP connection set-up goes across TCP as normal. The laptop then sends 
its first gre encapsulated packet. This is NATted and arrives at the PPTP 
server OK.

However, when the PPTP server sends a GRE response the Linux NAT machine 
responds with an ICMP protocol unreachable message.

/proc/net/ip_conntrack shows that  the GRE conntrack state is 'unreplied'.

What's weird however, is that things work fine when the user-space program 
is not in the way. Of course, my first reaction was that the user space 
program must be at fault, but a dump with 'ethereal' on the virtual adaptor 
shows that it's passing packets correctly.

I removed all firewall rules, except for a '-j ACCEPT' rule for all in the 
FORWARD chain, and a MASQUERADE entry for 10.6.0.0/24 addresses in the 
POSTROUTING chain. With this configuration, all protocols would appear to be 
NATted.

If the virtual adaptor is removed, and the eth1.6 interface is configured 
with a 10.6.0.1 address then everything works perfectly, with the modules.

There therefore seems to be either:

a) A difference between the 'tap' adaptor and a 'real' ethernet adaptor, 
which netfilter doesn't like. Looking at the code for 'tap' I can't see 
anything that would cause this.
b) Netfilter is confused because a packet is coming in one interface 
(eth1.6) and then being reinjected into the tun interface.
c) A bug in the user-space app. I have discounted this, as the first packet 
is being correctly passed - it's the response that isn't. In addition, if 
the user-space app had a bug then I don't think PPTP would work without 
connection tracking.

Given that the problem only occurs with the above modules in place I began 
to try and track down which module was rejecting the packet.

It would appear that ip_nat_proto_gre.c function gre_manip_pkt() is only 
being called for the first packet (client->PPTP server) and is not being 
called for the response (PPTP server->laptop) - or at least a DEBUGP there 
only occurs once.

I *think* (but this is where I begin to get out of my depth a bit) that the 
correct keymap entries aren't being added to the tables in 
ip_conntrack_proto_gre, and hence the gre_manip_pkt() isn't being called for 
the return entry. I'm not sure why though.

I turned on all debugging, and got a bit overwhelmed by it though. I have 
done some filtering and think that the relevant stuff (grepped on 
'ip_conntrack_proto_gre') is below.

(The addresses are laptop: 10.6.0.2->Linux 10.6.0.1 NAT Linux 
192.168.1.2->VPN server 192.168.1.104)

...gre_keymap_lookup() always returns 'match not found' when in the failed 
state.

This problem sounds so extremely weird that it smacks that I've gone too far 
down in the wrong direction. It also smacks of me being a bit lost within 
netfilter, but please don't comment on that :-)

I'm sure I'm doing something dumb... so kudos to anyone who can figure out 
what it is!

Please - if anybody can figure out what's happening then let me know and 
I'll be highly grateful!

Thanks,

Colin


Broken state debug:
==================

phoenix:~# tail -f /var/log/kern.log |grep 'ip_conntrack_proto_gre.c'
Jun 15 12:10:57 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_add_R98b7fe84: adding new entry 
c2b6a800: 10.6.0.2:0x439 -> 192.168.1.104:0xfb8:1:0x880b
Jun 15 12:10:57 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_add_R98b7fe84: adding new entry 
c2b6a820: 192.168.1.104:0xfb8 -> 10.6.0.2:0x439:1:0x880b
Jun 15 12:10:57 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_add_R98b7fe84: adding new entry 
c2b6a860: 192.168.1.104:0xfb8 -> 192.168.1.2:0x439:1:0x880b
Jun 15 12:10:57 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_add_R98b7fe84: adding new entry 
c2b6a840: 192.168.1.2:0x439 -> 192.168.1.104:0xfb8:1:0x880b
Jun 15 12:10:57 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_change_R56991fa9: changing entry 
c2b6a860 to: 192.168.1.104:0xfb8 -> 192.168.1.2:0x439:1:0x880b
Jun 15 12:10:57 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_change_R56991fa9: changing entry 
c2b6a840 to: 10.6.0.2:0xc000 -> 192.168.1.104:0xfb8:1:0x880b
Jun 15 12:10:57 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_change_R56991fa9: changing entry 
c2b6a800 to: 10.6.0.2:0xc000 -> 192.168.1.104:0xfb8:1:0x880b
Jun 15 12:10:57 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_change_R56991fa9: changing entry 
c2b6a820 to: 192.168.1.104:0xfb8 -> 192.168.1.2:0x439:1:0x880b
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_pkt_to_tuple: 
COLIN_DEBUG - gre_pkt_to_tuple
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_key_cmpfn: 
COLIN_DEBUG - gre_key_cmpfn - src: 200060a,200060a dst: 6801a8c0,6801a8c0 - 
match 1
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_keymap_lookup: 
COLIN_DEBUG - gre_keymap_lookup - found key 12582912
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_new: : 
10.6.0.2:0xc000 -> 192.168.1.104:0xfb8:1:0x880b
Jun 15 12:10:57 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_destroy_R5f89c60b: entering for 
exp cdc322c0
Jun 15 12:10:57 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_destroy_R5f89c60b: removing 
c2b6a860 from list
Jun 15 12:10:57 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_destroy_R5f89c60b: removing 
c2b6a840 from list
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_destroy:  
entering
Jun 15 12:10:57 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_destroy_R5f89c60b: entering for 
exp cdc321c0
Jun 15 12:10:57 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_destroy_R5f89c60b: removing 
c2b6a800 from list
Jun 15 12:10:57 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_destroy_R5f89c60b: removing 
c2b6a820 from list
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_pkt_to_tuple: 
COLIN_DEBUG - gre_pkt_to_tuple
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_keymap_lookup: 
COLIN_DEBUG - gre_keymap_lookup - match not found
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_new: : 
10.6.0.2:0x0 -> 192.168.1.104:0xfb8:1:0x880b
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_pkt_to_tuple: 
COLIN_DEBUG - gre_pkt_to_tuple
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_keymap_lookup: 
COLIN_DEBUG - gre_keymap_lookup - match not found
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_new: : 
192.168.1.104:0x0 -> 192.168.1.2:0x439:1:0x880b
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_pkt_to_tuple: 
COLIN_DEBUG - gre_pkt_to_tuple
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_keymap_lookup: 
COLIN_DEBUG - gre_keymap_lookup - match not found
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_pkt_to_tuple: 
COLIN_DEBUG - gre_pkt_to_tuple
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_keymap_lookup: 
COLIN_DEBUG - gre_keymap_lookup - match not found
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_pkt_to_tuple: 
COLIN_DEBUG - gre_pkt_to_tuple
Jun 15 12:10:57 phoenix kernel: ip_conntrack_proto_gre.c:gre_keymap_lookup: 
COLIN_DEBUG - gre_keymap_lookup - match not found

Working
-------

Jun 15 12:11:50 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_add_R98b7fe84: adding new entry 
ce053b80: 10.6.0.2:0x43a -> 192.168.1.104:0xfd05:1:0x880b
Jun 15 12:11:50 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_add_R98b7fe84: adding new entry 
cf5fc8e0: 192.168.1.104:0xfd05 -> 10.6.0.2:0x43a:1:0x880b
Jun 15 12:11:50 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_add_R98b7fe84: adding new entry 
cf5fcda0: 192.168.1.104:0xfd05 -> 192.168.1.2:0x43a:1:0x880b
Jun 15 12:11:50 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_add_R98b7fe84: adding new entry 
c2b6a880: 192.168.1.2:0x43a -> 192.168.1.104:0xfd05:1:0x880b
Jun 15 12:11:50 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_change_R56991fa9: changing entry 
cf5fcda0 to: 192.168.1.104:0xfd05 -> 192.168.1.2:0x43a:1:0x880b
Jun 15 12:11:50 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_change_R56991fa9: changing entry 
c2b6a880 to: 10.6.0.2:0x0 -> 192.168.1.104:0xfd05:1:0x880b
Jun 15 12:11:50 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_change_R56991fa9: changing entry 
ce053b80 to: 10.6.0.2:0x0 -> 192.168.1.104:0xfd05:1:0x880b
Jun 15 12:11:50 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_change_R56991fa9: changing entry 
cf5fc8e0 to: 192.168.1.104:0xfd05 -> 192.168.1.2:0x43a:1:0x880b
Jun 15 12:11:50 phoenix kernel: ip_conntrack_proto_gre.c:gre_pkt_to_tuple: 
COLIN_DEBUG - gre_pkt_to_tuple
Jun 15 12:11:50 phoenix kernel: ip_conntrack_proto_gre.c:gre_key_cmpfn: 
COLIN_DEBUG - gre_key_cmpfn - src: 200060a,200060a dst: 6801a8c0,6801a8c0 - 
match 1
Jun 15 12:11:50 phoenix kernel: ip_conntrack_proto_gre.c:gre_keymap_lookup: 
COLIN_DEBUG - gre_keymap_lookup - found key 0
Jun 15 12:11:50 phoenix kernel: ip_conntrack_proto_gre.c:gre_new: : 
10.6.0.2:0x0 -> 192.168.1.104:0xfd05:1:0x880b
Jun 15 12:11:50 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_destroy_R5f89c60b: entering for 
exp cf3810a0
Jun 15 12:11:50 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_destroy_R5f89c60b: removing 
cf5fcda0 from list
Jun 15 12:11:50 phoenix kernel: 
ip_conntrack_proto_gre.c:ip_ct_gre_keymap_destroy_R5f89c60b: removing 
c2b6a880 from list
Jun 15 12:11:50 phoenix kernel: ip_conntrack_proto_gre.c:gre_pkt_to_tuple: 
COLIN_DEBUG - gre_pkt_to_tuple
Jun 15 12:11:50 phoenix kernel: ip_conntrack_proto_gre.c:gre_key_cmpfn: 
COLIN_DEBUG - gre_key_cmpfn - src: 200060a,6801a8c0 dst: 6801a8c0,201a8c0 - 
match 0
Jun 15 12:11:50 phoenix kernel: ip_conntrack_proto_gre.c:gre_key_cmpfn: 
COLIN_DEBUG - gre_key_cmpfn - src: 6801a8c0,6801a8c0 dst: 201a8c0,201a8c0 - 
match 1
Jun 15 12:11:50 phoenix kernel: ip_conntrack_proto_gre.c:gre_keymap_lookup: 
COLIN_DEBUG - gre_keymap_lookup - found key 100466688
Jun 15 12:11:50 phoenix kernel: ip_conntrack_proto_gre.c:gre_pkt_to_tuple: 
COLIN_DEBUG - gre_pkt_to_tuple
Jun 15 12:11:50 phoenix kernel: ip_conntrack_proto_gre.c:gre_key_cmpfn: 
COLIN_DEBUG - gre_key_cmpfn - src: 200060a,6801a8c0 dst: 6801a8c0,201a8c0 - 
match 0
Jun 15 12:11:50 phoenix kernel: ip_conntrack_proto_gre.c:gre_key_cmpfn: 
COLIN_DEBUG - gre_key_cmpfn - src: 6801a8c0,6801a8c0 dst: 201a8c0,201a8c0 - 
match 1
Jun 15 12:11:50 phoenix kernel: ip_conntrack_proto_gre.c:gre_keymap_lookup: 
COLIN_DEBUG - gre_keymap_lookup - found key 100466688

_________________________________________________________________
Want to block unwanted pop-ups? Download the free MSN Toolbar now!  
http://toolbar.msn.co.uk/
