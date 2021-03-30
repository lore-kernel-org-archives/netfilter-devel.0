Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36154C433C1
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Mar 2021 22:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07869619D2
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Mar 2021 22:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbhC3Wx4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 18:53:56 -0400
Received: from mail.netfilter.org ([217.70.188.207]:46484 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbhC3Wxn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 18:53:43 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 186C063E52;
        Wed, 31 Mar 2021 00:53:28 +0200 (CEST)
Date:   Wed, 31 Mar 2021 00:53:39 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        twoerner@redhat.com, tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: Re: [PATCH v5] audit: log nftables configuration change events once
 per table
Message-ID: <20210330225339.GA14421@salvia>
References: <28de34275f58b45fd4626a92ccae96b6d2b4e287.1616702731.git.rgb@redhat.com>
 <CAHC9VhRo62vCJL0d_YiKC-Mq9S3P5rNN3yoiF+NBu7oeeeU9rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHC9VhRo62vCJL0d_YiKC-Mq9S3P5rNN3yoiF+NBu7oeeeU9rw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Mar 28, 2021 at 08:50:45PM -0400, Paul Moore wrote:
[...]
> Netfilter folks, were you planning to pull this via your tree/netdev
> or would you like me to merge this via the audit tree?  If the latter,
> I would appreciate it if I could get an ACK from one of you; if the
> former, my ACK is below.
> 
> Acked-by: Paul Moore <paul@paul-moore.com>

I'll merge this one into nf-next, this might simplify possible
conflict resolution later on.

Thanks for acking.
