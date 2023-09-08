Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CEA1EE57F9
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 11:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbjIHLJV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 07:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjIHLJU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 07:09:20 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D07111B
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 04:09:15 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qeZMN-0005a9-7g; Fri, 08 Sep 2023 13:09:11 +0200
Date:   Fri, 8 Sep 2023 13:09:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 5/6] build: drop recursive make for
 "examples/Makefile.am"
Message-ID: <ZPsA1x32YIAMAlR8@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20230825113042.2607496-1-thaller@redhat.com>
 <20230825113042.2607496-6-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230825113042.2607496-6-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 25, 2023 at 01:27:37PM +0200, Thomas Haller wrote:
[...]
> +check_PROGRAMS += examples/nft-buffer
> +
> +examples_nft_buffer_AM_CPPFLAGS = -I$(srcdir)/include
> +examples_nft_buffer_LDADD = src/libnftables.la
> +
> +check_PROGRAMS += examples/nft-json-file
> +
> +examples_nft_json_file_AM_CPPFLAGS = -I$(srcdir)/include
> +examples_nft_json_file_LDADD = src/libnftables.la

Does this replace or extend AM_CPPFLAGS/LDADD for the example programs?
IOW, do the global AM_CPPFLAGS added in the previous patch leak into the
example program compile calls or not?

Cheers, Phil
