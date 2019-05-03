Return-Path: <SRS0=n11Q=TD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84662C43219
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 15:07:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6123A205ED
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 15:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbfECPH2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 May 2019 11:07:28 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48414 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbfECPH2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 May 2019 11:07:28 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hMZmZ-00008s-1x; Fri, 03 May 2019 17:07:27 +0200
Date:   Fri, 3 May 2019 17:07:27 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Eric Garver <eric@garver.life>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] parser_json: default to unspecified l3proto for ct
 helper/timeout
Message-ID: <20190503150726.GI31599@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Eric Garver <eric@garver.life>,
        netfilter-devel@vger.kernel.org
References: <20190502162057.10312-1-eric@garver.life>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502162057.10312-1-eric@garver.life>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 02, 2019 at 12:20:57PM -0400, Eric Garver wrote:
> As per the man page, if the user does not specify the l3proto it should
> be derived from the table family.
> 
> Fixes: 586ad210368b ("libnftables: Implement JSON parser")
> Signed-off-by: Eric Garver <eric@garver.life>

Acked-by: Phil Sutter <phil@nwl.cc>
