From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCH RFC 0/3] Rework nfnetlink_queue conntrack support
Date: Wed, 9 Sep 2015 18:50:42 +0900
Message-ID: <20150909095042.GA11843@gmail.com>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35111 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbbIIJus (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2015 05:50:48 -0400
Received: by pacfv12 with SMTP id fv12so5748960pac.2
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Sep 2015 02:50:47 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hi Pablo,

Thank you for taking your time.

On Tue, Sep 08, 2015 at 06:54:48PM +0200, Pablo Neira Ayuso wrote:
> They are totally untested, so please carefully review them.

I'm sorry I could not to meet your expectations since I might not
understand your intention correctly, please let me ask three
questions:

* We will not modularize nfqueue attaching conntrack information
  part? (was nfnetlink_queue_ct.c)

* May I update nfqnl_ct prefix to nfnl_ct after this patch series
  applied to attach nfct info to nflog?

* We do not add another Kconfig for nflog attaching ct info?

I tested your patch a little with following lnf-queue patch and
it works fine. 

Thanks,
