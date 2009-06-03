From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 9/9] netfilter: conntrack: replace notify chain by function
 pointer
Date: Wed, 03 Jun 2009 10:50:53 +0200
Message-ID: <4A26396D.9000503@netfilter.org>
References: <20090602181336.18573.85368.stgit@Decadence> <20090602182115.18573.84532.stgit@Decadence> <4A261711.1020208@trash.net> <4A262EE3.8010607@netfilter.org> <4A2633FB.2040807@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48967 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZFCJIo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:08:44 -0400
In-Reply-To: <4A2633FB.2040807@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
>> Would you be OK with something like:
>>
>> BUG_ON(notify != new);
>>
>> So we can catch this very unlikely bug, if so.
> 
> Sure. We don't do this is 99% of the other unregistration functions
> however, so I don't think its particulary useful. It only affects
> out of tree code anyways, unless we've done something really stupid,
> like remove error checking in the initialization function :)

I see. Well, I don't have very strong arguments to support this, some of
them: if I remove it the unregistration function will not use the
parameter anymore and I'd like to keep the register/unregister interface
symmetric. Very unlikely but it can spot other problems like memory
corruptions? Although in that case, the kernel is more likely to crash.

Please, keep it there :). I'm going to send you a new version of this
patch to the mailing list.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
