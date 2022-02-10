Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF3BC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Feb 2022 09:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238315AbiBJJNd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 04:13:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238312AbiBJJNb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 04:13:31 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B922F1C;
        Thu, 10 Feb 2022 01:13:32 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4A827601BA;
        Thu, 10 Feb 2022 10:13:18 +0100 (CET)
Date:   Thu, 10 Feb 2022 10:13:29 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Yi Chen <yiche@redhat.com>
Subject: Re: [PATCH nf] selftests: netfilter: disable rp_filter on router
Message-ID: <YgTXHziKmce/fzDY@salvia>
References: <20220210033205.928458-1-liuhangbin@gmail.com>
 <YgTQ5KS1b2CZWvnR@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YgTQ5KS1b2CZWvnR@Laptop-X1>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Feb 10, 2022 at 04:46:28PM +0800, Hangbin Liu wrote:
> Hi Pablo, Florian,
> On Thu, Feb 10, 2022 at 11:32:05AM +0800, Hangbin Liu wrote:
> > +ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.rp_filter=0 > /dev/null
> > +ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.rp_filter=0 > /dev/null
> 
> Oh, disable rp_filter on veth0 is enough for the current testing. But for the
> format and maybe a preparation for future testing. Disable veth1 rp_filter
> should also be OK. If you think there is no need to do this on veth1.
> I can send a v2 patch.

Send v2, I'll toss v1 patch.

Thanks.
