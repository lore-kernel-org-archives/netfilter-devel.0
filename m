From: Vijay Subramanian <subramanian.vijay@gmail.com>
Subject: Re: [PATCH nf 1/1] nft: Fix nlmsg_type in GET operation callbacks
Date: Tue, 1 Sep 2015 14:35:27 -0400
Message-ID: <CAGK4HS9AYw63dNJRF1KnqoDjR7xNRBUEq9aX39s2WdAWRpQh9w@mail.gmail.com>
References: <1440887695-15068-1-git-send-email-subramanian.vijay@gmail.com>
	<20150901164610.GA3434@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:35169 "EHLO
	mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbbIASf2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Sep 2015 14:35:28 -0400
Received: by vkaw128 with SMTP id w128so62211133vka.2
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2015 11:35:28 -0700 (PDT)
In-Reply-To: <20150901164610.GA3434@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nstead of GET. Set the type correctly.
>
> We always NFT_MSG_NEWTABLE as message type other major netlink
> subsystems that I can remember, so that is there for consistency.
>
> Is there any why reason you need this change?

Not really. I was not sure if the current behavior was by design or an
oversight.
Thanks for clarifying.

Vijay
