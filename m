From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ctnetlink: optional packet drop to make event delivery
 reliable
Date: Tue, 24 Mar 2009 15:04:26 +0100
Message-ID: <49C8E86A.6060707@netfilter.org>
References: <20090324110706.13981.24167.stgit@Decadence> <49C8DE75.1050109@trash.net> <49C8E312.5060005@netfilter.org> <49C8E514.2010205@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57518 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754796AbZCXOEh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:04:37 -0400
In-Reply-To: <49C8E514.2010205@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> But it seems rather pointless to add it in this state, it doesn't
> increase reliability one bit. Additionally reversing the order of
> state transitions and event delivery seems like a highly intrusive
> change since event delivery obviously already needs to know the
> new state, meaning we'd need to record all state changes, then
> deliver the event, then "commit" them. So I'd like to see what
> we're engaging in before merging this half finished patch.

I see, I'm going to send you a new patch so we can discuss on something
in particular.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
