Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E707FCA0EC8
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Sep 2023 02:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240507AbjILCr2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240214AbjILCrQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Sep 2023 22:47:16 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40F6412D8
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Sep 2023 19:12:36 -0700 (PDT)
Received: from [31.221.198.239] (port=5790 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qfofm-009h13-UI; Mon, 11 Sep 2023 23:42:25 +0200
Date:   Mon, 11 Sep 2023 23:42:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/2] include: include <stdlib.h> in <nft.h>
Message-ID: <ZP+Jvc6GOppBj7C/@calendula>
References: <20230908173226.1182353-1-thaller@redhat.com>
 <20230908173226.1182353-2-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230908173226.1182353-2-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 08, 2023 at 07:32:20PM +0200, Thomas Haller wrote:
> It provides malloc()/free(), which is so basic that we need it
> everywhere. Include via <nft.h>.
> 
> The ultimate purpose is to define more things in <nft.h>. While it has
> not corresponding C sources, <nft.h> can contain macros and static
> inline functions, and is a good place for things that we shall have
> everywhere. Since <stdlib.h> provides malloc()/free() and size_t, that
> is a very basic dependency, that will be needed for that.

Also applied, thanks
