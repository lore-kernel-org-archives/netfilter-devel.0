Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F4CEC46467
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Jan 2023 18:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbjAKSKs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Jan 2023 13:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235547AbjAKSKl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Jan 2023 13:10:41 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 323B31C939;
        Wed, 11 Jan 2023 10:10:39 -0800 (PST)
Date:   Wed, 11 Jan 2023 19:10:35 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH v2] netfilter: ipset: Fix overflow before widen in the
 bitmap_ip_create() function.
Message-ID: <Y777m3reT6s1sCnD@salvia>
References: <Y76NQ7tQVB7kE0dG@corigine.com>
 <20230111115741.3347031-1-Ilia.Gavrilov@infotecs.ru>
 <Y76k9QxybRtf9aG6@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y76k9QxybRtf9aG6@corigine.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 11, 2023 at 01:00:53PM +0100, Simon Horman wrote:
> On Wed, Jan 11, 2023 at 11:57:39AM +0000, Gavrilov Ilia wrote:
> > [You don't often get email from ilia.gavrilov@infotecs.ru. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> > 
> > When first_ip is 0, last_ip is 0xFFFFFFFF, and netmask is 31, the value of
> > an arithmetic expression 2 << (netmask - mask_bits - 1) is subject
> > to overflow due to a failure casting operands to a larger data type
> > before performing the arithmetic.
> > 
> > Note that it's harmless since the value will be checked at the next step.
> > 
> > Found by InfoTeCS on behalf of Linux Verification Center
> > (linuxtesting.org) with SVACE.
> > 
> > Fixes: b9fed748185a ("netfilter: ipset: Check and reject crazy /0 input parameters")
> > Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Applied, thanks
