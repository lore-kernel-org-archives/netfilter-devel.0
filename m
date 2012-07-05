From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Thu,  5 Jul 2012 23:34:29 +0100
Message-ID: <cover.1341525006.git.mr.dash.four@googlemail.com>
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Netfilter Core Team <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56156 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab2GEWfN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jul 2012 18:35:13 -0400
Received: by wibhm11 with SMTP id hm11so160062wib.1
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Jul 2012 15:35:12 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series of 3 patches included in this set allow 'in' or 'out' values to be specified for the 'iface' part of hash:net,iface set, corresponding to the  incoming and outgoing interface accordingly, thus eliminating the discrepancy which, up until now, existed with the 'old' format and also reinforcing much-needed consistency with the rest of the netfilter/iptables terminology.

For backwards compatibility, the 'old' format, comprising of 'src' (incoming) and 'dst' (outgoing) direction parameter for the 'iface' part of hash:net,iface is also supported.

The first patch updates iptables (userspace), the second - ipset (userspace), while the last one deals with the rest of the updates to ipset in kernel space, enabling the above functionality.
 
Example of use:

iptables -A INPUT -m set --match-set test src,in
iptables -A OUTPUT -m set --match-set test dst,out

The first example above produces a packet match, based on source IP address/subnet and the incoming interfice (i.e. the 'src' interface in old speak), while the second one does the same, but for the destination IP address/subnet and the outgoing interface ('dst' using the old format). 

The above two examples also assume that the 'test' set exists and is of type hash:net,iface, otherwise NO match is ever produced.


-- 
1.7.10.4

