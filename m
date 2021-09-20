Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 216C0C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Sep 2021 11:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1BFA60E08
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Sep 2021 11:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhITLkg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Sep 2021 07:40:36 -0400
Received: from mail.netfilter.org ([217.70.188.207]:37876 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbhITLkg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Sep 2021 07:40:36 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4330F605E1;
        Mon, 20 Sep 2021 13:37:51 +0200 (CEST)
Date:   Mon, 20 Sep 2021 13:39:04 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_log v3] src: doc: revise doxygen for module
 "Netlink message helper functions"
Message-ID: <YUhy2NgyV0tx7qct@salvia>
References: <20210916025822.14231-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210916025822.14231-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 16, 2021 at 12:58:22PM +1000, Duncan Roe wrote:
> Adjust style to work better in a man page.
> Document actual return values.
> Replace qnum with gnum (and in .h and utils/).
> Show possible copy modes (rather than refer users to header file)

Applied, thanks.
