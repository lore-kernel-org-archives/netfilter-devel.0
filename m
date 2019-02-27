Return-Path: <SRS0=q2Xo=RC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12CA1C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 11:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D42BE2146F
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 11:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbfB0LSI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Feb 2019 06:18:08 -0500
Received: from Galois.linutronix.de ([146.0.238.70]:48567 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729521AbfB0LSG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Feb 2019 06:18:06 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1gyxDu-0002E8-Lc; Wed, 27 Feb 2019 12:18:02 +0100
Date:   Wed, 27 Feb 2019 12:18:02 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Li RongQing <lirongqing@baidu.com>
cc:     netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sboyd@kernel.org, john.stultz@linaro.org
Subject: Re: [PATCH] time: Introduce jiffies64_to_msecs()
In-Reply-To: <1551260313-2926-1-git-send-email-lirongqing@baidu.com>
Message-ID: <alpine.DEB.2.21.1902271217110.1857@nanos.tec.linutronix.de>
References: <1551260313-2926-1-git-send-email-lirongqing@baidu.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 27 Feb 2019, Li RongQing wrote:

> there is a similar helper in net/netfilter/nf_tables_api.c,
> this maybe become a common request someday.

Maybe is not a really good justification for adding that. At least you
should provide a patch which replaces the instance in the netfilter code.

Thanks,

	tglx
