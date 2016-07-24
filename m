From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC] l2tp for nftables
Date: Sun, 24 Jul 2016 19:25:30 +0200
Message-ID: <20160724172530.GA1655@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: James Chapman <jchapman@katalix.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56084 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbcGXRZg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Jul 2016 13:25:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0D8D7EAA63
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Jul 2016 19:25:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 00060A8E1
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Jul 2016 19:25:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D37EFA8E1
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Jul 2016 19:25:31 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi James,

I'm looking what is missing to add l2tp for nftables, after a quick
glance this is what I found.

The L2TPv3 over IP (after quick reading of the RFC) seems easy to add.
I'm attaching a patch for the header layout definition (still parser
side is missing, so this patch is incomplete).

For L2TP over UDP, we need more infrastructure to match based the
content of UDP tunnels. I think the port should be one of the key to
look up for the possible protocol there, I can see 1701 is the L2TP
port. Then, we can add a definition to match the L2TP_HDR_T_BIT and
the version. On top of that, the sid and tid fields depend on the
version number, so we need to have a way to register different
interpretations based on the type, that should be possible from the
evaluation phase (just after the parsing). Thus, the design changes
with regards to xt_l2tp since in nft, the user will explicitly specify
what L2TP over UDP protocol version whats to match (in xt_l2tp this
occurs transparently to the user, in runtime from the packet path).

Does this assesment look correct to you?

Thanks!
