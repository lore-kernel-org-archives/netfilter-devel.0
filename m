Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B9DEC33CB1
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 15:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18B5D2072B
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 15:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgAPP3n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 10:29:43 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:50588 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgAPP3n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 10:29:43 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1is75X-0001Wg-PN; Thu, 16 Jan 2020 16:29:39 +0100
Date:   Thu, 16 Jan 2020 16:29:39 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     aa.santos@campus.fct.unl.pt
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Fixed some man pages typos ('This modules' -> 'This
 module')
Message-ID: <20200116152939.GD19873@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, aa.santos@campus.fct.unl.pt,
        netfilter-devel@vger.kernel.org
References: <20200116014057.25897-1-aa.santos@campus.fct.unl.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200116014057.25897-1-aa.santos@campus.fct.unl.pt>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 16, 2020 at 01:40:57AM +0000, aa.santos@campus.fct.unl.pt wrote:
> From: Álvaro Santos <aa.santos@campus.fct.unl.pt>

Applied, thanks!

In future, please always add your Signed-off-by and ideally a bit of
description, although in this case the patch is trivial enough to not
need it.

Thanks, Phil
