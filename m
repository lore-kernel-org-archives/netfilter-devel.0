Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE03E82CA5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 15:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbjI0PaP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 11:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbjI0PaO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 11:30:14 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70BA9139;
        Wed, 27 Sep 2023 08:30:13 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: [PATCH -stable,5.10 0/2] Netfilter stable fixes for 5.10
Date:   Wed, 27 Sep 2023 17:30:05 +0200
Message-Id: <20230927153007.562809-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg, Sasha,

The following small batch contains two more fixes for a WARNING splat on
chain unregistration and UaF in the flowtable unregistration that is
exercised from netns path for 5.10 -stable.

I am using original commit IDs for reference:

1) 6069da443bf6 ("netfilter: nf_tables: unregister flowtable hooks on netns exit")

2) f9a43007d3f7 ("netfilter: nf_tables: double hook unregistration in netns path")

Please, apply.

Thanks.

Pablo Neira Ayuso (2):
  netfilter: nf_tables: unregister flowtable hooks on netns exit
  netfilter: nf_tables: double hook unregistration in netns path

 net/netfilter/nf_tables_api.c | 68 ++++++++++++++++++++++++++---------
 1 file changed, 52 insertions(+), 16 deletions(-)

-- 
2.30.2

