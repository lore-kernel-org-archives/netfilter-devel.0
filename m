From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next resend 0/3] netfilter: connlabel set support
Date: Mon, 14 Mar 2016 14:46:31 +0100
Message-ID: <1457963194-19132-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52681 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbcCNNqQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 09:46:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patch #1 is a cleanup, #2 avoids ctnetlink even storm when label replacement
doesn't change anything, #3 is the actual change.

With patch #3 'ct label set ct label | foo' works, there are no changes
needed on nft/userspace side.

