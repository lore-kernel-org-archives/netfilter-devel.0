From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] remove timer from ecache extension
Date: Thu, 22 May 2014 11:43:06 +0200
Message-ID: <1400751788-7923-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57106 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753499AbaEVJst (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2014 05:48:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry about the huge delay, I forgot about this patch series.
Changes since last version:

- hide REDELIVER bit from userspace
- don't allow setting of REDELIVER bit from userspace

Thanks,
Florian
