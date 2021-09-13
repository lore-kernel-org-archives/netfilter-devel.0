Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C39AC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 22:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D62E060F11
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 22:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347527AbhIMXAM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 19:00:12 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53608 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350353AbhIMW7n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 18:59:43 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 61A6C60056;
        Tue, 14 Sep 2021 00:56:47 +0200 (CEST)
Date:   Tue, 14 Sep 2021 00:57:54 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, horms@verge.net.au, ja@ssi.bg
Subject: Re: [PATCH nf] ipvs: check that ip_vs_conn_tab_bits is between 8 and
 20
Message-ID: <20210913225754.GB5737@salvia>
References: <86eabeb9dd62aebf1e2533926fdd13fed48bab1f.1631289960.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <86eabeb9dd62aebf1e2533926fdd13fed48bab1f.1631289960.git.aclaudi@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 10, 2021 at 06:08:39PM +0200, Andrea Claudi wrote:
> ip_vs_conn_tab_bits may be provided by the user through the
> conn_tab_bits module parameter. If this value is greater than 31, or
> less than 0, the shift operator used to derive tab_size causes undefined
> behaviour.
> 
> Fix this checking ip_vs_conn_tab_bits value to be in the range specified
> in ipvs Kconfig. If not, simply use default value.

Applied, thanks.
