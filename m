Return-Path: <SRS0=X33E=XO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9000C3A5A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 13:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5DC921D79
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 13:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390466AbfISNlf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 09:41:35 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:47334 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389222AbfISNlf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 09:41:35 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iAwgf-0005EL-Qt; Thu, 19 Sep 2019 15:41:33 +0200
Date:   Thu, 19 Sep 2019 15:41:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Wambui Karuga <wambui.dev@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Contributing to the Netfilter Project.
Message-ID: <20190919134133.GR6961@breakpoint.cc>
References: <CAF0ihpasN+7p8T8xiVt9tnmKUVtBAbF50_hv_E1mspWV+A0dYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF0ihpasN+7p8T8xiVt9tnmKUVtBAbF50_hv_E1mspWV+A0dYg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wambui Karuga <wambui.dev@gmail.com> wrote:
> Hello Netfilter team!
> 
> I've been following the work of the Netfilter project for a while now,
> and would love to start contributing to any of the software under the
> project. I have mainly interacted with the  libmnl, conntrack-tools,
> and libnetfilter_conntrack projects, but would be up for starting out
> anywhere. Please let me know how I can go about contributing to the
> project as a developer!

http://people.netfilter.org/pablo/nf-ideas-2019.txt

"1.6" (logging infra) is not resolved yet, and I don't know of anyone
working on this.
