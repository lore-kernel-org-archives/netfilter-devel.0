Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55F3C31E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F19C21479
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbfFRObL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:31:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37578 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbfFRObL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:31:11 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2F8F3307D90E;
        Tue, 18 Jun 2019 14:31:10 +0000 (UTC)
Received: from egarver.localdomain (ovpn-121-240.rdu2.redhat.com [10.10.121.240])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A3F27BE64;
        Tue, 18 Jun 2019 14:31:07 +0000 (UTC)
Date:   Tue, 18 Jun 2019 10:31:06 -0400
From:   Eric Garver <eric@garver.life>
To:     Shekhar Sharma <shekhar250198@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v7 1/2]tests:py: conversion to  python3
Message-ID: <20190618143106.tgpedjytw74octms@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <20190614143144.10482-1-shekhar250198@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614143144.10482-1-shekhar250198@gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 18 Jun 2019 14:31:10 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 14, 2019 at 08:01:44PM +0530, Shekhar Sharma wrote:
> This patch converts the 'nft-test.py' file to run on both python 2 and python3.
> 
> Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> ---
> The version hystory of this patch is:
> v1:conversion to py3 by changing the print statements.
> v2:add the '__future__' package for compatibility with py2 and py3.
> v3:solves the 'version' problem in argparse by adding a new argument.
> v4:uses .format() method to make print statements clearer.
> v5:updated the shebang and corrected the sequence of import statements.
> v6:resent the same with small changes
> v7:resent with small changes

"with small changes" is not helpful. In the future please list what was
actually changed so reviewers know what to focus on.

Patch looks good though.

Acked-by: Eric Garver <eric@garver.life>
