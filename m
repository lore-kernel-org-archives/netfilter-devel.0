Return-Path: <SRS0=YYk6=R7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC43C10F06
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Mar 2019 23:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 215F82173C
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Mar 2019 23:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbfC1XzJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Mar 2019 19:55:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58864 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728006AbfC1XzJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Mar 2019 19:55:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD62B14D67600;
        Thu, 28 Mar 2019 16:55:08 -0700 (PDT)
Date:   Thu, 28 Mar 2019 16:55:08 -0700 (PDT)
Message-Id: <20190328.165508.276862640990910773.davem@davemloft.net>
To:     fbl@sysclose.org
Cc:     netdev@vger.kernel.org, joe@ovn.org, pshelar@ovn.org,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] openvswitch: load and reference the NAT
 helper.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190326205715.22288-1-fbl@sysclose.org>
References: <20190326205715.22288-1-fbl@sysclose.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 Mar 2019 16:55:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Flavio Leitner <fbl@sysclose.org>
Date: Tue, 26 Mar 2019 17:57:07 -0300

> The request_module() is quite expensive and triggers the
> usermode helper in userspace. Instead, load only if the
> module is not present and keep module references to avoid
> problems.
> 
> The first patch standardize the module alias which is already
> there, but not in a formal way.
> 
> The second patch adds an API to point to the NAT helper.
> 
> The following patches will register each NAT helper using
> the new API.
> 
> The last patch fixes openvswitch to use the new API to
> load and reference the NAT helper and also report an error
> if the operation fails.

These are mostly netfilter changes so I would like to see some
reviews/ACKs from netfilter folks.

Thanks.
