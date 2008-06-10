From: Petr Pisar <petr.pisar@atlas.cz>
Subject: iptables-1.4.1: ip6tables -L prints network mask instead of prefix length
Date: Tue, 10 Jun 2008 11:49:14 +0000 (UTC)
Message-ID: <slrng4sqhq.6hn.petr.pisar@album.ics.muni.cz>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:53148 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYFJLtZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2008 07:49:25 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K62Ls-0002I3-Ft
	for netfilter-devel@vger.kernel.org; Tue, 10 Jun 2008 11:49:24 +0000
Received: from album.ics.muni.cz ([147.251.23.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jun 2008 11:49:24 +0000
Received: from petr.pisar by album.ics.muni.cz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jun 2008 11:49:24 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I found regression between iptables 1.4.0 and 1.4.1-rc1 (also in
1.4.1). The "ip6tables -nL" prints source and destination addresses in
NETWORK/NETMASK instead of NETWORK/PREFIXLEN as used in iptables 1.4.0.

This doesn't happen if the PREFIXLEN is 0 (i.e. ::/0).

Example:

# /tmp/iptables-1.4.0/ip6tables -nL FORWARD
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         
netall-in  all      ::/0                 2002:93fb:1712::/48
netall-out  all      2002:93fb:1712::/48  ::/0

# /tmp/iptables-1.4.1-rc1/ip6tables -nL FORWARD 
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         
netall-in  all      ::/0                 2002:93fb:1712::/ffff:ffff:ffff:: 
netall-out  all      2002:93fb:1712::/ffff:ffff:ffff::  ::/0

-- Petr


