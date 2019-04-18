Return-Path: <SRS0=/8pw=SU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB08C10F14
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 06:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16CBD214DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 06:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387990AbfDRGZK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 02:25:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35558 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbfDRGZK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 02:25:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 922F0103F5463;
        Wed, 17 Apr 2019 23:25:09 -0700 (PDT)
Date:   Wed, 17 Apr 2019 23:25:09 -0700 (PDT)
Message-Id: <20190417.232509.1761143873528182624.davem@davemloft.net>
To:     fbl@redhat.com
Cc:     netdev@vger.kernel.org, joe@ovn.org, pshelar@ovn.org,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org
Subject: Re: [PATCH net-next v3 0/4] openvswitch: load and reference the
 NAT helper
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190417144617.14922-1-fbl@redhat.com>
References: <20190417144617.14922-1-fbl@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Apr 2019 23:25:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Flavio Leitner <fbl@redhat.com>
Date: Wed, 17 Apr 2019 11:46:13 -0300

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
> The third patch will register each NAT helper using the
> new API.
> 
> The last patch fixes openvswitch to use the new API to
> load and reference the NAT helper and also report an error
> if the operation fails.

Netfilter folks, besides a review, I was wondering if you'd like
to take this series the netfilter tree since it's mostly changes
in that area?

Thanks.
