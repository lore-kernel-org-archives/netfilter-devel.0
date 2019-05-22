Return-Path: <SRS0=iiCe=TW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A5CCC282CE
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 17:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4E1820862
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 17:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbfEVRaB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 May 2019 13:30:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40338 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbfEVRaB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 May 2019 13:30:01 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 409D43082137;
        Wed, 22 May 2019 17:29:57 +0000 (UTC)
Received: from egarver.localdomain (ovpn-123-106.rdu2.redhat.com [10.10.123.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C63455DE68;
        Wed, 22 May 2019 17:29:54 +0000 (UTC)
Date:   Wed, 22 May 2019 13:29:53 -0400
From:   Eric Garver <eric@garver.life>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 0/3] Resolve cache update woes
Message-ID: <20190522172953.mh5jylrbdig2alau@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20190517230033.25417-1-phil@nwl.cc>
 <20190521170614.epj4gjlhfpgmhvas@egarver.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521170614.epj4gjlhfpgmhvas@egarver.localdomain>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 22 May 2019 17:30:00 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 21, 2019 at 01:06:14PM -0400, Eric Garver wrote:
> Hi Phil,
> 
> On Sat, May 18, 2019 at 01:00:30AM +0200, Phil Sutter wrote:
> > This series implements a fix for situations where a cache update removes
> > local (still uncommitted) items from cache leading to spurious errors
> > afterwards.
> >
> > The series is based on Eric's "src: update cache if cmd is more
> > specific" patch which is still under review but resolves a distinct
> > problem from the one addressed in this series.
> >
> > The first patch improves Eric's patch a bit. If he's OK with my change,
> > it may very well be just folded into his.
> >
> > Phil Sutter (3):
> >   src: Improve cache_needs_more() algorithm
> >   libnftables: Keep list of commands in nft context
> >   src: Restore local entries after cache update
> >
> >  include/nftables.h |  1 +
> >  src/libnftables.c  | 21 +++++------
> >  src/rule.c         | 91 +++++++++++++++++++++++++++++++++++++++++++---
> >  3 files changed, 96 insertions(+), 17 deletions(-)
> >
> > --
> > 2.21.0
> 
> I've been testing this series. I found anonymous sets are mistakenly
> free()d if a cache_release occurs.

Below is a real fix for this issue. After a cache update we need to skip adding
anonymous sets from the cmd list into the cache.

Phil, if you agree please fold this into your series.

diff --git a/src/rule.c b/src/rule.c
index 4f015fc5354b..94830b651925 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -224,6 +224,9 @@ static void cache_add_set_cmd(struct nft_ctx *nft, struct cmd *cmd)
 {
        struct table *table;
 
+       if (cmd->set->flags & NFT_SET_ANONYMOUS)
+               return;
+
        table = table_lookup(&cmd->handle, &nft->cache);
        if (table == NULL)
                return;
