Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D47C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Sep 2021 18:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78D8460F5D
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Sep 2021 18:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhIJSlI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 14:41:08 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:36788 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhIJSlI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 14:41:08 -0400
Received: from madeliefje.horms.nl (tulip.horms.nl [83.161.246.101])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 3A27E25AF0D;
        Sat, 11 Sep 2021 04:39:55 +1000 (AEST)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id 8971241CD; Fri, 10 Sep 2021 20:39:53 +0200 (CEST)
Date:   Fri, 10 Sep 2021 20:39:53 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, ja@ssi.bg
Subject: Re: [PATCH nf] ipvs: check that ip_vs_conn_tab_bits is between 8 and
 20
Message-ID: <20210910183953.GB19514@vergenet.net>
References: <86eabeb9dd62aebf1e2533926fdd13fed48bab1f.1631289960.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86eabeb9dd62aebf1e2533926fdd13fed48bab1f.1631289960.git.aclaudi@redhat.com>
Organisation: Horms Solutions BV
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
> 
> Fixes: 6f7edb4881bf ("IPVS: Allow boot time change of hash size")
> Reported-by: Yi Chen <yiche@redhat.com>
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>

Acked-by: Simon Horman <horms@verge.net.au>

