From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Subject: Re: [PATCH] netfilter: fix looped (broad|multi)cast's bogus MACs in NFQUEUE
Date: Thu,  9 Jun 2011 15:39:07 +0200
Message-ID: <1307626748-10992-1-git-send-email-cavallar@lri.fr>
References: <20110608153032.GA26912@Chamillionaire.breakpoint.cc>
To: fw@strlen.de, kaber@trash.net, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:57254 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757646Ab1FINru (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:47:50 -0400
In-Reply-To: <20110608153032.GA26912@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> nfnetlink_log has the same problem.

I also figured from source that ip_queue has the same problem too, so
the next patch fixes that too.

