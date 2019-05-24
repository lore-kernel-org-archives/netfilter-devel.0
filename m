Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E731C072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 20:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D50B520868
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 20:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403950AbfEXUa3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 16:30:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403760AbfEXUa3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 16:30:29 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6A1373082DDD;
        Fri, 24 May 2019 20:30:29 +0000 (UTC)
Received: from egarver.localdomain (ovpn-122-200.rdu2.redhat.com [10.10.122.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D7B3160639;
        Fri, 24 May 2019 20:30:28 +0000 (UTC)
Date:   Fri, 24 May 2019 16:30:26 -0400
From:   Eric Garver <eric@garver.life>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 3/3] src: Restore local entries after cache update
Message-ID: <20190524203026.7sghf4mw5tknuajr@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190522194406.16827-1-phil@nwl.cc>
 <20190522194406.16827-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522194406.16827-4-phil@nwl.cc>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 24 May 2019 20:30:29 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 22, 2019 at 09:44:06PM +0200, Phil Sutter wrote:
> When batching up multiple commands, one may run into a situation where
> the current command requires a cache update while the previous ones
> didn't and that causes objects added by previous commands to be removed
> from cache. If the current or any following command references any of
> these objects, the command is rejected.
> 
> Resolve this by copying Florian's solution from iptables-nft: After
> droping the whole cache and populating it again with entries fetched
> from kernel, use the current list of commands to restore local entries
> again.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---

Acked-by: Eric Garver <eric@garver.life>
