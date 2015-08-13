From: Andreas Schultz <aschultz@tpip.net>
Subject: nftables: precondition validation fails on map construct
Date: Thu, 13 Aug 2015 16:28:29 +0200
Message-ID: <55CCA98D.2030908@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:46020 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbbHMO2c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Aug 2015 10:28:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

As far as I can tell the following construct should be valid:

# nft add nat prerouting ip protocol {tcp, udp} snat 10.200.4.1-10.200.4.254:10240-20480

However it fails with:

<cmdline>:1:72-82: Error: transport protocol mapping is only valid after transport protocol match
add nat prerouting ip protocol {tcp, udp} snat 10.200.4.1-10.200.4.254:10240-20480
                                           ~~~~                         ^^^^^^^^^^^

Is this intended behaviour?

Andreas
