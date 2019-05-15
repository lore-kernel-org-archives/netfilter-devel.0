Return-Path: <SRS0=H0Uh=TP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A669C04E53
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 13:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9EB720843
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 13:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfEONYi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 May 2019 09:24:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35876 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbfEONYi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 May 2019 09:24:38 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 48AED30A01B0;
        Wed, 15 May 2019 13:24:38 +0000 (UTC)
Received: from egarver.localdomain (ovpn-123-218.rdu2.redhat.com [10.10.123.218])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 998DC1001E61;
        Wed, 15 May 2019 13:24:37 +0000 (UTC)
Date:   Wed, 15 May 2019 09:24:36 -0400
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft v2] evaluate: force full cache update on rule index
 translation
Message-ID: <20190515132436.xpndwgt5qtruzxsm@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
References: <20190506184038.17675-1-eric@garver.life>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506184038.17675-1-eric@garver.life>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 15 May 2019 13:24:38 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, May 06, 2019 at 02:40:38PM -0400, Eric Garver wrote:
> If we've done a partial fetch of the cache and the genid is the same the
> cache update will be skipped without fetching the rules. This causes the
> index to handle lookup to fail. To remedy the situation we flush the
> cache and force a full update.
> 
> Fixes: 816d8c7659c1 ("Support 'add/insert rule index <IDX>'")
> Signed-off-by: Eric Garver <eric@garver.life>
[..]

Please drop this patch. After discussing with Phil we should fix cache
issues like this generically by considering the cache "cmd". I have a
patch mostly ready - I'll try to post it today.

Thanks.
Eric.
