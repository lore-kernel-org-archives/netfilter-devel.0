From: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Git commits possibly suitable for 3.8-stable tree?
Date: Sat, 20 Apr 2013 20:19:01 +0200
Message-ID: <20098583.RM2dngnsmy@gentoovm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:48492 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab3DTSZj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Apr 2013 14:25:39 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 38B59A3377
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Apr 2013 19:19:38 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id uS8MKGyMeNST for <netfilter-devel@vger.kernel.org>;
	Sat, 20 Apr 2013 19:19:28 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Would any of the following mainline commits be appropriate for cherry-picking 
into the 3.8 stable tree?

c2d421e netfilter: nf_nat: fix race when unloading protocol modules
6eb4c7e netfilter: ipset: hash:*net*: nomatch flag not excluded on set resize
02f815c netfilter: ipset: list:set: fix reference counter update
3a7b21e netfilter: nf_ct_sip: don't drop packets with offsets pointing outside 
the packet
906b1c3 netfilter: ip6t_NPT: Fix translation for non-multiple of 32 prefix 
lengths
bae99f7 netfilter: nfnetlink_queue: fix incorrect initialization of copy range 
field
dd82088 netfilter: ipset: "Directory not empty" error message
cf1c4a0 netfilter: ipset: timeout values corrupted on set resize
442fad9 netfilter: ctnetlink: don't permit ct creation with random tuple
d9e8565 netfilter ip6table_mangle: Use ipv6_addr_equal() where appropriate.
29e3b16 netfilter ipset: Use ipv6_addr_equal() where appropriate.

Additionally there are these two related commits:

124dff0 netfilter: don't reset nf_trace in nf_reset()
130549f netfilter: reset nf_trace in nf_reset

Kind Regards,

Oliver
