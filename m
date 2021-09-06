Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1055C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 10:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEF6D60FBF
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 10:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhIFKtM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 06:49:12 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39386 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhIFKtL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 06:49:11 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 940EB6001C;
        Mon,  6 Sep 2021 12:47:00 +0200 (CEST)
Date:   Mon, 6 Sep 2021 12:48:00 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] tests/conntrack: script for stress-testing ct load
Message-ID: <20210906104800.GB12944@salvia>
References: <20210823155715.81729-1-mikhail.sennikovskii@ionos.com>
 <20210823155715.81729-2-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210823155715.81729-2-mikhail.sennikovskii@ionos.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 23, 2021 at 05:57:14PM +0200, Mikhail Sennikovsky wrote:
> The tests/conntrack/bulk-load-stress.sh is intended to be used for
> stress-testing the bulk load of ct entries from a file (-R option).
> 
> Script usage detail is given by the ./bulk-load-stress.sh -h

Applied with a few edits, thanks.
