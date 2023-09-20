Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48093C04AA7
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 16:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbjITQcw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 12:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbjITQcv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 12:32:51 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96928C2
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 09:32:45 -0700 (PDT)
Received: from [78.30.34.192] (port=36134 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qj082-004hCE-0f; Wed, 20 Sep 2023 18:32:43 +0200
Date:   Wed, 20 Sep 2023 18:32:41 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 5/9] payload: use enum icmp_hdr_field_type in
 payload_may_dependency_kill_icmp()
Message-ID: <ZQseqVaYG5W4Ri5U@calendula>
References: <20230920142958.566615-1-thaller@redhat.com>
 <20230920142958.566615-6-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230920142958.566615-6-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 20, 2023 at 04:26:06PM +0200, Thomas Haller wrote:
> Don't mix icmp_dep (enum icmp_hdr_field_type) and the uint8_t icmp_type.

Applied, thanks
