From: Ed Tomlinson <edt@aei.ca>
Subject: nftables in network name spaces breaks networking
Date: Wed, 29 Oct 2014 08:00:26 -0400
Message-ID: <2819252.KHfeL7dgec@grover>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:59463 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384AbaJ2MA3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:00:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

Using 3.17.1 and setting up firewalls with nftables breaks networking when nft -f <somefile> is run in an systemd-nspawn instance.  

Please take a look at: https://bugs.freedesktop.org/show_bug.cgi?id=85464 

The network gets setup correctly either by systemd-nspawn or manually via ip netns and all is okay until you try to load a firewall in
the spawned instance with nftables.  At this point the host's bridge interface stop responding.  Load a nftable in the spawned client 
should NOT affect the host's networking.

I like nftables and find them easier to use than iptables (or ipchains which dates me).

Please fix this problem or stop nft from loading tables when not it the root namespace.

I am willing to test fixes.

Thanks,
Ed Tomlinson

