From: Dave Johnson <dave-kernel@centerclick.org>
Subject: Wrong icmp6 checksum for ICMPV6_TIME_EXCEED in reverse SNATv6 path
Date: Tue, 18 Apr 2017 22:15:29 -0400
Message-ID: <22774.51265.265373.257836@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lexington.centerclick.org ([72.0.224.86]:43063 "EHLO
        lexington.centerclick.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933209AbdDSCXu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2017 22:23:50 -0400
Received: from alliance.centerclick.org (alliance.centerclick.org [IPv6:2606:8800:21:fe60::10])
        by lexington.centerclick.org (Postfix) with ESMTP id 72F45EE0A2
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 22:15:29 -0400 (EDT)
Received: from intrepid-wired.ind.centerclick.org ([10.10.63.2] helo=intrepid)
        by alliance.centerclick.org with esmtp (Exim 3.36 #1 (Debian))
        id 1d0f9V-0004Oo-00
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 22:15:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



I Have the following setup.

3 linux systems A, B, and C.

host A is an end host with IPv6 address Z2.

host B is doing v6/v6 forwarding (no NAT) between an ethernet
interface and a tun (openvpn) with addresses Z1 and Y2.

host C is doing v6/v6 SNAT between a tun (openvpn) and an
ethernet interface with addresses Y1 and X2.  X2 is a static address
so SNAT instead of MASQUERADE is used.


Network X is a public IPv6 subnet.

Networks Y and Z are private networks and need NAT66 SNAT on their way
to the internet done in host C.


  +--------+       +---------------+       +---------------+       +------...
  | host-A |       |     host-B    |       |     host-C    |       | internet
  |  IP-Z2 <- eth -> IP-Z1   IP-Y2 <- tun -> IP-Y1   IP-X2 <- eth -> IP-X1
  +--------+       +---------------+       +---------------+       +------...
                       (IPv6 Fwd)             (IPv6 SNAT)


See problem when doing a traceroute with icmp6 from host A to
internet.

All ICMPV6_TIME_EXCEED responses from X1 and beyond are getting
corrupted by host C on the reverse path back to host A.

Final hop return ICMPV6_ECHO_REPLY which is fine.

  host-A$ traceroute -6 --icmp -n www.google.com
  traceroute to www.google.com (2607:f8b0:4004:800::2004), 30 hops max, 80 byte packets
   1  [host-B-Z1]  0.313 ms  0.326 ms  0.371 ms
   2  [host-C-Y1]  19.732 ms  20.040 ms  20.051 ms
   3  * * *
   4  * * *
   5  * * *
   6  * * *
   7  * * *
   8  * * *
   9  * * *
  10  * * *
  11  2607:f8b0:4004:800::2004  26.670 ms  27.193 ms  27.202 ms

All those ICMPV6_TIME_EXCEED packets are corrupted by host C and are
discarded by host A:


host A is logging:

  Apr 18 17:10:56 host-A kernel: [9843084.191460] ICMPv6 checksum failed [some-internet-router-3 > host-A-Z2]
  Apr 18 17:10:56 host-A kernel: [9843084.191504] ICMPv6 checksum failed [some-internet-router-3 > host-A-Z2]
  Apr 18 17:10:56 host-A kernel: [9843084.193587] ICMPv6 checksum failed [some-internet-router-3 > host-A-Z2]
  Apr 18 17:10:56 host-A kernel: [9843084.196254] ICMPv6 checksum failed [some-internet-router-4 > host-A-Z2]
  Apr 18 17:10:56 host-A kernel: [9843084.196398] ICMPv6 checksum failed [some-internet-router-4 > host-A-Z2]
  Apr 18 17:10:56 host-A kernel: [9843084.196526] ICMPv6 checksum failed [some-internet-router-4 > host-A-Z2]


A packet capture on host-C's X2 interface show correct (pre-nat)
packets on the reverse path, and on host-C's Y1 tun interface show
incorrect (post-nat) packets on the reverse path.


Looking at the packet capture, 4 updates are needed by host C on it's
way from internet back to host A:

1) outer (ICMPV6_TIME_EXCEED) packet dest ip from X2 to Z2
2) outer (ICMPV6_TIME_EXCEED) packet icmp6 checksum recalc
3) inner (ICMPV6_ECHO_REQUEST) packet src ip from X2 to Z2
4) inner (ICMPV6_ECHO_REQUEST) packet icmp6 checksum recalc

1,3,4 are done correctly by host C.
2 is changed by host C but to an incorrect value.


Originally seen in kernel 3.16, but brought host C up to kernel 4.9.23
to make sure it's not already fixed in recent builds, still happens in
that version.


seems like possible issue in nf_nat_icmpv6_reply_translation() or
icmpv6_manip_pkt() area.

Thoughts before I start digging deaper?


-- 
Dave
