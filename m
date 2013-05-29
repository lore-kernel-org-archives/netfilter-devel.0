From: Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH 0/4] ipset: add "inner" flag support
Date: Wed, 29 May 2013 01:13:08 +0100
Message-ID: <51A54814.5040405@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:37949 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab3E2ANO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 May 2013 20:13:14 -0400
Received: by mail-we0-f172.google.com with SMTP id w62so5975040wes.17
        for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2013 17:13:13 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series of 4 patches implements "inner" flag option in the set
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


Dash Four (4):
   ipset: minor variable-naming corrections
   ipset: add "inner" flag implementation
   iptables: add set match "inner" flag support
   iptables (userspace): add set match "inner" flag support



