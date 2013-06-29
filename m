From: Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH v3 0/5]  ipset: add "inner" flag support
Date: Sat, 29 Jun 2013 22:32:06 +0100
Message-ID: <51CF5256.3010004@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:44218 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab3F2VcS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Jun 2013 17:32:18 -0400
Received: by mail-wg0-f51.google.com with SMTP id e11so2630954wgh.6
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Jun 2013 14:32:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series of 5 patches implements "inner" flag option in the set
iptables match, allowing matching based on the properties
(source/destination IP address, protocol, port and so on) of the
original (inner) connection in the event of the following
ICMP[v4,v6] messages:

ICMPv4 destination-unreachable (code 3);
ICMPv4 source-quench (code 4);
ICMPv4 time-exceeded (code 11);
ICMPv6 destination-unreachable (code 1);
ICMPv6 packet-too-big (code 2);
ICMPv6 time-exceeded (code 3);

Revision history:

v1 * initial revision
v2 * redundant code removed;
    * added a new header file (ip_set_icmp.h) with 2 inline functions,
      allowing access to the internal icmp header properties;
    * removed ip[46]inneraddr[ptr]functions as they are no longer needed
    * added new ipv[46]addr[ptr] and ip_set_get*port functions, the old
      functions are still preserved for backwards compatibility
v3 * rename and move ip_set_get_icmpv[46]_inner_hdr functions to
      ip_set_core.c and remove ip_set_icmp.h
    * move icmpv[46] protocol and offset checks inside
      ip_set_get_ip[46]_inner_hdr functions
    * eliminate ip[46]addrptr & ip_set_get_ip[46]_port backward-compatible
      functions and rename the new ones to use the same name
    * eliminate single-path error gotos in ip_set.h and ip_set_getport.c

Dash Four (5):
   iptables: bugfix: prevent wrong syntax being accepted by the set match
   ipset: add "inner" flag implementation
   ipset: add set match "inner" flag support
   iptables: add set match "inner" flag support
   iptables (userspace): add set match "inner" flag support

