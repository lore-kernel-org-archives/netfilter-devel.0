From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: don't do window scaling for a picked up connection
Date: Mon, 2 Apr 2012 00:41:25 +0800
Message-ID: <CABa6K_FXZiAgfArXky5V_sS-8WtcxiR6JE4pT6n4Ajy0MpbLhw@mail.gmail.com>
References: <1333292683-31414-1-git-send-email-xiaosuo@gmail.com> <20120401162155.GA10861@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38542 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599Ab2DAQlq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:41:46 -0400
In-Reply-To: <20120401162155.GA10861@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 2, 2012 at 12:21 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> This breaks conntrackd and its ability to recover flows by injecting
> the window scaling via ctnetlink.

Got it. Thanks.

Just forget this patch. I'll post another patch to fix the duplicate
window scaling: one is here, and the other is before the state
updating code.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
