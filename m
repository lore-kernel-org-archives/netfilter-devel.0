Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6620C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Feb 2022 14:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241454AbiBBOl1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Feb 2022 09:41:27 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44468 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbiBBOl0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Feb 2022 09:41:26 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 35A0E6017A;
        Wed,  2 Feb 2022 15:41:22 +0100 (CET)
Date:   Wed, 2 Feb 2022 15:41:23 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vimal Agrawal <avimalin@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de,
        kadlec@blackhole.kfki.hu, Vimal Agrawal <vimal.agrawal@sophos.com>
Subject: Re: commit a504b703bb1da526a01593da0e4be2af9d9f5fa8 missing from 4.x
 LTS
Message-ID: <YfqYEyxVs82xTVc3@salvia>
References: <CALkUMdS9sYb6fuBbmnS+u1M_Eh39Or5iwGcOK5ikqX930ibOYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALkUMdS9sYb6fuBbmnS+u1M_Eh39Or5iwGcOK5ikqX930ibOYA@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 02, 2022 at 07:56:47PM +0530, Vimal Agrawal wrote:
> Hi Florian/ Pablo,
> 
> We are hitting https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/net/netfilter?h=v5.4.172&id=a504b703bb1da526a01593da0e4be2af9d9f5fa8
> in 4.x LTS and I see it is not back ported.
> 
> We have MASQ/NAT enabled with 64000+ active connections and hence hitting it.
> 
> I am wondering if there is a good reason why it is not back ported to
> 4.x LTS that I should be aware of. I tried back porting it locally on
> 4.14.173 and it seems to be working fine.

Could you post the backport to netfilter-devel@vger.kernel.org for review?

That would save time, if it looks correct, we can request for
inclusion into 4.x LTS

Thanks
