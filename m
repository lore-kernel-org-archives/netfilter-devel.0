From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] [PATCH] fix sleepable allocation with spin lock bh
Date: Wed, 13 Aug 2008 16:35:53 +0200
Message-ID: <48A2F149.6000301@netfilter.org>
References: <20080807100803.8036.8684.stgit@Decadence> <20080807100846.8036.73172.stgit@Decadence> <48A2E1B4.9050607@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50939 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751443AbYHMOgP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:36:15 -0400
In-Reply-To: <48A2E1B4.9050607@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> This patch removes a GFP_KERNEL allocation while holding a spin lock with
>> bottom halves disabled in ctnetlink_change_helper().
>>
>> This problem was introduced in 2.6.23 with the netfilter extension
>> infrastructure.
> 
> Also applied, thanks. I'll push all three to -stable once they
> are upstream.

Thanks Patrick. Let me know if you need any backport of the patches.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
