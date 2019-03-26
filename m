Return-Path: <SRS0=49hf=R5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 569EBC4360F
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 19:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33AB620823
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 19:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732369AbfCZTsx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 15:48:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49726 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfCZTsw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 15:48:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4250414C5C7F5;
        Tue, 26 Mar 2019 12:48:52 -0700 (PDT)
Date:   Tue, 26 Mar 2019 12:48:51 -0700 (PDT)
Message-Id: <20190326.124851.814224885981895120.davem@davemloft.net>
To:     fbl@sysclose.org
Cc:     netdev@vger.kernel.org, joe@ovn.org, pshelar@ovn.org,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next v2] openvswitch: add seqadj extension when NAT
 is used.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190325185831.27284-1-fbl@sysclose.org>
References: <20190325185831.27284-1-fbl@sysclose.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Mar 2019 12:48:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Flavio Leitner <fbl@sysclose.org>
Date: Mon, 25 Mar 2019 15:58:31 -0300

> When the conntrack is initialized, there is no helper attached
> yet so the nat info initialization (nf_nat_setup_info) skips
> adding the seqadj ext.
> 
> A helper is attached later when the conntrack is not confirmed
> but is going to be committed. In this case, if NAT is needed then
> adds the seqadj ext as well.
> 
> Fixes: 16ec3d4fbb96 ("openvswitch: Fix cached ct with helper.")
> Signed-off-by: Flavio Leitner <fbl@sysclose.org>

Applied.
