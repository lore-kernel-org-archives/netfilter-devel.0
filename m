From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH v2 0/3] iptables: change 'iface' part in hash:net,iface set
Date: Mon,  9 Jul 2012 23:23:17 +0100
Message-ID: <cover.1341871199.git.mr.dash.four@googlemail.com>
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Netfilter Core Team <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35607 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab2GIWXm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:23:42 -0400
Received: by wgbdr13 with SMTP id dr13so11857859wgb.1
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Jul 2012 15:23:41 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series of 3 patches included in this set is an alternative to the previous version as they allow 'in' or 'out' values to be specified for the 'iface' part of hash:net,iface set *only*, corresponding to the incoming and outgoing interface accordingly, eliminating the discrepancy which existed with the 'old' format and also reinforcing much-needed consistency with the rest of the netfilter/iptables terminology.

The 'old' format, comprising of 'src' (incoming) and 'dst' (outgoing) direction parameter for the 'iface' part of hash:net,iface is also supported. Other ip set types are not affected by this change.

The first patch updates iptables (userspace), the second - ipset (userspace), while the last one deals with the rest of the updates to ipset in kernel space, enabling the above functionality.
 
Example of use:

iptables -A INPUT -m set --match-set iface_set src,in -j ACCEPT
iptables -A OUTPUT -m set --match-set iface_set dst,out -j ACCEPT

The first example above produces a packet match, based on source IP address/subnet and the incoming interfice (i.e. the 'src' interface in old speak), while the second one does the same, but for the destination IP address/subnet and the outgoing interface ('dst' using the old format). 

The above two examples also assume that the 'iface_set' set exists and is of type hash:net,iface, otherwise NO match is produced.

Changelog:

Version 2: Enforces restrictions on 'in' and 'out' direction parameters to be used only in hash:net,iface type sets. Minor bugs in the previous version of the patch have also been corrected.

Version 1: Initial submission

-- 
1.7.10.4

