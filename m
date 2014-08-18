From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/3] nftables: fix some endian issues
Date: Tue, 19 Aug 2014 00:27:28 +0100
Message-ID: <1408404451-9075-1-git-send-email-kaber@trash.net>
Cc: alvaroneay@gmail.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53268 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbaHRX1i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2014 19:27:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches fix the endian issues Alvaro observed in the bridge table.

The main problem was that the ETH_P_* values are in host byte order, so
they never matches. This is fixed by simply converting the constants to
big endian.

Two related problems are that symbol table printing and higher layer
protocol lookup didn't take endianess into account properly. This is
fixes by exporting the value in the proper byte order before comparison.

With these patches, everything works as expected:

table bridge filter {
	chain input {
		 type filter hook input priority -200;
		 ip daddr 192.168.1.80 tcp dport ssh counter packets 0 bytes 0
		 ether type ip counter packets 128 bytes 36734
		 ether type arp counter packets 12 bytes 336
	}
}

