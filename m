From: Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH v2 0/5]  ipset: add "inner" flag support
Date: Mon, 17 Jun 2013 00:26:52 +0100
Message-ID: <51BE49BC.2050903@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56114 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3FPX1H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Jun 2013 19:27:07 -0400
Received: by mail-wi0-f175.google.com with SMTP id m6so1754696wiv.2
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Jun 2013 16:27:04 -0700 (PDT)
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
      functions are still preserved for backwards compatibility;

Dash Four (5):
   iptables: bugfix: prevent wrong syntax being accepted by the set match
   ipset: add "inner" flag implementation
   ipset: add set match "inner" flag support
   iptables: add set match "inner" flag support
   iptables (userspace): add set match "inner" flag support


