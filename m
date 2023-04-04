Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923DEC761A6
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Apr 2023 11:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbjDDL1y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Apr 2023 07:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjDDL1x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Apr 2023 07:27:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085521980
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Apr 2023 04:27:51 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pjepJ-00024w-Cw; Tue, 04 Apr 2023 13:27:49 +0200
Date:   Tue, 4 Apr 2023 13:27:49 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Markus Boehme <markubo@amazon.com>
Cc:     netfilter-devel@vger.kernel.org,
        Jonathan Caicedo <jonathan@jcaicedo.com>
Subject: Re: [PATCH iptables] ip6tables: Fix checking existence of rule
Message-ID: <ZCwJtYiZRlUBXh1M@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Markus Boehme <markubo@amazon.com>, netfilter-devel@vger.kernel.org,
        Jonathan Caicedo <jonathan@jcaicedo.com>
References: <20230403211347.501448-1-markubo@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403211347.501448-1-markubo@amazon.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 03, 2023 at 11:13:47PM +0200, Markus Boehme wrote:
> Pass the proper entry size when creating a match mask for checking the
> existence of a rule. Failing to do so causes wrong results.
> 
> Reported-by: Jonathan Caicedo <jonathan@jcaicedo.com>
> Fixes: eb2546a846776 ("xshared: Share make_delete_mask() between ip{,6}tables")
> Signed-off-by: Markus Boehme <markubo@amazon.com>

Patch applied, thanks!
