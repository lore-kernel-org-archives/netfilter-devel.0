Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CBE8C7EE2C
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Aug 2023 07:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjHXHEA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 03:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240293AbjHXHDj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 03:03:39 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D80E66
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 00:03:22 -0700 (PDT)
Received: from [78.30.34.192] (port=58372 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qZ4NB-0081xO-8W; Thu, 24 Aug 2023 09:03:19 +0200
Date:   Thu, 24 Aug 2023 09:03:16 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v5 0/6] add input flags and "no-dns"/"json" flags
Message-ID: <ZOcAtG++Pcxdst9x@calendula>
References: <20230818094335.535872-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818094335.535872-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 18, 2023 at 11:40:35AM +0200, Thomas Haller wrote:
> Changes since v4:
> 
> - rename python API {set,get}_input() to {set,get}_input_flags() and
>   update commit message. Other 5 out of 6 patches are unchanged (except
>   adding Reviewed-by tag from Phil).
> 
> Changes since v3:
> 
> - set-input() now returns the old value (both for Python and C API)
> - python: API follows the style of existing set_debug()/get_debug()
>   methods.
> - nft_input_no_dns()/nft_input_json() helper functions added and used.
> - python: new patch to better handle exception while creating Nftables
>   instance.

Series applied, thanks.
