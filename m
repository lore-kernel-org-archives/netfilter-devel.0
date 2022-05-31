Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9E6C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 May 2022 21:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346588AbiEaVeS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 May 2022 17:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238288AbiEaVeS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 May 2022 17:34:18 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 366644ECF1
        for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2022 14:34:17 -0700 (PDT)
Date:   Tue, 31 May 2022 23:34:14 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@chinatelecom.cn
Cc:     sven.auhagen@voleatech.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/2] netfilter: flowtable: fix nft_flow_route use
 saddr for nat case
Message-ID: <YpaJ1qL0kCJjMQCO@salvia>
References: <1653528346-5266-1-git-send-email-wenxu@chinatelecom.cn>
 <1653528346-5266-2-git-send-email-wenxu@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1653528346-5266-2-git-send-email-wenxu@chinatelecom.cn>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also applied.
