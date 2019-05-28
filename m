Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64143C04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 16:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4228121670
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 16:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfE1QGT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 12:06:19 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:37908 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbfE1QGT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 12:06:19 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hVecD-0005v9-GE; Tue, 28 May 2019 18:06:17 +0200
Date:   Tue, 28 May 2019 18:06:17 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Shekhar Sharma <shekhar250198@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2]tests: json_echo: convert to py3
Message-ID: <20190528160617.GB21440@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <20190528003653.7565-1-shekhar250198@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528003653.7565-1-shekhar250198@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, May 28, 2019 at 06:06:53AM +0530, Shekhar Sharma wrote:
> This patch converts the run-test.py file to run on both python3 and python2.
> The version history of the patch is:
> v1: modified print and other statments.
> v2: updated the shebang and order of import statements.

I personally prefer to keep the respin-changelog out of the commit
message, again in a section between commit message and diffstat. My
approach is to rather make sure the commit message itself is up to date
and contains everything relevant worth keeping from the changelog. But
the topic is rather controversial (David Miller e.g. prefers the
changelog as part of the commit message), so you've just read a purely
informational monologue. :)

> Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
