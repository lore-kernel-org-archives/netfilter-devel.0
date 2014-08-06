From: Valentina Giusti <valentina.giusti@microon.de>
Subject: [PATCH 0/3] nftables: add cpu attribute to nft_meta
Date: Wed,  6 Aug 2014 23:59:49 +0200
Message-ID: <1407362392-24837-1-git-send-email-valentina.giusti@microon.de>
To: coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.microon.de ([37.252.125.21]:54655 "EHLO gattino.microon.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753885AbaHFWGN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:06:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

this patchset adds the metainformation selector "cpu", which would be the 
nftables equivalent of xt_cpu for iptables.
The patchset contains the code for kernel, libnfnt and nftables.
I created the kernel patch against the repository
git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nftables.git, 
hopefully it's the right one, otherwise please let me know and I'll send
the patch rebased on the correct repo.


Best Regards,
- Valentina Giusti

