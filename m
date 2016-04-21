From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next v6] nftables: connlabel set support
Date: Thu, 21 Apr 2016 16:34:40 +0200
Message-ID: <1461249284-12114-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54968 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662AbcDUOe1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Apr 2016 10:34:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Take six.

First (new) patch renames existing nft_ct struct to nft_ct_reg.
Second patch is the real (kernel) patch, adds new nft_ct_imm
struct and uses select_ops to pick it if IMM attr is present.

Last two patches are the userspace changes to libnftnl and nft itself.

