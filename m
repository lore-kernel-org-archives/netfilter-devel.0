Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC0EC2B9F4
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 23:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 014516128C
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 23:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhFVXJF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 19:09:05 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59490 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhFVXJE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 19:09:04 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1862B64252;
        Wed, 23 Jun 2021 01:05:23 +0200 (CEST)
Date:   Wed, 23 Jun 2021 01:06:44 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     David Miller <davem@davemloft.net>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH net 0/8] Netfilter fixes for net
Message-ID: <20210622230644.GA24815@salvia>
References: <20210622220001.198508-1-pablo@netfilter.org>
 <20210622.154112.927209782434891343.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210622.154112.927209782434891343.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 22, 2021 at 03:41:12PM -0700, David Miller wrote:
> 
> [davem@localhost net]$ git pull --no-ff git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git
> From git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
>  * branch                      HEAD       -> FETCH_HEAD
> Already up to date.
> [davem@localhost net]$
> 
> ???

A robot got stuck here and it did not push out to origin for some
reason, sorry. Please retry, it should be there now.
